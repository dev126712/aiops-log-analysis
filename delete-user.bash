#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 01/01/26
####################

FILE_DATA="$1"

# --- Logging Function ---
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

    # Check if the user actually exists before trying to delete
    if ! grep -q "^${NameToDelete}:" "$FILE_DATA"; then
        echo "Error: User '$NameToDelete' not found."
        log_event "WARNING" "User '$NameToDelete' not found" "delete user"
        return
    fi

    # Capture user details before deleting for the log
    USER_DETAILS=$(grep "^${NameToDelete}:" "$FILE_DATA")
    
    # Perform deletion
    sed -i "/^${NameToDelete}:/d" "$FILE_DATA"
    
    # Log the successful deletion
    echo "User deleted: $USER_DETAILS"
    log_event "INFO" "user deleted: $USER_DETAILS" "delete user"
}

main (){
    delete_user
    # Return to main menu
    ./main.bash "$FILE_DATA"
}

main "$@"
