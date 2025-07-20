@echo off

setlocal

call "%%~dp0__init__/__init__.bat" || exit /b

echo;^>%~nx0

setlocal DISABLEDELAYEDEXPANSION

call "%%CONTOOLS_ROOT%%/time/begin_time.bat"

for /L %%i in (1,1,10) do (
  setlocal

  call "%USERBIN_SCRIPTS_BAT_ROOT%/reset-env.bat" -d || (
    echo;%~nx0: error: failed to execute `reset-env.bat`
    exit /b 255
  ) >&2

  endlocal
)

call "%%CONTOOLS_ROOT%%/time/end_time.bat" 10

echo Time spent: %TIME_INTS%.%TIME_FRACS% secs
echo;

exit /b 0
