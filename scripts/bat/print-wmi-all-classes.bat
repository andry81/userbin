@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/wmi/print_wmi_all_classes.vbs.bat" %* | "%SystemRoot%\System32\sort.exe" /L C

rem USAGE:
rem   print-wmi-all-classes.bat

rem Description:
rem   Prints sorted list of all classes.
