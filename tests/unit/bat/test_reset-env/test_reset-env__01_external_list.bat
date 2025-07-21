@echo off

setlocal

call "%%~dp0__init__/__init__.bat" || exit /b
call "%%CONTOOLS_ROOT%%/std/assert_if_def.bat" __CTRL_SETLOCAL "error: cmd.exe is broken, please restart it!" && set "__CTRL_SETLOCAL=1"
call "%%CONTOOLS_TESTLIB_ROOT%%/init.bat" "%%~f0" || exit /b

call :TEST config.0.vars _common/00               00
call :TEST config.0.vars _common/00               01_noexpand               "-noexpand"

call :TEST config.0.vars _common/02_allow_rename  02_allow_rename           "          -allow-rename"
call :TEST config.0.vars _common/02_allow_rename  03_noexpand_allow_rename  "-noexpand -allow-rename"

call :TEST config.0.vars _common/00               10_PATH00                               "                                  -v PATH00"        PATH00
call :TEST config.0.vars _common/00               11_PREFIX_PATH00                        "                        -v PREFIX -v PATH00" PREFIX PATH00
call :TEST config.0.vars _common/00               12_noexpand_PATH00                      "-noexpand                         -v PATH00"        PATH00
call :TEST config.0.vars _common/00               13_noexpand_PREFIX_PATH00               "-noexpand               -v PREFIX -v PATH00" PREFIX PATH00

call :TEST config.0.vars _common/02_allow_rename  14_allow_rename_PATH00                  "          -allow-rename           -v PATH00"        PATH00
call :TEST config.0.vars _common/02_allow_rename  15_allow_rename_PREFIX_PATH00           "          -allow-rename -v PREFIX -v PATH00" PREFIX PATH00
call :TEST config.0.vars _common/02_allow_rename  16_noexpand_allow_rename_PATH00         "-noexpand -allow-rename           -v PATH00"        PATH00
call :TEST config.0.vars _common/02_allow_rename  17_noexpand_allow_rename_PREFIX_PATH00  "-noexpand -allow-rename -v PREFIX -v PATH00" PREFIX PATH00

call :TEST config.0.vars _common/00               20_PATH01                               "                                  -v PATH01"        PATH01
call :TEST config.0.vars _common/00               21_PREFIX_PATH01                        "                        -v PREFIX -v PATH01" PREFIX PATH01
call :TEST config.0.vars _common/00               22_noexpand_PATH01                      "-noexpand                         -v PATH01"        PATH01
call :TEST config.0.vars _common/00               23_noexpand_PREFIX_PATH01               "-noexpand               -v PREFIX -v PATH01" PREFIX PATH01

call :TEST config.0.vars _common/02_allow_rename  24_allow_rename_PATH01                  "          -allow-rename           -v PATH01"        PATH01
call :TEST config.0.vars _common/02_allow_rename  25_allow_rename_PREFIX_PATH01           "          -allow-rename -v PREFIX -v PATH01" PREFIX PATH01
call :TEST config.0.vars _common/02_allow_rename  26_noexpand_allow_rename_PATH01         "-noexpand -allow-rename           -v PATH01"        PATH01
call :TEST config.0.vars _common/02_allow_rename  27_noexpand_allow_rename_PREFIX_PATH01  "-noexpand -allow-rename -v PREFIX -v PATH01" PREFIX PATH01

call :TEST config.0.vars _common/00               30_PATH02                               "                                  -v PATH02"        PATH02
call :TEST config.0.vars _common/00               31_PREFIX_PATH02                        "                        -v PREFIX -v PATH02" PREFIX PATH02
call :TEST config.0.vars _common/00               32_noexpand_PATH02                      "-noexpand                         -v PATH02"        PATH02
call :TEST config.0.vars _common/00               33_noexpand_PREFIX_PATH02               "-noexpand               -v PREFIX -v PATH02" PREFIX PATH02

call :TEST config.0.vars _common/02_allow_rename  34_allow_rename_PATH02                  "          -allow-rename           -v PATH02"        PATH02
call :TEST config.0.vars _common/02_allow_rename  35_allow_rename_PREFIX_PATH02           "          -allow-rename -v PREFIX -v PATH02" PREFIX PATH02
call :TEST config.0.vars _common/02_allow_rename  36_noexpand_allow_rename_PATH02         "-noexpand -allow-rename           -v PATH02"        PATH02
call :TEST config.0.vars _common/02_allow_rename  37_noexpand_allow_rename_PREFIX_PATH02  "-noexpand -allow-rename -v PREFIX -v PATH02" PREFIX PATH02

call :TEST config.0.vars _common/00               40_PATH03                               "                                  -v PATH03"        PATH03
call :TEST config.0.vars _common/00               41_PREFIX_PATH03                        "                        -v PREFIX -v PATH03" PREFIX PATH03
call :TEST config.0.vars _common/00               42_noexpand_PATH03                      "-noexpand                         -v PATH03"        PATH03
call :TEST config.0.vars _common/00               43_noexpand_PREFIX_PATH03               "-noexpand               -v PREFIX -v PATH03" PREFIX PATH03

call :TEST config.0.vars _common/02_allow_rename  44_allow_rename_PATH03                  "          -allow-rename           -v PATH03"        PATH03
call :TEST config.0.vars _common/02_allow_rename  45_allow_rename_PREFIX_PATH03           "          -allow-rename -v PREFIX -v PATH03" PREFIX PATH03
call :TEST config.0.vars _common/02_allow_rename  46_noexpand_allow_rename_PATH03         "-noexpand -allow-rename           -v PATH03"        PATH03
call :TEST config.0.vars _common/02_allow_rename  47_noexpand_allow_rename_PREFIX_PATH03  "-noexpand -allow-rename -v PREFIX -v PATH03" PREFIX PATH03

call :TEST config.0.vars _common/00               50_PATH04                               "                                  -v PATH04"        PATH04
call :TEST config.0.vars _common/00               51_PREFIX_PATH04                        "                        -v PREFIX -v PATH04" PREFIX PATH04
call :TEST config.0.vars _common/00               52_noexpand_PATH04                      "-noexpand                         -v PATH04"        PATH04
call :TEST config.0.vars _common/00               53_noexpand_PREFIX_PATH04               "-noexpand               -v PREFIX -v PATH04" PREFIX PATH04

call :TEST config.0.vars _common/02_allow_rename  54_allow_rename_PATH04                  "          -allow-rename           -v PATH04"        PATH04
call :TEST config.0.vars _common/02_allow_rename  55_allow_rename_PREFIX_PATH04           "          -allow-rename -v PREFIX -v PATH04" PREFIX PATH04
call :TEST config.0.vars _common/02_allow_rename  56_noexpand_allow_rename_PATH04         "-noexpand -allow-rename           -v PATH04"        PATH04
call :TEST config.0.vars _common/02_allow_rename  57_noexpand_allow_rename_PREFIX_PATH04  "-noexpand -allow-rename -v PREFIX -v PATH04" PREFIX PATH04

call :TEST config.0.vars _common/00               60_PATH05                               "                                  -v PATH05"        PATH05
call :TEST config.0.vars _common/00               61_PREFIX_PATH05                        "                        -v PREFIX -v PATH05" PREFIX PATH05
call :TEST config.0.vars _common/00               62_noexpand_PATH05                      "-noexpand                         -v PATH05"        PATH05
call :TEST config.0.vars _common/00               63_noexpand_PREFIX_PATH05               "-noexpand               -v PREFIX -v PATH05" PREFIX PATH05

call :TEST config.0.vars _common/02_allow_rename  64_allow_rename_PATH05                  "          -allow-rename           -v PATH05"        PATH05
call :TEST config.0.vars _common/02_allow_rename  65_allow_rename_PREFIX_PATH05           "          -allow-rename -v PREFIX -v PATH05" PREFIX PATH05
call :TEST config.0.vars _common/02_allow_rename  66_noexpand_allow_rename_PATH05         "-noexpand -allow-rename           -v PATH05"        PATH05
call :TEST config.0.vars _common/02_allow_rename  67_noexpand_allow_rename_PREFIX_PATH05  "-noexpand -allow-rename -v PREFIX -v PATH05" PREFIX PATH05

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
