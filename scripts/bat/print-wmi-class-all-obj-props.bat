@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/wmi/print_wmi_class_all_obj_props.vbs.bat" %*

rem USAGE:
rem   print-wmi-class-all-obj-props.bat [--] <ClassName> [<prop>...]

rem Description:
rem   Prints property names and values of all class instances.

rem Examples:
rem   >
rem   print-wmi-class-all-obj-props.bat Win32_Volume BlockSize
