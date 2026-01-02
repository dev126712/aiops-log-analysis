#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 12/31/25
#####################


FILE_DATA=$1

log_event() {
    local LEVEL=$1
    local MSG=$2
    local MODULE=$3
    local TIMESTAMP=$(date +"%A,%B%d,%Y-%H:%M")
    printf "%s: %s: %s: FROM %s\n" "$LEVEL" "$MSG" "$TIMESTAMP" "$MODULE" >> system_log.csv
}

simulation() {
    if [ $((RANDOM % 20)) -eq 0 ]; then
        for i in {1..10}; do
            log_event "CRITICAL" "Disk space at 99% - partition /dev/sda1" "system_monitor"
        done
    fi

    if [ $((RANDOM % 50)) -eq 0 ]; then
        LONG_STR=$(printf '%.0sERROR_BLOB_' {1..20})
        log_event "ERROR" "Unexpected buffer: $LONG_STR" "memory_manager"
    fi
}

home() {
    simulation
    echo ""
    echo "Welcome by Alexandre St-fort"
    echo "Press 1 to see all the user"
    echo "press 2 to create a user"
    echo "press 3 to delete a user"
    echo "press (q) to quit"
    echo ""
    read a
    echo ""

    log_event "INFO" "press $a" "main"

    if [ -z $a ]; then
        echo "error: expcted a command..."
        log_event "WARNING" "expected a command" "main"
        home
    fi
    if [ $a == "1" ];then
        ./see-all-user.bash $FILE_DATA
    elif [ $a == "2" ];then
        ./create-user.bash $FILE_DATA
    elif [ $a == "3" ];then
        ./delete-user.bash $FILE_DATA
    elif [ $a == "q" ]; then
        exit 0
    else
        echo "error: command not expected"
        log_event "ERROR" "command not expected: $a" "main"
        simulation
        home

    fi
}

main() {
    simulation
    home
}

main "$@"
