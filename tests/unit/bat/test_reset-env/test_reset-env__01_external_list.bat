@echo off

setlocal

call "%%~dp0__init__/__init__.bat" || exit /b
call "%%CONTOOLS_ROOT%%/std/assert_if_def.bat" __CTRL_SETLOCAL "error: cmd.exe is broken, please restart it!" && set "__CTRL_SETLOCAL=1"
call "%%CONTOOLS_TESTLIB_ROOT%%/init.bat" "%%~f0" || exit /b

call :TEST config.0.vars _common/00 00
call :TEST config.0.vars _common/00 01_noexpand         "-noexpand"

call :TEST config.0.vars _common/00 10_PATH00           "          -v PATH00" PATH00
call :TEST config.0.vars _common/00 11_noexpand_PATH00  "-noexpand -v PATH00" PATH00

call :TEST config.0.vars _common/00 20_PATH01           "          -v PATH01" PATH01
call :TEST config.0.vars _common/00 21_noexpand_PATH01  "-noexpand -v PATH01" PATH01

call :TEST config.0.vars _common/00 30_PATH02           "          -v PATH02" PATH02
call :TEST config.0.vars _common/00 31_noexpand_PATH02  "-noexpand -v PATH02" PATH02

call :TEST config.0.vars _common/00 40_PATH03           "          -v PATH03" PATH03
call :TEST config.0.vars _common/00 41_noexpand_PATH03  "-noexpand -v PATH03" PATH03

call :TEST config.0.vars _common/00 50_PATH04           "          -v PATH04" PATH04
call :TEST config.0.vars _common/00 51_noexpand_PATH04  "-noexpand -v PATH04" PATH04

call :TEST config.0.vars _common/00 60_PATH05           "          -v PATH05" PATH05
call :TEST config.0.vars _common/00 61_noexpand_PATH05  "-noexpand -v PATH05" PATH05

echo;

rem WARNING: must be called without the call prefix!
"%CONTOOLS_TESTLIB_ROOT%/exit.bat"

rem no code can be executed here, just in case
exit /b

:TEST
call "%%CONTOOLS_ROOT%%/std/setshift.bat" -num 3 0 TEST_TITLE %*
echo;%TEST_TITLE%...
call "%%CONTOOLS_TESTLIB_ROOT%%/test.bat" %%*
exit /b
