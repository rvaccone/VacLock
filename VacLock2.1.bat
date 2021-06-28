@echo off
setlocal

Rem Current version number
set version=2.1

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
echo "If you want to change the idle delay, create a new automation"
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
Rem Determine if the user wants to create a lock or shutdown task
echo -----
set /p temp="Do you want to lock your computer when idle, shutdown, or both? (Ex: lock, shutdown, or both): "
set temp=%temp: =%
if /i "%temp%"=="lock" goto :CreateLock
if /i "%temp%"=="shutdown" goto :CreateShutdown
if /i "%temp%"=="both" goto :CreateBoth

Rem If their choice is not recognized
echo -----
echo Your choice is not recognized. Please try again.
pause
goto :Create

:CreateLock
Rem Input variables
echo -----
echo The delay is in minutes from 1 to 999
set /p iltime="How long after being idle should your computer be locked?: "
set iltime=%iltime: =%

Rem Creating the task
schtasks /create /sc onidle /tn "VacLock Lock" /tr %commandLock% /i %iltime% /it /f
echo Thank you for using VacLock
pause
goto :eof

:CreateShutdown
Rem Input variables
echo -----
echo The delay is in minutes from 1 to 999
set /p istime="How long after being idle should your computer shutdown?: "
set istime=%istime: =%

Rem Creating the task
schtasks /create /sc onidle /tn "VacLock Shutdown" /tr %commandShutdown% /i %istime% /it /f
echo Thank you for using VacLock
pause
goto :eof

:CreateBoth
Rem Input variables
echo -----
echo The delay is in minutes from 1 to 999
set /p iltime="How long after being idle should your computer be locked?: "
set iltime=%iltime: =%
set /p istime="How long after being idle should your computer shutdown?: "
set istime=%istime: =%

Rem Creating the tasks
schtasks /create /sc onidle /tn "VacLock Lock" /tr %commandLock% /i %iltime% /it /f
schtasks /create /sc onidle /tn "VacLock Shutdown" /tr %commandShutdown% /i %istime% /it /f
echo Thank you for using VacLock
pause
goto :eof

Rem Changing the task
schtasks /create /sc onidle /tn "VacLock" /tr %command% /i %itime% /it /f
echo Thank you for using VacLock
pause
goto :eof

:Delete
Rem Determine if the user wants to create a lock or shutdown task
echo -----
set /p temp="Do you want to delete your lock automation, shutdown automation, or both? (Ex: lock, shutdown, or both): "
set temp=%temp: =%
if /i "%temp%"=="lock" goto :DeleteLock
if /i "%temp%"=="shutdown" goto :DeleteShutdown
if /i "%temp%"=="both" goto :DeleteBoth

Rem If their choice is not recognized
echo -----
echo Your choice is not recognized. Please try again.
pause
goto :Delete

:DeleteLock
Rem Deleting the task
schtasks /delete /tn "VacLock Lock" /f
echo Thank you for using VacLock
pause
goto :eof

:DeleteShutdown
Rem Deleting the task
schtasks /delete /tn "VacLock Shutdown" /f
echo Thank you for using VacLock
pause
goto :eof

:DeleteBoth
Rem Deleting the tasks
schtasks /delete /tn "VacLock Lock" /f
schtasks /delete /tn "VacLock Shutdown" /f
echo Thank you for using VacLock
pause
goto :eof