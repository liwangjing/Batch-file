@ECHO OFF
setlocal enableextensions EnableDelayedExpansion

set currentdir=%CD%
::echo %currentdir%

:: generate test vector pat file
for %%a in ("%currentdir%\*.bench") do (atalanta-M -t %%~na.pat -W 1 %%~na.bench)
:: generate msk and rep file with pat file
for %%a in ("%currentdir%\*.pat") do (atalanta-M -S -t %%~na.pat -m msk_%%~na.txt -P %%~na.rep %%~na.bench)

:: calculate the coverage 
for %%a in ("%currentdir%\*.rep") do (
for /f "tokens=2" %%i in ('findstr /b faults: %%~na.rep') do (
for /f "tokens=2" %%j in ('findstr /b d_faults: %%~na.rep') do (
	echo %%j/%%i >> coverage_%%~na.txt
)
)
)


::if not exist "%currentdir%\output\" mkdir %currentdir%:\output
if not exist "%currentdir%\output\" md "%currentdir%\output"
:: move msk and coverage files to output
move %currentdir%\msk*.txt %currentdir%\output

move %currentdir%\coverage*.txt %currentdir%\output

:: delete all the rep files as you don't need them any more
del %currentdir%\*.rep