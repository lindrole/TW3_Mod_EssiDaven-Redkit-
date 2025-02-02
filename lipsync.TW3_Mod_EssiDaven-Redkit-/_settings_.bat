@echo off

rem dir where this _settings_.bat file is located - DO NOT CHANGE!
SET DIR_PROJECT_BASE=%~dp0

rem -----------------------------------------------------------------------------------------------
rem --- settings for project
rem ---

rem logging level for all encoders. uncomment desired level,
rem default is empty -> minimal info + warnings + errors
SET LOG_LEVEL=
rem set LOG_LEVEL=--verbose
rem set LOG_LEVEL=--very-verbose

rem -----------------------------------------------------------------------------------------------
rem !!! check these settings !!!
rem -----------------------------------------------------------------------------------------------

rem -- path to radish lipsync for redkit encoder binaries
SET DIR_RADISH_ENCODER=D:\Witcher__3\W3_modding_Tools\rmer Lipsync re encoder tool\radish-tools

rem -- path to root directory of the redkit project
rem generated audio and lipsync files will be placed in appropriate language 
rem dependent subdirectories automativally
SET DIR_REDKIT_PROJECT_ROOT=D:\Witcher__3\REDKIT\Projects\TW3_Mod_EssiDaven-Redkit-

rem -- wav/ogg -> wem conversion
rem auto-convert ogg or wav audio files in <lang>.audio directories to wem 
rem files. wem files will also be copied to redkit project.
rem requires Wwise to be installed, see DIR_WWISE_BIN_NEXT_GEN
rem 
rem Note: redkit scene editor scales voiceover segments based on wem audio 
rem       duration. set to "no" ONLY if you do not want to edit scenes in redkit 
rem       scene editor AND lip animations are created from text AND w3speech 
rem       files are created directly!
rem Note: this will convert all audio on every run!
SET CONVERT_TO_WEM=yes

rem W3 NEXT-GEN v4.x:
rem   - requires Wwise v2021.1.14
rem
rem path to wwise bin directory for *NEXT-GEN* compatible version
rem e.g. c:\Program Files (x86^)\Audiokinetic\Wwise2021.1.14.8108\Authoring\x64\Release\bin
SET DIR_WWISE_BIN_NEXT_GEN=C:\Program Files (x86)\Audiokinetic\Wwise2021.1.14.8108\Authoring\x64\Release\bin


rem -- source csv for text strings
rem set to "yes" to use a redkit csv file. the exported csv must be in root 
rem of this project directory and contain all translated texts for languages to 
rem be processed. 
rem otherwise the encoders expect a radish speech csv named <lang>.strings.csv 
rem in the respective <lang>.audio dirs
SET USE_REDKIT_STRINGS_CSV=yes

rem -- redkit csv name in project root
rem default name is already set to LocalEditorStringDataBaseW3_UTF8_mod_export.csv
rem SET REDKIT_STRINGS_CSV=my-custom-name.csv


rem -- specify languages to process
rem list of language(-code)s that should be processed. additionally for every
rem language to be processed a folder <language-code>.audio must be created.
rem
rem Note: lipsync from audio generation requires language to be supported by
rem       espeak AND the phoneme extractor. see DIR_RADISH_ENCODER/data for list
rem       of installed language packages (especially the pocketsphinx packages)
rem Note: lip animation from text generation requires language to be supported
rem       by espeak, see DIR_RADISH_ENCODER/data/espeak-data for supported languages
rem
rem default is LANGUAGES=de en fr pl ru
rem SET LANGUAGES=ar br cn cz de en es esmx fr hu it jp kr pl ru tr zh


rem -- w3speech file generation
rem set to "yes" to automatically create w3speech files for the processed languages
rem Note: w3speech generation requires wem files:
rem   - if lipsync animations are created from audio then CONVERT_TO_WEM must 
rem     set to "yes" and the path to the wwise bin directory must be valid
rem   - if animations are created from text lines CONVERT_TO_WEM is unnecessary 
rem     as a silence placeholder audio is used instead
SET CREATE_W3SPEECH_FILES=yes

rem -- w3speech directory
rem all w3speech files will be placed there, e.g. the content directory of the
rem mod in a w3 game installation for quick in-game testing
SET DIR_W3SPEECH=D:\Witcher__3\REDKIT\Projects\TW3_Mod_EssiDaven-Redkit-\lipsync.TW3_Mod_EssiDaven-Redkit-\w3speech

rem -----------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------
call "%DIR_PROJECT_BASE%\bin\_default.settings.bat"
