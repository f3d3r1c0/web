@echo off
@set OPTS=-o7
FOR /R %%i IN (output\*[WM]*) DO optipng %OPTS% output\%%~ni%%~xi
