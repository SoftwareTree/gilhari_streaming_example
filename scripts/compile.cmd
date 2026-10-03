@echo off
setlocal
REM Compiles the container domain model classes (all .java files under src\)
REM into bin\ with Java 8 compatibility, as required by the current Gilhari version.
REM
REM Can be run from any directory (e.g., scripts\compile.cmd from the project
REM root); it switches to the project root first.
REM
REM JX_HOME must point to the root directory of the Gilhari SDK installation.
REM If JX_HOME is not set, ..\.. (relative to the project root) is used, which
REM matches the location of this example in the SDK (examples\gilhari_streaming_example).
cd /d "%~dp0.."
if not defined JX_HOME set JX_HOME=..\..
for %%i in ("%JX_HOME%") do set "JX_HOME=%%~fi"
if exist "%JX_HOME%\libs\jxclasses.jar" goto :jx_home_ok
echo Cannot find the Gilhari SDK libraries at %JX_HOME%\libs\jxclasses.jar
echo Set JX_HOME to the root directory of your Gilhari SDK installation and run
echo this script again, for example:
echo     set JX_HOME=C:\path\to\Gilhari_SDK
exit /b 1
:jx_home_ok
if not exist bin mkdir bin

REM List all the .java files under src\ for javac, as paths relative to the
REM project root with forward slashes. (dir /s /b would write absolute paths,
REM which javac misreads if they contain spaces.)
setlocal enabledelayedexpansion
set "ROOT=%CD%\"
(for /r src %%f in (*.java) do (
    set "p=%%f"
    set "p=!p:%ROOT%=!"
    echo !p:\=/!
)) > sources.txt
endlocal

REM JDK 9 or higher: --release 8 produces Java 8 compatible classes.
REM JDK 1.8 does not support (or need) that flag.
set RELEASE_FLAG=
javac -help 2>&1 | findstr /C:"--release" >nul && set RELEASE_FLAG=--release 8 -Xlint:-options

javac %RELEASE_FLAG% -d .\bin -cp ".;%JX_HOME%\libs\jxclasses.jar;%JX_HOME%\external_libs\json-20240303.jar" @sources.txt
if errorlevel 1 (
    echo Compilation failed.
    exit /b 1
)
echo Compilation completed successfully.
