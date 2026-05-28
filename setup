@echo off
echo ===================================
echo Enabling WinRM / PS Remoting Setup
echo ===================================

:: Run PowerShell commands as admin
powershell -Command "Enable-PSRemoting -Force"

echo.
echo Setting firewall rule for WinRM...
powershell -Command "Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -Enabled True"

echo.
echo Setting network profile to Private...
powershell -Command "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private"

echo.
echo Starting WinRM service...
powershell -Command "Set-Service WinRM -StartupType Automatic"
powershell -Command "Start-Service WinRM"

echo.
echo ===================================
echo DONE - WinRM should now work
echo ===================================
pause
