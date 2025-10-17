#!/bin/bash
#  A script to invoke some sample curl commands on a Linux/Mac machine
#  against a running container image of the app-specific Gilhari microservice 
#  gilhari_streaming_example:1.0.
#
#  This scripts populates some data but does not delete them.
#
#  The responses are recorded in a log file (curl.log).
#
#  Note that these curl commands use a default mapped port number of 80
#  even though the port number exposed by the app-specific
#  microservice may be different (e.g., 8081) inside the container shell.
#
#  You may optionally specify a non-default port number as the first 
#  command line argument to this script. For example, to specify a 
#  port number of 8899, use the following command:
#     curlCommands 8899

# Check if a port is provided as an argument, if not, use default port 80
if [ -z "$1" ]; then
    port=80
else
    port=$1
fi

# Log file where output will be saved
log_file="curl.log"

# Start logging
echo "** BEGIN OUTPUT **" > "$log_file"
echo "" >> "$log_file"

# Log port information
echo "Using PORT number $port" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all Employee objects to start fresh
echo "** Delete all Employee objects to start fresh" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/Employee" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one Employee object
echo "** Insert one Employee object" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" -d '{"entity":{"id":39,"name":"John39","compensation":54039,"exempt":true,"DOB":381484800390}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all Employee objects
echo "** Query all Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert multiple (two) Employee objects
echo "** Insert multiple (two) Employee objects" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" -d '{"entity":[{"id":40,"name":"Mike40","compensation":54040,"exempt":false,"DOB":381484800400}, {"id":41,"name":"Mary41","compensation":54041,"exempt":true,"DOB":381484800410}]}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert multiple (three) Employee objects
echo "** Insert multiple (three) Employee objects" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" -d '{"entity":[{"id":42,"name":"Tom42","compensation":54042,"exempt":false,"DOB":381484800420}, {"id":43,"name":"Rob43","compensation":54043,"exempt":false,"DOB":381484800430},{"id":44,"name":"Sarah44","compensation":54044,"exempt":true,"DOB":381484800440}]}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all Employee objects
echo "** Query all Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query non-exempted Employee objects
echo "** Query non-exempted Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee?filter=exempt=0" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of exempted Employee objects
echo "** Query the count of exempted Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee/getAggregate?attribute=id&aggregateType=COUNT&filter=exempt=1" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# End logging
echo "** END OUTPUT **" >> "$log_file"
echo "" >> "$log_file"

# Display the log content
cat "$log_file"
