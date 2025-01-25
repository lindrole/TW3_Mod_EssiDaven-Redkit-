@echo off
:: ---------------------------------------------------
:: --- settings
:: ---------------------------------------------------
call _settings_.bat

:: ---------------------------------------------------
powershell "[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8; & '%DIR_PROJECT_BIN%\build.bat' 2>&1 | tee '%LOGFILE%'"
