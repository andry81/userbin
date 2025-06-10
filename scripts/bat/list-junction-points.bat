@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/Junction/list-junction-points.bat" %*

rem USAGE:
rem   list-junction-points.bat [<flags>] [//] <from-path> > <links-list-file>
