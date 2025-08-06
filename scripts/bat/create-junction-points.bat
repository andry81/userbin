@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/Windows/Junction/create-junction-points.bat" %*

rem USAGE:
rem   create-junction-points.bat <junction-list-file>
