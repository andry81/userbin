@echo off
(call)
(
  setlocal DISABLEDELAYEDEXPANSION
  if 0 "%~nx0: %~1"
) >&2
cmd.exe /c exit -1073741510
exit

rem USAGE:
rem   abort.bat [<message>]

rem Description:
rem   Tests `<message>` and if is not empty, then stops an outer script
rem   execution with the error message:
rem     `"abort.bat: <message>" was unexpected at this time.`
rem   If `<message>` is empty, then stops an outer script execution
rem   with the error message:
rem     `The syntax of the command is incorrect.`
rem   Sets not zero error level before the abort.
rem   The `cmd.exe /c exit -1073741510` command emits CTRL-BREAK just in case
rem   of execution continue.

rem Examples:
rem   1. >abort.bat
rem      The syntax of the command is incorrect.
rem
rem   2. >abort.bat a b c
rem      a was unexpected at this time.
rem
rem   3. >abort.bat "a b c"
rem      "a b c" was unexpected at this time.
