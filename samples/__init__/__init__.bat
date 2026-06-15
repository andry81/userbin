@echo off

if defined USERBIN_PROJECT_ROOT_INIT0_DIR if exist "%USERBIN_PROJECT_ROOT_INIT0_DIR%\*" exit /b 0

call "%%~dp0..\..\__init__\__init__.bat" || exit /b

rem retarget externals of an external project

call "%%CONTOOLS_ROOT%%/std/canonical_path_if_ndef.bat" CONTOOLS_UTILS_PROJECT_EXTERNALS_ROOT "%%USERBIN_PROJECT_EXTERNALS_ROOT%%"

rem init external projects

call "%%CONTOOLS_ROOT%%/std/call_if_exist.bat" "%%USERBIN_PROJECT_EXTERNALS_ROOT%%/contools--utils/__init__/__init__.bat" %%* || exit /b

exit /b 0
