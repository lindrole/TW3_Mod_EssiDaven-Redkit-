@echo off
rem ---------------------------------------------------
rem --- check for settings
rem ---------------------------------------------------
IF %SETTINGS_LOADED% EQU 1 goto :SettingsLoaded

echo ERROR! Settings not loaded! - do not start this file directly!
EXIT /B 1

:SettingsLoaded
IF %ERRORLEVEL% NEQ 0 GOTO SomeError
rem ---------------------------------------------------
set DIR_EXECUTION_START=%cd%

echo ---------------------------------------------------------
echo ^>^> checking settings
echo ---------------------------------------------------------

if "%GENERATE_FROM_TEXT_ONLY%" == "yes" (
  if not "%CREATE_W3SPEECH_FILES%" == "yes" (
    if not "%CONVERT_TO_WEM%" == "yes" (
      echo.
      echo ERROR: generating animations from text requires either CREATE_W3SPEECH_FILES=yes and/or CONVERT_TO_WEM=yes
      echo        -^> redkit scene editor requires audio files with proper duration converted to wem
      GOTO:SomeError
    )
  )
) else (
  if not "%CONVERT_TO_WEM%" == "yes" (
    echo.
    echo ERROR: generating animations from audio requires CONVERT_TO_WEM=yes
    GOTO:SomeError
  )
)

rem check directory settings

rem dedicated error sub calls as a workaround for checking directory with
rem potentionally closing bracket within a () block

if NOT exist "%DIR_ENCODER%" (
  GOTO:EncoderNotFound
)

if NOT exist "%DIR_REDKIT_PROJECT_ROOT%" (
  GOTO:RedkitRootNotFound
)

if NOT exist "%DIR_WWISE_BIN_NEXT_GEN%" (
  if "%CONVERT_TO_WEM%" == "yes" (
    GOTO:WWiseNotFound
  )
)

if "%CREATE_W3SPEECH_FILES%" == "yes" (
  if NOT exist "%DIR_W3SPEECH%" (
    CALL:W3SpeechDirNotFound
  )
)

echo.
echo INFO ^>^> found all configured directories.
echo.

rem ---------------------------------------------------
setlocal enableDelayedExpansion

for %%l in ( %LANGUAGES% ) do (

  SET LANGUAGE=%%l
  SET DIR_AUDIO=%DIR_PROJECT_BASE%\!LANGUAGE!.audio
  SET DIR_PHONEMES=!DIR_AUDIO!
  SET DIR_AUDIO_WEM=%DIR_PROJECT_BASE%\!LANGUAGE!.wem

  call :printHeader language: %%l

  if exist "!DIR_AUDIO!" (

    if NOT exist "!DIR_AUDIO_WEM!" mkdir "!DIR_AUDIO_WEM!"

    if "%USE_REDKIT_STRINGS_CSV%" == "yes" (
        SET STRINGS_FILE=%DIR_PROJECT_BASE%\%REDKIT_STRINGS_CSV%
        SET SIMPLE_FILENAMES=
    ) else (
        SET STRINGS_FILE=!DIR_AUDIO!/!LANGUAGE!.strings.csv
        SET SIMPLE_FILENAMES=--simple-filenames
    )

    if "%GENERATE_FROM_TEXT_ONLY%" == "yes" (
        echo ---------------------------------------------------------
        echo ^>^> generating lipsync timings from text only
        echo ---------------------------------------------------------

        call :runEncoder "%DIR_ENCODER%\w3speech-phoneme-extractor" --data-dir "%DIR_DATA_PHONEME_GENERATION%" --generate-from-text-only --strings-file "!STRINGS_FILE!" --output-dir "!DIR_PHONEMES!" --language !LANGUAGE! --actor-mappings "%DIR_PROJECT_BASE%\actor_mapping.cfg" %LOG_LEVEL%

        IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

        echo ---------------------------------------------------------
        echo ^>^> generating lipsync animations + silence audio files
        echo ---------------------------------------------------------

        :: convert audio to wem
        if "%CONVERT_TO_WEM%" == "yes" (
          call :runEncoder "%DIR_ENCODER%\w3speech-lipsync-creator" --create-lipsync "!DIR_PHONEMES!\*.phonemes" --output-dir "!DIR_AUDIO_WEM!" --repo-dir "%DIR_REPO_LIPSYNC%" --generate-placeholder-wav-audio --actor-profiles "%DIR_PROJECT_BASE%\actor_mapping.cfg" %LOG_LEVEL%
          IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

          call :convertToWem
          IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

          call :copyToRedKitProject
          IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

        ) else (
          :: no wem conversion -> generate only placeholder wems
          call :runEncoder "%DIR_ENCODER%\w3speech-lipsync-creator" --create-lipsync "!DIR_PHONEMES!\*.phonemes" --output-dir "!DIR_AUDIO_WEM!" --repo-dir "%DIR_REPO_LIPSYNC%" --generate-placeholder-wav-audio --generate-placeholder-audio "%FILE_WEM_SILENCE%" --actor-profiles "%DIR_PROJECT_BASE%\actor_mapping.cfg" %LOG_LEVEL%
          IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError
        )

        if "%CREATE_W3SPEECH_FILES%" == "yes" (
          call :createW3speech
          IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError
        )

    ) else (
        echo ---------------------------------------------------------
        echo ^>^> extracting phoneme timings from audio
        echo ---------------------------------------------------------

        call :runEncoder "%DIR_ENCODER%\w3speech-phoneme-extractor" --data-dir "%DIR_DATA_PHONEME_GENERATION%" --extract "!DIR_AUDIO!" --strings-file "!STRINGS_FILE!" --language !LANGUAGE! --actor-mappings "%DIR_PROJECT_BASE%\actor_mapping.cfg" %LOG_LEVEL%

        IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

        echo ---------------------------------------------------------
        echo ^>^> generating lipsync animations
        echo ---------------------------------------------------------

        call :runEncoder "%DIR_ENCODER%\w3speech-lipsync-creator" --create-lipsync "!DIR_PHONEMES!\*.phonemes" --output-dir "!DIR_AUDIO_WEM!" --repo-dir "%DIR_REPO_LIPSYNC%" --actor-profiles "%DIR_PROJECT_BASE%\actor_mapping.cfg" %LOG_LEVEL%
        IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

        :: convert audio to wem
        if "%CONVERT_TO_WEM%" == "yes" (
            call :convertToWem
            IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError

            call :copyToRedKitProject
            IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError
        )
        if "%CREATE_W3SPEECH_FILES%" == "yes" (
            call :createW3speech
            IF /I "!ERRORLEVEL!" NEQ "0" GOTO:SomeError
        )
    )

  ) else (
      echo ^>^> directory !DIR_AUDIO! not found. nothing to do...
  )
)
echo.

endlocal

rem ---------------------------------------------------
rem END
:TheEnd
call :printResult DONE.
pause
EXIT /B 0

rem ---------------------------------------------------------------------------
:convertToWem
echo -------------------------------------------------------
echo ^>^> converting AUDIO to WEM
echo -------------------------------------------------------

echo.
echo  ^>^> COLLECTING AUDIO LIST
echo.

CALL "%WWISE_CONF_DIR%\_generate.sources.bat"

IF /I "%ERRORLEVEL%" NEQ "0" EXIT /B %ERRORLEVEL%

echo.
echo  ^>^> CONVERTING AUDIO FILES TO *.wem
echo.

if "%LOG_LEVEL%" NEQ "" SET WWISE_LOGLEVEL=--verbose

call :runEncoder "%DIR_WWISE_BIN_NEXT_GEN%\WwiseConsole" convert-external-source "%WWISE_CONF_DIR%\nextgen\NG-Conversion.wproj" --output WINDOWS "%DIR_AUDIO_WEM%" --no-wwise-dat %WWISE_LOGLEVEL%

IF /I "%ERRORLEVEL%" NEQ "0" EXIT /B %ERRORLEVEL%

EXIT /B 0


rem ---------------------------------------------------------------------------
:copyToRedKitProject
echo ---------------------------------------------------------
echo ^>^> generating redkit compatible lipsync animations
echo ---------------------------------------------------------

call :runEncoder "%DIR_ENCODER%\w3speech-converter" %SIMPLE_FILENAMES% --input-dir "%DIR_AUDIO_WEM%" --wav-audio-dir "%DIR_AUDIO%" --output-dir "%DIR_REDKIT_PROJECT_ROOT%" --strings-file "%STRINGS_FILE%" --language %LANGUAGE%

IF /I "%ERRORLEVEL%" NEQ "0" EXIT /B %ERRORLEVEL%

EXIT /B 0


rem ---------------------------------------------------------------------------
:createW3speech
echo ---------------------------------------------------------
echo ^>^> generating w3speech file
echo ---------------------------------------------------------

rem name of the final speech file
SET W3SPEECH_FILE=%LANGUAGE%pc.w3speech

call :runEncoder "%DIR_ENCODER%\w3speech" --encode-cr2w "%DIR_AUDIO_WEM%" %LOG_LEVEL%
IF /I "%ERRORLEVEL%" NEQ "0" EXIT /B %ERRORLEVEL%

echo.
call :runEncoder "%DIR_ENCODER%\w3speech" --pack-w3speech "%DIR_AUDIO_WEM%" --output-dir "%DIR_W3SPEECH%" --language %LANGUAGE% %LOG_LEVEL%
rem includes sbui speech selection script
rem call :runEncoder "%DIR_ENCODER%\w3speech" --pack-w3speech "%DIR_AUDIO_WEM%" --output-dir "%DIR_W3SPEECH%" --script-prefix "R2R" --script-output-dir "%DIR_W3SPEECH%" --strings-file "%STRINGS_FILE%" --language %LANGUAGE% %LOG_LEVEL%

IF /I "%ERRORLEVEL%" NEQ "0" EXIT /B %ERRORLEVEL%

if exist "%DIR_W3SPEECH%\%W3SPEECH_FILE%" del "%DIR_W3SPEECH%\%W3SPEECH_FILE%"
rename "%DIR_W3SPEECH%\%LANGUAGE%.w3speech.packed" "%W3SPEECH_FILE%"

EXIT /B 0


rem ---------------------------------------------------------------------------
:printHeader
echo.
echo --------------------------------------------------------------------------
echo -- %*
echo --------------------------------------------------------------------------
echo.
EXIT /B 0


rem ---------------------------------------------------------------------------
:printResult
echo.
echo --------------------------------------------------------------------------
echo -- %*
echo --------------------------------------------------------------------------
EXIT /B 0


rem ---------------------------------------------------
rem error
:EncoderNotFound
echo.
echo ERROR: encoder directory '%DIR_ENCODER%' not found.
GOTO :SomeError
EXIT /B 1

rem ---------------------------------------------------
rem error
:RedkitRootNotFound
echo.
echo ERROR: redkit project root directory '%DIR_REDKIT_PROJECT_ROOT%' not found.
GOTO:SomeError
EXIT /B 1

rem ---------------------------------------------------
rem error
:WWiseNotFound
echo.
echo ERROR: wwise installation directory '%DIR_WWISE_BIN_NEXT_GEN%' not found.
GOTO:SomeError
EXIT /B 1

rem ---------------------------------------------------
rem error
:W3SpeechDirNotFound
echo.
echo WARN: target w3speech directory '%DIR_W3SPEECH%' not found. creating dir...
mkdir "%DIR_W3SPEECH%"
IF /I "%ERRORLEVEL%" NEQ "0" GOTO:SomeError
EXIT /B 0

rem ---------------------------------------------------
rem error
:SomeError
cd /D "%DIR_EXECUTION_START%"
echo.
echo ERROR! Something went WRONG! Please check the logfile: [%LOGFILE%] for the root cause.
echo.
echo - press key to continue -
echo.
pause
EXIT /B 1

rem ---------------------------------------------------------------------------
:runEncoder
echo.
echo RUN ^> %* 
echo.
%*

EXIT /B %ERRORLEVEL%

