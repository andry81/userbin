@echo off & goto DOC_END

rem Description:
rem   Script prints N first lines from the input stream. If N is not set then
rem   all.
rem
rem Features:
rem   * Prints all characters including control characters like !%^&|> and so.
rem   * Counts all lines including empty lines.
rem
rem Issues:
rem   * The `findstr` truncates lines longer than 8180 characters
rem     ("FINDSTR: Line NNN is too long" message).
rem   * Line returns converts into the Windows format (CRLF).
rem   * Is not so fast, prints ~2000 lines about 8 seconds on 3.2GHz AMD
rem     processor.
:DOC_END

setlocal DISABLEDELAYEDEXPANSION

set "NUM=%~1"
if not defined NUM set NUM=-1
set "STR_PREFIX=%~2"
set "STR_SUFFIX=%~3"

set LINE_INDEX=0

for /F "usebackq tokens=* delims="eol^= %%i in (`@"%%SystemRoot%%\System32\findstr.exe" /N /R /C:"^" 2^>nul`) do (
  set "LINE_STR=%%i"
  setlocal ENABLEDELAYEDEXPANSION
  if !NUM! GEQ 0 if !LINE_INDEX! GEQ !NUM! exit /b 0
  for /F "usebackq tokens=* delims="eol^= %%j in ('"!STR_PREFIX!!LINE_STR:*:=!!STR_SUFFIX!"') do endlocal & echo;%%~j
  set /A LINE_INDEX+=1
)

exit /b 0
