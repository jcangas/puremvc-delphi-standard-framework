@echo off
REM default settings

REM let user override settings
if "%dvmuser%"=="" set dvmuser=%username%
call dvmsetup@%dvmuser%.bat
