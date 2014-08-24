@echo off

:rem MS SQL Server related Features on Windows Server 2008 R2

echo.
echo.
echo Enable Windows Feature=NetFx3
dism.exe /Online /Enable-Feature=NetFx3
echo.
echo Done...

echo [NETSH] Open firewall ports 1433
netsh advfirewall firewall add rule name="MS SQL Service Port 1433" dir=in action=allow protocol=TCP localport=1433
