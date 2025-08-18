@echo;%~$PATH:1
@exit /b

rem USAGE:
rem   which.bat <path>

rem Description:
rem   Script finds a file in the PATH environment variable.
rem   Difference with the `where.exe` is that the `which.bat` requires the
rem   full file name including the extension.
rem   Can find a partial path files.

rem Examples:
rem
rem   1. >which.bat cmd.exe
rem      C:\Windows\System32\cmd.exe
rem
rem   2. >which.bat system32/cmd.exe
rem      C:\Windows\System32\cmd.exe
rem
rem   3. >which.bat .
rem      C:\Windows\System32
rem
rem   3. >which.bat .\
rem      CURRENT-PATH
