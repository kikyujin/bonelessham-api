@echo off
chcp 65001 >nul
echo ========================================
echo HAMLOG HTTP API Server Setup
echo ========================================
echo.

REM Python確認
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found
    echo Please install Python 3.8+ from https://www.python.org/
    pause
    exit /b 1
)

echo [OK] Python found

REM Flask確認・インストール
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installing Flask...
    pip install flask
    if errorlevel 1 (
        echo [ERROR] Failed to install Flask
        pause
        exit /b 1
    )
)

echo [OK] Flask installed

REM AutoHotkey確認
if not exist "C:\Program Files\AutoHotkey\AutoHotkey.exe" (
    echo [WARNING] AutoHotkey not found at default location
    echo Please install from https://www.autohotkey.com/
    echo Or update the path in hamlog_api_server.py
    pause
)

echo [OK] AutoHotkey found

REM 設定確認
echo.
echo ========================================
echo Configuration Check
echo ========================================
echo.
echo Please verify the following paths in hamlog_api_server.py:
echo   - AHK_SCRIPT: Path to hamlog_api.ahk
echo   - AUTOHOTKEY: Path to AutoHotkey.exe
echo.
echo Current directory: %CD%
echo.

REM サーバー起動確認
echo ========================================
echo Ready to Start Server
echo ========================================
echo.
set /p START="Start server now? (y/n): "

if /i "%START%"=="y" (
    echo.
    echo Starting server at http://127.0.0.1:86109
    echo Press Ctrl+C to stop
    echo.
    python hamlog_api_server.py
) else (
    echo.
    echo To start manually:
    echo   python hamlog_api_server.py
    echo.
    pause
)
