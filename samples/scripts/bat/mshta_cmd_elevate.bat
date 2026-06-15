@echo off & goto DOC_END

rem Description:
rem   Example of an uniform variant of a command line to pass as a single
rem   argument into the `mshta.exe` executable and other cases.
rem   You must take care about escaping of nested quotes and Windows Batch
rem   control characters.
rem
rem   The end implementation is introduced in the `cmd-admin*.bat` and
rem   `runas-admin*.bat` scripts in the `userbin` project.
rem
rem   NOTE:
rem     `ExecuteGlobal` is used as a workaround, because the `mshta.exe` first
rem     argument must not be used with the surrounded quotes.
rem
rem   A command line or a variable (ex: `__QARG0__`) can contain an even number
rem   of double quotes prefixed by the `\` character.
rem   It will be replaced by N/2 number of quotes without the prefix:
rem     \"" -> "
rem     \"""" -> ""
rem     \"""""" -> """
rem     etc
rem   The meaning is to always use an even number of quotes to insert an
rem   arbitrary number of quotes. For example, in the `set` command, because
rem   the `set` command argument is started by a double quote:
rem     >
rem     set "A=X \"" | & < > \"""
rem     set "B=Y \"" | & < > \"" | & < > \"""" | & < > \"""""

rem CAUTION:
rem   The `mshta.exe` does expand all the %-escape placeholders (`%NN`).
rem   The script does prevent the expansion by replacing all the `%` by `%25`
rem   to avoid the command line breakage.
rem   All the `"` does process for the same reason.

rem CAUTION:
rem   The `ShellExecute` API does expand the %-variables in the context of an
rem   elevated process. You must properly escape these to avoid the expansion
rem   before the elevation!

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
:DOC_END

setlocal DISABLEDELAYEDEXPANSION

call "%%~dp0..\..\__init__\__init__.bat" || exit /b

for /F "tokens=* delims="eol^= %%i in ("%CD%\.") do set "CWD=%%~fi"

if "%CWD:~-1%" == "\" set "CWD=%CWD%."

set "__QARG0__=vbscript:ExecuteGlobal(\""Close(CreateObject(\""""Shell.Application\"""").ShellExecute(\""""%COMSPEC%\"""", \""""/k @cd \""""""%CWD%\"""""" & %CWD:~0,2% & \""""""%CONTOOLS_UTILS_BIN_ROOT%/contools/printargs.exe\"""""" \""""""123 456\""""""\"""", \""""\"""", \""""runas\"""", 1))\"")"

rem the input to translate
set __QARG0__

echo;---

rem Command line variant for the executable with C runtime command line parser

echo Translated into C runtime command line format:
echo;

(
  setlocal ENABLEDELAYEDEXPANSION

  rem escape %-escapes
  set "?.=!__QARG0__:%%=%%25!"

  rem translate Windows Batch compatible escapes into escape placeholders
  set "?.=!?.:$=$0!"
  set "?.=!?.:\""""""=$3!"
  set "?.=!?.:\""""=$2!"
  set "?.=!?.:\""=$1!"

  rem translate escape placeholders into C runtime command line escapes
  set "?.=!?.:$3=\\\\\\\"!"
  set "?.=!?.:$2=\\\"!"
  set "?.=!?.:$1=\"!"
  for /F "tokens=* delims="eol^= %%i in ("!?.:$0=$!") do endlocal & set "?.=%%i"
)

set ?.

echo;---

echo Executed as `printargs.exe "<?.>"` (with quotes):
echo;

setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & ^
"%CONTOOLS_UTILS_BIN_ROOT%/contools/printargs.exe" "%%i"

echo;---

echo Translated into `mshta.exe` command line format:
echo;

rem Command line variant for `mshta.exe` executable

(
  setlocal ENABLEDELAYEDEXPANSION

  rem escape %-escapes
  set "?.=!__QARG0__:%%=%%25!"

  rem translate Windows Batch compatible escapes into escape placeholders
  set "?.=!?.:$=$0!"
  set "?.=!?.:\""""""=$3!"
  set "?.=!?.:\""""=$2!"
  set "?.=!?.:\""=$1!"

  rem translate escape placeholders into `mshta.exe` (vbs) escapes
  set "?.=!?.:$3=""""!"
  set "?.=!?.:$2=""!"
  set "?.=!?.:$1="!"
  for /F "tokens=* delims="eol^= %%i in ("!?.:$0=$!") do endlocal & set "?.=%%i"
)

set ?.

echo;---

echo Executed as `start "" /B /WAIT mshta.exe ^<?.^>` (without quotes):
echo;

setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & ^
start "" /B /WAIT "%SystemRoot%\System32\mshta.exe" %%i
