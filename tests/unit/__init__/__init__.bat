@echo off

if defined USERBIN_PROJECT_ROOT_INIT0_DIR if exist "%USERBIN_PROJECT_ROOT_INIT0_DIR%\*" exit /b 0

call "%%~dp0..\..\__init__\__init__.bat" || exit /b
