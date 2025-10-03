@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    exit /b 1
)

set "FOLDER_PATH=%~1"

if not exist "%FOLDER_PATH%" (
    exit /b 1
)

for /f "tokens=*" %%R in ('netsh advfirewall firewall show rule name^=all ^| findstr /I "OSPanel-"') do (
    for /f "tokens=1,* delims=:" %%A in ("%%R") do (
        netsh advfirewall firewall delete rule name="%%A"
    )
)

set /a idx=0
for /R "%FOLDER_PATH%" %%F in (*.exe) do (
    set /a idx+=1
    set "num=000!idx!"
    set "num=!num:~-3!"

    set "rname_in=OSPanel-!num!-IN"
    set "rname_out=OSPanel-!num!-OUT"

    netsh advfirewall firewall add rule name="!rname_in!" dir=in  action=allow program="%%~fF" enable=yes profile=any
    netsh advfirewall firewall add rule name="!rname_out!" dir=out action=allow program="%%~fF" enable=yes profile=any
)

endlocal