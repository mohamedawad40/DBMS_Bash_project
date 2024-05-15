#!/bin/bash
dataDir="./databases"
function dropDb {
    while true; do
    read -p "Enter Database name: " DBNAME

    if [[ -d "$dataDir/$DBNAME" ]] && [[ -n $DBNAME ]]
    then
        echo "Are you sure you want to drop the database $DBNAME? "
        select confirm in "yes" "no"
        do
        case $confirm in
            "yes") rm -r "$dataDir/$DBNAME"
                   if [[ ! -d "$dataDir/$DBNAME" ]]; then
                       echo "Database $DBNAME deleted successfully :)"
                       break 2
                   else
                       echo "Failed to delete database $DBNAME."
                   fi
                   ;;
            "no")
                   echo "Database $DBNAME was not deleted."
                   ;;
            *)
                   echo "Invalid input. Database $DBNAME was not deleted."
                   ;;
        esac
        break
        done
    else
        echo "Database $DBNAME doesn't exist!"
    fi

    done
}
