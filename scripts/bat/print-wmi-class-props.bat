@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/wmi/print_wmi_class_props.vbs.bat" %*

rem USAGE:
rem   print-wmi-class-props.bat <ClassName>

rem Description:
rem   Prints property names of a class.

rem Examples:
rem   >
rem   print-wmi-class-props.bat Win32_Volume
