@echo off

rem USAGE:
rem   reset-env.bat [-p] [-r] [-d] [--] [<vars-file>]

rem Description:
rem   Script resets all environment variables using a variables list file.
rem   By default all existing environment variables not in list(s) does clear.
rem   A variable name must not start by `=` or `?`.

rem -p
rem   Print variables assign.
rem
rem -r
rem   Skips existing environment variable clear if is not found in list(s).
rem
rem -d
rem   Use `ver` command output to select the builtin variables list from
rem   `_config/default/env` directory to load before <vars-file>.
rem   Has effect if <vars-file> is defined and loads before it.

rem --:
rem   Separator to stop parse flags.

rem <vars-file>:
rem   Explicit variables file list to load.
rem   Has effect if `-d` flag is used and loads after it.

rem Variables file list format:
rem   [;]VAR[=VALUE]

rem drop error level
call;

rem script names call stack
if defined ?~ ( set "?~=%?~%-^>%~nx0" ) else if defined ?~nx0 ( set "?~=%?~nx0%-^>%~nx0" ) else set "?~=%~nx0"

set "?~dp0=%~dp0"

rem script flags
set ?FLAG_P=0
set ?FLAG_R=0
set ?FLAG_D=0

rem flags always at first
set "?FLAG=%~1"

if defined ?FLAG if not "%?FLAG:~0,1%" == "-" set "?FLAG="

if defined ?FLAG if "%?FLAG%" == "-p" set "?FLAG_P=1" & shift & call set "?FLAG=%%~1"
if defined ?FLAG if "%?FLAG%" == "-r" set "?FLAG_R=1" & shift & call set "?FLAG=%%~1"
if defined ?FLAG if "%?FLAG%" == "-d" set "?FLAG_D=1" & shift & call set "?FLAG=%%~1"

if defined ?FLAG if "%?FLAG%" == "--" shift

set "?VARS_FILE=%~1"

if not defined ?VARS_FILE (
  if %?FLAG_D% EQU 0 (
    echo.%?~%: error: variables list file is not defined.
    exit /b 255
  ) >&2
) else if not exist "%?VARS_FILE%" (
  echo.%?~%: error: variables list file does not exist: "%?VARS_FILE%".
  exit /b 1
) >&2

if %?FLAG_D% EQU 0 goto SKIP_LOAD_DEFAULT_VARS_FILE

set "?OSVER=" & for /F "usebackq tokens=1,* delims=[" %%i in (`@ver 2^>nul`) do for /F "tokens=1,* delims=]" %%k in ("%%j") do set "?OSVER=%%k"

if not defined ?OSVER goto SKIP_LOAD_DEFAULT_VARS_FILE

setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!?OSVER:* =!"') do endlocal & set "?OSVER=%%~i"

set "?OSVERMAJOR=0" & set "?OSVERMINOR=0" & for /F "tokens=1,2 delims=."eol^= %%i in ("%?OSVER%") do set "?OSVERMAJOR=%%i" & set "?OSVERMINOR=%%j"

if "%?OSVERMAJOR:~1,1%" == "" set "?OSVERMAJOR=0%?OSVERMAJOR%"
if "%?OSVERMINOR:~1,1%" == "" set "?OSVERMINOR=0%?OSVERMINOR%"

set "?LOAD_DEFAULT_VARS_FILE_DIR=%?~dp0%..\..\_config\default\env"

set "?LOAD_DEFAULT_VARS_FILE=" & set "?LOAD_VARS_FILE=" & ^
for %%i in ("%?LOAD_DEFAULT_VARS_FILE_DIR%\%?OSVERMAJOR%_%?OSVERMINOR%_*.lst") do set "?LOAD_VARS_FILE=%%i" & call :LOAD_VARS_FILE || exit /b

if defined ?LOAD_VARS_FILE goto LOAD_DEFAULT_VARS_FILE_END

rem find closest version (greater)
set ?.=@dir "%?LOAD_DEFAULT_VARS_FILE_DIR%\*_*_*.lst" /A:-D /B /O:N 2^>nul

for /F "usebackq tokens=* delims="eol^= %%i in (`%%?.%%`) do set "?LOAD_VARS_FILE=%?LOAD_DEFAULT_VARS_FILE_DIR%\%%i" & call :LOAD_CLOSEST_VARS_FILE || exit /b & if defined ?LOAD_VARS_FILE goto LOAD_DEFAULT_VARS_FILE_END

:LOAD_DEFAULT_VARS_FILE_END

if defined ?LOAD_VARS_FILE set "?LOAD_DEFAULT_VARS_FILE=%?LOAD_VARS_FILE%" & set "?LOAD_VARS_FILE="

:SKIP_LOAD_DEFAULT_VARS_FILE

if not defined ?VARS_FILE goto LOAD_VARS_FILE_END

set "?LOAD_VARS_FILE=%?VARS_FILE%" & call :LOAD_VARS_FILE || exit /b

goto LOAD_VARS_FILE_END

:LOAD_CLOSEST_VARS_FILE
for /F "tokens=* delims="eol^= %%i in ("%?LOAD_VARS_FILE%\.") do for /F "tokens=1,2 delims=_"eol^= %%j in ("%%~ni") do (
  if %%j EQU %?OSVERMAJOR% if %%k GTR %?OSVERMAJOR% call :LOAD_VARS_FILE & exit /b
  if %%j GTR %?OSVERMAJOR% call :LOAD_VARS_FILE & exit /b
  set "?LOAD_VARS_FILE="
)
exit /b 0

goto LOAD_VARS_FILE_END

:LOAD_VARS_FILE
if %?FLAG_P% NEQ 0 setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?LOAD_VARS_FILE!") do endlocal & echo.=^>%%~fi
for /F "usebackq eol=; tokens=1,* delims==" %%j in ("%?LOAD_VARS_FILE%") do if not "%%k" == "" ( if %?FLAG_P% NEQ 0 echo.%%j=%%k) & set "%%j=%%k" || exit /b
if %?FLAG_P% NEQ 0 echo.
exit /b 0

:LOAD_VARS_FILE_END

if %?FLAG_R% NEQ 0 goto CHECK_VAR_END
if not defined ?LOAD_DEFAULT_VARS_FILE if not defined ?LOAD_VARS_FILE goto CHECK_VAR_END

for /F "usebackq tokens=1 delims=="eol^= %%i in (`@set 2^>nul`) do set "?VAR_NAME=%%i" & call :CHECK_VAR && ( ( if %?FLAG_P% NEQ 0 echo.-%%i ) & set "%%i=" )

goto CHECK_VAR_END

:CHECK_VAR
if ^%?VAR_NAME:~0,1%/ == ^?/ exit /b 1
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?VAR_NAME!") do endlocal & (
  if defined ?LOAD_DEFAULT_VARS_FILE for /F "usebackq eol=; tokens=1 delims==" %%j in ("%?LOAD_DEFAULT_VARS_FILE%") do if /i "%%i" == "%%j" exit /b 1
  if defined ?LOAD_VARS_FILE for /F "usebackq eol=; tokens=1 delims==" %%j in ("%?LOAD_VARS_FILE%") do if /i "%%i" == "%%j" exit /b 1
)
exit /b 0

:CHECK_VAR_END

if not defined ?LOAD_DEFAULT_VARS_FILE if not defined ?LOAD_VARS_FILE (
  echo.%?~%: error: os version is not detected, nothing to reset.
  rem cleanup
  for /F "usebackq tokens=1 delims=="eol^= %%i in (`@set ? 2^>nul`) do set "%%i="
  exit /b 127
) >&2

rem cleanup
for /F "usebackq tokens=1 delims=="eol^= %%i in (`@set ? 2^>nul`) do set "%%i="

exit /b 0
