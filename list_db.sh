#!/bin/bash

data_folder="./databases"

if [ ! -d "$data_folder" ]
then
    echo "Data Folder does not exit ,There is no databases yet."
else
	# List existing databases in the "data" folder
	if [ "$(ls -A "$data_folder")" ]; then
		ls -F "$data_folder" | grep / | tr / " " 
	echo "             ========================================================="
        echo "                             ========================             "	
		#source ./main.sh
	else
		echo "No databases yet. 'data' folder is empty."
	fi
fi

