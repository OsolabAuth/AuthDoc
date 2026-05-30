@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%generate-summary.ps1"

if errorlevel 1 (
  echo Failed to update SUMMARY.md
  exit /b 1
)

echo SUMMARY.md updated successfully.
exit /b 0
