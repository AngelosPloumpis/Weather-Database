# Weather Database

This is a MySQL project that takes in a CSV file with weather data, checks and cleans it, and then uses a stored procedure to create a table with weather advisories for extreme conditions. After that, the final weather table is joined with the advisory table so users can see everything in one place.

---

## Project Background

This is the first of three projects I'm doing from the book *MySQL Crash Course* by Rick Silva.

The idea is that a trucking company is working with a meteorological service to get hourly weather updates for the cities in its delivery network. Since the delivery time of the weather data might not always be consistent, I added a cron job and a Bash script to check every few minutes if a new file has arrived and process it automatically.

---

## How It Works

### 1. Creating the Tables

The script `Create_Weather_Tables.sql` sets up three tables:

- `current_weather_load`: This is where the raw CSV data goes first. It has 17 columns with different weather metrics. If any values are outside normal ranges, they get set to `NULL`, and the user should ask the weather service for a new file.
- `current_weather`: This is the cleaned-up version of the data that users can actually work with.
- `weather_advisory`: This table shows alerts for extreme weather (like freezing temperatures). It’s filled by a stored procedure.

---

### 2. Loading the Data

The script `Load_Current_Weather.sql` does the following:

- Clears the `current_weather_load` table
- Loads the new CSV file into it
- Shows any warnings from MySQL
- Checks if any stations are missing from the new file

---

### 3. Copying and Creating Advisories

The script `Copy_Current_Weather.sql`:

- Clears the `current_weather` table
- Copies the verified data from `current_weather_load`
- Calls the procedure `p_weather_advisory` to fill the `weather_advisory` table
- Gives the user two options:
  - **Join view (default)**: Combines `current_weather` and `weather_advisory` so you can see alerts next to the cities
  - **Separate view**: You can comment/uncomment parts of the SQL to show the tables separately
- You can also export the joined table to a CSV file if you want

---

### 4. The Advisory Procedure

The script `Weather_Advisory.sql` defines the procedure `p_weather_advisory`, which:

- Clears the `weather_advisory` table
- Adds alerts based on certain conditions (like if the temperature drops below 32°F or 0°C, it adds a message like "Freezing Conditions")

---

### 5. Automation with Cron and Bash

- `weather_cronjob.txt`: This is a cron job that runs every 5 minutes
- `weather.sh`: A Bash script that:
  - Prompts the user for their MySQL username and password
  - Checks if a new CSV file has been received
  - If yes, it runs the Load_Current_weather and Copy_Current_Weather SQL scripts
  - If not, it exits and waits for the next cron run

This setup helps automate the process since the weather data might not always arrive at the same time.

---

## Notes

- The advisory table and procedure weren’t part of the original project in the book — I added them because I thought it would be helpful to highlight extreme weather conditions automatically.
- The criteria I used for generating advisory messages are just a proof of concept. The advisory system can easily be expanded to include any conditions that would make driving unsafe — the examples in the code are just a starting point.
- The advisory procedure is created once during the initial setup and doesn’t need to be recreated each time the system runs. The Copy_Current_Weather script simply calls it when needed. This keeps the process efficient and avoids unnecessary overhead.
- I wrote all the SQL scripts myself. The Bash and cron scripts were adapted from the book, but I modified them to prompt for credentials and fit this project.
- In the future, I’d like to add a simple predictive model using Python or R to forecast next-day temperatures based on the data.

---

Thanks for checking out my project! If you have any feedback or suggestions, I’d love to hear them.
