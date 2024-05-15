#! /usr/bin/bash

source ./createTable.sh

function connectToDb {

	databases="./databases"

# Check if the "data" folder exists
if [ ! -d "$databases" ]; then
	echo "the databases folder is not found ..."
	./main.sh
fi

	databasesfound=$(ls ./databases| wc -l)

	if (($databasesfound == 0)); then
		echo "the database folder is empty!"

	else

		echo "What Database do you want to connect to ?"

		# Check if the "data" folder exists
		if [ ! -d "$databases" ]; then
			echo "No databases yet. 'database' folder does not exist."
		else
			echo ""
			echo ">>>>(Already existing databases)>>>>"
			echo ""

			# List existing databases in the "data" folder
			if [ "$(ls -A "$databases")" ]; then
				ls -F "$databases" | grep / | tr / " "

			else
				echo "No databases yet. 'data' folder is empty."
			fi
		fi

		read -p "enter database name: " name
		if [[ -z "$name" ]]; then
		echo "invalid input"
		./connectToDb.sh
		elif [[ ! $name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
		echo "database $name does not exist."
		./main.sh
		fi

		if [ -d databases/$name ]; then
			#cd database/$name
			echo ""
			#clear
			echo ">>>>>>>>successfully connected to $name database<<<<<<<<"
                        echo ""
			select choice in "create table" "drop table" "list tables" "select from table" "insert into table" "update from table" "delete from table" "connect to another database" "return to main"; do
				case $REPLY in
				1)
					createTable $name
					break
					;;
				2)
					./dropTable.sh $name
					break
					;;
				3)
					./list_tables.sh $name
					break
					;;
				4)
					./selectFromTable.sh $name
					break
					;;
				5)
					./insertTable.sh $name


					break
					;;
				6)
					source ./updateTable.sh $name
					break
					;;
				7)
					./deleteFromTable.sh $name
					break
					;;
				8)
					./connectToDb.sh
					break
					;;
				9)
					./main.sh
					break
					;;

				* )
					echo "Invalid Input."
					;;
				esac

			done
		else
			echo "database $name does not exist."
			connectToDb

		fi
	fi	
}

connectToDb
