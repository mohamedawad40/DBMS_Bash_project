#!/bin/bash

# Function to select records from a table
selectFromTable() {
   # Prompt the user to enter the table name
    read -p "Enter Table Name: " tbname
    
    local records_file="./databases/$1/${tbname}"
    # Check if the table name is empty or contains special characters
    if [[ -z "$tbname" || "$tbname" =~ [/.:\\-] ]]; then
        echo "Error: Table name cannot be empty or have special characters. Please enter a valid name."
    elif [[ ! -f "$records_file" ]]; then
        echo "Error: Table $tbname does not exist."
        ./connectToDb.sh
        
    else
        while true; do
            read -p "Select operation: (1) Select All, (2) Select by Primary Key: " operation
            echo "=============================================================="
        
            case $operation in
                1)
                    # Select All
               #       echo "$records_file"
                #    ls -A "$records_file"
                    if [ -s "${records_file}" ]; then
                    echo ""
                    echo "*****************"
                    cat "${records_file}"
                    echo "*****************"
                    echo ""
                    else
                    echo "No records to display."
                    fi
                    ./connectToDb.sh
                    break
                    ;;
             
                  
                2)
                   # Select by Primary Key
    
			    # Prompt the user to enter the primary key value
			    while true; do
				read -p "Enter the primary key value: " primaryKeyValue

				# Extract the primary key column name from the table metadata file
				primaryKeyColumn=$(awk -F: '/pk/{print $1}' "./databases/$1/${tbname}_meta")
				#echo "${primaryKeyColumn}"  # Display the extracted primary key column name

				# Determine the line number of the primary key column in the metadata file
				primaryKeyColumnNumber=$(awk -F: -v pkColumn="$primaryKeyColumn" '$0 ~ pkColumn{print NR}' "./databases/$1/${tbname}_meta")
				#echo "${primaryKeyColumnNumber}"  # Display the line number of the primary key column

				# Validate if the primary key value is not empty
				if [[ -z "$primaryKeyValue" ]]; then
				    echo "Error: Primary key value cannot be empty."
				    return
				fi

				# Search for the row with the specified primary key value
				row=$(awk -F: -v pkColumnNumber="$primaryKeyColumnNumber" -v pkValue="$primaryKeyValue" '$pkColumnNumber == pkValue' "$records_file")

				# Output Handling
				if [[ -z "$row" ]]; then
				     read -p "Row with primary key value '$primaryKeyValue' not found in table '$tableName'. Do you want to select another value? (yes/no): " selectAnother
			     if [[ "$selectAnother" == "yes" ]]; then
					    continue
			      else
					    break
				     fi
				else
				    # If a matching row is found, display the row
				    echo "Row with primary key value '$primaryKeyValue' in table '$tbname':"
				    echo "*****************"
				    echo "$row"
				    echo "*****************"
				    ./connectToDb.sh
				fi
				done

                       break
                    ;;
                *)
                    echo "Invalid operation. Please select a valid option."
                    ;;
            esac
        done
    fi
}



# Call the function to select records from the table
selectFromTable "$1"

