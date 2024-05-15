#!/bin/bash

list_tables(){

database_name="$1"
tables_folder="./databases/$database_name"

if [[ $database_name =~ ^[0-9] ]]; then
echo "The name table should not start with a number,Please enter a valid name."
return
fi

if [[ $database_name == *" "* ]]
then
echo "The name table should not contain spaces,please enter again."
return
fi

if [[ ! $database_name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]
then
echo "The name table should only contain letters, numbers, or underscores,please enter again your name."
return
fi



if [ ! -d "$tables_folder" ] || [ -z "$(ls -A "$tables_folder")" ]
then
echo "There is no tables"
else
echo ""
echo ">>>>(Tables in this "$database_name" database)<<<<"
echo ""
ls -A "$tables_folder" | grep -v "_meta"
echo "             ========================================================="
echo "                             ========================             "
fi

}

list_tables "$1"
./connectToDb.sh
