@echo off & goto DOC_END

rem Description:
rem   Example of an uniform variant of a command line to pass as a single
rem   argument into the `mshta.exe` executable and other cases.
rem   You must take care about escaping of nested quotes and Windows Batch
rem   control characters.

rem NOTE:
rem   Based on:
rem     `Uniform variant of a command line as a single argument for the mshta.exe executable and other cases` :
rem     https://github.com/andry81/contools/discussions/11

rem NOTE:
rem   A command line or a variable (ex: `__SCRIPT__`) can contain an even
rem   number of double quotes prefixed by the `\` character.
rem
rem   It can be replaced by N/2 number of quotes without the prefix or
rem   a quote with N/2-nested escape sequence:
rem
rem     \""     -> "    or \"
rem     \""""   -> ""   or \\\"
rem     \"""""" -> """  or \\\\\\\"
rem     etc
rem
rem   The meaning is to always use an even number of quotes to insert an
rem   arbitrary number of quotes with or without an escape sequence.
rem
rem   For example, in the `set` command, because
rem   the `set` command argument is started by a double quote:
rem
rem     >
rem     set "A=X \"" | & < > \"""
rem     set "B=Y \"" | & < > \"" | & < > \"""" | & < > \"""""

rem CAUTION:
rem   The environment variables does use by the shell code to workaround the
rem   `mshta.exe` command line length limitation (see the link).

rem CAUTION:
rem   The `mshta.exe` does expand all the %-escape placeholders (`%NN`).
rem   The script does not use `%` character in the shell code. In case of a
rem   change in the future you must prevent the expansion by replacing all the
rem   `%` by `%25` to avoid the command line breakage.
rem   All the `"` does process for the same reason.

rem NOTE:
rem   The `ExecuteGlobal` is used as a workaround, because the `mshta.exe`
rem   first argument must not be used with the surrounded quotes.

rem CAUTION:
rem   The `ShellExecute` does not wait a child process close.

rem CAUTION:
rem   The `cmd.exe` does expand the %-variables in the context of an elevated
rem   process. You must properly escape these to avoid the expansion before the
rem   elevation!

rem CAUTION:
rem   `\""`, `\""""`, etc expressions only has meaning inside a `.bat` script.
rem   Any attempt to use it outside of a script (including a terminal command
rem   line) will lead into incorrect expansion because a terminal command
rem   line or an `.exe` command line has their own different expansion rules
rem   including command line of the `cmd.exe` executable.

rem CAUTION:
rem   Avoid a back slash before the double quote in an executable (`.exe`)
rem   command line, otherwise a command line parse will be broken:
rem     >
rem     some.exe "... ... \"
rem                        ^ - escaped
rem     >
rem     some.exe "... ... \""
rem                        ^ - escaped
rem   To workaround:
rem     >
rem     some.exe "... ... \\"
rem                        ^ - escaped
rem     >
rem     some.exe "... ... \\""
rem                        ^ - escaped
rem
rem   A trailing double quote will be escaped in some command line parse code
rem   runtimes. But not everywhere, for example, `cmd.exe` has different rules:
rem
rem     >
rem     cmd.exe /c @echo "... ... \"
rem                               ^ - prints as is

rem NOTE:
rem   The `::"::"::` is an unexisted statement in the VBS
rem   (error: `VBScript compilation error: Expected statement`) in case of
rem   strip from a string with a valid VBS shell code. So it can be used as a
rem   VBS shell code lines delimiter in another shell code or Windows Batch
rem   script.

rem CAUTION:
rem   If you pass a parameter or set of parameters starting the first argument,
rem   then these may be skipped, due to the internal `cmd.exe` command line
rem   parse logic. The command line does not ignored if started using the slash
rem   character with the known option - `/k`, `/c` and etc.

rem NOTE:
rem   The end implementation is introduced in the `cmd-admin*.bat` and
rem   `runas-admin*.bat` scripts in the `userbin` project.
:DOC_END

rem second `setlocal` to drop locals before a command line execution
setlocal DISABLEDELAYEDEXPANSION & setlocal

call "%%~dp0..\..\__init__\__init__.bat" || exit /b

rem CAUTION:
rem   The `cd "%CD%" ^& %CD:~0,2%` must be before the command, otherwise the system root will be the current directory!
rem

for /F "tokens=* delims="eol^= %%i in ("%CD%\.") do set "CWD=%%~fi"

if "%CWD:~-1%" == "\" set "CWD=%CWD%."

rem Windows Batch compatible command line with escapes
set "__CMDLINE__=/k @set \""IMPL_MODE=1\"" & cd \""%CWD%\"" & %CWD:~0,2% & \""%CONTOOLS_UTILS_BIN_ROOT%/contools/printargs.exe\"" \""123 456\"""

set "__SCRIPT__=ExecuteGlobal(\""Set objProc = CreateObject(\""""WScript.Shell\"""").Environment(\""""Process\"""") : ::"^
::"::Close(CreateObject(\""""Shell.Application\"""").ShellExecute(objProc(\""""?0\""""), objProc(\""""?@\""""), \""""\"""", \""""runas\"""", 1))\"")"

set "__SCRIPT__=%__SCRIPT__:::"::"::=%"

rem command
set __CMDLINE__

rem shell code
set __SCRIPT__

echo;---
echo;

rem Command line variant for the executable with C runtime command line parser

echo Translated into C runtime command line format:
echo;

(
  setlocal ENABLEDELAYEDEXPANSION

  set "?0=!CONTOOLS_UTILS_BIN_ROOT!/contools/printargs.exe"
  set "?@="

  if defined __CMDLINE__ (
    rem translate Windows Batch compatible escapes into escape placeholders
    set "?@=!__CMDLINE__:$=$0!"
    set "?@=!?@:\""""""=$3!"
    set "?@=!?@:\""""=$2!"
    set "?@=!?@:\""=$1!"

    rem translate escape placeholders into C runtime command line escapes
    set "?@=!?@:$3=\\\\\\\"!"
    set "?@=!?@:$2=\\\"!"
    set "?@=!?@:$1=\"!"
    set "?@=!?@:$0=$!"
  )

  rem with locals drop
  for /F "usebackq tokens=* delims="eol^= %%j in ('"!?0!"') do break ^
  & for /F "usebackq tokens=* delims="eol^= %%k in ('"!?@!"') do endlocal ^
  & set "?0=%%~j" & set "?@=%%~k"
)

set ?0
set ?@

echo;---
echo;

echo Executed as `"<?0>" "<?@>"` (with quotes^):
echo;

setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!?0!" "!?@!"') do endlocal & %%i

echo;---
echo;

echo Translated into `mshta.exe` command line format:
echo;

rem Command line variant for `mshta.exe` executable

(
  setlocal ENABLEDELAYEDEXPANSION

  set "?0=!COMSPEC!"
  set "?@="

  rem translate Windows Batch compatible escapes into escape placeholders
  set "__SCRIPT__=!__SCRIPT__:$=$0!"
  set "__SCRIPT__=!__SCRIPT__:\""""""=$3!"
  set "__SCRIPT__=!__SCRIPT__:\""""=$2!"
  set "__SCRIPT__=!__SCRIPT__:\""=$1!"
  set "__SCRIPT__=!__SCRIPT__:"^=$1!"

  if defined __CMDLINE__ (
    set "?@=!__CMDLINE__:$=$0!"
    set "?@=!?@:\""""""=$3!"
    set "?@=!?@:\""""=$2!"
    set "?@=!?@:\""=$1!"
    set "?@=!?@:"^=$1!"
  )

  rem translate escape placeholders into `mshta.exe` (vbs) escapes
  set "__SCRIPT__=!__SCRIPT__:$3=""""!"
  set "__SCRIPT__=!__SCRIPT__:$2=""!"
  set "__SCRIPT__=!__SCRIPT__:$1="!"
  set "__SCRIPT__=!__SCRIPT__:$0=$!"

  if defined ?@ (
    set "?@=!?@:$3=""""!"
    set "?@=!?@:$2=""!"
    set "?@=!?@:$1="!"
    set "?@=!?@:$0=$!"
  )

  rem with locals drop
  for /F "tokens=* delims="eol^= %%i in ("!__SCRIPT__!") do break ^
  & for /F "usebackq tokens=* delims="eol^= %%j in ('"!?0!"') do break ^
  & for /F "usebackq tokens=* delims="eol^= %%k in ('"!?@!"') do endlocal ^
  & set "__SCRIPT__=%%~i" & set "?0=%%~j" & set "?@=%%~k"
)

set __SCRIPT__
set ?0
set ?@

echo;---
echo;

echo Executed as `start "" /B /WAIT "%%SystemRoot%%\System32\mshta.exe" vbscript:^<__SCRIPT__^>` (without quotes^):
echo;

rem with locals drop
setlocal ENABLEDELAYEDEXPANSION & ^
for /F "tokens=* delims="eol^= %%i in ("!__SCRIPT__!") do ^
for /F "usebackq tokens=* delims="eol^= %%j in ('"!?0!"') do ^
for /F "usebackq tokens=* delims="eol^= %%k in ('"!?@!"') do endlocal & endlocal & ^
set "?0=%%~j" & set "?@=%%~k" & ^
start "" /B /WAIT "%SystemRoot%\System32\mshta.exe" vbscript:%%i
exit /b
