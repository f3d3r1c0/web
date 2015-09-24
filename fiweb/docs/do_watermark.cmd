@echo off
@set OPTS=-dissolve 10% -gravity NorthEast
FOR /R %%i IN (output\*) DO composite %OPTS% sources\watermark.png output\%%~ni%%~xi output\%%~ni[WM]%%~xi
