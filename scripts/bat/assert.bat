@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/Scripts/Tools/std/assert.bat" %*

rem USAGE:
rem   assert.bat <message>
