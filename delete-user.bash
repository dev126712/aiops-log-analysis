#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 01/01/26
####################

FILE_DATA="$1"

log_event() {
    local LEVEL=$1
    local MSG=$2
    local MODULE=$3
    local TIMESTAMP=$(date +"%A,%B%d,%Y-%H:%M")
    printf "%s: %s: %s: FROM %s\n" "$LEVEL" "$MSG" "$TIMESTAMP" "$MODULE" >> system_log.csv
}

delete_user() {
    echo "User name to delete: "
    read NameToDelete

    if [ -z "$NameToDelete" ]; then
        echo "ERROR: User name cannot be empty."
        log_event "WARNING" "User name cannot be empty" "delete user"
        delete_user
        return
    fi

    if ! grep -q "^${NameToDelete}:" "$FILE_DATA"; then
        echo "Error: User '$NameToDelete' not found."
        log_event "WARNING" "User '$NameToDelete' not found" "delete user"
        return
    fi

    USER_DETAILS=$(grep "^${NameToDelete}:" "$FILE_DATA")
    
    sed -i "/^${NameToDelete}:/d" "$FILE_DATA"
    
    echo "User deleted: $USER_DETAILS"
    log_event "INFO" "user deleted: $USER_DETAILS" "delete user"
}

main (){
    delete_user
    ./main.bash "$FILE_DATA"
}

main "$@"
