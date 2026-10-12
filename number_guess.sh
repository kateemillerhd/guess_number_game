#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~~~ Number Guessing Game ~~~~~\n"

NUMBER_GUESS() {
  # generate random number between 1 and 1000, initialize number of tries
  NUMBER=$(( RANDOM % (1000 - 1 + 1) + 1 ))
  TRIES=0

  # for testing, erase before complete
  echo $NUMBER

  #ask user for guess 
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS

  # if guess is not an integer
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "That is not an integer, guess again:"
    read GUESS
  fi

  # if guess is lower than number
  if [[ $GUESS -lt $NUMBER ]]
  then
    TRIES=$((TRIES + 1))
    echo -e "It's higher than that, guess again:"
    read GUESS
  fi

  # if guess is higher than number
  if [[ $GUESS -gt $NUMBER ]]
  then
    TRIES=$((TRIES + 1))
    echo -e "It's lower than that, guess again:"
    read GUESS
  fi


}

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
  NUMBER_GUESS

# if username already in database  
else
  # get games played and best game data
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")

  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses." 

  # run game function
  NUMBER_GUESS
fi

