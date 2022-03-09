REM ************************************************************************************************
REM Runs speedtest cli and saves the results to a json file that will be retrieved by Home Assistant
REM which is running in a docker container. The folder must be on a shared docker volume and be
REM defined in the "allowlist_external_dirs:" section of the configuration.yaml file.
REM 
REM To be run run by task scheduler at regular intervals
REM ************************************************************************************************

@echo off

cd %~dp0

REM File and folder configs
set SPEEDTEST_FOLDER=.
set SPEEDTEST_FILENAME=speedtest
set SPEEDTEST_FORMAT=json

REM Run speedtest against UNINETT (server id 25057). Save result on file
REM See https://c.speedtest.net/speedtest-servers-static.php for more server IDs
speedtest.exe --server-id=25057 --format=%SPEEDTEST_FORMAT% > %SPEEDTEST_FOLDER%\%SPEEDTEST_FILENAME%_real.%SPEEDTEST_FORMAT%

REM Remove ending CRLF in file
for /F usebackq^ delims^=^ eol^= %%L in ("%SPEEDTEST_FOLDER%\%SPEEDTEST_FILENAME%_real.%SPEEDTEST_FORMAT%") do (
    < nul set /P ="%%L" > %SPEEDTEST_FOLDER%\%SPEEDTEST_FILENAME%.%SPEEDTEST_FORMAT% 
) 

REM Remove unnecessary files
del /q %SPEEDTEST_FOLDER%\%SPEEDTEST_FILENAME%_real.%SPEEDTEST_FORMAT% 2> nul

EXIT