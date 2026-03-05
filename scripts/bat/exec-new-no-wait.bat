@start "" "%~$PATH:1" %2 %3 %4 %5 %6 %7 %8 %9
@exit /b

rem USAGE:
rem   exec-new-no-wait.bat <path> <args>...

rem Description:
rem   Script runs a file in the PATH environment variable.
rem   Requires the full file name including the extension.
rem   Can run a partial path files.
rem   Does not wait a child process.
rem   Does allocate a new console window for a console flagged executable.

rem Examples:
rem   1. >exec-new-no-wait.bat system32/cmd.exe /k
