#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~~~ Number Guessing Game ~~~~~\n"

# get username
echo -e "Enter your username:"
read  USERNAME_INPUT

USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME_INPUT'")

# if username not in database
if [[ -z $USERNAME ]]
then
  # add user to database
  INPUT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME_INPUT')")
  USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME_INPUT'")

  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  
  # run game function
  

# if username already in database  
else
  # get games played and best game data
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")

  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses." 

  # run game function
 
fi

