#!/bin/bash

function deleteFromTable {
# Prompt the user to enter the name of the table
read -p "Enter Table Name: " tbname

# Define the directory structure for the DBMS
records_file="./databases/$1/${tbname}"
#echo "${records_file}"

# Check if the table name is empty or contains special characters
if [[ -z "$tbname" || "$tbname" =~ [/.:\\-] ]]; then
    echo "Error: Table name cannot be empty or have special characters. Please enter a valid name."
    ./connectToDb.sh
# Check if the specified table directory and records file exist
elif [[ ! -f "$records_file" ]]; then
    echo "Error: Table $tbname does not exist."
    ./connectToDb.sh
else
  while true; do
	    # Prompt the user to choose the action
	    read -p "Do you want to delete all records from $tbname table? (yes/no): " choice

	    if [[ "$choice" == "yes" ]]; then
		# Delete all records from the table
		> "$records_file"
		echo "All records successfully deleted from $tbname table."
		./connectToDb.sh
	    elif [[ "$choice" == "no" ]]; then
		# Prompt the user to enter the primary key value of the record to delete
		read -p "Enter the primary key value to identify the record: " value

		# Check if the primary key value is empty
		if [[ -z "$value" ]]; then
		    echo "Error: value cannot be empty."
		else
		    if grep -q -w "$value" "${records_file}"
		   then
		     deleteElements=$(grep -w -n "$value" "${records_file}" | cut -d: -f1 | tac)
		     echo "======================="
		     echo "row number ${deleteElements} has deleted successfully"
		     echo "======================="
		     for option in $deleteElements
			do
			 
			  sed -i "${option}d" "${records_file}"
			./connectToDb.sh 
			done
			 
		   else
		     echo "No matching rows found for $value"
		  fi
		    
		fi
	    else
		echo "Invalid choice. Please enter 'yes' or 'no'."
	        
	    fi
	    
   done	
   ./connectToDb.sh    
fi
}

deleteFromTable "$1"
