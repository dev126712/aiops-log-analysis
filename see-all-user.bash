#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#####################


FILE_DATA=$1

log_event() {
    local LEVEL=$1
    local MSG=$2
    local MODULE=$3
    local TIMESTAMP=$(date +"%A,%B%d,%Y-%H:%M")
    printf "%s: %s: %s: FROM %s\n" "$LEVEL" "$MSG" "$TIMESTAMP" "$MODULE" >> system_log.csv
}

seeAllUser() {
    usercount=0

    if [ ! -f "$FILE_DATA" ]; then
        echo "Error: Data file not found."
        log_event "ERROR" "Data file $FILE_DATA missing" "see all users"
        ./main.bash "$FILE_DATA"
        exit 1
    fi

    echo "--- User List ---"

    while IFS=: read -r name id desc; do
        echo ""
        echo "name: $name"
        echo "description: $desc"
        echo "id: $id"
        ((usercount++))
    done < $FILE_DATA

    echo "-----------------"
    echo "$usercount users registered."

    log_event "INFO" "search all user: found $usercount records" "see all users"
    ./main.bash $FILE_DATA
    exit 0
}

main() {
    seeAllUser
}

main "$@"
