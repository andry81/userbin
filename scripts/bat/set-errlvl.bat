@if "%~1" == "" exit /b %ERRORLEVEL%
@exit /b %~1

rem USAGE:
rem   set-errlvl.bat [<exit-code>]

rem Description:
rem   See `errlvl.bat` script from `contools` project.
