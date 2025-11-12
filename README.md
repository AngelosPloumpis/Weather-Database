# Weather-Database
A MySQL project that accepts a CSV file, checks and cleans the data, and then, using a procedure creates an advisory table for extreme weather conditions. Then the final weather table is joined with the advisory table.
# Full Description

This is the frist of three projects from the textbook MySQL Crash Course by Rick Silva.

A trucking company is working with a meteorological service to get hourly weather updates in the cities it conducts business.

1. We create a database containing three tables. The script is called Create_Weather_Tables.sql.
  1.1. The first table, called current_weather_load, contains 17 columns with various meteorological data. This is an intermediate table, where we load our unverified data and using constraint checks, we verify that all inputs are within normal parameters.
  1.2. The second table, called current_weather, is our final "user" table, where the user is able to check all 17 columns and inform the trucking company.
  1.3. The third table, called weather advisory, has 4 columns, the station's ID, in which city the station is located, the advisory message and the date and time the advisory message was created. It is filled through a procedure described below, and it's purpose is to highlight extreme weather conditions, that might pose risks for the drivers of the trucking company.
