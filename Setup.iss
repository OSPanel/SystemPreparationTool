#define AppVersion      GetDateTimeString('yy/m/d/h', '.', '.')
#define AppVersion_     GetDateTimeString('yy/m/d/h', '_', '_')
#define AppDomain       "ospanel.io"
#define AppTitle        "System Preparation Tool"
#define CurrentYear     GetDateTimeString('yyyy', '', '')

[Setup]

SourceDir               = .
OutputDir               = release
OutputBaseFilename      = ospanel_sys_prep_tool

// Application info

AppName                 = {#AppTitle}
AppVersion              = {#AppVersion}
AppPublisherURL         = https://{#AppDomain}
AppPublisher            = {#AppDomain}
SetupMutex              = Global\OSPSystemPreparationTool
VersionInfoCompany      = {#AppDomain}
VersionInfoVersion      = {#AppVersion}
VersionInfoTextVersion  = {#AppVersion}
VersionInfoDescription  = {#AppTitle}
VersionInfoProductName  = {#AppTitle}
VersionInfoCopyright    = Copyright (c) {#CurrentYear}, {#AppDomain}

// Compression

Compression             = lzma2/ultra64
InternalCompressLevel   = ultra64
LZMAUseSeparateProcess  = yes
SolidCompression        = yes

// Misc

AllowNoIcons            = yes
AllowRootDirectory      = yes
AllowUNCPath            = no
ArchitecturesAllowed    = x64os
ArchitecturesInstallIn64BitMode = x64os
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

Name: "en";             MessagesFile: "lang\en.isl";   LicenseFile: "LICENSE"
Name: "ru";             MessagesFile: "lang\ru.isl";   LicenseFile: "LICENSE"
Name: "ua";             MessagesFile: "lang\ua.isl";   LicenseFile: "LICENSE"

[Tasks]

Name: "task_MSVC";      Description:  "{cm:Msvcr}"
Name: "task_HOSTS";     Description:  "{cm:UnblHosts}"
Name: "task_FIREWALL";  Description:  "{cm:UnblFirewall}"
Name: "task_SSD";       Description:  "{cm:Ssdopts}";       Flags: restart unchecked

[Files]

Source: "resources\hosts";                       DestDir: "{sys}\drivers\etc";                 Flags: ignoreversion onlyifdoesntexist;                       Tasks: task_HOSTS;  Permissions: users-modify
Source: "{sys}\drivers\etc\hosts";               DestDir: "{sys}\drivers\etc";                 Flags: ignoreversion external onlyifdestfileexists;           Tasks: task_HOSTS;  Permissions: users-modify
Source: "resources\VC_redist.x86.exe";           DestDir: "{tmp}";                             Flags: ignoreversion deleteafterinstall;                      Tasks: task_MSVC;   Permissions: users-modify
Source: "resources\VC_redist.x64.exe";           DestDir: "{tmp}";                             Flags: ignoreversion deleteafterinstall;                      Tasks: task_MSVC;   Permissions: users-modify

[Run]

// Microsoft Visual C++ Redistributable packages

Filename: "{tmp}\VC_redist.x86.exe";             Parameters: "/install /passive /norestart";   Flags: runascurrentuser waituntilterminated;                  Tasks: task_MSVC;   Check: not IsVerySilent
Filename: "{tmp}\VC_redist.x64.exe";             Parameters: "/install /passive /norestart";   Flags: runascurrentuser waituntilterminated;                  Tasks: task_MSVC;   Check: not IsVerySilent
Filename: "{tmp}\VC_redist.x86.exe";             Parameters: "/install /quiet /norestart";     Flags: runascurrentuser waituntilterminated;                  Tasks: task_MSVC;   Check: IsVerySilent
Filename: "{tmp}\VC_redist.x64.exe";             Parameters: "/install /quiet /norestart";     Flags: runascurrentuser waituntilterminated;                  Tasks: task_MSVC;   Check: IsVerySilent

// System settings optimization (USER)

Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\Control Panel\Desktop""      /v AutoEndTasks              /t REG_SZ    /d 0          /f";  Flags: runasoriginaluser runhidden waituntilterminated
Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\Control Panel\Desktop""      /v WaitToKillAppTimeout      /t REG_SZ    /d 30000      /f";  Flags: runasoriginaluser runhidden waituntilterminated
Filename: "{sys}\reg.exe";   Parameters: "ADD ""HKEY_CURRENT_USER\Control Panel\Desktop""      /v HungAppTimeout            /t REG_SZ    /d 30000      /f";  Flags: runasoriginaluser runhidden waituntilterminated

// System settings optimization (ADMIN)

Filename: "{sys}\sc.exe";    Parameters: "config SysMain start= auto";                         Flags: runascurrentuser runhidden waituntilterminated
Filename: "{sys}\sc.exe";    Parameters: "start SysMain";                                      Flags: runascurrentuser runhidden waituntilterminated

// Set firewall rules

Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Allow OSPanel Folder Inbound"" dir=in action=allow program=""{code:GetProgramFolder}\*"" enable=yes profile=any"; Flags: runascurrentuser runhidden waituntilterminated; Tasks: task_FIREWALL; Check: IsOSPanelPresent
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Allow OSPanel Folder Outbound"" dir=out action=allow program=""{code:GetProgramFolder}\*"" enable=yes profile=any"; Flags: runascurrentuser runhidden waituntilterminated; Tasks: task_FIREWALL; Check: IsOSPanelPresent

[Registry]

// System settings optimization for SSD

Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\FileSystem";                           ValueType: dword;  ValueName: "DisableDeleteNotification";    ValueData: "0";     Flags: deletevalue; Tasks: task_SSD
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\FileSystem";                           ValueType: dword;  ValueName: "NtfsDisable8dot3NameCreation"; ValueData: "1";     Flags: deletevalue; Tasks: task_SSD

// Network settings optimization 

Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "LocalPriority";                ValueData: "4";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "HostsPriority";                ValueData: "5";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "DnsPriority";                  ValueData: "6";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider";               ValueType: dword;  ValueName: "NetbtPriority";                ValueData: "7";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Dnscache\Parameters";                 ValueType: dword;  ValueName: "NegativeCacheTime";            ValueData: "300";   Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Dnscache\Parameters";                 ValueType: dword;  ValueName: "NetFailureCacheTime";          ValueData: "30";    Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\Dnscache\Parameters";                 ValueType: dword;  ValueName: "NegativeSOACacheTime";         ValueData: "120";   Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters";                   ValueType: dword;  ValueName: "DisabledComponents";           ValueData: "32";    Flags: deletevalue

// System settings optimization (ADMIN)

Root: "HKCU"; Subkey: "Control Panel\Desktop";                                                 ValueType: string; ValueName: "AutoEndTasks";                 ValueData: "0";     Flags: deletevalue
Root: "HKCU"; Subkey: "Control Panel\Desktop";                                                 ValueType: string; ValueName: "WaitToKillAppTimeout";         ValueData: "30000"; Flags: deletevalue
Root: "HKCU"; Subkey: "Control Panel\Desktop";                                                 ValueType: string; ValueName: "HungAppTimeout";               ValueData: "30000"; Flags: deletevalue
Root: "HKU";  Subkey: ".DEFAULT\Control Panel\Desktop";                                        ValueType: string; ValueName: "AutoEndTasks";                 ValueData: "0";     Flags: deletevalue
Root: "HKU";  Subkey: ".DEFAULT\Control Panel\Desktop";                                        ValueType: string; ValueName: "WaitToKillAppTimeout";         ValueData: "30000"; Flags: deletevalue
Root: "HKU";  Subkey: ".DEFAULT\Control Panel\Desktop";                                        ValueType: string; ValueName: "HungAppTimeout";               ValueData: "30000"; Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\FileSystem";                           ValueType: dword;  ValueName: "LongPathsEnabled";             ValueData: "1";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management";    ValueType: dword;  ValueName: "ClearPageFileAtShutdown";      ValueData: "0";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management";    ValueType: dword;  ValueName: "LargeSystemCache";             ValueData: "0";     Flags: deletevalue
Root: "HKLM"; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters";    ValueName: "EnablePrefetcher";             ValueData: "0";     Flags: deletevalue; ValueType: dword

[Code]

function GetProgramFolder(Param: string): string;
var
  InstallerPath: string;
begin
  InstallerPath := ExpandConstant('{srcexe}');
  Result := ExtractFileDir(ExtractFileDir(InstallerPath));
end;

function IsOSPanelPresent(): Boolean;
begin
  Result := FileExists(GetProgramFolder() + '\ospanel.exe');
end;

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

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedHeadingLabel.Font.Style := [];
  end;
end;
