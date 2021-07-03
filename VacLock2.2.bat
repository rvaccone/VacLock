@echo off
setlocal

Rem Current version number
set version=2.2

Rem Changes the text colors for slightly better readability
color 07

Rem Deleting previous VacLock file
set oversion=%~1
if not "%oversion%"=="" (del /F /Q VacLockVersion%oversion%.bat)

Rem Checking if the user is online
Ping www.vacwear.com -n 1 -w 1000
cls
if errorlevel 1 (goto Offline) else (goto Online)

:Offline
echo You are not connected to the internet
echo VacLock cannot check for updates
goto OfflineStart

:Online
echo You are connected to the internet

Rem Checking for updates
echo Checking for updates...
powershell wget https://vacwear.com/VacLock/version.txt -OutFile VacLockVersion.txt
set /p nversion=< VacLockVersion.txt
del /F /Q VacLockVersion.txt
if %version%==%nversion% (goto Current) else (goto Update)
pause

Rem Needs to be updated
:Update
echo You are not up to date! File will update automatically
powershell wget https://vacwear.com/VacLock/VacLock%nversion%.bat -OutFile VacLock%nversion%.bat

Rem Call the new version, so you dont need to restart VacLock
echo -----
call VacLock%nversion%.bat %version%

Rem Current version is up to date
:Current
echo You are up to date!
:OfflineStart
echo -----
echo Welcome to VacLock %version%

Rem Create a variable for the lock command
set commandLock="%windir%\System32\rundll32.exe user32.dll,LockWorkStation"
set commandShutdown="shutdown /s /t 300"

Rem Determine if the user wants to create or delete a task
:Action
echo -----
echo New automations will lock your computer when idle
set /p temp="Do you want to create a new automation or delete an existing one? (Ex: create or delete): "
set temp=%temp: =%
if /i "%temp%"=="create" goto :Create
if /i "%temp%"=="delete" goto :Delete

Rem If their choice is not recognized
echo -----
echo Your choice is not recognized. Please try again.
pause
goto :Action

:Create
Rem Input variables
echo -----

Rem Creating the task
schtasks /create /sc onidle /tn "VacLock Lock" /tr %commandLock% /i "1" /it /f
echo Thank you for using VacLock
pause
goto :eof

:Delete
Rem Deleting the task
schtasks /delete /tn "VacLock Lock" /f
echo Thank you for using VacLock
pause
goto :eof