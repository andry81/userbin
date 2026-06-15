@echo off & goto DOC_END

rem USAGE:
rem   runas-admin-system.bat <cmdline>...

rem Description:
rem   Script runs <cmdline> under UAC promotion using `mshta.exe` and
rem   `psexec.exe` executables.
rem
rem   If the environment is already under the `SYSTEM` account, then
rem   `mshta.exe` and `psexec.exe` does skip.
rem
rem   If is not under the `SYSTEM` account, then `psexec.exe` is required in
rem   the `PATH` or in the `PSEXEC` variable.
rem
rem   The command line does split by the first argument to be passed into
rem   `ShellExecute` function.
rem
rem   NOTE:
rem     `ExecuteGlobal` is used as a workaround, because the `mshta.exe` first
rem     argument must not be used with the surrounded quotes.
rem
rem   The <cmdline> can contain an even number of double quotes prefixed by the
rem   `\` character. It will be replaced by N/2 number of quotes without the
rem   prefix:
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
rem   The command line load and parse code is a copy from
rem   `print-args-as-splitted-exe-cmdline.bat` script in the `userbin` project.

rem CAUTION:
rem   Opposite to `runas-admin.bat` script the
rem   `runas-admin-system.bat "%SystemRoot%\System32\cmd.exe" ...` command will
rem   start a 64-bit variant of `cmd.exe` process even if run from 32-bit
rem   `cmd.exe` process.
rem   You have to use
rem   `runas-admin-system.bat "%SystemRoot%\SysWOW64\cmd.exe" ..` command
rem   instead to directly run 32-bit `cmd.exe` process.

rem Examples (in script):
rem   1. >
rem      set "PSEXEC=.../psexec.exe"
rem      runas-admin-system.bat "%SystemRoot%\System32\cmd.exe" /k echo 123
rem      runas-admin-system.bat "%SystemRoot%\SysWOW64\cmd.exe" /k echo 123
rem
rem   2. Without Windows Batch compatible double quote escapes
rem      >
rem      set "PSEXEC=.../psexec.exe"
rem      set CMDLINE=print-args-as-splitted-exe-cmdline.bat "123 & 456" "654 | 321"
rem      
rem      call is-system-elevated.bat && (
rem        set CMDLINE="%SystemRoot%\System32\cmd.exe" /c %CMDLINE%
rem        call;
rem      ) || set CMDLINE="%SystemRoot%\System32\cmd.exe" /k %CMDLINE%
rem      
rem      runas-admin-system.bat %CMDLINE%
rem      
rem      <
rem      |"123 & 456"|
rem      |"654 | 321"|
rem
rem   3. With Windows Batch compatible double quote escapes
rem      >
rem      set "PSEXEC=.../psexec.exe"
rem      set "CMDLINE=print-args-as-splitted-exe-cmdline.bat \""123 & 456\"" \""654 | 321\"""
rem      
rem      call is-system-elevated.bat && (
rem        set CMDLINE="%SystemRoot%\System32\cmd.exe" /S /c "%CMDLINE%"
rem        call;
rem      ) || set CMDLINE="%SystemRoot%\System32\cmd.exe" /S /k "%CMDLINE%"
rem      
rem      runas-admin-system.bat %CMDLINE%
rem      
rem      <
rem      |"123 & 456"|
rem      |"654 | 321"|
:DOC_END

rem with save of previous error level
setlocal DISABLEDELAYEDEXPANSION & setlocal & set LAST_ERROR=%ERRORLEVEL%

rem script names call stack
if defined ?~ ( set "?~=%?~%-^>%~nx0" ) else if defined ?~nx0 ( set "?~=%?~nx0%-^>%~nx0" ) else set "?~=%~nx0"

if defined SCRIPT_TEMP_CURRENT_DIR (
  set "CMDLINE_TEMP_FILE=%SCRIPT_TEMP_CURRENT_DIR%\%~n0.%RANDOM%-%RANDOM%.txt"
) else set "CMDLINE_TEMP_FILE=%TEMP%\%~n0.%RANDOM%-%RANDOM%.txt"

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

rem WORKAROUND:
rem   In case if `echo` is turned off externally.
rem
if not defined ?. exit /b %LAST_ERROR%

setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!?.:~5,-2!"') do endlocal & set "?.=%%~i"

if not defined ?. exit /b %LAST_ERROR%

rem CAUTION:
rem   We must always use the Administrator elevation in case of not SYSTEM
rem   account, because `psexec.exe` can be installed only in the elevated
rem   account.

call :IS_SYSTEM_ELEVATED || goto CALL_ADMIN_ELEVATE_AND_EXIT

(
  setlocal ENABLEDELAYEDEXPANSION

  rem translate Windows Batch compatible double quote escapes into escape placeholders
  set "?.=!?.:$=$0!"
  set "?.=!?.:\""""""=$3!"
  set "?.=!?.:\""""=$2!"
  set "?.=!?.:\""=$1!"
  set "?.=!?.:"^=$1!"

  rem translate escape placeholders into an arbitrary number of double quotes
  set "?.=!?.:$3="""!"
  set "?.=!?.:$2=""!"
  set "?.=!?.:$1="!"
  set "?.=!?.:$0=$!"

  rem with locals drop
  for /F "usebackq tokens=* delims="eol^= %%i in ('"!?.!"') do endlocal & endlocal & %%~i

  exit /b
)

rem CAUTION:
rem   Windows 7 has an issue around the `find.exe` utility and code page 65001.
rem   We use `findstr.exe` instead of `find.exe` to workaround it.
rem
rem   Based on: https://superuser.com/questions/557387/pipe-not-working-in-cmd-exe-on-windows-7/1869422#1869422

rem CAUTION:
rem   In Windows XP an elevated call under data protection flag will block the wmic tool, so we have to use `ver` command instead!

:IS_SYSTEM_ELEVATED
set "WINDOWS_VER_STR=" & set "WINDOWS_MAJOR_VER=0" & for /F "usebackq tokens=1,2,* delims=[]" %%i in (`@ver 2^>nul`) do set "WINDOWS_VER_STR=%%j"
if not defined WINDOWS_VER_STR goto SKIP_VER
setlocal ENABLEDELAYEDEXPANSION & for /F "usebackq tokens=* delims="eol^= %%i in ('"!WINDOWS_VER_STR:* =!"') do endlocal & set "WINDOWS_VER_STR=%%~i"
for /F "tokens=1,2,* delims=."eol^= %%i in ("%WINDOWS_VER_STR%") do set "WINDOWS_MAJOR_VER=%%i"
:SKIP_VER
if %WINDOWS_MAJOR_VER% GEQ 6 (
  if exist "%SystemRoot%\System32\where.exe" "%SystemRoot%\System32\whoami.exe" /groups | "%SystemRoot%\System32\findstr.exe" /L "S-1-16-16384" >nul 2>nul & exit /b
) else if exist "%SystemRoot%\System32\fltmc.exe" "%SystemRoot%\System32\fltmc.exe" >nul 2>nul & exit /b
exit /b 255

:CALL_ADMIN_ELEVATE_AND_EXIT
if not defined PSEXEC set "PSEXEC=psexec.exe"

setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!PSEXEC!") do endlocal & set "PSEXEC=%%~fi"

if not exist "%PSEXEC%" (
  echo;%?~%: error: `psexec.exe` is not found: "%PSEXEC%".
  exit /b 255
) >&2

call :SPLIT_COMMAND_LINE

(
  setlocal ENABLEDELAYEDEXPANSION

  rem translate Windows Batch compatible double quote escapes into escape placeholders
  if defined PSEXEC (
    rem escape %-escapes
    set "PSEXEC=!PSEXEC:%%=%%25!"
  )

  if defined COMMAND (
    rem escape %-escapes
    set "COMMAND=!COMMAND:%%=%%25!"

    set "COMMAND=!COMMAND:$=$0!"
    set "COMMAND=!COMMAND:\""""""=$3!"
    set "COMMAND=!COMMAND:\""""=$2!"
    set "COMMAND=!COMMAND:\""=$1!"
    set "COMMAND=!COMMAND:"^=$1!"
  )

  if defined ?. (
    rem escape %-escapes
    set "?.=!?.:%%=%%25!"

    set "?.=!?.:$=$0!"
    set "?.=!?.:\""""""=$3!"
    set "?.=!?.:\""""=$2!"
    set "?.=!?.:\""=$1!"
    set "?.=!?.:"^=$1!"
  )

  rem translate escape placeholders into an arbitrary number of double quotes in `mshta.exe` (vbs) format
  if defined COMSPEC (
    set "COMMAND=!COMMAND:$3=""""""""""""!"
    set "COMMAND=!COMMAND:$2=""""""""!"
    set "COMMAND=!COMMAND:$1=""""!"
    set "COMMAND=!COMMAND:$0=$!"
  )

  if defined ?. (
    set "?.=!?.:$3=""""""""""""!"
    set "?.=!?.:$2=""""""""!"
    set "?.=!?.:$1=""""!"
    set "?.=!?.:$0=$!"
  )

  rem CAUTION: ShellExecute does not wait a child process close!
  rem NOTE: `ExecuteGlobal` is used as a workaround, because the `mshta.exe` first argument must not be used with the surrounded quotes

  rem with locals drop
  for /F "usebackq tokens=* delims="eol^= %%i in ('"!PSEXEC!"') do break ^
  & for /F "usebackq tokens=* delims="eol^= %%j in ('"!COMMAND!!ARGS!"') do endlocal & endlocal ^
  & start "" /B /WAIT "%SystemRoot%\System32\mshta.exe" vbscript:ExecuteGlobal("Close(CreateObject(""Shell.Application"").ShellExecute(""%%~i"", ""-i -s -d %%~j"", """", ""runas"", 0))"^)

  exit /b
)

:SPLIT_COMMAND_LINE
rem Encode these characters (see general implementation in `std/encode/encode_sys_chars_exe_cmdline.bat` script):
rem  $          - encode character
rem  |&()<>     - control flow characters
rem  '`^%!+     - escape or sequence expand characters (`+` is a unicode codepoint sequence character in 65000 code page)
rem  ?*<>       - globbing characters in the `for ... %%i in (...)` expression or in a command line (`?<` has different globbing versus `*`, `*.` versus `*.>`)
rem  ,;=        - separator characters in the `for ... %%i in (...)` expression or in a command line

setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.:$=$24!") do endlocal & set "?.=%%i"

setlocal ENABLEDELAYEDEXPANSION & set "?.=!?.:"=$22!"
for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & set "?.=%%i"

set "?.=%?.:!=$21%"

setlocal ENABLEDELAYEDEXPANSION & if "!?.!" == "!?.:**=!" ( endlocal & goto ASTERISK_CHAR_ENCODE_END ) else endlocal

:ASTERISK_CHAR_ENCODE_LOOP
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=1 delims=*"eol^= %%i in (".!?.!") do for /F "tokens=* delims="eol^= %%j in ("!?.:**=!.") do endlocal & set "?.=%%i$2A%%j" & ^
setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.:~1,-1!") do ^
if not "!?.!" == "!?.:**=!" ( endlocal & set "?.=%%i" & goto ASTERISK_CHAR_ENCODE_LOOP ) else endlocal & set "?.=%%i"
:ASTERISK_CHAR_ENCODE_END

setlocal ENABLEDELAYEDEXPANSION & for /F "tokens=* delims="eol^= %%i in ("!?.!") do for /F "tokens=1 delims=="eol^= %%j in (".!?.!") do endlocal & set "__HEAD__=%%j" & set "__TAIL__=.%%i" & ^
setlocal ENABLEDELAYEDEXPANSION & if "!__HEAD__!" == "!__TAIL__!" ( endlocal & goto EQUAL_CHAR_ENCODE_END ) else endlocal

set "?.=" & setlocal ENABLEDELAYEDEXPANSION
:EQUAL_CHAR_ENCODE_LOOP
if "!__HEAD__!" == "!__TAIL__!" for /F "tokens=* delims="eol^= %%i in ("!?.!!__TAIL__:~1!") do endlocal & set "?.=%%i" & goto EQUAL_CHAR_ENCODE_END
set "__OFFSET__=2" & set "__TMP__=!__HEAD__!" & for %%i in (65536 32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do if not "!__TMP__:~%%i,1!" == "" set /A "__OFFSET__+=%%i" & set "__TMP__=!__TMP__:~%%i!"
if defined __TAIL__ set "__TAIL__=!__TAIL__:~%__OFFSET__%!"
set "?.=!?.!!__HEAD__:~1!$3D" & ^
for /F "tokens=* delims="eol^= %%i in ("!?.!") do for /F "tokens=1 delims=="eol^= %%j in (".!__TAIL__!") do for /F "tokens=* delims="eol^= %%k in (".!__TAIL__!") do ^
endlocal & set "?.=%%i" & set "__HEAD__=%%j" & set "__TAIL__=%%k" & setlocal ENABLEDELAYEDEXPANSION
goto EQUAL_CHAR_ENCODE_LOOP
:EQUAL_CHAR_ENCODE_END

setlocal ENABLEDELAYEDEXPANSION & ^
set "?.=!?.:|=$7C!" & set "?.=!?.:&=$26!"  & set "?.=!?.:(=$28!" & set "?.=!?.:)=$29!" & ^
set "?.=!?.:<=$3C!" & set "?.=!?.:>=$3E!"  & set "?.=!?.:'=$27!" & set "?.=!?.:`=$60!" & ^
set "?.=!?.:^=$5E!" & set "?.=!?.:%%=$25!" & set "?.=!?.:+=$2B!" & ^
set "?.=!?.:?=$3F!" & set "?.=!?.:,=$2C!"  & set "?.=!?.:;=$3B!" & ^
for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & set "?.=%%i"

set "COMMAND="
set "ARGS="

setlocal ENABLEDELAYEDEXPANSION & set "?.=!?.:$22="!" & ^
for /F "tokens=* delims="eol^= %%i in ("!?.!") do endlocal & for %%j in (%%i) do (
  set "__ARG__=%%j" & setlocal ENABLEDELAYEDEXPANSION & set "__ARG__=!__ARG__:"=$22!"
  for /F "tokens=* delims="eol^= %%i in ("!__ARG__!") do endlocal & set "__ARG__=%%i"

  call set "__ARG__=%%__ARG__:$21=!%%"

  setlocal ENABLEDELAYEDEXPANSION & set "__ARG__=!__ARG__:$22="!"
    set "__ARG__=!__ARG__:$7C=|!" & set "__ARG__=!__ARG__:$26=&!"  & set "__ARG__=!__ARG__:$28=(!" & set "__ARG__=!__ARG__:$29=)!" ^
  & set "__ARG__=!__ARG__:$3C=<!" & set "__ARG__=!__ARG__:$3E=>!"  & set "__ARG__=!__ARG__:$27='!" & set "__ARG__=!__ARG__:$60=`!" ^
  & set "__ARG__=!__ARG__:$5E=^!" & set "__ARG__=!__ARG__:$25=%%!" & set "__ARG__=!__ARG__:$2B=+!" ^
  & set "__ARG__=!__ARG__:$3F=?!" & set "__ARG__=!__ARG__:$2A=*!" ^
  & set "__ARG__=!__ARG__:$2C=,!" & set "__ARG__=!__ARG__:$3B=;!"  & set "__ARG__=!__ARG__:$3D==!" & set "__ARG__=!__ARG__:$24=$!" ^
  & for /F "tokens=* delims="eol^= %%i in ("!__ARG__!") do break ^
  & if defined COMMAND (
    for /F "usebackq tokens=* delims="eol^= %%j in ('"!ARGS!"') do endlocal & set "ARGS=%%~j %%i"
  ) else endlocal & set "COMMAND=%%i"
)
