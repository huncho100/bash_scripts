Practice, project overview:
curl wttr.in/casablanca
Hands On lab:
https://labs.cognitiveclass.ai/v2/tools/cloud-ide?ulid=ulid-ac71126968897a4f9c0de97a60ffd6fe9a9d150c
Weather report header:
header=$(echo -e "year\tmonth\tday\thour\tobs_tmp\tfc_temp") — \t is a tab separator
echo $header>rx_poc.log
OR:
echo -e "year\tmonth\tday\thour\tobs_tmp\tfc_temp">rx_poc.log
Writing date in a specified format: date +%Y%m%d
Create the filename for today’s wttr.in weather report:
today=$(date +%Y%m%d)
weather_report=raw_data_$today
OR:
weather_report=raw_data_$(date +%Y%m%d)
Download the wttr.in weather report for Casablanca and save it with the filename you created:
city=Casablanca
curl wttr.in/$city --output $weather_report
OR:
curl wttr.in/casablanca > weather_rp_$today 
Extracting required Data:
Filters Examples:
tr:
tr - trim repeated characters to a single character.
echo "There are    too    many spaces in this    sentence." | tr -s " "
xargs:
xargs - can be used to trim leading and trailing spaces from a string.
echo " Never start or end a sentence with a space. " | xargs 
rev:
rev - reverse the order of characters on a line of text.
echo ".sdrawkcab saw ecnetnes sihT" | rev
rev | cut — Combining rev with cut command:
# print the last field of the string
echo "three two one" | rev | cut -d " " -f 1 | rev
Xargs | cut:
# Unfortunately, this prints the last field of the string, which is empty:
echo "three two one " | rev | cut -d " " -f 1 | rev
# But if you trim the trailing space first, you get the expected result:
echo "three two one " | xargs | rev | cut -d " " -f 1 | rev
Extracting the data of interest: temperatures:
grep °C $weather_report > temperatures.txt
OR:
cat | grep + $weather_report > temperatures.txt
Extract the current temperature, and store it in a shell variable called obs_tmp:
obs_tmp=$(head -1 temperatures.txt | tr -s " " | xargs | rev | cut -d " " -f2 | rev)
OR:
obs_tmp1=$(head -1 temperatures.txt | tr -s " " | xargs | cut -d " " -f5) — without rev
Extract tomorrow’s temp forecast for noon, and store it in a shell variable called fc_tmp:
fc_temp=$(head -3 temperatures.txt | tail -1 | tr -s " " | xargs | cut -d "C" -f2 | rev | cut -d " " -f2 | rev)
OR:
fc1_tmp=$(head -3 temperatures.txt | tail -1 | tr -s " " | xargs | cut -d " " -f11)
OR:
fc_tmp=$(sed -n '3p' temperatures.txt | tr -s " " | xargs | cut -d " " -f11-12)
popular date format specifiers:
%D		date in figures (03/9/2024)
%d		day of the month (01 to 31)
%h		abbreviated month name (Jan to Dec)
%m		month of year (01 to 12)
%Y		four-digit year
%T		time in 24 hour format as HH:MM:SS
%H		hour
%j 		julian day of the year
%A		day of the week
Example:
date +%D — Display date in figure
hour=$(TZ='Nigeria/makurdi' date -u +%T)
day=$(TZ='Nigeria/makurdi' date -u +%d)
month=$(TZ='Nigeria/makurdi' date +%h)
year=$(TZ='Nigeria/makurdi' date +%Y)
date "+It's %A, the %j day of %Y!" 

Merge the fields into a tab-delimited record, corresponding to a single row in:
current_tmp=$(echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp")
echo $current_tmp >> current_weather.tmp
OR:
echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp" >> rx_poc.log

Determine dates:
date
date -u — utc
Creating cron job — Exercise 3 - Schedule your bash script rx_poc.sh to run every day at noon local time:
m	h	dom	mon	dow	command
*/13 * * * * rx_poc.sh

Reading: Cheat Sheet: Linux Commands and Shell Scripting:
https://d3c33hcgiwev3.cloudfront.net/PQO2fyvcSZqpWkCMOizTgA_0e2952a3788e4850a67b007331175ef1_M4_Cumulative_Cheat_Sheet.pdf?Expires=1710201600&Signature=NSveBSzx1OcYP9o85EmdSqYfQr7qOJgMmZqQ~cEzNq9VuxHfSTOoKBVKTrgHHNHeZ9Pk~6UaJyo6Vpls147AGJU1jk9QrA0H5b1Bkb~E9VgkpEBaibpsgcQwqVfhHwaFScnogEJ08ROZqcn8YBHReSMQAcPsJsFrt8blSKMfn18_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A

