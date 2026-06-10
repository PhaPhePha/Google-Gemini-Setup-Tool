@echo off
chcp 65001 >nul
title Google Gemini Setup
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

where adb >nul 2>&1
if errorlevel 1 (
    echo.
    echo %ESC%[91m[ERROR]%ESC%[0m ADB not found!
    echo.
    echo Please place adb.exe in this folder
    echo or add ADB to PATH.
    echo.
    pause
    exit
)



:MENU
cls
echo           %ESC%[94m____ _____ __  __ ___ _   _ ___
echo          / ___^| ____^|  \/  ^|_ _^| \ ^| ^|_ _^|
echo         ^| ^|  _^|  _^| ^| ^|\/^| ^|^| ^|^|  \^| ^|^| ^|
echo         ^| ^|_^| ^| ^|___^| ^|  ^| ^|^| ^|^| ^|\  ^|^| ^|
echo          \____^|_____^|_^|  ^|_^|___^|_^| \_^|___^|%ESC%[0m
echo.
echo %ESC%[96m##################################################%ESC%[0m
echo %ESC%[96m#%ESC%[0m            %ESC%[94mG%ESC%[0m%ESC%[91mo%ESC%[0m%ESC%[93mo%ESC%[0m%ESC%[94mg%ESC%[0m%ESC%[92ml%ESC%[0m%ESC%[91me%ESC%[0m %ESC%[94mGemini%ESC%[0m Setup Tool%ESC%[0m            %ESC%[96m#%ESC%[0m
echo %ESC%[96m#%ESC%[0m                 %ESC%[93mby PhaPhePha%ESC%[0m                   %ESC%[96m#%ESC%[0m
echo %ESC%[96m##################################################%ESC%[0m
echo.
echo [1] Setup Google Assistant
echo [2] Restore Xiaomi AI
echo [3] Check Assistant Status
echo [0] Exit
echo.

choice /c 1230 /n /m "Select an option: "

if errorlevel 4 exit
if errorlevel 3 goto CHECK
if errorlevel 2 goto RESTORE
if errorlevel 1 goto SETUP

echo.
echo Invalid option!
pause
goto MENU





:SETUP
cls
echo %ESC%[93m============================================%ESC%[0m
echo        %ESC%[96mSetup Google Gemini Assistant%ESC%[0m
echo %ESC%[93m============================================%ESC%[0m
echo.

echo [1/5] Checking device...
adb devices

adb devices | findstr "unauthorized" >nul
if not errorlevel 1 (
echo.
echo  %ESC%[91m[ERROR] %ESC%[93mDevice unauthorized!%ESC%[0m
echo.
echo Please unlock your phone and allow USB debugging.
echo.
pause
goto MENU
)

adb devices | findstr /R /C:".*device$" >nul
if errorlevel 1 (
echo.
echo %ESC%[91m[ERROR] No device detected!%ESC%[0m
echo.
echo Please:
echo - Connect your phone via USB
echo - Enable USB Debugging
echo - Allow the RSA fingerprint prompt
echo.
pause
goto MENU
)

echo.
echo %ESC%[92mDevice detected successfully.%ESC%[0m

adb shell pm list packages | findstr "com.google.android.googlequicksearchbox" >nul

if errorlevel 1 (
    echo.
    echo %ESC%[91m[ERROR]%ESC%[0m Google App not installed!
    echo.
    pause
    goto MENU
)

echo.
echo [2/5] Granting microphone permission...
adb shell pm grant com.google.android.googlequicksearchbox android.permission.RECORD_AUDIO

if errorlevel 1 (
echo FAILED!
pause
goto MENU
)

echo %ESC%[92mSUCCESS!%ESC%[0m
echo.

echo [3/5] Setting Assistant on Power button...
adb shell settings put global power_button_long_press 5

if errorlevel 1 (
echo FAILED!
pause
goto MENU
)

echo %ESC%[92mACTIVATED!%ESC%[0m
echo.

echo [4/5] Verifying setting...
set VALUE=
for /f %%i in ('adb shell settings get global power_button_long_press') do set VALUE=%%i

echo Current value: %VALUE%

if not "%VALUE%"=="5" (
echo Verification failed!
pause
goto MENU
)

echo %ESC%[92mVERIFIED!%ESC%[0m
echo.




echo [5/5] Removing Xiaomi Voice Assistant...

adb shell pm uninstall -k --user 0 com.miui.voiceassist > temp.txt 2>&1

findstr /C:"Success" temp.txt >nul
if not errorlevel 1 (
echo %ESC%[92mUNINSTALLED!%ESC%[0m
del temp.txt
goto COMPLETE
)

findstr /C:"not installed for 0" temp.txt >nul
if not errorlevel 1 (
echo %ESC%[96mXiaomi Voice Assistant is already removed.%ESC%[0m
del temp.txt
goto COMPLETE
)

echo %ESC%[91mFAILED!%ESC%[0m
type temp.txt
del temp.txt
pause
goto MENU

:COMPLETE
echo.
echo ============================================
echo                  %ESC%[92m[ACTIVATED]%ESC%[0m               
echo ============================================
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU






:RESTORE
cls
echo %ESC%[93m============================================%ESC%[0m
echo              %ESC%[96mRestore Xiaomi AI%ESC%[0m
echo %ESC%[93m============================================%ESC%[0m
echo.

echo Checking device...
echo.
adb devices

adb devices | findstr /R /C:".*device$" >nul
if errorlevel 1 (
echo.
echo %ESC%[91m[ERROR]%ESC%[0m No device detected!
echo.
pause
goto MENU
)

adb shell cmd package install-existing com.miui.voiceassist

if errorlevel 1 (
echo.
echo %ESC%[93mRestore failed!%ESC%[0m
) else (
echo.
echo %ESC%[92mXiaomi AI restored successfully!%ESC%[0m
)

echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU





:CHECK
cls
echo %ESC%[93m============================================%ESC%[0m
echo            %ESC%[96mAssistant Status Check%ESC%[0m
echo %ESC%[93m============================================%ESC%[0m
echo.

echo Checking device...
echo.
adb devices

for /f "delims=" %%i in ('adb shell getprop ro.product.model') do set MODEL=%%i
for /f "delims=" %%i in ('adb shell getprop ro.build.version.release') do set ANDROID=%%i
for /f "delims=" %%i in ('adb shell getprop ro.miui.ui.version.name') do set HYPEROS=%%i

echo Device  : %MODEL%
echo Android : %ANDROID%
echo HyperOS  : %HYPEROS%
echo.

adb devices | findstr /R /C:".*device$" >nul
if errorlevel 1 (
echo.
echo %ESC%[91m[ERROR]%ESC%[0m No device detected!
echo.
pause
goto MENU
)

set VALUE=
for /f %%i in ('adb shell settings get global power_button_long_press') do set VALUE=%%i

echo Current value: %VALUE%
echo.

if "%VALUE%"=="5" (
echo %ESC%[92m[ACTIVE]%ESC%[0m Google Gemini Assistant is enabled.
) else (
echo %ESC%[91m[INACTIVE]%ESC%[0m Google Gemini Assistant is not enabled.
)

echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU
