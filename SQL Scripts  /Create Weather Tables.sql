-- Weather Database Project for a trucking company.
/*Creating the database and the two tables required. Also I made 
an advisory table and procedure for extreme weather events. */
create database weather;
use weather;
/* First table that loads and checks for accurate weather data.
We also force the intertion of some vital values like station_id,
temperature and visibility.*/
create table current_weather_load(
station_id int not null,
station_city varchar(50), -- Setting to 50 characters as most city names don't exceed that. 
station_state varchar(3), -- Setting it to varchar(3) to give some flexibility for future additions of other states.
station_latitude decimal(6,4),
station_longitude decimal(7,4),
input_datetime datetime not null, -- the date and time that the data was gathered
temp tinyint not null,
percieved_temp tinyint,
wind_speed smallint not null, -- Wind speed in KPH
wind_direction varchar(3) not null,
precipitation decimal(3,1) not null,
pressure decimal(6,2),
visibility decimal(3,1) not null,
humidity tinyint unsigned,
weather_condition varchar(100) not null,
sunrise time,
sunset time,
-- Setting appropriate constraints.
constraint check(station_latitude between -90 and 90),
constraint check(station_longitude between -180 and 180),
constraint check(temp between -50 and 150),
constraint check(percieved_temp between -50 and 150),
constraint check(wind_speed between 0 and 500), -- Greatest wind speed recorded ~ 450kph.
constraint check(wind_direction in ('N','S','E','W','NE','NW','SE','SW',
	    'NNE','ENE','ESE','SSE','SSW','WSW','WNW','NNW')),
constraint check(precipitation between 0 and 400),
constraint check(pressure between 0 and 1100),
constraint check(visibility between 0 and 10), -- In observational meteorolgy, visibility greater than 10 miles is considered perfect and stll reported as 10 miles.
constraint check(humidity between 0 and 100),
primary key(station_id)
);

-- Creating the second table to insert the clean data into.
create table current_weather like current_weather_load;

-- Creating the weather_advisory table.

create table weather_advisory
(
	station_id int not null,
    station_city varchar(50),
	advisory_message varchar(200),
    created_at datetime default now()
);
