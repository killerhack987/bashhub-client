export BH_EXEC_DIRECTORY=~/.bashhub/.python/

bh_process_command()
{
    source ~/.bashhub/.config
    PROCESS_ID=$$
    PROCESS_START=`ps -p $$ -o lstart | sed -n 2p`
    USER_ID=$BH_USER_ID
    SYSTEM_ID=$BH_SYSTEM_ID
    WORKING_DIRECTORY=`pwd`

    if [[ $1 != "bash_command=" ]]
    then
        PARSED_COMMAND=`echo $1 | sed -e 's/^ *//g' -e 's/ *$//g'`
        (./bashhub.py "$PARSED_COMMAND" $USER_ID $SYSTEM_ID $PROCESS_ID \
           "$PROCESS_START" "$WORKING_DIRECTORY"&)
    fi;
}

trap 'previous_command=$this_command; this_command=$(history 1 | cut -d " " -f4-)' DEBUG
PROMPT_COMMAND='bash_command=$previous_command; if [[ $bash_command ]]; then (cd $BH_EXEC_DIRECTORY && bh_process_command "$bash_command"); bash_command=; fi;'

bh()
{
    (cd $BH_EXEC_DIRECTORY && ./bh.py "$@")
}
