:: This script installs Chocolatey and a list of programs 
@echo off
cls

set $choco_install=Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

set $program_install=choco install
set $upgrade_install=choco upgrade all
set $programs= brave sublimetext3 discord ffmpeg intel-dsa rufus crystaldiskinfo.portable 7zip googlechrome windirstat greenshot firefox vlc cutepdf notepadplusplus foxitreader gimp autoruns paint.net hwinfo screentogif cyberduck cpu-z.install gpu-z hwmonitor steam unifying speccy mpv shortcut lGHub dropbox k-litecodecpackfull kitty spotify ChocolateyGUI

:choice
set /P c=Install Chocolatey or Install/Upgrade packages [[92mY[0m/[91mN[0m]? 
if /I "%c%" EQU "Y" goto :install
if /I "%c%" EQU "N" goto :exit

echo [91mError[0m Invalid choice
goto :choice

:install

:: Checks if choco is a recognized command
WHERE choco >nul
if %ERRORLEVEL% neq 0 echo choco not installed yet & goto :install_choco
echo [92mchoco already installed[0m & goto :install_upgrade_programs

:: Installs choco
:install_choco
echo.
echo [92mInstalling Chocolatey...[0m

for /f "delims=" %%a in ('powershell -command Get-ExecutionPolicy') do set "$policy_value=%%a"

echo Get-ExecutionPolicy : %$policy_value%

if %$policy_value%==Restricted start powershell -Command "&{ Start-Process powershell -ArgumentList '-command Set-ExecutionPolicy AllSigned' -Verb RunAs}"

:: Resolves a problem of '' inside ''
set $choco_install=%$choco_install:'=''%
powershell -Command "&{ Start-Process powershell -ArgumentList '-command %$choco_install%' -Verb RunAs}"
goto :install_upgrade_programs

:: Installs or Upgrades programs from choco
:install_upgrade_programs
echo.

:programs_operation_choice
choice /c IU /n /t 10 /d I /m "[I]nstall or [U]pgrade packages [I/U]? "
if errorlevel 2 goto :upgrade_programs
if errorlevel 1 goto :install_programs

:install_programs

echo.
echo Predefined packages : %$programs%
echo.

:choice_progrs
echo You have 10 seconds to answer. Default is No.
choice /c YN /n /t 10 /d N /m "Do you want to install other programs [Y/N]? "
if errorlevel 2 goto :keep_programs
if errorlevel 1 goto :add_programs

:: Allows the user to install a custom list of programs
:add_programs
echo.
echo [92mCustom package list[0m
echo Insert the list of packages you want to install.
echo [91mWarning[0m you have to manually add the default packages if you want any of them
echo [92mFind more here[0m https://community.chocolatey.org/packages
echo.
set /p $programs=Enter list of packages (separate with space):
goto :install_programs_install

:: Constinues the instalation with the default programs
:keep_programs
echo.
echo No other programs will be installed
goto :install_programs_install

:: Installs the programs selected
:install_programs_install
echo.
echo [92mInstalling Packages...[0m
powershell -Command "&{ Start-Process powershell -ArgumentList '-command %$program_install% %$programs% -y' -Verb RunAs}"
goto :exit

:: Upgrades all programs
:upgrade_programs
echo.
echo [92mUpgrading All Packages...[0m
powershell -Command "&{ Start-Process powershell -ArgumentList '-command %$upgrade_install% -y' -Verb RunAs}"
goto :exit

:: Stops execution of the script
:exit
echo.
echo [91mExiting...[0m
goto :eof

:: Extras
:: color pallette : https://gist.githubusercontent.com/mlocati/fdabcaeb8071d5c75a2d51712db24011/raw/b710612d6320df7e146508094e84b92b34c77d48/win10colors.cmd
:: chocolatey : https://community.chocolatey.org/
:: Source - source: https://gist.github.com/bentodaniel/46b92d8d0d9fc67edb175e67a85d4da0