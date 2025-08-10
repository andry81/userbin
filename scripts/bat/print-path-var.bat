@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/std/echo_path_var.bat" %*

rem USAGE:
rem   print-path-var.bat <var> [<prefix> [<suffix>]]
