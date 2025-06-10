@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/Scripts/Tools/std/assert_if_false.bat" %*

rem USAGE:
rem   assert-if-false.bat <var> <message>
