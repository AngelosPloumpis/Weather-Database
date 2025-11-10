/* This script creates the procedure to populate the advisory table.
   The procedure is meant to first clear the advisory table, and then fill 
   it with new advisories for cities that meet certain criteria.*/

use weather;

drop procedure if exists p_weather_advisory;

delimiter //
create procedure p_weather_advisory()
begin
	truncate table weather_advisory; -- Clearing the advisory table.
	insert into weather_advisory
    (station_id,
    station_city,
    advisory_message
    )
    select station_id,station_city,
		case -- Inputing the criteria.
			when temp < 32 then 'Freezing Conditions'
			when wind_speed > 50 then 'High Wind Advisory'
			when precipitation between 30 and 49 then 'Possible Flooding'
			when precipitation >= 50 then 'Flooded Roads Warning'
			when visibility between 0.3 and 0.5 then 'Possible Limited Visibility Ahead'
			when visibility < 0.3 then 'Dangerous Visibility Conditions'
			when weather_condition like '%snow%' then 'Snow Advisory'
			when weather_condition like '%ice%' then 'Icy Roads Advisory'
			when weather_condition like '%thunderstorm%' then 'Possible Flooding And Limited Visibility Advisory'
			when weather_condition like '%heatwave%' then 'Possible Heat Exhaustion Advisory'
		end
	from current_weather
    where (
		   temp < 32
        or wind_speed > 50
        or precipitation >= 30
        or visibility <= 0.5
        or weather_condition like '%snow%'
        or weather_condition like '%ice%'
        or weather_condition like '%thunderstorm%'
        or weather_condition like '%heatwave%'
		);
	end //
    delimiter ;
drop procedure p_weather_advisory;