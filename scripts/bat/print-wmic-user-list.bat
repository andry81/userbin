@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/Windows/User/print_wmic_user_list.bat" %*

rem USAGE:
rem   print-wmic-user-list.bat

rem Description:
rem   Prints user account names and SID's
