@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--utils/bin/contools/callf.exe" %*

rem USAGE:
rem   <See `src/callf/help.tpl` for details>
