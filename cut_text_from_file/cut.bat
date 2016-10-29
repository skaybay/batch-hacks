@echo off
setlocal enabledelayedexpansion
set cut=%1
set text=%2
for /f "delims=" %%a in ('findstr %cut% %text%') do (
	set str=%%a
   	set str=!str:%cut%=! 
	echo( !str!
    ) 

