@echo off

set SRC="C:\vagrant\install\opt"
set DEST="C:\opt\"
set NSSM="C:\opt\nssm\bin\nssm.exe"
set ETCD="C:\opt\etcd\bin\etcd.exe"
set SERVICE_NAME=etcd Service
set SERVICE_DESCRIPTION=etcd Service for Windows
set SERVICE_LOGFILE="C:\opt\etcd\log\etcd.log"
set SERVICE_PARAMETERS="-config C:\opt\etcd\etc\etcd.conf -trace=*"

:rem ---DO NOT EDIT BEYOND---

echo.
echo Script: provision-etcd.bat startet...
echo.

if not exist "%DEST%" (
  echo.
  echo Copy files to %DEST%
  echo.
  xcopy /Y /E "%SRC%" "%DEST%"
) 

echo.
echo [SC] Stopping service "%SERVICE_NAME%"
sc stop "%SERVICE_NAME%" >NUL 2>NUL

echo [NSSM] Trying to remove possibly pre-existing service "%SERVICE_NAME%"...
"%NSSM%" remove "%SERVICE_NAME%" confirm > NUL 2>NUL
"%NSSM%" install "%SERVICE_NAME%" "%ETCD%"
"%NSSM%" set "%SERVICE_NAME%" AppParameters "%SERVICE_PARAMETERS%"
"%NSSM%" set "%SERVICE_NAME%" AppStdout "%SERVICE_LOGFILE%"
"%NSSM%" set "%SERVICE_NAME%" AppStderr "%SERVICE_LOGFILE%"
"%NSSM%" set "%SERVICE_NAME%" Description "%SERVICE_DESCRIPTION%"


if not errorlevel 1 (
  :rem echo.
  :rem echo [SC] Configuring Service to allow access to desktop
  :rem echo.
  :rem sc config "%SERVICE_NAME%" type= own type= interact
  echo.
  echo [SC] Starting ETCD Service
  echo.
  sc start "%SERVICE_NAME%"
)

echo [NETSH] Open firewall ports 4001,7001
netsh advfirewall firewall add rule name="etcd Service Port 4001" dir=in action=allow protocol=TCP localport=4001
netsh advfirewall firewall add rule name="etcd Service Port 7001" dir=in action=allow protocol=TCP localport=7001

echo.
echo etcd Service should be available at:
echo     http://127.0.0.1:4001/version
echo     http://%COMPUTERNAME%:4001/version
echo.
