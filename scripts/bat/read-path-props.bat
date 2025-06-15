@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%SystemRoot%\System32\cscript.exe" //nologo "%PROJECTS_ROOT%/andry81/contools/contools/Scripts/Tools/ToolAdaptors/vbs/read_path_props.vbs" %*

rem USAGE:
rem   read_path_props.vbs <flags> [--] <PropertyPattern> <Path>
