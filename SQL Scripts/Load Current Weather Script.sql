-- This script is used to load the CSV file into the current_weather_load table.
use weather;

/* We are using the current_weather_load table as a filter to remove erroneous data
from the CSV file we received, so we need to clear the data of the previous weather 
report every time the program receives new data */

truncate table current_weather_load;

-- Loading the data from the CSV file.

load data
local infile 'C:/Users/aggel/Downloads/weather.csv'
into table current_weather_load
fields terminated by ','
(
	station_id,
	station_city,  
	station_state,
	station_latitude,
	station_longitude,
	@input_time, -- Here we create a user variable so we can convert the string date we receive from the CSV file into a SQL datetime.
	temp,
	percieved_temp,
	wind_speed,
	wind_direction,
	precipitation,
	pressure,
	visibility,
	humidity,
	weather_condition,
	sunrise,
	sunset
)
-- Creating the datetime value from the string.

set input_datetime = str_to_date(@input_time,'%Y%m%d %H:%i');

-- This command will show any errors we encounterd while loading the data to our table.

show warnings;

/* We create a query to check if any of the data is missing.
We compare the old data from the current_weather table with the new data we 
just wrote to the current_weather_load table by checking if there are
missing stations in our new entries.*/

select concat_ws('No data has been loaded for',station_id,':',station_city)
from current_weather as cw
where cw.station_id not in
(
    select cwl.station_id
    from current_weather_load as cwl
);
select * from current_weather_load;
