#!/bin/bash
# compile.sh
# Conversion of compile.cmd to a shell script.
# Compile java source files with JDK 1.8 compatibility
# set JX_HOME to the root directory of Gilhari installation.
JX_HOME=$PWD/../..

# With JDK 1.8
javac -d ./bin -cp .:$JX_HOME/libs/jxclasses.jar:$JX_HOME/external_libs/json-json-20240303.jar @sources.txt

# With JDK 1.9 or higher
javac -d ./bin --release 8 -cp .:$JX_HOME/libs/jxclasses.jar:$JX_HOME/external_libs/json-json-20240303.jar @sources.txt