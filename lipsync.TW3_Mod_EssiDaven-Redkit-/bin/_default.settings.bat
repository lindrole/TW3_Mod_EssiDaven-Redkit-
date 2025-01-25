rem --------------------------------------------------------------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------
rem --- the following settings do not need to be adjusted
rem --------------------------------------------------------------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------

rem --- remove trailing slash
IF %DIR_PROJECT_BASE:~-1%==\ SET DIR_PROJECT_BASE=%DIR_PROJECT_BASE:~0,-1%

rem --- settings for encoders
rem shortcut
SET DIR_ENCODER=%DIR_RADISH_ENCODER%

rem path to repository files of encoder
SET DIR_REPO_LIPSYNC=%DIR_ENCODER%\repo.lipsync

rem path to data directory for phoneme extraction/generation
SET DIR_DATA_PHONEME_GENERATION=%DIR_ENCODER%\data

rem path to a silent wem placeholder audio
SET FILE_WEM_SILENCE=%DIR_ENCODER%\template.wem-silence\-stringid-[0.1].next-gen.silence.wem

rem path to wwise configuration settings
SET WWISE_CONF_DIR=%DIR_PROJECT_BASE%\conf.wwise

rem expected name for exported redkit csv file
if "%REDKIT_STRINGS_CSV%" == "" (
    set REDKIT_STRINGS_CSV=LocalEditorStringDataBaseW3_UTF8_mod_export.csv
)

rem expected list of language to check
if "%LANGUAGES%" == "" (
    set LANGUAGES=de en fr pl ru
)

rem ---------------------------------------------------
rem --- some environment settings

rem dir where building batch files are located
SET DIR_PROJECT_BIN=%DIR_PROJECT_BASE%\bin

SET LOGFILE=%DIR_PROJECT_BASE%\_BUILD-LOG_.txt
SET MANUAL_SESSION_LOGFILE=%DIR_PROJECT_BASE%\_TIMING_ADJUSTMENTS-LOG_.txt
rem ---------------------------------------------------
rem --- default flags for build steps

SET GENERATE_FROM_TEXT_ONLY=no

SET SETTINGS_LOADED=1

rem ---------------------------------------------------
:NoError
rem reset errorlevel
exit /B 0
