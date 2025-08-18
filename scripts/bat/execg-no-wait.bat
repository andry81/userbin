@start "" "%~$PATH:1" %2 %3 %4 %5 %6 %7 %8 %9
@exit /b

rem USAGE:
rem   execg-no-wait.bat <path> <args>...

rem Description:
rem   Script runs a file in the PATH environment variable.
rem   Requires the full file name including the extension.
rem   Can run a partial path files.
rem   Does not wait a child process.

rem Examples:
rem   1. >execg-no-wait.bat system32/cmd.exe /k
