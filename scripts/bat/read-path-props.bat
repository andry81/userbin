@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%SystemRoot%\System32\cscript.exe" //nologo "%PROJECTS_ROOT%/andry81/contools/contools/scripts/tools/ToolAdaptors/vbs/read_path_props.vbs" %*

rem USAGE:
rem   read-path-props.vbs <flags> [--] <PropertyPattern> <Path>
