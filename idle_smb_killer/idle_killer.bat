@echo off
setlocal enabledelayedexpansion

::admin test module
:testadmin
	echo Administrative permissions required. Detecting permissions...
	    net session >nul 2>&1
	    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        goto :netparser
        ) else (
        echo Failure: Insufficient permissions. 
        echo THIS SCRIPT MUST BE RUN AS ADMINISTRATOR
        pause
        exit /b 1
        )
        
::parse net session and kill session with over 24h of idle time
:netparser
	net session | findstr /R "..D ..H ..M" > %temp%\net_session.txt
	echo net session | findstr /R "..D ..H ..M"
	FOR /F "tokens=1" %%a IN (%temp%\net_session.txt) DO (
		echo net session %%a /delete 
		net session %%a /delete /Y
		del %temp%\net_session.txt
		)
	exit /B 0
