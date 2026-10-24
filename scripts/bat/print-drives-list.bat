@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/Windows/FileSystem/print_drives_list.vbs.bat" %*

rem USAGE:
rem   print-drives-list.bat

rem Description:
rem   Prints list of drives and drive properties.

rem Print format:
rem   <Letter>|<Type>|<FileSystem>|<SerialNumber>|<TotalSize>|<Path>|<ShareName>|<VolumeName>
