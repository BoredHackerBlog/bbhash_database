#!/bin/bash
function help(){
	echo "$0 createdb database_filename"
	echo "$0 add database_filename binary_file"
	echo "$0 lookup database_filename bbhash_value"
}

function createdb(){
	echo "Starting - createdb"
	database_filename=$1

	#create database
	sqlite3 $database_filename 'CREATE TABLE "file_table" ( "filehash"	TEXT NOT NULL UNIQUE, "file_id"	INTEGER NOT NULL UNIQUE, PRIMARY KEY("file_id" AUTOINCREMENT));'
	sqlite3 $database_filename 'CREATE TABLE "function_table" ("file_id" INTEGER NOT NULL,"func_name" TEXT NOT NULL,"bbhash" TEXT NOT NULL,FOREIGN KEY("file_id") REFERENCES "file_table"("file_id"));'

	echo "Finished createdb"
}

function add(){
	echo "Starting - add"
	database_filename=$1
	binary_file=$2

	#hash the binary file
	filehash=($(md5sum $binary_file))
	
	#insert filehash, grab id
	file_id=$(sqlite3 $database_filename "INSERT INTO file_table(filehash) values (\"$filehash\"); SELECT last_insert_rowid();")

	#create csv
	r2 -q -c "aaa; zg; zj;" $binary_file | jq --arg file_id $file_id '.[] | ($file_id + "," + .name + "," + .hash.bbhash)' | sed 's/"//g' > $file_id.csv

	#insert csv
	sqlite3 $database_filename << EOF
.mode csv
.separator ","
.import $file_id.csv function_table
EOF

	#del csv
	rm $file_id.csv

	echo "Finished - add"
}

function lookup(){
	echo "Starting - lookup"
	database_filename=$1
	bbhash=$2

	#run query on the database
	sqlite3 $database_filename "select * from file_table where file_id in (select file_id from function_table where bbhash = \"$bbhash\" );"

	echo "Finished - lookup"
}

case $1 in
	createdb)
		createdb $2
	;;

	add)
		add $2 $3
	;;

	lookup)
		lookup $2 $3
	;;

	*)
	help
	;;
esac
