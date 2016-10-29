@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
	echo No PC Specified
	echo USAGE: r_boot full-computer-name-or-IP [time-in-minutes]
	pause
	exit /B
	) else (
	set r_PC=%~1
	)
if "%~2"=="" (
	echo No time specified. Default time = now.
	set r_time=0
	echo %r_PC% will be rebooted now
	) else ( 
	set /a r_time=%~2*60
	echo "%r_PC% will be rebooted in %r_time% seconds (%~2 minutes)"
	)
ping %r_PC% -n 1 -l 1 >nul 2>&1
if %errorlevel% neq 0 (
	echo %r_PC% seems to be already offline.
	pause
	exit /B
	)

echo Does everything seem correct? Press ctrl + c to cancel.
pause

shutdown -r -f -t %r_time% -m \\%R_PC% -c "Computer will be rebooted in %~2 minutes - logout and save your work" >nul 2>&1
if %errorlevel% neq 0 (
	echo The shutdown command could not be issued.
)
echo Computer will be rebooted. You can now quit or monitor progress below.
echo To cancel use : shutdown -a  -m \\%r_PC%
timeout /t %r_time% /NOBREAK

:loop1

	echo %time% %r_PC% is shutting down...
	timeout /t 5 /NOBREAK >nul 2>&1
	ping %r_PC% -n 1 -l 1 |findstr /r /c:"[0-9] *ms" >nul 2>&1
	if %errorlevel% neq 0 (
	echo %time% %r_PC% is now rebooting...
) else ( goto loop1 )

:loop2
	timeout /t 5 /NOBREAK >nul 2>&1
	ping %r_PC% -n 1 -l 1 |findstr /r /c:"[0-9] *ms" >nul 2>&1
	if %errorlevel% equ 0 ( 
	echo %time% %r_PC% is back online
) else ( goto loop2 )