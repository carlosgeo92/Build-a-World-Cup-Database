#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#Clean data in filled tables
CLEAN=$($PSQL "TRUNCATE TABLE teams, games;")
#Fill teams table
#Read the data in games.csv
cat games.csv | while  IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER = 'winner' ]]
    then
      continue
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  if [[ -z $WINNER_ID ]]
    then
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
  fi
  if [[ -z $OPPONENT_ID ]]
    then
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
  fi
done

#Fill games table
cat games.csv | while  IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  #Ignore first row
  if [[ $WINNER = 'winner' ]]
    then
      continue
  fi
  #Get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
  #Get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
  #Fill table 
  INSERT_GAME_INFO=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
done
