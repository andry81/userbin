@echo off & goto DOC_END

rem USAGE:
rem   reset-env.bat [-p] [-r] [-d] [-noexpand] [-allow-rename] [-v <var>]... [--] [<vars-file>]

rem CAUTION:
rem   The delayed expansion feature must be disabled before this script call:
rem   `setlocal DISABLEDELAYEDEXPANSION`, otherwise the `!` character will be
rem   expanded.
rem

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
rem   `_config/default/env` directory to load.
rem   Has effect if <vars-file> is defined, loads before <vars-file>.
rem
rem -v <var>
rem   Resets only <var> variable.
rem   Can be reused for a list of variables.
rem
rem -noexpand
rem   Disables expansion of %-variables.
rem
rem -allow-rename
rem   Allow variable name change using `unset` before `set`.

rem --:
rem   Separator to stop parse flags.

rem <vars-file>:
rem   Explicit variables file list to load.
rem   Has effect if `-d` flag is used, loads after a builtin list.

rem Variables file list format:
rem   [;]VAR[=VALUE]
:DOC_END

rem drop error level
call;

rem script names call stack
if defined ?~ ( set "?~=%?~%-^>%~nx0" ) else if defined ?~nx0 ( set "?~=%?~nx0%-^>%~nx0" ) else set "?~=%~nx0"

set "?~dp0=%~dp0"

call "%%?~dp0%%.reset-env/reset-env.read_flags.bat" %%* || exit /b

if %?FLAG_SHIFT% GTR 0 for /L %%i in (1,1,%?FLAG_SHIFT%) do shift

set "?VARS_FILE=%~1"

if not defined ?VARS_FILE (
  if %?FLAG_D% EQU 0 (
    echo;%?~%: error: variables list file is not defined.
    exit /b 255
  ) >&2
) else if not exist "%?VARS_FILE%" (
  echo;%?~%: error: variables list file does not exist: "%?VARS_FILE%".
  exit /b 1
) >&2

if %?FLAG_D% EQU 0 goto SKIP_LOAD_DEFAULT_VARS_FILE

if defined WINDOWS_MAJOR_VER if defined WINDOWS_MINOR_VER (
  set "?OSVERMAJOR=%WINDOWS_MAJOR_VER%"
  set "?OSVERMINOR=%WINDOWS_MAJOR_VER%"
  goto SKIP_OSVER_LOAD
)

set "?OSVER=" & for /F "usebackq tokens=1,* delims=[" %%i in (`@ver 2^>nul`) do for /F "tokens=1,* delims=]" %%k in ("%%j") do set "?OSVER=%%k"

if not defined ?OSVER goto SKIP_LOAD_DEFAULT_VARS_FILE

setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!?OSVER:* =!"') do endlocal & set "?OSVER=%%~i"

set "?OSVERMAJOR=0" & set "?OSVERMINOR=0" & for /F "tokens=1,2 delims=."eol^= %%i in ("%?OSVER%") do set "?OSVERMAJOR=%%i" & set "?OSVERMINOR=%%j"

:SKIP_OSVER_LOAD
if "%?OSVERMAJOR:~1,1%" == "" set "?OSVERMAJOR=0%?OSVERMAJOR%"
if "%?OSVERMINOR:~1,1%" == "" set "?OSVERMINOR=0%?OSVERMINOR%"

set "?LOAD_DEFAULT_VARS_FILE_DIR=%?~dp0%..\..\_config\default\env"

set "?LOAD_DEFAULT_VARS_FILE=" & set "?LOAD_VARS_FILE=" & ^
for %%i in ("%?LOAD_DEFAULT_VARS_FILE_DIR%\%?OSVERMAJOR%_%?OSVERMINOR%_*.lst") do set "?LOAD_VARS_FILE=%%i" & call :LOAD_VARS_FILE || exit /b

if defined ?LOAD_VARS_FILE goto LOAD_DEFAULT_VARS_FILE_END

for %%i in ("%?LOAD_DEFAULT_VARS_FILE_DIR%\*_*_*.lst") do set "?LOAD_VARS_FILE=%%i" & call :LOAD_CLOSEST_VARS_FILE || exit /b & if defined ?LOAD_VARS_FILE goto LOAD_DEFAULT_VARS_FILE_END

:LOAD_DEFAULT_VARS_FILE_END

if defined ?LOAD_VARS_FILE set "?LOAD_DEFAULT_VARS_FILE=%?LOAD_VARS_FILE%" & set "?LOAD_VARS_FILE="

:SKIP_LOAD_DEFAULT_VARS_FILE

if not defined ?VARS_FILE goto LOAD_VARS_FILE_END

set "?LOAD_VARS_FILE=%?VARS_FILE%" & call :LOAD_VARS_FILE || exit /b

goto LOAD_VARS_FILE_END

:LOAD_CLOSEST_VARS_FILE
for /F "tokens=* delims="eol^= %%i in ("%?LOAD_VARS_FILE%\.") do for /F "tokens=1,2 delims=_"eol^= %%j in ("%%~ni") do (
  if %%j EQU %?OSVERMAJOR% if %%k GEQ %?OSVERMINOR% call :LOAD_VARS_FILE & exit /b
  if %%j GTR %?OSVERMAJOR% call :LOAD_VARS_FILE & exit /b
  set "?LOAD_VARS_FILE="
)
exit /b 0

goto LOAD_VARS_FILE_END

rem NOTE: encode `"` character to avoid `^` character partial duplication

:LOAD_VARS_FILE
if %?FLAG_P% NEQ 0 setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?LOAD_VARS_FILE!") do endlocal & echo;=^>%%~fi

if %?FLAG_R% NEQ 0 goto CLEAR_VAR_END
if not defined ?LOAD_DEFAULT_VARS_FILE if not defined ?LOAD_VARS_FILE goto CLEAR_VAR_END

for /F "usebackq tokens=1 delims=="eol^= %%i in (`@set 2^>nul`) do set "?VAR_NAME=%%i" & call :CLEAR_VAR && ( ( if %?FLAG_P% NEQ 0 echo;-%%i) & set "%%i=" )

goto CLEAR_VAR_END

:CLEAR_VAR
if ^%?VAR_NAME:~0,1%/ == ^?/ exit /b 1
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?VAR_NAME!") do endlocal & (
  if defined ?LOAD_DEFAULT_VARS_FILE for /F "usebackq eol=; tokens=1 delims==" %%j in ("%?LOAD_DEFAULT_VARS_FILE%") do if /i "%%i" == "%%j" exit /b 1
  if defined ?LOAD_VARS_FILE for /F "usebackq eol=; tokens=1 delims==" %%j in ("%?LOAD_VARS_FILE%") do if /i "%%i" == "%%j" exit /b 1
  if defined ?FLAG_VAR_LIST (
    for %%j in (%?FLAG_VAR_LIST%) do if /i "%%i" == "%%~j" exit /b 0
    exit /b 1
  )
)
exit /b 0

:CLEAR_VAR_END
if %?FLAG_P% NEQ 0 echo;

if %?FLAG_NO_EXPAND% NEQ 0 goto NO_EXPAND
if not defined ?FLAG_VAR_LIST goto NO_FLAG_VAR_LIST

for /F "usebackq eol=; tokens=1,* delims==" %%j in ("%?LOAD_VARS_FILE%") do if not "%%k" == "" for %%l in (%?FLAG_VAR_LIST%) do if /i "%%j" == "%%~l" ^
set "?VAR_NAME=%%j" & set "?VAR_VALUE=%%k" & call :SET_WITH_EXPAND
exit /b 0

:NO_FLAG_VAR_LIST
for /F "usebackq eol=; tokens=1,* delims==" %%j in ("%?LOAD_VARS_FILE%") do if not "%%k" == "" set "?VAR_NAME=%%j" & set "?VAR_VALUE=%%k" & call :SET_WITH_EXPAND
exit /b 0

:SET_WITH_EXPAND
setlocal ENABLEDELAYEDEXPANSION
set "?VAR_VALUE=!?VAR_VALUE:"=!"
call set "?VAR_VALUE=!?VAR_VALUE!" & if defined ?VAR_VALUE set "?VAR_VALUE=!?VAR_VALUE:^^=^!"
for /F "tokens=* delims="eol^= %%j in ("!?VAR_VALUE:="!"") do endlocal & set "?VAR_VALUE=%%j"
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?VAR_NAME!") do ^
for /F "tokens=* delims="eol^= %%j in ("!?VAR_VALUE:~0,-1!") do endlocal & (
  if %?FLAG_P% NEQ 0 echo;%%i=%%j
  if %?FLAG_ALLOW_RENAME% NEQ 0 set "%%i="
  set "%%i=%%j"
)
exit /b 0

:NO_EXPAND
if not defined ?FLAG_VAR_LIST goto NO_FLAG_VAR_LIST

for /F "usebackq eol=; tokens=1,* delims==" %%j in ("%?LOAD_VARS_FILE%") do if not "%%k" == "" for %%l in (%?FLAG_VAR_LIST%) do if /i "%%j" == "%%~l" (
  if %?FLAG_P% NEQ 0 echo;%%j=%%k
  if %?FLAG_ALLOW_RENAME% NEQ 0 set "%%j="
  set "%%j=%%k"
)
exit /b 0

:NO_FLAG_VAR_LIST
for /F "usebackq eol=; tokens=1,* delims==" %%j in ("%?LOAD_VARS_FILE%") do if not "%%k" == "" (
  if %?FLAG_P% NEQ 0 echo;%%j=%%k
  if %?FLAG_ALLOW_RENAME% NEQ 0 set "%%j="
  set "%%j=%%k"
)
exit /b 0

:LOAD_VARS_FILE_END

if not defined ?LOAD_DEFAULT_VARS_FILE if not defined ?LOAD_VARS_FILE (
  echo;%?~%: error: os version is not detected, nothing to reset.
  rem cleanup
  for /F "usebackq tokens=1 delims=="eol^= %%i in (`@set ? 2^>nul`) do set "%%i="
  exit /b 127
) >&2

rem cleanup
for /F "usebackq tokens=1 delims=="eol^= %%i in (`@set ? 2^>nul`) do set "%%i="

exit /b 0
