#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 12/31/25
#
####################


FILE_DATA=$1

log_event() {
    local LEVEL=$1
    local MSG=$2
    local MODULE=$3
    local TIMESTAMP=$(date +"%A,%B%d,%Y-%H:%M")
    printf "%s: %s: %s: FROM %s\n" "$LEVEL" "$MSG" "$TIMESTAMP" "$MODULE" >> system_log.csv
}

create_user() {
    echo "User name to add: "
    read user_name

    if [ -z $user_name ]; then
        echo "ERROR: name is required.."
        # Log the error for the AI to detect
        log_event "ERROR" "name is required" "create user"
        create_user
        return
    fi

    echo "User id (press enter to auto-generate): "
    read user_id

    if [ -z $user_id ]; then
        #id_generator
        user_id=$((RANDOM % 9000 + 1000))
        echo "Generated User ID: $user_id"
    fi

    echo "Description: " 
    read user_description


    log_event "INFO" "$user_name:$user_id:$user_description" "create user"

    newuser="$user_name:$user_id:$user_description"
    printf "$newuser\n" >> $FILE_DATA

    echo "User added successfully."
    ./main.bash $FILE_DATA
    exit 0
}

#id_generator() {}

main(){
    create_user
}

main "$@"
