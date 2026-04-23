@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/wmi/print_wmic_path_all_props.bat" %*

rem USAGE:
rem   print-wmic-path-all-props.bat <path>

rem Description:
rem   Prints all WMI property values from a path.
