# Author: DR
#

# defaults
$NumberOfPrinters   = 2            # Number of Printers/Ports to create
$PrintDestinationIP = "127.0.0.1"  # IP address of the destination print server



function install-driver {
Param ( $Srv = "." , $DrvName  )
 
$driverclass                 = [wmiclass]"\\$Srv\root\cimv2:win32_PrinterDriver"
$driverobj                   = $driverclass.createInstance()
$driverobj.Name              = $DrvName
$driverobj.FilePath          = "\vagrant\drivers\sealps\"
$driverobj.InfName           = "\vagrant\drivers\sealps\seal.inf"
$driverobj.Version           = "3"
$driverobj.SupportedPlatform = "Windows NT x64"
$newdriver = $driverclass.AddPrinterDriver($driverobj)
$newdriver = $driverclass.Put()
}
 
function create-port {
Param ( $Srv = "." , $PortName  , $TCPIP = $PortName, $Prot = 1, $PortNum = "9100", $Snmp= $false)
 
$newport             = ([WMICLASS]"\\$Srv\ROOT\cimv2:Win32_TcpIpPrinterPort").createInstance()
$newport.Name        = $PortName
$newport.Protocol    = $Prot
$newport.HostAddress = $TCPIP
$newport.PortNumber  = $PortNum
$newport.SnmpEnabled = $Snmp 
$newport.Put()
}
 
function create-printer {
Param ( $Srv = ".", $deviceID, $DrvName , $PortName, $Shared= $true, $ShareName = $deviceID, $Loc, $Comment )
 
$print              = ([WMICLASS]"\\$Srv\ROOT\cimv2:Win32_Printer").createInstance()
$print.drivername   = $DrvName
$print.PortName     = $PortName
$print.Shared       = $Shared
$print.Sharename    = $ShareName
$print.Location     = $Loc
$print.Comment      = $Comment
$print.DeviceID     = $deviceID
$print.Put()
}


$timeStart = (Get-Date -UFormat %s) #-Replace("[,\.]\d*", "")
Write-Host "timeStart = $timeStart"


# Install a printer driver
$DriverName  = "Microsoft XPS Document Writer"
###Write-Host "`nInstall PrinterDriver..."
Write-Host "...PrinterDriver = $DriverName"
###install-driver -DrvName "$DriverName"
###Write-Host "...done"

# Define host "backfire" in /etc/hosts
Add-Content C:\Windows\System32\drivers\etc\hosts "`r`n$PrintDestinationIP	backfire"

# Create a number of printers
for ($i=1; $i -le $NumberOfPrinters; $i++) {
  $PortName    = "Port-{0:D6}" -f $i
  $PrinterName = "Printer-{0:D6}" -f $i
  $PortNum     = 10000 + $i
  
  Write-Host "`nCreate PrinterPort = $PortName"
  create-port -PortName "$PortName" -TCPIP "backfire" -PortNum "$PortNum"
  Write-Host "...done"
  
  Write-Host "`nCreate PrinterQueue = $PrinterName"
  create-printer -deviceID "$PrinterName" -PortName "$PortName" -DrvName "$DriverName" -Shared $true
  Write-Host "...done"
}


$timeEnd = (Get-Date -UFormat %s) #-Replace("[,\.]\d*", "")
Write-Host ""
Write-Host "timeStart = $timeStart"
Write-Host "timeEnd   = $timeEnd"
#$timeDiff = ($timeEnd - $timeStart)  
#Write-Host "timeDiff  = $timeDiff"

