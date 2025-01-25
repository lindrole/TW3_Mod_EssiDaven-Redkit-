@echo off
:: ---------------------------------------------------
:: --- settings
:: ---------------------------------------------------
call _settings_.bat

:: ---------------------------------------------------

:: generate lipsync only from text:
:: lipsync animations and silent placeholder audio will be generated from the 
:: strings csv file (e.g. no voiceaudio available, yet).  
:: 
:: Note: only string lines with non-empty VOICEOVER column will be used. 
:: (or non-empty ACTOR column for radish strings csv)
:: 
SET GENERATE_FROM_TEXT_ONLY=yes

powershell "[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8; & '%DIR_PROJECT_BIN%\build.bat' 2>&1 | tee '%LOGFILE%'"
