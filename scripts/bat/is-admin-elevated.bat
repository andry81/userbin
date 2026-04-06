@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/std/is_admin_elevated.bat"

rem USAGE:
rem   is-admin-elevated.bat
