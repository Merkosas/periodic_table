#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

get_element_by_atomic_number() {
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  echo "$ELEMENT"
}

get_element_by_name_or_symbol() {
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
  echo "$ELEMENT"
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
 if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$(get_element_by_atomic_number $1)
else
  ELEMENT=$(get_element_by_name_or_symbol $1)
fi

