@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/Windows/Fonts/reset_font_file_permissions.bat" %*

rem USAGE:
rem   reset_font_file_permissions.bat [<flags>] [--] <glob-files>...

rem Description:
rem   Script to update a font file permissions before or after install into
rem   system fonts directory.

rem <flags>:
rem   -WD
rem     Working directory path used instead of current directory path.
rem     Has no effect if <glob-files> is absolute path.
rem
rem   -nolog
rem     Disable logging and so a log directory allocation.

rem --:
rem   Separator to stop parse flags.

rem <glob-files>
rem   File path list with globbing.
