@echo off & goto DOC_END

rem USAGE:
rem   print-args-as-splitted-bat-cmdline.bat <args>...

rem Description:
rem   Script prints script arguments as a splitted multi line text, where each
rem   line is the batch command line argument surrounded by the `|`
rem   character.
rem   Characters , ; = is treated as a command line separators.
rem   Prints `||` in case of empty arguments.

rem CAUTION:
rem   Would print nothing if called as `cmd.exe /Q ...`.

rem NOTE:
rem   The command line load and parse code is a copy from `callshift.bat`
rem   script in the `contools` project.
:DOC_END

setlocal DISABLEDELAYEDEXPANSION & set "LAST_ERROR=%ERRORLEVEL%"

if defined SCRIPT_TEMP_CURRENT_DIR (
  set "CMDLINE_TEMP_FILE=%SCRIPT_TEMP_CURRENT_DIR%\%~n0.%RANDOM%_%RANDOM%.txt"
) else set "CMDLINE_TEMP_FILE=%TEMP%\%~n0.%RANDOM%_%RANDOM%.txt"

(
  setlocal DISABLEEXTENSIONS
  (PROMPT=$_)
  echo on
  for %%z in (%%z) do rem |%*|
  @echo off
  endlocal
) > "%CMDLINE_TEMP_FILE%"

set "?.=" & for /F "usebackq tokens=* delims="eol^= %%i in ("%CMDLINE_TEMP_FILE%") do set "?.=%%i"

rem CAUTION: must check on empty variable to avoid accidental `del /Q ""` case
if defined CMDLINE_TEMP_FILE del /F /Q /A:-D "%CMDLINE_TEMP_FILE%" >nul 2>nul

if not defined ?. exit /b %LAST_ERROR%

setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!?.:~5,-2!"') do endlocal & set "?.=%%~i"

if not defined ?. (echo;^|^|) & exit /b %LAST_ERROR%

rem Encode these characters (see general implementation in `std/encode/encode_sys_chars_bat_cmdline.bat` script):
rem  $          - encode character
rem  |&()<>     - control flow characters
rem  '`^%!+     - escape or sequence expand characters (`+` is a unicode codepoint sequence character in 65000 code page)
rem  ?*<>       - globbing characters in the `for ... %%i in (...)` expression or in a command line (`?<` has different globbing versus `*`, `*.` versus `*.>`)

setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.:$=$24!") do endlocal & set "?.=%%i"

setlocal ENABLEDELAYEDEXPANSION & set "?.=!?.:"=$22!"
for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & set "?.=%%i"

set "?.=%?.:!=$21%"

setlocal ENABLEDELAYEDEXPANSION & if "!?.!" == "!?.:**=!" ( goto ASTERISK_CHAR_ENCODE_END ) else endlocal

:ASTERISK_CHAR_ENCODE_LOOP
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=1 delims=*"eol^= %%i in (".!?.!") do for /F "tokens=* delims="eol^= %%j in ("!?.:**=!.") do endlocal & set "?.=%%i$2A%%j" & ^
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.:~1,-1!") do ^
if not "!?.!" == "!?.:**=!" ( endlocal & set "?.=%%i" & goto ASTERISK_CHAR_ENCODE_LOOP ) else endlocal & set "?.=%%i"
:ASTERISK_CHAR_ENCODE_END

setlocal ENABLEDELAYEDEXPANSION & ^
set "?.=!?.:|=$7C!" & set "?.=!?.:&=$26!"  & set "?.=!?.:(=$28!" & set "?.=!?.:)=$29!" & ^
set "?.=!?.:<=$3C!" & set "?.=!?.:>=$3E!"  & set "?.=!?.:'=$27!" & set "?.=!?.:`=$60!" & ^
set "?.=!?.:^=$5E!" & set "?.=!?.:%%=$25!" & set "?.=!?.:+=$2B!" & set "?.=!?.:?=$3F!" & ^
for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & set "?.=%%i"

setlocal ENABLEDELAYEDEXPANSION & set "?.=!?.:$22="!"

for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & for %%j in (%%i) do (
  set "__ARG__=%%j" & setlocal ENABLEDELAYEDEXPANSION & set "__ARG__=!__ARG__:"=$22!"
  for /F "tokens=* delims="eol^= %%i in ("!__ARG__!") do endlocal & set "__ARG__=%%i"

  call set "__ARG__=%%__ARG__:$21=!%%"

  setlocal ENABLEDELAYEDEXPANSION & set "__ARG__=!__ARG__:$22="!"
    set "__ARG__=!__ARG__:$7C=|!" & set "__ARG__=!__ARG__:$26=&!"  & set "__ARG__=!__ARG__:$28=(!" & set "__ARG__=!__ARG__:$29=)!" ^
  & set "__ARG__=!__ARG__:$3C=<!" & set "__ARG__=!__ARG__:$3E=>!"  & set "__ARG__=!__ARG__:$27='!" & set "__ARG__=!__ARG__:$60=`!" ^
  & set "__ARG__=!__ARG__:$5E=^!" & set "__ARG__=!__ARG__:$25=%%!" & set "__ARG__=!__ARG__:$2B=+!" ^
  & set "__ARG__=!__ARG__:$3F=?!" & set "__ARG__=!__ARG__:$2A=*!"  & set "__ARG__=!__ARG__:$24=$!" ^
  & for /F "tokens=* delims="eol^= %%i in ("!__ARG__!") do endlocal & echo;^|%%i^|
)

exit /b %LAST_ERROR%
