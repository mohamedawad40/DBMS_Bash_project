#!/bin/bash

function insert {
    # Prompt the user to enter the name of the table
    read -p "Enter Table Name: " tbname
    # Construct the path to the metadata file
    metaFilePath="./databases/${1}/${tbname}_meta"

    # Check if the metadata file exists
    if [ ! -f "$metaFilePath" ]; then
        echo "Error: Metadata file does not found."
        ./connectToDb.sh
    fi
    
    # Read metadata for the specified table
    metaData=$(<"$metaFilePath")

    # Get columns, data types, and constraints from metadata
    columns=($(echo "$metaData" | cut -d: -f1))
    datatypes=($(echo "$metaData" | cut -d: -f2))
    constraints=($(echo "$metaData" | cut -d: -f3))

    # Initialize variables
    record=""
    records_file="./databases/${1}/${tbname}"

    # Create an associative array to hold the primary key constraints
    declare -A pkConstraints

    for ((i = 0; i < ${#columns[@]}; i++)); do
        col="${columns[i]}"
        dtype="${datatypes[i]}"

        while true; do
            echo ""
            read -p "Enter $col ($dtype): " value
            
            if [[ -z "$value" ]]; then
                echo "Error: $col cannot be empty."
            elif [[ "$dtype" == "integer" && ! "$value" =~ ^[0-9]+$ ]]; then
                echo "Error: $col must be an integer."
            elif [[ "$dtype" == "varchar" && "$value" =~ [0-9] ]]; then
                echo "Error: $col must not contain numbers."
            elif [[ "$dtype" == "varchar" && ! "$value" =~ ^[a-zA-Z0-9]+$ ]]; then
                echo "Error: $col must only contain alphanumeric characters."
            else
                # Check for primary key constraint
                if [[ "${constraints[i]}" == "pk" ]]; then
                    # Check for duplicate primary key values
                    if grep -q "^$value:" "$records_file"; then
                        echo "Error: Duplicate value '$value' found for primary key '$col'."
                        continue
                    else
                        pkConstraints["$col"]=$value
                    fi
                fi

                record+="$value:"
                break
            fi
        done
    done

    # Append the record to the table file
    echo "$record" >> "$records_file"
     echo ""
    echo "Record successfully inserted into the $tbname table."
    ./connectToDb.sh
}

# Example usage:
insert "${1}"

