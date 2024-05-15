#!/usr/bin/bash
function createTable {
	read -p "Enter the name of the table you want to create: " TABLENAME
	if [ -f "./databases/$1/$TABLENAME" ]; then
		echo "Table with the same name already exists in this Database!"
		createTable
	elif [ -z "$TABLENAME" ]; then
		echo "Invalid input: empty string."
		createTable $1
	elif [[ "$TABLENAME" =~ ^[0-9] ]]; then
		echo "Invalid input: Table name shouldn't start with a number."
		createTable $1
	elif [[ "$TABLENAME" == *" "* ]]; then
		echo "invalid input: Table Name shouldn't contain spaces"
	elif ! [[ "$TABLENAME" =~ ^[a-zA-Z][a-zA-Z]*$ ]]; then
		echo "Invalid input: Table name shouldn't have special character,numbers or spaces."
		createTable $1
	else
		touch ./databases/$1/"${TABLENAME}"
		touch ./databases/$1/"${TABLENAME}_meta"
		enterColsNum $1 $TABLENAME
	fi
}

function enterColsNum {
	 read -p "Enter the number of the columns for the table: " COLUMNSNUMBER

	if [ -z "$COLUMNSNUMBER" ]; then
		echo "Invalid input: empty value."
		enterColsNum $1 $2
	elif ! [[ $COLUMNSNUMBER =~ ^[0-9]+$ ]]; then
		echo "Invalid input: expected positive numbers only ."
		enterColsNum $1 $2
	elif [[ $COLUMNSNUMBER -lt 1 ]]; then
		echo "Invalid input: expected number greater than two ."
		enterColsNum $1 $2
	elif [[ $COLUMNSNUMBER -gt 100 ]]; then
		echo "Invalid input: expected number less than 100 ."
		enterColsNum $1 $2
	else

		counter=1
		while [ "$counter" -le "$COLUMNSNUMBER" ]; do
			if [ "$counter" -eq 1 ]; then
				validatePk "$1" "$2"
				echo -e -n "\n" >>./databases/$1/"${2}_meta"
			else
				validateCol "$1" "$2"
				echo -e -n "\n" >>./databases/$1/"${2}_meta"
			fi
			((counter++))
		done
		echo "Table created successfully!"
		source ./connectToDb.sh
	fi
}

function validatePk {
	pk=1
	read -p "enter the name of the primary key : " PKNAME

	if grep -w "$PKNAME" ./databases/$1/"${2}_meta" ; then
		echo "You already have a column with this name in this Database!"
		validatePk $1 $2

	elif [ -z "${PKNAME}" ]; then
		echo "Invalid input: empty string."
		validatePk $1 $2
	elif [[ "${PKNAME}" == *" "* ]]; then
		echo "Invalid input: Column name shouldn't contain spaces."
		validatePk $1 $2
	elif [[ "${PKNAEM}" == [1-9]* ]]; then
		echo "Invalid input: Column name shouldn't start with a number."
		validatePk $1 $2
	elif ! [[ "${PKNAME}" == [a-zA-Z]* ]]; then
		echo "Invalid input: Column name shouldn't start with a special character."
		validatePk $1 $2
	else
		echo -n $PKNAME >>./databases/$1/"${2}_meta"
		enterColDataType $PKNAME $1 "${2}_meta" $pk

		echo -n ":pk" >>./databases/$1/"${2}_meta"
	fi
}

function validateCol {
	pk=0
	read -p "enter the name of the next column : " COLUMNNAME

	if grep -w "$COLUMNNAME" ./databases/$1/"${2}_meta"; then
		echo "You already have a column with this name in this Database!"
		validateCol $1 $2

	elif [ -z "${COLUMNNAME}" ]; then
		echo "Invalid input: empty string."
		validateCol $1 $2
	elif [[ "${COLUMNNAME}" == *" "* ]]; then
		echo "Invalid input: Column name shouldn't contain spaces."
		validateCol $1 $2
	elif [[ "${COLUMNNAME}" == [1-9]* ]]; then
		echo "Invalid input: Column name shouldn't start with a number."
		validateCol $1 $2
	elif ! [[ "${COLUMNNAME}" == [a-zA-Z]* ]]; then
		echo "Invalid input: Column name shouldn't start with a special character."
		validateCol $1 $2
	else
		echo -n $COLUMNNAME >>./databases/$1/"${2}_meta"
		enterColDataType $COLUMNNAME $1 "${2}_meta" $pk
	fi
}

function enterColDataType {
	echo "specify data type of the column ${1} : "
	select option in "varchar" "integer"; do
		case $REPLY in
		1)
			echo -n ":varchar" >>./databases/$2/$3
			
			break
			;;
		2)
			echo -n ":integer" >>./databases/$2/$3
			
			break
			;;
		*)
			echo "Invalid Input."
			#enterColDataType $1 $2 $3 $4
			rm "./databases/$2/${TABLENAME}"
			rm "./databases/$2/$3"
			
			./connectToDb.sh
			;;
		esac

	done
}

