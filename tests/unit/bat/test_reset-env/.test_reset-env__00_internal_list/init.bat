@echo off

set "TEST_DATA_FILE_REF_PTTN=%~1"
set "TEST_DATA_FILE_REF_DIR=%~2"
set "RESET_ENV_FLAGS_CMD_LINE=%~3"

if not defined TEST_DATA_FILE_REF_PTTN exit /b 255
if not defined TEST_DATA_FILE_REF_DIR exit /b 255

call "%%CONTOOLS_ROOT%%/std/setshift.bat" 3 RESET_ENV_VAR_LIST %%*

call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" TEST_DATA_REF_DIR "%%TEST_DATA_IN_ROOT%%\%%TEST_SCRIPT_FILE_NAME%%\%%TEST_DATA_FILE_REF_DIR%%"

call "%%CONTOOLS_ROOT%%/std/allocate_temp_dir.bat" . "%%TEST_SCRIPT_FILE_NAME%%" "" "%%TEST_DATA_TEMP_ROOT%%" || exit /b

set "TEST_TEMP_DIR_NAME=%SCRIPT_TEMP_DIR_NAME%"
set "TEST_TEMP_DIR_PATH=%SCRIPT_TEMP_CURRENT_DIR%"

rem initialize setup parameters
call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" TEST_TEMP_DATA_IN_FILE                  "%%TEST_TEMP_DIR_PATH%%\in.lst"
call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" TEST_TEMP_DATA_OUT_FILE                 "%%TEST_TEMP_DIR_PATH%%\out.lst"
call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" TEST_TEMP_DATA_REF_FILE                 "%%TEST_TEMP_DIR_PATH%%\ref.lst"
call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" TEST_TEMP_DATA_IN_FILTERED_BY_REF_FILE  "%%TEST_TEMP_DIR_PATH%%\in-filtered-by-ref.lst"

pushd "%TEST_TEMP_DIR_PATH%"

exit /b 0
