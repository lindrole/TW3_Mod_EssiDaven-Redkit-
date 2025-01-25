@echo off
:: ---------------------------------------------------
:: --- settings
:: ---------------------------------------------------
call _settings_.bat

: with logfile but no coloring in console and start up error (which is not an error)
rem powershell "& '%DIR_ENCODER%\w3speech-phoneme-extractor' --data-dir '%DIR_DATA_PHONEME_GENERATION%' --actor-mappings '%DIR_PROJECT_BASE%\actor_mapping.cfg' %LOG_LEVEL% 2>&1 | tee '%MANUAL_SESSION_LOGFILE%'"

"%DIR_ENCODER%\w3speech-phoneme-extractor" --data-dir "%DIR_DATA_PHONEME_GENERATION%" --actor-mappings "%DIR_PROJECT_BASE%\actor_mapping.cfg" %LOG_LEVEL% 2>&1

pause