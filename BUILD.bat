@echo off
setlocal
set BDSPROJECTGROUPDIR=%~dp0

call rsvars
cd .\src\D170-XE3
msbuild PureMVC4D.groupproj /p:BuildGroup=All
cd ..