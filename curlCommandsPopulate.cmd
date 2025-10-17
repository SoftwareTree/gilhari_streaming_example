REM  A script to invoke some sample curl commands on a Windows machine
REM  against a running container image of the app-specific Gilhari microservice 
REM  gilhari_streaming_example:1.0.
REM
REM  This scripts populates some data but does not delete them.
REM
REM  The responses are recorded in a log file (curl.log).
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

echo ** Delete all Employee objects to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/Employee" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one Employee object >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json"  -d "{""entity"":{""id"":39,""name"":""John39"",""compensation"":54039,""exempt"":true,""DOB"":381484800390}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert multiple (two) Employee objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json"  -d "{""entity"":[{""id"":40,""name"":""Mike40"",""compensation"":54040,""exempt"":false,""DOB"":381484800400}, {""id"":41,""name"":""Mary41"",""compensation"":54041,""exempt"":true,""DOB"":381484800410}]}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert multiple (three) Employee objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json"  -d "{""entity"":[{""id"":42,""name"":""Tom42"",""compensation"":54042,""exempt"":false,""DOB"":381484800420}, {""id"":43,""name"":""Rob43"",""compensation"":54043,""exempt"":false,""DOB"":381484800430},{""id"":44,""name"":""Sarah44"",""compensation"":54044,""exempt"":true,""DOB"":381484800440}]}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query non-exempted Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee?filter=exempt=0"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of exempted Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/getAggregate?attribute=id&aggregateType=COUNT&filter=exempt=1"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** END OUTPUT ** >> curl.log
echo. >> curl.log

type curl.log

