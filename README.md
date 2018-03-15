# Satellite Tracker README

## Description
Satellite Tracker is an endpoint that listen's to Nestio's satellite API and creates separate API end-points for /stats and /health. Nestio's satellite API posts satellite altitude (km) and time of update every 10 seconds. 

The Satellite Tracker /stats end-point returns the minimum, maximum, and average altitudes from Nestio's API from the last 5 minutes (i.e. if the /stats API request was made at 5:55:25, the stats would include records from Nestio's API going back to 5:50:20) in a json object.

The Satellite Tracker /health end-point returns a description of the altitude of the satellite. If the altitude has been below 160 km for the past minute (i.e. if the request was made at 5:55:25, the satellite would have been below 160 km since 5:55:20), the end-point returns "WARNING: RAPID ORBITAL DECAY IMMINENT". Once the average altitude of the satellite returns to 160km or above, the end-point returns "Sustained Low Earth Orbit Resumed" for a minute. Otherwise, the /health end-point returns "Altitude is A-OK".

Satellite Tracker works by making calls to the Nestio API every 10 seconds and saving the data as a record saved to a Postgres database table called satellite_records with variables time_updated, altitude, average, and minute_below. On each API call any records beyond the 5 minutes of records needed to calculate the data for the /stats endpoint are deleted. The only rails model used is the model in the table, Satellite Record. There are two service object used to fetch data (Satellite Data Fetcher) and report data (Satellite Reporter).

## Specifications
### Rails
* Version: 5.1.5
* Gems/Dependencies: pg, rest-client, json, whenever
### Postgresql
* Version 9.6

## Installation and Implementation Instructions
In order to run the application, fork the repo or clone using the following:

git clone https://github.com/pawlkris/satellite-tracker.git

Navigate to the main directory on your local drive. 

Run
```whenever --update-crontab```
in the terminal command line to start the cron job to pull data from Nestio's satellite API. The cron job is set to run on the developer server. You can make modifications to the cron job in the schedule.rb file (root/config/schedule.rb)

Run
```rails s```
in the terminal command line to run the rails server on http://localhost:3000

Get requests to http://localhost:3000/stats will yield /stats data and http://localhost:3000/health will yield /health data, which are outlined in the Description section.

To stop the cron job, enter 
```crontab -r```
in the terminal command line.

You can run tests by running
```rspec```
in the command line. Tests can be found in the root/rspec/models folder.


