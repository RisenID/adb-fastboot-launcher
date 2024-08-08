@echo off
mode 78, 20
if exist "C:\Program Files\platform-tools" (
 goto :menu1  
) else (
  goto :menu2
)

::========================================================================================================================================

:menu1

cls
title  ADB and Fastboot launcher/installer - Risen
mode 78, 23

echo:
echo:
echo:       ______________________________________________________________
echo:
echo:             [1] DOWNLOAD LATEST
echo:             _____________________________________________________
echo:
echo:             [2] RUN LOCAL
echo:             _____________________________________________________
echo:
echo:             [3] ADD TO PATH (Requires Admin)
echo:             _____________________________________________________
echo:
echo:             [4] EXIT
echo:       ______________________________________________________________
echo:
echo:
echo:
echo:            "Enter a menu option on the Keyboard [1,2,3] :"
choice /C:123 /N
set _erl=%errorlevel%

if %_erl%==4 exit
if %_erl%==3 setlocal & call :elevation & cls & endlocal & goto :menu1
if %_erl%==2 setlocal & call :run & cls & endlocal & goto :menu1
if %_erl%==1 setlocal & call :download & cls & endlocal & goto :menu1

::========================================================================================================================================

:menu2

cls
title  ADB and Fastboot launcher/installer - Risen
mode 78, 17

echo:
echo:
echo:       ______________________________________________________________
echo:
echo:             [1] DOWNLOAD LATEST
echo:             _____________________________________________________
echo:
echo:             [2] EXIT
echo:       ______________________________________________________________
echo:
echo:
echo:
echo:            "Enter a menu option on the Keyboard [1,2] :"
choice /C:12 /N
set _erl=%errorlevel%

if %_erl%==2 exit
if %_erl%==1 setlocal & call :download & cls & endlocal & goto :menu2

::========================================================================================================================================

:menu3

cls
title  ADB and Fastboot launcher/installer - Risen
mode 78, 23

echo:
echo:               PLEASE REBOOT PC FOR CHANGES TO TAKE EFFECT
echo:       ______________________________________________________________
echo:
echo:             [1] DOWNLOAD LATEST
echo:             _____________________________________________________
echo:
echo:             [2] RUN LOCAL
echo:             _____________________________________________________
echo:
echo:             [3] REBOOT NOW
echo:             _____________________________________________________
echo:
echo:             [4] EXIT
echo:       ______________________________________________________________
echo:
echo:
echo:
echo:            "Enter a menu option on the Keyboard [1,2,3] :"
choice /C:123 /N
set _erl=%errorlevel%

if %_erl%==4 exit
if %_erl%==3 shutdown /r /t 1 & shutdown /r /t 1
if %_erl%==2 setlocal & call :run & cls & endlocal & goto :menu1
if %_erl%==1 setlocal & call :download & cls & endlocal & goto :menu1

::========================================================================================================================================

:download
title  DOWNLOADING - Risen
if exist "%appdata%"\Risen\ADB\ (
 rmdir "%appdata%"\Risen\ADB\ /s /q
 goto :download1  
) else (
  goto :download1
)

::========================================================================================================================================

:download1
mkdir "%appdata%"\Risen\ADB\tmp
powershell -c "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile '"%appdata%"/Risen/ADB/tmp/platform-tools-latest-windows.zip'"
@echo off
setlocal
cd /d %~dp0
Call :UnZipFile "C:\Program Files\" "%appdata%\Risen\ADB\tmp\platform-tools-latest-windows.zip"
exit /b

:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%
rmdir "%appdata%"\Risen\ADB\tmp\ /s /q
goto :menu1

::========================================================================================================================================

:run
start /d "C:\Program Files\platform-tools"
exit

::========================================================================================================================================

:elevation
@setlocal DisableDelayedExpansion
@echo off

set "nul=>nul 2>&1"
set psc=powershell.exe
set "nceline=echo: &echo ==== ERROR ==== &echo:"

::========================================================================================================================================

::  Fix for the special characters limitation in path name

set "_work=%~dp0"
if "%_work:~-1%"=="\" set "_work=%_work:~0,-1%"

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

set _PSarg="""%~f0""" -el %_args%

set "_ttemp=%temp%"

setlocal EnableDelayedExpansion

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop

%nul% reg query HKU\S-1-5-19 || (
if not defined _elev %nul% %psc% "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && call :exit
%nceline%
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'.
setlocal & call :oofed & cls & endlocal & goto :oofed
)

::========================================================================================================================================

:path
REM usage: append_user_path "path"
SET Key="HKCU\Environment"
FOR /F "usebackq tokens=2*" %%A IN (`REG QUERY %Key% /v PATH`) DO Set CurrPath=%%B
ECHO %CurrPath% > user_path_bak.txt

echo.%CurrPath% | findstr /C:"platform-tools" 1>nul

if errorlevel 1 (
  echo. got one - pattern not found
  SETX PATH "%CurrPath%";"C:\Program Files\platform-tools"
  goto :menu3
) ELSE (
  echo. got zero - found pattern
  goto :error
)

::========================================================================================================================================

:error

cls
title  Error - Risen
mode 78, 17

echo:
echo:
echo:       ______________________________________________________________
echo:
echo:             ADB and Fastboot are already in the system PATH
echo:       ______________________________________________________________
echo:
echo:
echo:

pause
call :menu1 & cls & endlocal & goto :error

::========================================================================================================================================

:exit
exit
exit /b

::========================================================================================================================================

:oofed
echo:
if %_unattended%==1 timeout /t 2 & exit /b
 "Press any key to exit..."
pause >nul
exit /b

::========================================================================================================================================