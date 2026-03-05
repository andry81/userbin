@"%~$PATH:1" %2 %3 %4 %5 %6 %7 %8 %9
@exit /b

rem USAGE:
rem   exec.bat <path> <args>...

rem Description:
rem   Script runs a file in the PATH environment variable.
rem   Requires the full file name including the extension.
rem   Can run a partial path files.
rem   Does wait a child process.
rem   Does not allocate a new console window for a console flagged executable
rem   if console window has already allocated or attached in a parent process.

rem Examples:
rem   1. >exec.bat system32/cmd.exe /k
rem      C:\Windows\System32\cmd.exe
