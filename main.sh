#!/bin/bash
source ./dropDb.sh 
source ./create_db.sh
# create the first menu
clear
PS3="Please select a command from the menu: "
menu=("Create Database" "List Databases" "Connect To Databases" "Drop Database" "exit")
while true; do
    echo  "                          Welcome to Our DBMS           "
    echo  "                              *********                 "
    select choice in "${menu[@]}"
    do
        case $REPLY in
            1) createDb
                ;;
            2)
                source ./list_db.sh
                ;;
            3)
                source ./connectToDb.sh
                ;;
            4)
                dropDb
                ;;
            5)
                exit 0;;
            *)
                echo "Invalid choice";;
        esac
    done
done

