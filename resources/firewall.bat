@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "FOLDER_PATH=%SCRIPT_DIR%.."
set "RULE_GROUP=OSPanel Applications"
set /a idx=0

netsh advfirewall firewall delete rule group="%RULE_GROUP%" >nul 2>&1

for /R "%FOLDER_PATH%" %%F in (*.exe) do (
    set /a idx+=1
    set "num=000!idx!"
    set "num=!num:~-3!"

    set "rname_in=FWRule-!num! (IN)"
    set "rname_out=FWRule-!num! (OUT)"

    netsh advfirewall firewall add rule name="!rname_in!" dir=in action=allow program="%%~fF" enable=yes profile=any grouping="%RULE_GROUP%" >nul 2>&1
    netsh advfirewall firewall add rule name="!rname_out!" dir=out action=allow program="%%~fF" enable=yes profile=any grouping="%RULE_GROUP%" >nul 2>&1

)

endlocal
