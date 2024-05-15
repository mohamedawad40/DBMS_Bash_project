#!/bin/bash
database="./databases"
function dropTable {
  read -p "Enter the name of the table: " TABLENAME
  if [ -f "$database/$1/$TABLENAME" ]
  then  
    rm "$database/$1/$TABLENAME"
    rm "$database/$1/${TABLENAME}_meta"
    echo "$TABLENAME table was Successfully Dropped"
  else
   echo "$TABLENAME doesn't exit"
   return
  fi 
}
dropTable $1