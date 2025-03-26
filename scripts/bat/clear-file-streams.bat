@echo off

rem USAGE:
rem   clear-file-streams.bat [<flags>] [--] [<glob-path> [<streams>...]]

rem <flags>:
rem   -WD
rem     Working directory path used instead of current directory path.
rem     Has no effect if <glob-path> is absolute path.
rem
rem   -r
rem     Search files recursively.
rem
rem   -size
rem     Print alternative file stream size at beginning separated from the path
rem     by a tabulation:
rem       SIZE	>PATH:STREAM

rem --:
rem   Separator to stop parse flags.

rem <streams>
rem   List of stream names.
rem   If `*`, then a known list is used:
rem     * Zone.identifier

setlocal

call "%%PROJECTS_ROOT%%/andry81/contools/contools--admin/scripts/FileSystem/clear_file_streams.bat" %%*
