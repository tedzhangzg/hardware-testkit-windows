:: run_as_administrator.cmd
:: ==================================================
:: Description
:: This script checks if it is run with admin rights.
:: If not, it shows an error message and exits.
:: If it is run with admin rights, it changes the
:: current directory to the script's directory and
:: runs a PowerShell script named script-init.ps1.
:: ==================================================
:: Usage
:: Right-click this file and select 'Run as administrator'
:: ==================================================


echo Starting run_as_administrator.cmd ...

:: echo off
@echo off

:: check if admin
:: if not, show error and exit
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo.
echo ---------- ERROR ----------
echo.
echo Run needs admin rights
echo.
echo Steps:
echo Close this window
echo Right-click this file
echo Select 'Run as administrator'
echo.
echo Press any key to exit...
pause >nul
exit
)

:: change pwd to script dir
cd /D "%~dp0"
:: Window properties
title Run Powershell Script
setlocal EnableExtensions EnableDelayedExpansion

echo.

:: run script-init.ps1
echo Running Powershell script
powershell -executionpolicy bypass -file script-init.ps1

:: exit
echo.
echo Terminating run_as_administrator.cmd ...
pause >nul
exit


:: ==================================================
:: Notes
:: ==================================================
