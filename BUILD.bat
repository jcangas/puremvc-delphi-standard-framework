@echo off
setlocal
SET PWD=%CD%
SET empty=""

if "%1"=="/?" goto HELP

if "%1"=="help" goto HELP

if "%1"=="XE6" goto VS_14.0

if "%1"=="XE7" goto VS_15.0

for %%i in (dcc32.exe) do SET DCCPATH=%%~dp$PATH:i

if "%DCCPATH%"==%empty% goto NO_DCC

for %%f in ("%DCCPATH%..") do goto VS_%%~nxf
goto NO_DCC

:VS_13.0
SET BRAND=XE5
SET DVM_IDETAG=D190
goto DOBUILD

:VS_14.0
SET BRAND=XE6
SET DVM_IDETAG=D200
goto DOBUILD

:VS_15.0
SET BRAND=XE7
SET DVM_IDETAG=D210
goto DOBUILD

:NO_DCC
echo "Delphi not found"
goto END

:DOBUILD
echo Building for Delphi %BRAND%
REM echo %DCCPATH%
SET DVM_PRJDIR=%~dp0
call "%DCCPATH%rsvars"

for %%i in (%DVM_PRJDIR%src\%DVM_IDETAG%-%BRAND%\*.groupproj) do msbuild /clp:ErrorsOnly;verbosity=quiet  "%%i" /p:BuildGroup=All
goto END

:HELP
echo build does a build for most recent supported IDE (XE7 at this moment)
echo build [XE5^|XE6^|XE7] does a build for the requested IDE
echo build [/?^|help] show this help
:END
cd %PWD%
