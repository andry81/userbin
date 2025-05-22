@echo;%~$PATH:1
@exit /b

rem USAGE:
rem   which.bat <path>

rem Description:
rem   Script finds a file in the PATH environment variable.
rem   Difference with the `where.exe` is that the `which.bat` requires the
rem   full file name including the extension.

rem Examples:
rem   1. >which.bat cmd.exe
rem      C:\Windows\System32\cmd.exe
