@echo off


set DEST="C:\opt\"

set NSSM="C:\opt\nssm\bin\nssm.exe"
set SERVICE_NAME=etcd Service

echo.
echo [SC] Stopping service "%SERVICE_NAME%"
sc stop "%SERVICE_NAME%" >NUL 2>NUL

echo [NSSM] Trying to remove possibly pre-existing service "%SERVICE_NAME%"...
"%NSSM%" remove "%SERVICE_NAME%" confirm > NUL 2>NUL

if exist "%DEST%" (
  echo.
  echo Removing files in %DEST%
  echo.
  rmdir /Q /S "%DEST%"
)

netsh advfirewall firewall delete rule name="etcd Service Port 4001"
netsh advfirewall firewall delete rule name="etcd Service Port 7001"
