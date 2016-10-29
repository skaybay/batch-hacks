@echo off
setlocal enabledelayedexpansion


::detects permissions and checks if O: drive is present
	:testadmin
		echo Administrative permissions required. Detecting permissions...
		    net session >nul 2>&1
		    if %errorLevel% == 0 (
		echo Success: Administrative permissions confirmed. 
		::an ugly oneliner for checking if drive o: is present, displaying message to user if not and gracefully exiting after waiting for user to read the message:
		cd O: >nul 2>&1 || ( msg * Error: O: drive not found. ) && exit /b 1
		goto :testdiskspace
		) else (
		echo Failure: Insufficient permissions. 
		echo ERROR:THIS SCRIPT MUST BE RUN AS ADMINISTRATOR
		pause
		exit /b 1
		)
:: checking if amount of free space is sufficient for backup
	:testdiskspace
		echo Checking amount of free disk space on O:
		fsutil volume diskfree O: | findstr "avail" > %temp%o_space_free.txt 
		FOR /F "tokens=8" %%a IN (%temp%o_space_free.txt) DO (
		set space_free=%%a
		)
		set /a freeGB=%space_free:~0,-5%*100
		fsutil volume diskfree O: | findstr /v free > %temp%o_space_total.txt
		FOR /F "tokens=6" %%a IN (%temp%o_space_total.txt) DO (
		set space_total=%%a
		)
		set /a totalGB=%space_total:~0,-5%
		set /a percent=%freeGB%/%totalGB%
		msg * /time:10 %percent%%% of free space left on backup drive O:. 
		goto :backup
		
::backing up data + closing and restarting outlook
	:backup
		
		taskkill /f /t /im outlook.exe >nul 2>&1 && echo Closing Outlook...
		echo Backing up %UserProfile% to O:\%USERNAME%
		::mkdir O:\"%date:~7,2%-%date:~4,2%-%date:~10,4%"
		timeout /t 1 >nul 2>&1
		echo Backup operation in progress, please wait...
		start /wait robocopy %UserProfile% O:\%USERNAME% /MIR /FFT /ZB /R:3 /W:5 /NP /MT:8 /XJ /SEC /SECFIX /V /LOG:%userprofile%\Desktop\%date:~7,2%-%date:~4,2%-%date:~10,4%.txt /tee
		timeout /t 5 >nul 2>&1
		echo Restarting Outlook...
		start outlook
		msg * Backup completed. Data from %UserProfile% was backed up to O:\%USERNAME%. Examine log %userprofile%\Desktop\%date:~7,2%-%date:~4,2%-%date:~10,4%.txt for details.
		:: literal bells and whistles (: :
		echo  (^G)  (^G) (^G) (^G) (^G)
		timeout /t 2 >nul 2>&1
		exit /b 0