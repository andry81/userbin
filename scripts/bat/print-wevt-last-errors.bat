@echo off

if not defined PROJECTS_ROOT "%~dp0abort.bat" "PROJECTS_ROOT environment variable is not defined"

"%PROJECTS_ROOT%/andry81/contools/contools--admin/scripts/Windows/EventLog/print_wevt_last_errors.bat" %*

rem USAGE:
rem   print-wevt-last-errors.bat [<flags>] [--]

rem Description:
rem   Print Event Log last (10 by default) `System` and `Application` errors
rem   and warnings.
rem   By default script prints for the current day only.

rem <flags>:
rem   -a
rem     Print for all the time.
rem
rem     Has no effect on the events quantity.
rem
rem     NOTE:
rem       To limit or increase the events quantity use `/c:N` bare option.
rem
rem   -long
rem     Print long output instead of short as by default.
rem
rem   -err
rem     Print errors only.
rem
rem   /<bare>
rem     Bare option for the `wevtutil.exe` utility.
