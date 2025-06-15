@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/Scripts/Tools/wmi/print_wmic_path_all_props.bat" %*

rem USAGE:
rem   print_wmic_path_all_props.bat <path>

rem Description:
rem   Prints all WMI property values from a path.
