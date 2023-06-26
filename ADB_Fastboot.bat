@echo off
mode 78, 20
if exist "%appdata%"\Risen\ADB\ (
 goto :menu1  
) else (
  goto :menu2
)

::========================================================================================================================================

:menu1

cls
title  ADB and Fastboot launcher - Risen
mode 78, 20

echo:
echo:
echo:       ______________________________________________________________
echo:
echo:             [1] DOWNLOAD AND RUN LATEST
echo:             _____________________________________________________
echo:
echo:             [2] RUN LOCAL
echo:             _____________________________________________________
echo:
echo:             [3] EXIT
echo:       ______________________________________________________________
echo:
echo:
echo:
echo:            "Enter a menu option on the Keyboard [1,2,3] :"
choice /C:123 /N
set _erl=%errorlevel%

if %_erl%==3 exit
if %_erl%==2 setlocal & call :run & cls & endlocal & goto :menu1
if %_erl%==1 setlocal & call :download & cls & endlocal & goto :menu1

::========================================================================================================================================

:menu2

cls
title  ADB and Fastboot launcher - Risen
mode 78, 17

echo:
echo:
echo:       ______________________________________________________________
echo:
echo:             [1] DOWNLOAD AND RUN LATEST
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
Call :UnZipFile "%appdata%\Risen\ADB\" "%appdata%\Risen\ADB\tmp\platform-tools-latest-windows.zip"
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
goto :run

::========================================================================================================================================

:run
start /d "%appdata%"\Risen\ADB\platform-tools
exit

::========================================================================================================================================