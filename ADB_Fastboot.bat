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
echo:             [3] ADD TO PATH (!!!ONLY DO THIS ONCE!!!)
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
if %_erl%==3 setlocal & call :path & cls & endlocal & goto :menu1
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

:path
REM usage: append_user_path "path"
SET Key="HKCU\Environment"
FOR /F "usebackq tokens=2*" %%A IN (`REG QUERY %Key% /v PATH`) DO Set CurrPath=%%B
ECHO %CurrPath% > user_path_bak.txt
SETX PATH "%CurrPath%";"C:\Program Files\platform-tools"
goto :menu3

::========================================================================================================================================