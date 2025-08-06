@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/encoding/dos2unix.bat" %*

rem USAGE:
rem   dos2unix.bat [-i] [-fix-tail-lr] <file>
