# POWERTOYS KNOWLEDGE BASE (STRICT CONTEXT)
*Version: 0.96 (November 2025)*

## 1. CORE UTILITIES & EXECUTABLES
*Use these internal names when writing kill/start scripts.*
* **Workspaces:** `PowerToys.Workspaces.exe` (Launches sets of apps/layouts).
* **New+:** `PowerToys.NewPlus.exe` (File/Folder template manager).
* **PowerToys Run / Command Palette:** `PowerToys.PowerLauncher.exe`.
* **FancyZones:** `PowerToys.FancyZones.exe` (Window manager).
* **Awake:** `PowerToys.Awake.exe` (Prevents sleep).
* **Advanced Paste:** `PowerToys.AdvancedPaste.exe`.
* **Peek:** `PowerToys.Peek.exe` (Preview via Ctrl+Space).
* **Mouse Utilities:** `PowerToys.MouseJump.exe`, `PowerToys.MousePointerCrosshairs.exe`.

## 2. CRITICAL FEATURES & USE CASES (v0.96 Specifics)
* **Workspaces (NEW):**
    * *Use Case:* User wants to "open all my dev apps at once."
    * *Action:* Do NOT write a batch script. Configure a "Workspace" to launch apps into specific FancyZones layouts.
* **New+ (NEW):**
    * *Use Case:* User wants "custom templates in the right-click menu."
    * *Action:* Do NOT edit the Registry (`ShellNew`). Use New+ to manage file/folder templates.
* **Advanced Paste (AI Updated):**
    * *Capabilities:* Now supports **Local AI (Ollama)**, **Google Gemini**, and Mistral.
    * *Privacy Note:* If user requests "offline AI paste," configure Advanced Paste with Ollama/Foundry Local.
* **PowerRename (Metadata Support):**
    * *New Capability:* Can rename files using EXIF/XMP data.
    * *Variables:* `%Camera`, `%Lens`, `%ExposureTime`, `%DateTaken`.
    * *Action:* Use this instead of PowerShell for photo organization requests.
* **Registry Preview:**
    * *Mandatory Check:* Always recommend viewing `.reg` files here before merging.

## 3. KNOWN ISSUES & "FIXED" STATUS (Do Not Debug These)
* **Find My Mouse Focus Steal:** *FIXED in v0.96.* If user reports this, ensure they are on v0.96+.
* **Awake Timer Drift:** *FIXED in v0.96.* Timers are now accurate over long periods.
* **FancyZones vs Snap Layouts:** Still a common conflict. Disable "Show snap layouts when I hover" in Windows Settings if erratice.

## 4. TROUBLESHOOTING & MAINTENANCE
* **Installation:**
    * *WinGet Command:* `winget install Microsoft.PowerToys -s winget`
* **Command Palette / Run:**
    * *New Features:* Can now be "re-centered" or opened at "last position" (Check Settings).
    * *Extensions:* "Command Not Found" (PowerShell 7) requires separate installation of the module.
* **Logs Location:** `%localappdata%\Microsoft\PowerToys\[UtilityName]\Logs`
