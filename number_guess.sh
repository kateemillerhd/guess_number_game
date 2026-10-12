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

   # if they guess the secret number 
  if [[ $GUESS = $NUMBER ]]
  then
    TRIES=$((TRIES + 1))
    echo -e "You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!"
    
    # add game to games played
    UPDATE_GAMES_PLAYED=$((GAMES_PLAYED + 1))

    # update table with new games played
    INSERT_UPDATED_GAMES=$($PSQL "UPDATE users SET games_played = $UPDATE_GAMES_PLAYED WHERE username = '$USERNAME'")

    # if first game, add best game
    if [[ -z $BEST_GAME ]]
    then
      INSERT_UPDATED_BEST=$($PSQL "UPDATE users SET best_game = $TRIES WHERE username = '$USERNAME'")
    fi


    # compare tries to best game/update if needed
    if [[ $TRIES -lt $BEST_GAME ]]
    then
      INSERT_UPDATED_BEST=$($PSQL "UPDATE users SET best_game = $TRIES WHERE username = '$USERNAME'")
    fi

  
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

