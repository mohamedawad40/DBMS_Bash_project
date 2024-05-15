#!/bin/bash
dataDir="./databases/$1"
function updateTable {
    
    read -p "Enter the name of the table you want to update: " TABLENAME
    if [[ -f "$dataDir/$TABLENAME" ]]; then
        if [ ! -s "$dataDir/$TABLENAME" ]; then
            echo "Table '$TABLENAME' is empty. Nothing to update."
            #return
            #break
            ./connectToDb.sh
        fi

        echo "Columns in the table:"
        awk -F: '{print $1}' "$dataDir/${TABLENAME}_meta"

        read -p "Enter the primary key value of the row you want to update: " primaryKeyValue

        # Check if the primary key exists in the table
        pKeyColumn=$(grep -n "pk" "$dataDir/${TABLENAME}_meta" | cut -d: -f1)
        if ! grep -i -w "$primaryKeyValue" "$dataDir/$TABLENAME" >/dev/null; then
            echo "Row with primary key '$primaryKeyValue' not found in table '$TABLENAME'."
            ./connectToDb.sh
        fi

        read -p "Enter the column name you want to update: " columnName

        # Check if the column exists in the table
        if ! grep -w "$columnName" "$dataDir/${TABLENAME}_meta" >/dev/null; then
            echo "Column '$columnName' not found in table '$TABLENAME'."
            #return
            ./connectToDb.sh
        fi

        # Find the column number
        colNumber=$(awk -F: -v col="$columnName" '$1 == col {print NR}' "$dataDir/${TABLENAME}_meta")

        read -p "Enter the new value for column '$columnName': " newValue

        # Validate the new value to prevent special characters
        if [[ $newValue =~ [^a-zA-Z0-9_] ]]; then
            echo "Invalid input! The new value cannot contain special characters."
            #return
            ./connectToDb.sh
        fi

        # Validate new value based on data type
        dataType=$(awk -F: -v colNum="$colNumber" 'NR == colNum {print $2}' "$dataDir/${TABLENAME}_meta")
        case $dataType in
            "integer")
                if ! [[ $newValue =~ ^[0-9]+$ ]]; then
                    echo "Invalid input! This column must be an integer."
                    ./connectToDb.sh
                fi
                ;;
            "varchar")
                # No need for additional validation for varchar
                ;;
            *)
                echo "Unknown data type '$dataType' for column '$columnName'."
                ./connectToDb.sh
                ;;
        esac

        # Check if new primary key value conflicts with existing ones
        if grep -i -w "$newValue" "$dataDir/$TABLENAME" | grep -v -w "$primaryKeyValue" >/dev/null; then
            echo "Error: New primary key value '$newValue' conflicts with existing values."
            ./connectToDb.sh
        fi

        # Update the row
        awk -v primaryKey="$primaryKeyValue" -v colNum="$colNumber" -v pKeyCol="$pKeyColumn" -v newVal="$newValue" -F: 'BEGIN{OFS=":"} {if ($pKeyCol == primaryKey) $colNum = newVal; print}' "$dataDir/$TABLENAME" >"$dataDir/${TABLENAME}.tmp"

        if mv "$dataDir/${TABLENAME}.tmp" "$dataDir/$TABLENAME"; then
            echo "Row with primary key '$primaryKeyValue' updated successfully in table '$TABLENAME'."
            ./connectToDb.sh
        else
            echo "Error updating row in table '$TABLENAME'."
            ./connectToDb.sh
        fi
    else
        echo "Table '$TABLENAME' not found."
        ./connectToDb.sh
    fi
}
updateTable $1