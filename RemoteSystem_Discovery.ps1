
##Functions

function checkthelist{

#Load Message Box Assembly. You don't need to know what's going on here. 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$check = Test-Path ./servers.txt

if ($check -eq $false ){[System.Windows.Forms.Messagebox]::`
Show("Please include a text file called servers.txt in the same folder as the script and try again.")}

}

function Collect_Disks{
foreach($PSItem in $list) {GET-WMIOBJECT –computername "$PSItem” -Credential $auth -Query "Select * from Win32_logicaldisk where DriveType = '3'" -Authentication 6 `
 | Select deviceID, @{Label=’Total Size (GB)’;Expression={$_.size/1GB}}, @{Label=’Freespace_Left(GB)’;Expression={$_.freespace/1GB}},`
  @{Label=’Consumed Capacity(GB)’;Expression={($_.size/1GB) - ($_.freespace/1GB)}} | FL `
| FORMAT-TABLE -AutoSize | Out-File $env:USERProfile\Desktop\$PSITEM.txt}
}

#Get The Machine Processor Type, Max ClockSeed Number of Cores and Number of Logical Processors and append to the file from collect disks.
function Collect_Processor{

$properties = "Name","maxclockspeed","numberOfCores","NumberOfLogicalProcessors"

foreach($PSItem in $list) {GET-WMIOBJECT –computername "$PSItem” -Credential $auth -Class win32_processor -Property $properties -Authentication 6 `
 | Select-Object -Property $properties | Format-Table -AutoSize >> C:\Users\Jason\Desktop\$PSITEM.txt}

}

#Collect the capacity of Machine Ram and append to file
function Collect_RAM{


foreach($PSItem in $list) {GET-WMIOBJECT –computername "$PSItem” -Credential $auth -Class Win32_PhysicalMemory -Authentication 6 `
 | select @{Label=’Total Size Ram (GB)’;Expression={$_.capacity/1GB}}| Format-Table -Wrap -Autosize >> C:\Users\Jason\Desktop\$PSITEM.txt}

}

function Collect_OS{


foreach($PSItem in $list) {GET-WMIOBJECT –computername "$PSItem” -Credential $auth -Class Win32_OperatingSystem -Authentication 6 `
 | select @{Label=’Operating System Version’;Expression={$_.caption}}| Format-Table -Wrap -Autosize >> C:\Users\Jason\Desktop\$PSITEM.txt}

}

#Main Part of script

checkthelist

$list = Get-content .\servers.txt

$auth = Get-Credential -Message "Enter in a domain administrator account in the form of Domain\User:"

Collect_Disks

Collect_Processor

Collect_Ram

collect_os





 