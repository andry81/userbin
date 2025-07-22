@echo off

rem script flags
set ?FLAG_SHIFT=0
set ?FLAG_P=0
set ?FLAG_R=0
set ?FLAG_D=0
set ?FLAG_NO_EXPAND=0
set ?FLAG_ALLOW_RENAME=0
set "?FLAG_VAR_LIST="

rem flags always at first
set "?FLAG=%~1"

if defined ?FLAG if not "%?FLAG:~0,1%" == "-" set "?FLAG="

if defined ?FLAG if "%?FLAG%" == "-p" set "?FLAG_P=1" & shift & call set "?FLAG=%%~1" & set /A ?FLAG_SHIFT+=1
if defined ?FLAG if "%?FLAG%" == "-r" set "?FLAG_R=1" & shift & call set "?FLAG=%%~1" & set /A ?FLAG_SHIFT+=1
if defined ?FLAG if "%?FLAG%" == "-d" set "?FLAG_D=1" & shift & call set "?FLAG=%%~1" & set /A ?FLAG_SHIFT+=1
if defined ?FLAG if "%?FLAG%" == "-noexpand" set "?FLAG_NO_EXPAND=1" & shift & call set "?FLAG=%%~1" & set /A ?FLAG_SHIFT+=1
if defined ?FLAG if "%?FLAG%" == "-allow-rename" set "?FLAG_ALLOW_RENAME=1" & shift & call set "?FLAG=%%~1" & set /A ?FLAG_SHIFT+=1

:FLAG_V_LOOP
if defined ?FLAG if "%?FLAG%" == "-v" ( set ?FLAG_VAR_LIST=%?FLAG_VAR_LIST% "%~2") & shift & shift & call set "?FLAG=%%~1" & set /A ?FLAG_SHIFT+=2 & goto FLAG_V_LOOP

if defined ?FLAG if "%?FLAG%" == "--" shift & set /A ?FLAG_SHIFT+=1
