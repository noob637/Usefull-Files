@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: 1. Administrative Handoff
:: ==========================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Relaunching in an elevated administrator window...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd.exe -ArgumentList '/k \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

:START
cls
echo ==================================================
echo         WinRM Local TrustedHosts Configurator
echo ==================================================
echo.

:: 2. Prompt for IP
set "TARGET_IP="
set /p TARGET_IP="Enter the IP address you want to trust: "

if defined TARGET_IP set TARGET_IP=!TARGET_IP:"=!

if "%TARGET_IP%"=="" (
    echo.
    echo [ERROR] No IP address entered. Please try again.
    echo.
    pause
    goto START
)

echo.
echo --------------------------------------------------
echo Configuring Local WinRM Client Policies...
echo Target: %TARGET_IP%
echo --------------------------------------------------
echo.

:: 3. Safe WinRM Configuration Logic
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command " ^
    try { ^
        Start-Service WinRM -ErrorAction SilentlyContinue; ^
        $current = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value; ^
        ^
        if ([string]::IsNullOrEmpty($current) -or $current -eq '*') { ^
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value '%TARGET_IP%' -Force; ^
        } else { ^
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value '%TARGET_IP%' -Force -Concatenate; ^
        } ^
        ^
        Write-Host 'Successfully updated TrustedHosts.' -ForegroundColor Green; ^
        Write-Host 'Current entries:' -ForegroundColor Yellow; ^
        Get-Item WSMan:\localhost\Client\TrustedHosts | Select-Object -ExpandProperty Value; ^
    } catch { ^
        Write-Host 'An error occurred during adjustment:' $_.Exception.Message -ForegroundColor Red; ^
    }"

echo.
echo ==================================================
echo Process Finished.
echo You can now run the core management application.
echo ==================================================
echo.
pause