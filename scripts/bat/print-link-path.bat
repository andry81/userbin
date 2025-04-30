@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/FileSystem/print_link_path.bat" %*

rem USAGE:
rem   print-link-path.vbs <path>
