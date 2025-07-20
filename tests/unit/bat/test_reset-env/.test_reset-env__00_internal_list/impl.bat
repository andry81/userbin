@echo off

rem CAUTION:
rem   We must test or save variables BEFORE `reset-env.bat` script!
rem

set TEST_LAST_ERROR=0

(
  setlocal

  (
    for /F "usebackq tokens=1,* delims=="eol^= %%i in (`@set`) do echo;%%i
  ) > "%TEST_TEMP_DATA_IN_FILE%"

  call "%%USERBIN_SCRIPTS_BAT_ROOT%%/reset-env.bat" -d || (
    set "TEST_LAST_ERROR=20" & goto ENDLOCAL_AND_EXIT
  )

  (
    for /F "usebackq tokens=1,* delims=="eol^= %%i in (`@set`) do echo;%%i
  ) > "%TEST_TEMP_DATA_OUT_FILE%"

  endlocal
) >nul

rem CAUTION:
rem   1. If a variable is empty, then it would not be expanded in the `cmd.exe`
rem      command line or in the inner expression of the
rem      `for /F "usebackq ..." %%i in (`<inner-expression>`) do ...`
rem      statement.
rem   2. The `cmd.exe` command line or the inner expression of the
rem      `for /F "usebackq ..." %%i in (`<inner-expression>`) do ...`
rem      statement does expand twice.
rem
rem   We must expand the command line into a variable to avoid these above.
rem
set ?.=@dir "%TEST_DATA_FILE_REF_PTTN%" /A:-D /B /O:N 2^>nul

set NUM_REF_FILES=0
set NUM_PASSED_FILES=0

for /F "usebackq tokens=* delims="eol^= %%i in (`%%?.%%`) do (
  (
    for /F "usebackq tokens=1,* delims=="eol^= %%j in (`@type "%TEST_DATA_FILE_REF_DIR%\%%i"`) do echo;%%j
  ) > "%TEST_TEMP_DATA_REF_FILE%"

  type "%TEST_TEMP_DATA_IN_FILE%" | "%SystemRoot%\System32\findstr.exe" /B /E /L /I /G:"%TEST_TEMP_DATA_REF_FILE%" > "%TEST_TEMP_DATA_IN_FILTERED_BY_REF_FILE%"

  "%SystemRoot%\System32\fc.exe" "%TEST_TEMP_DATA_OUT_FILE%" "%TEST_TEMP_DATA_IN_FILTERED_BY_REF_FILE%" >nul && (
    set /A NUM_PASSED_FILES+=1
    echo;    VALID: %%i
    call;
  ) || echo;NOT VALID: %%i

  set /A NUM_REF_FILES+=1
)

echo;

if %NUM_PASSED_FILES% EQU 0 set TEST_LAST_ERROR=10

goto EXIT

:ENDLOCAL_AND_EXIT
(
  endlocal
  set "TEST_IMPL_ERROR=%ERRORLEVEL%"
  set "TEST_LAST_ERROR=%TEST_LAST_ERROR%"
)

:EXIT
if %TEST_LAST_ERROR% EQU 0 (
  echo PASSED: %TESTLIB__TEST_ORDER_NUMBER%: %NUM_PASSED_FILES% of %NUM_REF_FILES% is valid
) else echo FAILED: %TESTLIB__TEST_ORDER_NUMBER%: %NUM_PASSED_FILES% of %NUM_REF_FILES% is valid


echo;

exit /b %TEST_LAST_ERROR%
