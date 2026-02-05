@echo off
echo ========================================
echo Restarting KisaanSaathi Flask Server
echo ========================================
echo.

echo Stopping any existing Flask servers on port 5000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5000') do (
    echo Killing process %%a
    taskkill /F /PID %%a 2>nul
)

echo.
echo Waiting 2 seconds...
timeout /t 2 /nobreak >nul

echo.
echo Starting server...
echo.
python flask-model-server/app.py

pause
