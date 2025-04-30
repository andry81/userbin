@echo off
(
  if 0 %*
) >&2
cmd.exe /c exit -1073741510
exit

rem USAGE:
rem   abort.bat [<expr>]

rem Description:
rem   Stops an outer script execution with the message:
rem     `The syntax of the command is incorrect.` if `%1` is empty, otherwise
rem     `%1 was unexpected at this time.` if not.
rem   Does not change the error level.
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
