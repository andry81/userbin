@echo off

rem CAUTION:
rem   We must test or save variables BEFORE `reset-env.bat` script!
rem

set TEST_LAST_ERROR=0

(
  setlocal

  if not defined RESET_ENV_VAR_LIST (
    call "%%USERBIN_SCRIPTS_BAT_ROOT%%/reset-env.bat" %%RESET_ENV_FLAGS_CMD_LINE%% -- "%%TEST_DATA_IN_FILE%%" || (
      set "TEST_LAST_ERROR=20" & goto ENDLOCAL_AND_EXIT
    )
    set > "%TEST_TEMP_DATA_OUT_FILE%"
  ) else (
    call "%%USERBIN_SCRIPTS_BAT_ROOT%%/reset-env.bat" %%RESET_ENV_FLAGS_CMD_LINE%% -- "%%TEST_DATA_IN_FILE%%" || (
      set "TEST_LAST_ERROR=20" & goto ENDLOCAL_AND_EXIT
    )
    for %%i in (%RESET_ENV_VAR_LIST%) do set %%i >> "%TEST_TEMP_DATA_OUT_FILE%"
  )

  endlocal
) >nul

if not exist "%TEST_DATA_REF_FILE%" set "TEST_LAST_ERROR=22" & goto EXIT

"%SystemRoot%\System32\fc.exe" "%TEST_TEMP_DATA_OUT_FILE%" "%TEST_DATA_REF_FILE%" >nul || set "TEST_LAST_ERROR=23"

goto EXIT

:ENDLOCAL_AND_EXIT
(
  endlocal
  set "TEST_IMPL_ERROR=%ERRORLEVEL%"
  set "TEST_LAST_ERROR=%TEST_LAST_ERROR%"
)

:EXIT
if %TEST_LAST_ERROR% EQU 0 (
  echo PASSED: %TESTLIB__TEST_ORDER_NUMBER%
) else echo FAILED: %TESTLIB__TEST_ORDER_NUMBER%


echo;

exit /b %TEST_LAST_ERROR%
