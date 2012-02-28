@echo off
setlocal
set BDSPROJECTGROUPDIR=%~dp0

call rsvars
cd .\XE
msbuild PureMVCGroup.groupproj
cd ..