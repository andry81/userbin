@echo off & goto DOC_END

rem USAGE:
rem   cmd-admin-system.bat <cmdline>...

rem Description:
rem   Script runs `COMSPEC` executable with <cmdline> under UAC promotion using
rem   `mshta.exe` and `psexec.exe` executables.
rem
rem   If the environment is already under the `SYSTEM` account, then
rem   `mshta.exe` and `psexec.exe` does skip.
rem
rem   If is not under the `SYSTEM` account, then `psexec.exe` is required in
rem   the `PATH` or in the `PSEXEC` variable.
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
rem   The command line load and parse code is a copy from `callshift.bat`
rem   script from `contools` project.

rem CAUTION:
rem   If you pass a parameter or set of parameters starting the first argument,
rem   then these may be skipped, due to the internal `cmd.exe` command line
rem   parse logic. The command line does not ignored if started using the slash
rem   character with the known option - `/k`, `/c` and etc.
rem   To change the path to the `cmd.exe`, use `runas-admin*.bat` instead.

rem CAUTION:
rem   Opposite to `cmd-admin.bat` script the
rem   `cmd-admin-system.bat ...` command will start a 64-bit variant of
rem   `cmd.exe` process even if run from 32-bit `cmd.exe` process.
rem   You have to use
rem   `runas-admin-system.bat "%SystemRoot%\SysWOW64\cmd.exe" ..` command
rem   instead to directly run 32-bit `cmd.exe` process.

rem Examples (in script):
rem   1. >
rem      set "PSEXEC=.../psexec.exe"
rem      cmd-admin-system.bat /k echo 123
rem
rem   2. Without Windows Batch compatible double quote escapes
rem      >
rem      set "PSEXEC=.../psexec.exe"
rem      set CMDLINE=print-args-as-splitted-exe-cmdline.bat "123 & 456" "654 | 321"
rem      
rem      call is-system-elevated.bat && (
rem        set CMDLINE=/c %CMDLINE%
rem        call;
rem      ) || set CMDLINE=/k %CMDLINE%
rem      
rem      cmd-admin-system.bat %CMDLINE%
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
rem        set CMDLINE=/S /c "%CMDLINE%"
rem        call;
rem      ) || set CMDLINE=/S /k "%CMDLINE%"
rem      
rem      cmd-admin-system.bat %CMDLINE%
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
  for %%z in (%%z) do ^
rem |%*|
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

rem CAUTION:
rem   We must always use the Administrator elevation in case of not SYSTEM
rem   account, because `psexec.exe` can be installed only in the elevated
rem   account.

call :IS_SYSTEM_ELEVATED || goto CALL_ADMIN_ELEVATE_AND_EXIT

(
  setlocal ENABLEDELAYEDEXPANSION

  if defined ?. (
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
  )

  rem with locals drop
  for /F "usebackq tokens=* delims="eol^= %%i in ('"!COMSPEC!" !?.!') do endlocal & endlocal & %%i

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

set "COMMAND="

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
  & for /F "usebackq tokens=* delims="eol^= %%j in ('""""!COMMAND!"""" !?.!') do endlocal & endlocal ^
  & start "" /B /WAIT "%SystemRoot%\System32\mshta.exe" vbscript:ExecuteGlobal("Close(CreateObject(""Shell.Application"").ShellExecute(""%%~i"", ""-i -s -d %%j"", """", ""runas"", 0))"^)

  exit /b
)
