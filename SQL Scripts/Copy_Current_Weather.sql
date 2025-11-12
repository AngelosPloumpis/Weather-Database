/* This script copies the (now validated) data from current_weather_load
to the current_weather table, then calls the p_weather_advisory procedure
to generate advisories based on conditions, and finally displays both the 
user-intended weather table and the advisory table.*/
use weather;
truncate table current_weather;
insert into current_weather
(
	station_id,
	station_city,  
	station_state,
	station_latitude,
	station_longitude,
	input_datetime,
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
select	station_id,
		station_city,  
		station_state,
		station_latitude,
		station_longitude,
		input_datetime,
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
from    current_weather_load;

-- Calling the advisory procedure.

call p_weather_advisory();

/*Here we have two options. First one is to create a left join to display 
all the values from the current_weather table and the advisory message 
for the cities that meet the criteria. */
select  cw.station_id,
		cw.station_city,  
		cw.station_state,
		cw.station_latitude,
		cw.station_longitude,
		cw.input_datetime,
		cw.temp,
		cw.percieved_temp,
		cw.wind_speed,
		cw.wind_direction,
		cw.precipitation,
		cw.pressure,
		cw.visibility,
		cw.humidity,
		cw.weather_condition,
		cw.sunrise,
		cw.sunset,
        wa.advisory_message,
        wa.created_at
from current_weather as cw
left join weather_advisory as wa
on cw.station_id = wa.station_id;

/* Or we can query the database twice, once to display the current_weather table
and again to display the weather_advisory table. The choice would be 
left up to the user

select * from current_weather;
select * from weather_advisory;

*/

/* Additionally, the user can choose to save the joint table by 
uncommenting the following code and choosing the file path they wish:
select  cw.station_id,
        cw.station_city,  
        cw.station_state,
        cw.station_latitude,
        cw.station_longitude,
        cw.input_datetime,
        cw.temp,
        cw.percieved_temp,
        cw.wind_speed,
        cw.wind_direction,
        cw.precipitation,
        cw.pressure,
        cw.visibility,
        cw.humidity,
        cw.weather_condition,
        cw.sunrise,
        cw.sunset,
        wa.advisory_message,
        wa.created_at
into outfile 'FILE_PATH.csv'
fields terminated by ',' 
enclosed by '"' 
lines terminated by '\n'
from current_weather as cw
left join weather_advisory as wa
on cw.station_id = wa.station_id;
*/
