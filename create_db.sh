#!/bin/bash

function createDb {
    while true; do
        read -p "Enter the name of your database: " db_name

        if [[ $db_name =~ ^[0-9] ]]; then
            echo "Error: The database name should not start with a number. Please enter a valid name."
        elif [[ $db_name == *" "* ]]; then
            echo "Error: The name of the database should not contain spaces. Please enter a valid name."
        elif [[ ! $db_name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            echo "Error: The database name should only contain letters, numbers, or underscores. Please enter a valid name."
        elif [ -d "./databases/$db_name" ]; then
            echo "Error: Database '$db_name' already exists. Please enter another name."
        else
            mkdir -p "./databases/$db_name"
            echo "Database '$db_name' created successfully."
            echo "             ========================================================="
        echo "                             ========================             "	
           
            break
              
        fi
        
    done
    
}


 
