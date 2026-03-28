@echo off & goto DOC_END

rem USAGE:
rem   print-args.bat <args>...

rem Description:
rem   Script prints script arguments as a single `|` character surrounded line.
rem   Prints `||` in case of empty arguments.

rem CAUTION:
rem   Would print nothing if called as `cmd.exe /Q ...`.
:DOC_END

setlocal DISABLEDELAYEDEXPANSION & set "LAST_ERROR=%ERRORLEVEL%"

if defined SCRIPT_TEMP_CURRENT_DIR (
  set "CMDLINE_TEMP_FILE=%SCRIPT_TEMP_CURRENT_DIR%\%~n0.%RANDOM%_%RANDOM%.txt"
) else set "CMDLINE_TEMP_FILE=%TEMP%\%~n0.%RANDOM%_%RANDOM%.txt"

(
  setlocal DISABLEEXTENSIONS
  (PROMPT=$_)
  echo on
  for %%z in (%%z) do rem |%*|
  @echo off
  endlocal
) > "%CMDLINE_TEMP_FILE%"

set "?.=" & for /F "usebackq tokens=* delims="eol^= %%i in ("%CMDLINE_TEMP_FILE%") do set "?.=%%i"

rem CAUTION: must check on empty variable to avoid accidental `del /Q ""` case
if defined CMDLINE_TEMP_FILE del /F /Q /A:-D "%CMDLINE_TEMP_FILE%" >nul 2>nul

if not defined ?. exit /b %LAST_ERROR%

setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!?.:~4,-1!"') do endlocal & echo;%%~i

exit /b %LAST_ERROR%
