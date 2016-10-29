@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
echo No MAC address specified
echo USAGE: RARP 00:11:22:33:44:55:66
) else (
set MAC=%1
set MAC=!MAC::=-!
echo !MAC!
echo   IP 			MAC		      Type
arp -a | findstr /I !MAC!
)