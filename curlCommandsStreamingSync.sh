#!/bin/bash
#  A script to invoke some sample curl commands on a Linux/Mac machine
#  against a running container image of the app-specific Gilhari microservice 
#  gilhari_streaming_example:1.0.
#
#  The responses are recorded in a log file (curl.log).
#
#  These curl commands invoke the REST APIs in sync mode. Default is Async.
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

# ** Query all Employee objects
echo "** Query all Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Start a streaming query for all exempt Employee objects in the descending order by their "name"s, get first two
echo "** Start a streaming query for all exempt Employee objects in the descending order by their 'name's, get first two" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee/startStream/sync?filter=exempt+ORDER+BY+name+DESC&maxObjects=2" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Fetch 3 more Employee objects from the stream
echo "** Fetch 3 more Employee objects from the stream" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee/fetchMore/sync?maxObjects=3" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Fetch the remaining Employee objects from the stream
echo "** Fetch the remaining Employee objects from the stream" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee/fetchMore/sync?maxObjects=-1" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Close the streaming query for the Employee objects
echo "** Close the streaming query for the Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee/closeStream/sync" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query non-exempted Employee objects
echo "** Query non-exempted Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee?filter=exempt=0" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of all Employee objects
echo "** Query the count of all Employee objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/Employee/getAggregate?attribute=id&aggregateType=COUNT" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# End logging
echo "** END OUTPUT **" >> "$log_file"
echo "" >> "$log_file"

# Display the log content
cat "$log_file"
