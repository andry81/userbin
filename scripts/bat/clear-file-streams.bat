@echo off


rem USAGE:
rem   clear-file-streams.bat <glob-path> <streams>...

rem <streams>
rem   List of stream names.
rem   If `*`, then a known list is used:
rem     * Zone.identifier

setlocal

call "%%PROJECTS_ROOT%%/andry81/contools/contools--admin/scripts/FileSystem/01_Telemetry/01_clear_file_streams.bat" %%*
