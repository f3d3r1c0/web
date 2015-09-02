@echo off
@REM 
@REM Argomenti opzionali
@REM 	- %1 estensione usata per la conversione (preceeduta da '.') 
@REM 
@set OPTS=-density 150
if exist output goto skip_mkdir
mkdir output
goto skip_cldir
:skip_mkdir
@del /q output\*>nul 2>&1
:skip_cldir
@set ext=.png
@if "%1"=="" goto skip_ext
@set ext=%1
:skip_ext
FOR /R %%i IN (sources\*.pdf) DO convert %OPTS% sources\%%~ni%%~xi output\%%~ni%ext%

