#!/bin/bash

# Database connection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to get element by atomic number
get_element_by_atomic_number() {
  $PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1"
}

# Function to get element by name or symbol
get_element_by_name_or_symbol() {
  $PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'"
}

# Function to display element information
display_element_info() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$1" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

# Main script logic
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
  display_element_info "$ELEMENT"
fi
