@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/encoding/unix2dos.bat" %*

rem USAGE:
rem   unix2dos.bat [-i] [-fix-tail-lr] <file>
