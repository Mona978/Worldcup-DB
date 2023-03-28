#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINN_RESULT=$($PSQL "insert into teams(name) values ('$WINNER')")
      if [[ $INSERT_WINN_RESULT == "INSERT 0 1" ]]
      then
        echo Insert: $WINNER
      fi
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    # get opponent id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPP_RESULT=$($PSQL "insert into teams(name) values ('$OPPONENT')")
      if [[ $INSERT_OPP_RESULT == "INSERTED 0 1" ]]
      then
        echo Insert: $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Insert: $YEAR, $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS, $ROUND
    fi
  fi
done