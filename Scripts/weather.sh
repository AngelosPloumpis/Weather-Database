# This is the bash script to execute the SQL scripts for loading and copying the weather data.

#!/bin/bash

# Change to the directory where the script and weather.csv are located
cd "$(dirname "$0")"

# Prompt for MySQL credentials
read -p "Enter MySQL username: " DB_USER
read -s -p "Enter MySQL password: " DB_PASS
echo

# Check if weather.csv exists
if [ ! -f weather.csv ]; then 
    echo "No weather.csv file found. Exiting."
    exit 0
fi

# Load data into load_weather table
mysql --local_infile=1 -h 127.0.0.1 -D weather -u "$DB_USER" -p"$DB_PASS" -s \
    < sql/load_weather.sql > sql/load_weather.log

# If load_weather.log is not empty, proceed to copy and advisory
if [ ! -s sql/load_weather.log ]; then
    mysql -h 127.0.0.1 -D weather -u "$DB_USER" -p"$DB_PASS" -s \
        < sql/copy_weather.sql > sql/copy_weather.log
fi

# Archive the original CSV with a timestamp
mv weather.csv "weather.csv.$(date +%Y%m%d%H%M%S)"

echo "Weather data processed and archived."
