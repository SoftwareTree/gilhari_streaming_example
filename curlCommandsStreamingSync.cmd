REM  A script to invoke some sample curl commands on a Windows machine
REM  against a running container image of the app-specific Gilhari microservice 
REM  gilhari_streaming_example:1.0.
REM
REM  The responses are recorded in a log file (curl.log).
REM
REM  These curl commands invoke the REST APIs in sync mode. Default is Async.
REM
REM  Note that these curl commands use a default mapped port number of 80
REM  even though the port number exposed by the app-specific
REM  microservice may be different (e.g., 8081) inside the container shell.
REM
REM  You may optionally specify a non-default port number as the first 
REM  command line argument to this script. For example, to specify a 
REM  port number of 8899, use the following command:
REM     curlCommands 8899

IF %1.==. GOTO DefaultPort
SET port=%1
GOTO Proceed

:DefaultPort
SET port=80
GOTO Proceed

:Proceed

echo ** BEGIN OUTPUT ** > curl.log
echo. >> curl.log

echo Using PORT number %port% >> curl.log
echo. >> curl.log


echo ** Query all Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log


echo ** Start a streaming query for all exempt Employee objects in the descending order by their "name"s, get first two >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/startStream/sync?filter=exempt+ORDER+BY+name+DESC&maxObjects=2"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Fetch 3 more Employee objects from the stream >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/fetchMore/sync?maxObjects=3"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Fetch the remaining Employee objects from the stream >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/fetchMore/sync?maxObjects=-1"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Close the streaming query for the Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/closeStream/sync"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query non-exempted Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee?filter=exempt=0"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log


echo ** Query the count of all Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/getAggregate?attribute=id&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** END OUTPUT ** >> curl.log
echo. >> curl.log

type curl.log

