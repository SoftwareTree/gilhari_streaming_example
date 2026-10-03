#!/bin/bash
# Compiles the container domain model classes (all .java files under src/)
# into bin/ with Java 8 compatibility, as required by the current Gilhari version.
#
# Can be run from any directory (e.g., ./scripts/compile.sh from the project
# root); it switches to the project root first.
#
# JX_HOME must point to the root directory of the Gilhari SDK installation.
# If JX_HOME is not set, ../.. (relative to the project root) is used, which
# matches the location of this example in the SDK (examples/gilhari_streaming_example).
cd "$(dirname "$0")/.."
JX_HOME="${JX_HOME:-$PWD/../..}"
if [ ! -f "$JX_HOME/libs/jxclasses.jar" ]; then
    echo "Cannot find the Gilhari SDK libraries at $JX_HOME/libs/jxclasses.jar"
    echo "Set JX_HOME to the root directory of your Gilhari SDK installation and run"
    echo "this script again, for example:"
    echo "    export JX_HOME=/path/to/Gilhari_SDK"
    exit 1
fi
mkdir -p ./bin

# List all the .java files under src/ for javac
find src -name "*.java" | sort > sources.txt

# JDK 9 or higher: --release 8 produces Java 8 compatible classes.
# JDK 1.8 does not support (or need) that flag.
RELEASE_FLAG=""
if javac -help 2>&1 | grep -q -- "--release"; then
    RELEASE_FLAG="--release 8 -Xlint:-options"
fi

if javac $RELEASE_FLAG -d ./bin -cp ".:$JX_HOME/libs/jxclasses.jar:$JX_HOME/external_libs/json-20240303.jar" @sources.txt; then
    echo "Compilation completed successfully."
else
    echo "Compilation failed."
    exit 1
fi
