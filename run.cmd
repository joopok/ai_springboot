@echo off
setlocal

:menu
cls
echo ===================================
echo PM7 Spring Boot Application Manager
echo ===================================
echo.
echo 1. Start Application
echo 2. Stop Application
echo 3. Exit
echo.
set /p choice="Select an option (1-3): "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto stop
if "%choice%"=="3" goto end
goto menu

:start
echo.
echo Starting PM7 Application...
start /B .\mvnw spring-boot:run
echo Application is starting... Please wait.
timeout /t 5 /nobreak > nul
echo.
echo Application should be running on http://localhost:8081
pause
goto menu

:stop
echo.
echo Stopping PM7 Application...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8081" ^| find "LISTENING"') do taskkill /F /PID %%a
echo Application has been stopped.
pause
goto menu

:end
echo.
echo Exiting...
exit /b 0 