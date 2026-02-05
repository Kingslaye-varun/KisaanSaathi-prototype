@echo off
echo ========================================
echo Starting KisaanSaathi Flask Server
echo ========================================
echo.

echo Checking Python installation...
python --version
if errorlevel 1 (
    echo ERROR: Python not found!
    pause
    exit /b 1
)

echo.
echo Starting server...
echo.
echo Server will be available at:
echo   - Local: http://localhost:5000
echo   - Android Emulator: http://10.0.2.2:5000
echo.
echo Press Ctrl+C to stop the server
echo.

python flask-model-server/app.py

pause
