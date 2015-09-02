@echo off
@set gs=gswin64c
@REM %gs% -sDEVICE=jpeg -o page3.jpeg -dFirstPage=3 -dLastPage=3 -dJPEGQ=30 -r150x150 sources\F0016398.pdf
%gs% -q -dQUIET -dBATCH -dNOPOMPT -sDEVICE=pngalpha -o page3.png -dFirstPage=3 -dLastPage=3 -r120 sources\F0016398.pdf


