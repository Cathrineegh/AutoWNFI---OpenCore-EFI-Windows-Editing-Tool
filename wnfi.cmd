@echo off
set nl=^& echo.
net session >nul 2>&1 || (echo Please run this script as administrator&pause&goto :End)

:F0
CLS
echo Welcome to Windows OpenCore EFI Workbench %nl%%nl%^
1) List current drives, volumes and assign standards %nl%^
2) Assign drive letter to your EFI volume %nl%^
3) Extract files from your EFI volume %nl%^
4) Copy your EFI workspace to the EFI folder %nl%^
5) Remove drive letter from EFI drive %nl%
CHOICE /C 12345 /M "Enter your choice:"
IF ERRORLEVEL 5 GOTO F5
IF ERRORLEVEL 4 GOTO F4
IF ERRORLEVEL 3 GOTO F3
IF ERRORLEVEL 2 GOTO F2
IF ERRORLEVEL 1 GOTO F1

:F1
SET cd=%cd%
ECHO LIST DISK > C:\wnfiscript
ECHO The operation is in progress, please do not exit the script
DISKPART /S C:\wnfiscript > C:\wnfiout
CLS
TYPE C:\wnfiout | findstr /v DiskPart | findstr /v Copyright | findstr /v computer:
DEL C:\wnfiscript & DEL C:\wnfiout
ECHO.
SET /p DRV=Please insert the number corresponding to your MacOS installation disk:
:F1P2
(ECHO SELECT DISK %DRV:~0,1% & ECHO LIST VOLUME) > C:\wnfiscript
ECHO The operation is in progress, please do not exit the script
DISKPART /S C:\wnfiscript > C:\wnfiout
CLS
TYPE C:\wnfiout | findstr /v DiskPart | findstr /v Copyright | findstr /v computer:
DEL C:\wnfiscript & DEL C:\wnfiout
ECHO.
SET /p VOL=Please insert the number corresponding to your EFI volume:
CLS
ECHO You have selected%nl%Drive: %DRV:~0,1%, and%nl%Volume: %VOL:~0,1%%nl%
choice /C:YN /M:"Do you wish to save this configuration for later automated use?"
IF ERRORLEVEL ==2 GOTO F0
mkdir C:\AutoWNFI
mkdir C:\AutoWNFI\data
ECHO %DRV:~0,1% > C:\AutoWNFI\data\drv.txt
ECHO %VOL:~0,1% > C:\AutoWNFI\data\vol.txt
CLS
ECHO The configuration has been saved to C:\AutoWNFI\data, press the return key to return to the main screen
pause
GOTO F0
:F2
CLS
IF NOT EXIST "C:\AutoWNFI\data\drv.txt" (
GOTO F2P2
)
:F2P1
set /p DRV=<C:\AutoWNFI\data\drv.txt
set /p VOL=<C:\AutoWNFI\data\vol.txt
ECHO You have previously selected%nl%%nl%Drive: %DRV:~0,1%, and%nl%%nl%Volume: %VOL:~0,1%%nl%
choice /C:YN /M:"Do you wish to use this configuration?"
IF ERRORLEVEL ==2 GOTO F2P2
IF ERRORLEVEL ==1 GOTO F2P3
:F2P2
CLS
ECHO You do not have any disk or drive defined, to define using a simple tool choose option one from the main screen.%nl%%nl% 
choice /C:YN /M:"Would you instead like to define the disk and volume manually instead?"
IF ERRORLEVEL ==2 GOTO F0
CLS
SET /p DRV=Please insert the number corresponding to your MacOS installation disk: 
SET /p VOL=Please insert the number corresponding to your EFI volume: 
CLS
ECHO You have selected%nl%Drive: %DRV:~0,1%, and%nl%Volume: %VOL:~0,1%%nl%%nl%
choice /C:YN /M:"Is this correct?"
IF ERRORLEVEL ==2 GOTO F2P2
:F2P3
CLS
SET /p LTR=Please enter an UNUSED drive letter to use with the EFI volume (A-Z): 
CLS
ECHO You have selected to use the drive letter %LTR:~0,1%, please ensure that this letter is not in use%nl%%nl%
choice /C:YN /M:"Do you wish to proceed?"
IF ERRORLEVEL ==2 GOTO F2P3
CLS
ECHO The operation is in progress, please do not exit the script
(ECHO SELECT DISK %DRV:~0,1% & ECHO SELECT VOLUME %VOL:~0,1% & ECHO assign letter=%LTR:~0,1%) > C:\wnfiscript
ECHO The operation is in progress, please do not exit the script
DISKPART /S C:\wnfiscript
DEL C:\wnfiscript
CLS
choice /C:YN /M:"The operation has finished. Would you like to save the correlation to Drive %LTR:~0,1% for later automated use?"
IF ERRORLEVEL ==2 GOTO F0
mkdir C:\AutoWNFI
mkdir C:\AutoWNFI\data
ECHO %LTR:~0,1% > C:\AutoWNFI\data\ltr.txt
CLS
ECHO The configuration has been saved. Press enter to return to the main screen
pause
GOTO F0
:F3
CLS
IF NOT EXIST "C:\AutoWNFI\data\ltr.txt" (
GOTO F3P1
)
set /p LTR=<C:\AutoWNFI\data\ltr.txt
choice /C:YN /M:"Drive with letter %LTR:~0,1%% is saved in your configuration as the EFI drive, would you like to use this drive?"
IF ERRORLEVEL ==2 GOTO F3P1
IF ERRORLEVEL ==1 GOTO F3P3
:F3P1
CLS
choice /C:YN /M:"You do not have any drive letter association saved, would you like to enter it manually instead?"
IF ERRORLEVEL ==2 GOTO F0
:F3P2
CLS
SET /p LTR=Please insert drive letter associated with the OpenCore EFI drive: 
CLS
choice /C:YN /M:"You have selected drive %LTR:~0,1%% as the EFI drive, is this correct?"
IF ERRORLEVEL ==2 GOTO F3P2
CLS
choice /C:YN /M:"Would you like to save this configuration for later automated use?"
IF ERRORLEVEL ==2 GOTO F3P3
CLS
ECHO %LTR:~0,1% > C:\AutoWNFI\data\ltr.txt
ECHO The configuration has been saved. Please press the return key to continue
pause
:F3P3
CLS
mkdir C:\AutoWNFI
RMDIR /Q/S C:\AutoWNFI\Workspace
mkdir C:\AutoWNFI\Workspace
CLS
ECHO The operation is in progress, please do not exit the script
Xcopy "%LTR:~0,1%%:\EFI" "C:\AutoWNFI\Workspace" /E/H/C/I
cls
ECHO The files have been copied to the %LTR:~0,1%%:\EFI folder
pause
GOTO F0
:F4
CLS
IF NOT EXIST "C:\AutoWNFI\data\ltr.txt" (
GOTO F4P1
)
set /p LTR=<C:\AutoWNFI\data\ltr.txt
choice /C:YN /M:"Drive with letter %LTR:~0,1%% is saved in your configuration as the EFI drive, would you like to use this drive?"
IF ERRORLEVEL ==2 GOTO F4P1
IF ERRORLEVEL ==1 GOTO F4P3
:F4P1
CLS
choice /C:YN /M:"You do not have any drive letter association saved, would you like to enter it manually instead?"
IF ERRORLEVEL ==2 GOTO F0
:F4P2
CLS
SET /p LTR=Please insert drive letter associated with the OpenCore EFI drive: 
CLS
choice /C:YN /M:"You have selected drive %LTR:~0,1%% as the EFI drive, is this correct?"
IF ERRORLEVEL ==2 GOTO F4P2
CLS
choice /C:YN /M:"Would you like to save this configuration for later automated use?"
IF ERRORLEVEL ==2 GOTO F4P3
CLS
ECHO %LTR:~0,1% > C:\AutoWNFI\data\ltr.txt
ECHO The configuration has been saved. Please press the return key to continue
pause
:F4P3
CLS
IF NOT EXIST "C:\AutoWNFI\Workspace" (
ECHO Your workplace folder does not exist. Exiting to main screen
pause
GOTO F0
)
ECHO Make sure you have an original backup of the MacOS EFI folder before you proceed as this action will completely overwrite it's contents.%nl%
choice /C:YN /M:"Are you sure you want to continue?"
IF ERRORLEVEL ==2 GOTO F0
CLS
ECHO The operation is in progress, please do not exit the script
RMDIR /Q/S %LTR:~0,1%%:\EFI
MKDIR %LTR:~0,1%%:\EFI
Xcopy "C:\AutoWNFI\Workspace" "%LTR:~0,1%%:\EFI" /E/H/C/I
cls
ECHO The files have been copied to the C:\AutoWNFI\Workspace folder. Use this tool again to export the workspace folder to the EFI drive
pause
GOTO F0
:F5
CLS
IF NOT EXIST "C:\AutoWNFI\data\drv.txt" (
GOTO F5P2
)
:F5P1
set /p DRV=<C:\AutoWNFI\data\drv.txt
set /p VOL=<C:\AutoWNFI\data\vol.txt
ECHO You have previously selected%nl%%nl%Drive: %DRV:~0,1%, and%nl%%nl%Volume: %VOL:~0,1%%nl%
choice /C:YN /M:"Do you wish to use this configuration?"
IF ERRORLEVEL ==2 GOTO F5P2
IF ERRORLEVEL ==1 GOTO F5P3
:F5P2
CLS
ECHO You do not have any disk or drive defined, to define using a simple tool choose option one from the main screen.%nl%%nl% 
choice /C:YN /M:"Would you instead like to define the disk and volume manually instead?"
IF ERRORLEVEL ==2 GOTO F0
CLS
SET /p DRV=Please insert the number corresponding to your MacOS installation disk: 
SET /p VOL=Please insert the number corresponding to your EFI volume: 
CLS
ECHO You have selected%nl%Drive: %DRV:~0,1%, and%nl%Volume: %VOL:~0,1%%nl%%nl%
choice /C:YN /M:"Is this correct?"
IF ERRORLEVEL ==2 GOTO F5P2
:F5P3
CLS
SET /p LTR=Please enter the drive letter association you wish to remove (A-Z): 
CLS
ECHO You have selected to remove the drive letter association %LTR:~0,1%
choice /C:YN /M:"Do you wish to proceed?"
IF ERRORLEVEL ==2 GOTO F5P3
CLS
ECHO The operation is in progress, please do not exit the script
(ECHO SELECT DISK %DRV:~0,1% & ECHO SELECT VOLUME %VOL:~0,1% & ECHO remove letter=%LTR:~0,1%) > C:\wnfiscript
DISKPART /S C:\wnfiscript
DEL C:\wnfiscript
CLS
choice /C:YN /M:"The operation has finished. Would you like to remove another drive letter association?"
IF ERRORLEVEL ==2 GOTO F0
IF ERRORLEVEL ==1 GOTO F5P3