#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  if [ "$year" == "year" ]; then
        continue
  fi
   for team in "$winner" "$opponent"; do
   # Check if the team already exists in the table
        existing_team=$($PSQL "SELECT team_id FROM teams WHERE name = '$team'")
        if [ -z "$existing_team" ]; then
            # Insert the team into the teams table
            $PSQL "INSERT INTO teams (name) VALUES ('$team')"
        fi
    done
    # Get winner and opponent team IDs from the teams table
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")

    # Insert the game into the games table
    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$opponent_id', '$winner_goals', '$opponent_goals')"
done
#$PSQL "SELECT * FROM teams"
#$PSQL "SELECT * FROM games"