@echo off
setlocal enabledelayedexpansion

set "RESOURCES=%~dp0resources"
if not exist "%RESOURCES%" mkdir "%RESOURCES%"

set "TMPDIR=%TEMP%\ospanel_dl_%RANDOM%"
if exist "%TMPDIR%" rd /s /q "%TMPDIR%"
mkdir "%TMPDIR%"

:: === x86 ===
echo === Checking VC_redist.x86.exe ===
if exist "%RESOURCES%\VC_redist.x86.exe" (
    curl -s -L -o "%TMPDIR%\VC_redist.x86.exe" https://aka.ms/vs/17/release/VC_redist.x86.exe

    set "OLDHASH="
    set "NEWHASH="
    for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%RESOURCES%\VC_redist.x86.exe" SHA256') do if not defined OLDHASH set "OLDHASH=%%H"
    for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%TMPDIR%\VC_redist.x86.exe" SHA256') do if not defined NEWHASH set "NEWHASH=%%H"

    echo Old: !OLDHASH!
    echo New: !NEWHASH!

    if /i "!OLDHASH!"=="!NEWHASH!" (
        echo Hashes match - keeping existing file.
        del "%TMPDIR%\VC_redist.x86.exe"
    ) else (
        echo Hashes differ - replacing file.
        move /y "%TMPDIR%\VC_redist.x86.exe" "%RESOURCES%\VC_redist.x86.exe" >nul
    )
) else (
    echo File not found - downloading...
    curl -L -o "%RESOURCES%\VC_redist.x86.exe" https://aka.ms/vs/17/release/VC_redist.x86.exe
)

:: === x64 ===
echo === Checking VC_redist.x64.exe ===
if exist "%RESOURCES%\VC_redist.x64.exe" (
    curl -s -L -o "%TMPDIR%\VC_redist.x64.exe" https://aka.ms/vs/17/release/VC_redist.x64.exe

    set "OLDHASH="
    set "NEWHASH="
    for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%RESOURCES%\VC_redist.x64.exe" SHA256') do if not defined OLDHASH set "OLDHASH=%%H"
    for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%TMPDIR%\VC_redist.x64.exe" SHA256') do if not defined NEWHASH set "NEWHASH=%%H"

    echo Old: !OLDHASH!
    echo New: !NEWHASH!

    if /i "!OLDHASH!"=="!NEWHASH!" (
        echo Hashes match - keeping existing file.
        del "%TMPDIR%\VC_redist.x64.exe"
    ) else (
        echo Hashes differ - replacing file.
        move /y "%TMPDIR%\VC_redist.x64.exe" "%RESOURCES%\VC_redist.x64.exe" >nul
    )
) else (
    echo File not found - downloading...
    curl -L -o "%RESOURCES%\VC_redist.x64.exe" https://aka.ms/vs/17/release/VC_redist.x64.exe
)

:: Cleanup
if exist "%TMPDIR%" rd /s /q "%TMPDIR%"

echo === Done! Files saved to %RESOURCES% ===
