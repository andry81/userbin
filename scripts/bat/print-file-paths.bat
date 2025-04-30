@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/FileSystem/print_file_paths.bat" %*

rem USAGE:
rem   print-file-paths.bat [<flags>] [--] [<glob-path>]

rem <flags>:
rem   -WD
rem     Working directory path used instead of current directory path.
rem     Has no effect if <glob-path> is absolute path.
rem
rem   -r
rem     Search files and/or directories recursively.
rem
rem   -len
rem     Print path length at beginning separated from the path by a tabulation:
rem       LENGTH	>PATH
rem
rem   -long
rem     Prints only long paths.
rem
rem   -no-long
rem     Does not print long paths.
rem     Has no effect if `-long` is used.
rem
rem   -links
rem     Allow print symbolic link paths
rem     CAUTION:
rem       Does not detect links recursion.

rem --:
rem   Separator to stop parse flags.
