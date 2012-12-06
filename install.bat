@echo off

echo You are about to install ALL of the AutoHotKey scripts.
echo NOTE: This will overwrite any versions of the scripts you already have installed.

set /p TARGET=Enter your install directory? [%BIN%]: 

copy /Y .\*.ahk %TARGET%A

echo.
echo Done.
