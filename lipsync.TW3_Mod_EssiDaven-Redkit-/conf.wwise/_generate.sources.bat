@echo off

SET FILE_SOURCES="%WWISE_CONF_DIR%\ext-sources.wsources"

echo ^<?xml version="1.0" encoding="UTF-8"?^>  > %FILE_SOURCES%
echo ^<ExternalSourcesList SchemaVersion="1" Root="%DIR_AUDIO%"^> >> %FILE_SOURCES%

for %%f in ("%DIR_AUDIO%\*") do (
    if "%%~xf"==".wav" (
        echo    ^<Source Path="%%~nxf" Conversion="Default Conversion Settings" /^> >> %FILE_SOURCES%
    )
    if "%%~xf"==".ogg" (
        echo    ^<Source Path="%%~nxf" Conversion="Default Conversion Settings" /^> >> %FILE_SOURCES%
    )
)

echo ^</ExternalSourcesList^> >> %FILE_SOURCES%
