# Google Gemini Setup Tool
### For Xiaomi China ROM / HyperOS Devices

![Banner](screenshots/menu.png)

A lightweight ADB batch tool that enables **Google Gemini Assistant** on Xiaomi devices running **China ROM / HyperOS**.

This tool automates the ADB commands required to enable Google Gemini on Xiaomi China ROM devices, providing a simple interactive menu for activation, restoration, and status checking.

---

## Features

✔ Enable Google Gemini via Long Press Power Button

✔ Grant required microphone permission automatically

✔ Disable Xiaomi Voice Assistant

✔ Restore Xiaomi Voice Assistant anytime

✔ Check current Assistant status

✔ Detect unauthorized devices

✔ Detect missing devices

---

## Requirements

### Device Requirements
- Xiaomi / Redmi / POCO device
- HyperOS / MIUI China ROM
- Google App installed
- USB Debugging enabled

### PC Requirements
- **Windows**: Windows 10 / 11.
- **Linux / macOS**: Bash shell environment.
- ADB Tools (The Bash script will safely attempt to auto-install this for you if missing).

Verify ADB installation:

```cmd
adb version
```

---

## Enable USB Debugging

1. Open **Settings** ➔ **About Phone**.
2. Tap **OS Version** (or **MIUI Version**) 7 times to unlock Developer Options.
3. Go back to **Settings** ➔ **Additional Settings** ➔ **Developer Options**.
4. Enable the following toggles:
   - **USB Debugging**
   - **USB Debugging (Security Settings)** *(Crucial for granting permissions via ADB)*
5. Connect your device to the PC and allow the **RSA fingerprint authorization prompt** on your phone screen.

---

## Usage

### On Windows
Run the interactive batch script:
```cmd
Activation_google_gemini_assistant.bat
```

### On Linux/MacOS
Grant executable permission and run the bash script:
```Bash
chmod +x Activation_google_gemini_assistant.sh
./Activation_google_gemini_assistant.sh
```

You will see:

```text
[1] Enable Google Gemini (Long Press Power Button)
[2] Restore Xiaomi Voice Assistant
[3] Check Assistant Status
[0] Exit
```

---

## Option 1
### Enable Google Gemini

This option will:

1. Verify device connection
2. Grant microphone permission:

```cmd
adb shell pm grant com.google.android.googlequicksearchbox android.permission.RECORD_AUDIO
```

3. Configure Power Button Assistant:

```cmd
adb shell settings put global power_button_long_press 5
```

4. Verify configuration

5. Disable Xiaomi Voice Assistant:

```cmd
adb shell pm uninstall -k --user 0 com.miui.voiceassist
```

After completion:

```text
[ACTIVATED]
```

---

## Option 2
### Restore Xiaomi Voice Assistant

Restores the original Xiaomi Assistant:

```cmd
adb shell cmd package install-existing com.miui.voiceassist
```

---

## Option 3
### Check Assistant Status

Checks:

```cmd
adb shell settings get global power_button_long_press
```

Results:

```text
[ACTIVE]
Google Gemini is enabled.
```

or

```text
[INACTIVE]
Google Gemini is not enabled.
```

---

## What Does This Tool Change?

### Enable Gemini

```cmd
adb shell settings put global power_button_long_press 5
```

Meaning:

```text
Long Press Power Button
        ↓
Launch Google Gemini
```

### Disable Xiaomi Assistant

```cmd
adb shell pm uninstall -k --user 0 com.miui.voiceassist
```

This removes Xiaomi Voice Assistant only for the current user.

System files remain untouched.

---

## Safety & Reversibility

This utility is completely safe:
- Does NOT require an unlocked bootloader.
- Does NOT require root access (su).
- Does NOT alter system partition tables (read-only files stay safe).
- Does NOT format user data.
Everything altered can be perfectly reverted back to factory stock by choosing option [2] Restore Xiaomi AI (Xiao AI) within the script interface.

All changes can be reverted using:

```text
[2] Restore Xiaomi Voice Assistant
```

---

## Tested On

- Xiaomi HyperOS 1
- Xiaomi HyperOS 2
- Xiaomi HyperOS 3
- Xiaomi HyperOS 3.1
- Android 15
- Android 16

Additional versions may also work but have not been fully tested.

---

## Troubleshooting

### Device Unauthorized

Unlock your phone and accept the USB debugging authorization prompt.

---

### No Device Detected

Check:

- USB cable
- USB Debugging
- ADB installation

Verify:

```cmd
adb devices
```

---

### Google App Not Installed

Install Google App first:

Package:

```text
com.google.android.googlequicksearchbox
```

---

## Known Limitation

On some HyperOS versions, Google Gemini activation may be reset after a device reboot.

If this happens, simply run:

```text
[1] Enable Google Gemini (Long Press Power Button)
```

again.

This behavior is controlled by HyperOS and cannot be permanently overridden without root access.

---

## Disclaimer

This tool is not affiliated with Xiaomi or Google.

Use at your own risk. Always review the included ADB commands before running the tool.

---

## Screenshots

### Main Menu

![Main Menu](screenshots/menu.png)

### Activation Process

![Activation](screenshots/setup.png)

### Restore Process

![Restore](screenshots/restore.png)

### Status Check

![Status](screenshots/status.png)

---

## Download

Download latest version here:
[Releases](https://github.com/PhaPhePha/Google-Gemini-Setup-Tool/releases)

---

## Author


**PhaPhePha** - Original Windows Batch Script & Core Logic - [GitHub](https://github.com/PhaPhePha).

**Vanphat111** - POSIX Bash Refactoring, Package Manager Auto-Installer - [GitHub](https://github.com/vanphat111).

---

## License

This project is licensed under the MIT License.
See the LICENSE file for details.
