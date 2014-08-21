@echo off

:rem Printing related Features on Windows Server 2008 R2
:rem Feature Name : Printing-LPRPortMonitor
:rem Feature Name : Printing-InternetPrinting-Client
:rem Feature Name : Printing-AdminTools-Collection
:rem Feature Name : Printing-Server-Role
:rem Feature Name : Printing-LPDPrintService
:rem Feature Name : Printing-InternetPrinting-Server

echo.
echo "Enable Windows Feature=Printing-Server-Role"
dism.exe /Online /Enable-Feature=Printing-Server-Role

echo.
echo "Enable Windows Feature=Printing-LPDPrintService"
echo "   LPD-Server is running on Port=515/tcp"
dism.exe /Online /Enable-Feature=Printing-LPDPrintService

echo.
echo "Enable Windows Feature=Printing-LPRPortMonitor"
echo "   LPR.exe, LPQ.exe, LPR-PortMonitor"
dism.exe /Online /Enable-Feature=Printing-LPRPortMonitor

echo.
echo "Enable Windows Feature=TelnetClient"
echo "   TELNET.exe"
dism.exe /Online /Enable-Feature=TelnetClient
echo.
echo "Done..."
