@echo off
REM ============================================================================
REM MAHLE ANAND GROWTH PASSPORT - WINDOWS SERVER AUTO-START ON REBOOT
REM Run this script as Administrator
REM ============================================================================

echo [1/4] Installing pm2-windows-startup package globally...
call npm install -g pm2-windows-startup

echo [2/4] Registering Windows auto-startup service...
call pm2-startup install

echo [3/4] Starting application with PM2...
call pm2 start ecosystem.config.js

echo [4/4] Saving current PM2 process list to persist across reboots...
call pm2 save

echo ============================================================================
echo DONE! The application is now configured to:
echo  1. Automatically restart on crash/failure (via ecosystem.config.js)
echo  2. Automatically start when Windows Server boots up (even before user logs in)
echo ============================================================================
pause
