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
echo    %ESC%[92mActive%ESC%[0m %ESC%[94m____ _____ __  __ ___ _   _ ___
echo          / ___^| ____^|  \/  ^|_ _^| \ ^| ^|_ _^|
echo         ^| ^|  _^|  _^| ^| ^|\/^| ^|^| ^|^|  \^| ^|^| ^|
echo         ^| ^|_^| ^| ^|___^| ^|  ^| ^|^| ^|^| ^|\  ^|^| ^|
echo          \____^|_____^|_^|  ^|_^|___^|_^| \_^|___^|%ESC%[0m v1.2.0
echo.
echo %ESC%[96m##################################################%ESC%[0m

echo %ESC%[96m#%ESC%[0m            %ESC%[94mG%ESC%[0m%ESC%[91mo%ESC%[0m%ESC%[93mo%ESC%[0m%ESC%[94mg%ESC%[0m%ESC%[92ml%ESC%[0m%ESC%[91me%ESC%[0m %ESC%[94mGemini%ESC%[0m %ESC%[93mSetup Tool%ESC%[0m            %ESC%[96m#%ESC%[0m

echo %ESC%[96m#%ESC%[0m         %ESC%[93mfor Xiaomi China ROM Devices%ESC%[0m           %ESC%[96m#%ESC%[0m

echo %ESC%[96m#%ESC%[0m                 %ESC%[93mby PhaPhePha%ESC%[0m                   %ESC%[96m#%ESC%[0m

echo %ESC%[96m##################################################%ESC%[0m
echo.
echo [1] Setup Google Gemini Assistant (via Power Button)
echo [2] Restore Xiaomi Voice Assistant
echo [3] Check Assistant Status
echo [4] About
echo [0] Exit
echo.

choice /c 12340 /n /m "Select an option: "

if errorlevel 5 exit
if errorlevel 4 goto ABOUT
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



echo %ESC%[96m[1/6]%ESC%[0m Device Check
adb devices

adb devices | findstr "unauthorized" >nul
if not errorlevel 1 (
echo.
echo  %ESC%[91m[ERROR] %ESC%[0mDevice unauthorized!
echo.
echo Please unlock your phone and allow USB debugging.
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU
)

adb devices | findstr /R /C:".*device$" >nul
if errorlevel 1 (
echo.
echo %ESC%[91m[ERROR]%ESC%[0m No device detected!
echo.
echo Please:
echo - Connect your phone via USB
echo - Enable USB Debugging
echo - Allow the RSA fingerprint prompt
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU
)

echo.
echo %ESC%[92mDEVICE DETECTED SUCCESSFULLY!%ESC%[0m





echo.
echo.
echo %ESC%[96m[2/6]%ESC%[0m Google App Check

adb shell pm list packages | findstr "com.google.android.googlequicksearchbox" >nul

if errorlevel 1 (
    echo %ESC%[91m[ERROR]%ESC%[0m Google App not installed!
    echo.
    echo Please install Google App first.
    echo Package: com.google.android.googlequicksearchbox
    echo.
    echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
    pause
    goto MENU
)
echo %ESC%[92mGOOGLE APP DETECTED!%ESC%[0m







echo.
echo.
echo %ESC%[96m[3/6]%ESC%[0m Permission Setup
adb shell pm grant com.google.android.googlequicksearchbox android.permission.RECORD_AUDIO > temp.txt 2>&1

findstr /C:"SecurityException" temp.txt >nul
if not errorlevel 1 (
    echo.
    echo %ESC%[93m[WARNING]%ESC%[0m Unable to grant microphone permission automatically.
    echo *Gemini may request microphone permission on first launch*
    del temp.txt
    echo.
    goto STEP4
)

findstr /C:"Unknown package" temp.txt >nul
if not errorlevel 1 (
    echo %ESC%[91m[ERROR]%ESC%[0m Google App not found!
    del temp.txt
    echo.
    echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
    pause
    goto MENU
)

del temp.txt

echo %ESC%[92mSUCCESS!%ESC%[0m
echo.




:STEP4
echo.
echo %ESC%[96m[4/6]%ESC%[0m Assistant Configuration

adb shell settings put global power_button_long_press 5 > temp.txt 2>&1

findstr /C:"SecurityException" temp.txt >nul

if not errorlevel 1 (
    echo.
    echo %ESC%[91m[ERROR] Permission denied!%ESC%[0m
    echo Please enable:
    echo - USB debugging
    echo - USB debugging ^(Security settings^)
    echo - Install via USB
    echo.
    del temp.txt
    echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
    pause
    goto MENU
)

findstr /C:"Exception occurred" temp.txt >nul
if not errorlevel 1 (
    echo.
    echo %ESC%[91m[ERROR]%ESC%[0m Failed to modify system settings.
    echo.
    type temp.txt
    del temp.txt
    echo.
    echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
    pause
    goto MENU
)

del temp.txt

echo %ESC%[92mACTIVATED!%ESC%[0m
echo.



echo.
echo %ESC%[96m[5/6]%ESC%[0m Configuration Verification
set VALUE=
for /f %%i in ('adb shell settings get global power_button_long_press') do set VALUE=%%i

echo Current value: %VALUE%

if not "%VALUE%"=="5" (
    echo.
    echo %ESC%[91mVerification failed!%ESC%[0m
    echo.
    echo Current value: %VALUE%
    echo.
    echo Possible causes:
    echo - USB debugging ^(Security settings^) is disabled
    echo - Your ROM does not allow changing this setting
    echo - HyperOS reverted the value
    echo.
    echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
    pause
    goto MENU
)

echo %ESC%[92mVERIFIED!%ESC%[0m
echo.



echo.
echo %ESC%[96m[6/6]%ESC%[0m Xiaomi AI Removal

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
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU

:COMPLETE
echo.
echo %ESC%[92m============================================
echo                 [ACTIVATED]               
echo ============================================%ESC%[0m
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU






:RESTORE
cls
echo %ESC%[93m============================================%ESC%[0m
echo        %ESC%[96mRestore Xiaomi Voice Assistant%ESC%[0m
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
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU
)

adb shell cmd package install-existing com.miui.voiceassist

if errorlevel 1 (
echo.
echo %ESC%[93mRestore failed!%ESC%[0m
) else (
echo.
echo %ESC%[92mXiaomi Voice Assistant restored successfully!%ESC%[0m
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

adb devices | findstr /R /C:".*device$" >nul
if errorlevel 1 (

echo %ESC%[91m[ERROR]%ESC%[0m No device detected!
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU
)


for /f "delims=" %%i in ('adb shell getprop ro.product.model') do set MODEL=%%i
for /f "delims=" %%i in ('adb shell getprop ro.build.version.release') do set ANDROID=%%i
for /f "delims=" %%i in ('adb shell getprop ro.miui.ui.version.name') do set HYPEROS=%%i

echo %ESC%[91mDevice%ESC%[0m  : %MODEL%
echo %ESC%[92mAndroid%ESC%[0m : %ANDROID%
echo %ESC%[94mHyperOS%ESC%[0m  : %HYPEROS%
echo.


set VALUE=
for /f %%i in ('adb shell settings get global power_button_long_press') do set VALUE=%%i

echo %ESC%[93mCurrent value:%ESC%[0m %VALUE%
echo.

if "%VALUE%"=="5" (
echo %ESC%[92m[ACTIVE]%ESC%[0m Google Gemini Assistant is enabled.
) else (
echo %ESC%[91m[INACTIVE]%ESC%[0m Google Gemini Assistant is disabled.
)

echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU




:ABOUT
cls
echo %ESC%[93m============================================%ESC%[0m
echo                    %ESC%[96mAbout%ESC%[0m
echo %ESC%[93m============================================%ESC%[0m
echo.
echo %ESC%[96mGGeS Tool%ESC%[0m - %ESC%[94mG%ESC%[0m%ESC%[91mo%ESC%[0m%ESC%[93mo%ESC%[0m%ESC%[94mg%ESC%[0m%ESC%[92ml%ESC%[0m%ESC%[91me%ESC%[0m %ESC%[94mGemini%ESC%[0m %ESC%[93mSetup Tool%ESC%[0m 
echo Version : %ESC%[93m1.2.0%ESC%[0m
echo Author  : %ESC%[93mPhaPhePha%ESC%[0m
echo.
echo %ESC%[92mGitHub:%ESC%[0m
echo https://github.com/PhaPhePha/Google-Gemini-Setup-Tool
echo.
echo %ESC%[93mDesigned for Xiaomi China ROM / HyperOS devices.%ESC%[0m
echo.
echo %ESC%[93mPress any key to return to the menu.%ESC%[0m
pause
goto MENU
