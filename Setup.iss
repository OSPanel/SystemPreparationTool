#define AppVersion      GetDateTimeString('yy/m/d/h', '.', '.')
#define AppVersion_     GetDateTimeString('yy/m/d/h', '_', '_')
#define AppDomain       "ospanel.io"
#define AppTitle        "System Preparation Tool"
#define CurrentYear     GetDateTimeString('yyyy', '', '')

[Setup]

SourceDir               = .
OutputDir               = release
OutputBaseFilename      = open_server_panel_sp_tool_{#AppVersion_}

// Application info

AppName                 = {#AppTitle}
AppVersion              = {#AppVersion}
AppPublisherURL         = https://{#AppDomain}
AppPublisher            = {#AppDomain}
VersionInfoCompany      = {#AppDomain}
VersionInfoVersion      = {#AppVersion}
VersionInfoTextVersion  = {#AppVersion}
VersionInfoDescription  = {#AppTitle}
VersionInfoProductName  = {#AppTitle}
VersionInfoCopyright    = Copyright (c) 2010-{#CurrentYear}, {#AppDomain}

// Compression

Compression             = lzma2/ultra64
InternalCompressLevel   = ultra64
LZMAUseSeparateProcess  = yes
LZMAAlgorithm           = 1
SolidCompression        = yes

// Misc

AllowNoIcons            = yes
AllowRootDirectory      = yes
AllowUNCPath            = no
ArchitecturesAllowed    = x64
ArchitecturesInstallIn64BitMode = x64
CloseApplications       = no
DefaultDirName          = {tmp}
DefaultGroupName        = {#AppTitle}
DisableDirPage          = yes
DisableProgramGroupPage = yes
DisableReadyPage        = yes
DisableStartupPrompt    = yes
DisableWelcomePage      = yes
MinVersion              = 6.1sp1
RestartApplications     = no
ShowLanguageDialog      = auto
Uninstallable           = no
UsePreviousAppDir       = no
UsePreviousGroup        = no
UsePreviousLanguage     = no
UsePreviousPrivileges   = no
UsePreviousSetupType    = no
UsePreviousTasks        = no

[Languages]

Name: "ru";             MessagesFile: "lang\Russian.isl";   LicenseFile: "LICENSE"
Name: "ua";             MessagesFile: "lang\Ukrainian.isl"; LicenseFile: "LICENSE"
Name: "en";             MessagesFile: "lang\Default.isl";   LicenseFile: "LICENSE"

[Tasks]

Name: "task_MSVC";      Description:  "{cm:Msvcr}"
Name: "task_HOSTS";     Description:  "{cm:UnblHosts}"
Name: "task_WIN";       Description:  "{cm:Sysopts}";       Flags: restart
Name: "task_NET";       Description:  "{cm:Netopts}";       Flags: restart
Name: "task_SSD";       Description:  "{cm:Ssdopts}";       Flags: restart unchecked

[Files]

Source: "{sys}\drivers\etc\hosts";               DestDir: "{sys}\drivers\etc";  Flags: ignoreversion external onlyifdestfileexists; Tasks: task_HOSTS; Permissions: users-modify
Source: "resources\hosts";                       DestDir: "{sys}\drivers\etc";  Flags: ignoreversion onlyifdoesntexist;             Tasks: task_HOSTS; Permissions: users-modify
Source: "resources\VCRHyb64.exe";                DestDir: "{tmp}";              Flags: ignoreversion deleteafterinstall;            Tasks: task_MSVC;  Permissions: users-modify
Source: "resources\VC_redist.x86.exe";           DestDir: "{tmp}";              Flags: ignoreversion deleteafterinstall;            Tasks: task_MSVC;  Permissions: users-modify
Source: "resources\VC_redist.x64.exe";           DestDir: "{tmp}";              Flags: ignoreversion deleteafterinstall;            Tasks: task_MSVC;  Permissions: users-modify

[Run]

// Microsoft Visual C++ 2005-2008-2010-2012-2013-2019-2022 Redistributable packages

Filename: "{tmp}\VCRHyb64.exe";                  Parameters: "/DelVCAll";                    Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: not IsVerySilent
Filename: "{tmp}\VCRHyb64.exe";                  Parameters: "/WithOutVC22";                 Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: not IsVerySilent
Filename: "{tmp}\VC_redist.x86.exe";             Parameters: "/install /passive /norestart"; Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: not IsVerySilent
Filename: "{tmp}\VC_redist.x64.exe";             Parameters: "/install /passive /norestart"; Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: not IsVerySilent
Filename: "{tmp}\VCRHyb64.exe";                  Parameters: "/S /DelVCAll";                 Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: IsVerySilent
Filename: "{tmp}\VCRHyb64.exe";                  Parameters: "/S /WithOutVC22";              Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: IsVerySilent
Filename: "{tmp}\VC_redist.x86.exe";             Parameters: "/install /quiet /norestart";   Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: IsVerySilent
Filename: "{tmp}\VC_redist.x64.exe";             Parameters: "/install /quiet /norestart";   Flags: runascurrentuser waituntilterminated;        Tasks: task_MSVC;  Check: IsVerySilent

// System settings optimization (USER)

Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\Control Panel\Desktop""                                    /v AutoEndTasks              /t REG_SZ    /d 0          /f"; Flags: runasoriginaluser runhidden waituntilterminated; Tasks: task_WIN
Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\Control Panel\Desktop""                                    /v WaitToKillAppTimeout      /t REG_SZ    /d 30000      /f"; Flags: runasoriginaluser runhidden waituntilterminated; Tasks: task_WIN
Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\Control Panel\Desktop""                                    /v HungAppTimeout            /t REG_SZ    /d 30000      /f"; Flags: runasoriginaluser runhidden waituntilterminated; Tasks: task_WIN
Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\BrowserEmulation""    /v IntranetCompatibilityMode /t REG_DWORD /d 0x00000000 /f"; Flags: runasoriginaluser runhidden waituntilterminated; Tasks: task_WIN

// Network settings optimization 

Filename: "{sys}\netsh.exe"; Parameters: "int ipv4 set dynamicport tcp start=49152 num=16384"; Flags: runascurrentuser runhidden waituntilterminated; Tasks: task_NET
Filename: "{sys}\netsh.exe"; Parameters: "int ipv4 set dynamicport udp start=49152 num=16384"; Flags: runascurrentuser runhidden waituntilterminated; Tasks: task_NET

// System services optimization for SSD

Filename: "{sys}\sc.exe";    Parameters: "stop SysMain";                                       Flags: runascurrentuser runhidden waituntilterminated; Tasks: task_SSD
Filename: "{sys}\sc.exe";    Parameters: "config SysMain start= disabled";                     Flags: runascurrentuser runhidden waituntilterminated; Tasks: task_SSD

[Registry]

// System settings optimization for SSD

Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\FileSystem";                           ValueType: dword;  ValueName: "DisableDeleteNotification";    ValueData: "0";     Flags: deletevalue; Tasks: task_SSD
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\FileSystem";                           ValueType: dword;  ValueName: "NtfsDisable8dot3NameCreation"; ValueData: "1";     Flags: deletevalue; Tasks: task_SSD
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management";    ValueType: dword;  ValueName: "ClearPageFileAtShutdown";      ValueData: "0";     Flags: deletevalue; Tasks: task_SSD
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management";    ValueType: dword;  ValueName: "LargeSystemCache";             ValueData: "0";     Flags: deletevalue; Tasks: task_SSD
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters";    ValueName: "EnablePrefetcher";             ValueData: "0";     Flags: deletevalue; Tasks: task_SSD; ValueType: dword

// DNS settings optimization 

Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "LocalPriority";                ValueData: "4";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "HostsPriority";                ValueData: "5";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "DnsPriority";                  ValueData: "6";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "NetbtPriority";                ValueData: "7";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Dnscache\Parameters";                 ValueType: dword;  ValueName: "NegativeCacheTime";            ValueData: "300";   Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Dnscache\Parameters";                 ValueType: dword;  ValueName: "NetFailureCacheTime";          ValueData: "30";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Dnscache\Parameters";                 ValueType: dword;  ValueName: "NegativeSOACacheTime";         ValueData: "120";   Flags: deletevalue; Tasks: task_NET

// Network settings optimization 

Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\AFD\Parameters";                      ValueType: dword;  ValueName: "EnableDynamicBacklog";         ValueData: "1";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\AFD\Parameters";                      ValueType: dword;  ValueName: "MinimumDynamicBacklog";        ValueData: "20";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\AFD\Parameters";                      ValueType: dword;  ValueName: "MaximumDynamicBacklog";        ValueData: "16384"; Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\AFD\Parameters";                      ValueType: dword;  ValueName: "DynamicBacklogGrowthDelta";    ValueData: "10";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters";                   ValueType: dword;  ValueName: "DisabledComponents";           ValueData: "32";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "StrictTimeWaitSeqCheck";       ValueData: "1";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "TcpTimedWaitDelay";            ValueData: "30";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "DefaultTTL";                   ValueData: "64";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "MaxFreeTcbs";                  ValueData: "16384"; Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "MaxFreeTWTcbs";                ValueData: "16384"; Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "MaxHashTableSize";             ValueData: "16384"; Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "TCPMaxDataRetransmissions";    ValueData: "5";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "TcpNumConnections";            ValueData: "16384"; Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "TcpWindowSize";                ValueData: "64240"; Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";                    ValueType: dword;  ValueName: "DisableTaskOffload";           ValueData: "0";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\QoS";                           ValueType: string; ValueName: "Do not use NLA";               ValueData: "1";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SOFTWARE\Microsoft\MSMQ\Parameters";                                    ValueType: dword;  ValueName: "TCPNoDelay";                   ValueData: "1";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\Psched";                            ValueType: dword;  ValueName: "NonBestEffortLimit";           ValueData: "0";     Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters";             ValueType: dword;  ValueName: "Size";                         ValueData: "2";     Flags: deletevalue; Tasks: task_NET 
Root: "HKLM"; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; ValueType: dword;  ValueName: "NetworkThrottlingIndex";       ValueData: "-1";    Flags: deletevalue; Tasks: task_NET
Root: "HKLM"; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; ValueType: dword;  ValueName: "SystemResponsiveness";         ValueData: "10";    Flags: deletevalue; Tasks: task_NET

// System settings optimization (ADMIN)

Root: "HKCU"; Subkey: "SOFTWARE\Microsoft\Internet Explorer\BrowserEmulation";                 ValueType: dword;  ValueName: "IntranetCompatibilityMode";    ValueData: "0";     Flags: deletevalue; Tasks: task_WIN 
Root: "HKCU"; Subkey: "Control Panel\Desktop";                                                 ValueType: string; ValueName: "AutoEndTasks";                 ValueData: "0";     Flags: deletevalue; Tasks: task_WIN
Root: "HKCU"; Subkey: "Control Panel\Desktop";                                                 ValueType: string; ValueName: "WaitToKillAppTimeout";         ValueData: "30000"; Flags: deletevalue; Tasks: task_WIN
Root: "HKCU"; Subkey: "Control Panel\Desktop";                                                 ValueType: string; ValueName: "HungAppTimeout";               ValueData: "30000"; Flags: deletevalue; Tasks: task_WIN
Root: "HKU";  Subkey: ".DEFAULT\Control Panel\Desktop";                                        ValueType: string; ValueName: "AutoEndTasks";                 ValueData: "0";     Flags: deletevalue; Tasks: task_WIN
Root: "HKU";  Subkey: ".DEFAULT\Control Panel\Desktop";                                        ValueType: string; ValueName: "WaitToKillAppTimeout";         ValueData: "30000"; Flags: deletevalue; Tasks: task_WIN
Root: "HKU";  Subkey: ".DEFAULT\Control Panel\Desktop";                                        ValueType: string; ValueName: "HungAppTimeout";               ValueData: "30000"; Flags: deletevalue; Tasks: task_WIN

[Code]

// Silent mode checking

function IsVerySilent: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to ParamCount do
    if CompareText(ParamStr(i), '/VERYSILENT') = 0 then
    begin
      Result := True;
      Exit;
    end;
end;
