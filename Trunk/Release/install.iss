; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=Nevod AntiSpam
AppVerName=Nevod AntiSpam 1.5
AppPublisher=Nevilon Software
AppPublisherURL=http://www.nevilon.com
AppSupportURL=http://www.nevilon.com
AppUpdatesURL=http://www.nevilon.com
DefaultDirName={pf}\Nevilon Software/Nevod AntiSpam
DefaultGroupName=Nevod AntiSpam
AllowNoIcons=yes
LicenseFile=C:\Projects\Nevod\Resources\license.txt
OutputDir=C:\Projects\Nevod\release
OutputBaseFilename=NevodAntiSpam1.4
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone

[Files]
Source: "C:\Projects\Nevod\Release\Nevod.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projects\Nevod\Release\help.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Projects\Nevod\Release\Sounds\*.*"; DestDir: "{app}\Sounds"; Flags: ignoreversion
Source: "C:\Projects\Nevod\Release\locale\ru\LC_MESSAGES\default.mo"; DestDir: "{app}\locale\ru\LC_MESSAGES"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Projects\Nevod\Release\NevodBackup.exe"; DestDir: "{app}"; Flags: ignoreversion;AfterInstall: WriteRegKeys
Source: "C:\Projects\Nevod\Release\Shared.dll"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]


procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
 ResultStr: String;
 ResultCode: Integer;
 Res:boolean;
begin
 if CurUninstallStep=usPostUninstall then
  begin
    RegDeleteKeyIncludingSubkeys(HKCU,'Software\Nevilon Software\Nevod AntiSpam');
    RegDeleteValue(HKCU,'Software\Microsoft\Windows\CurrentVersion\Run','Nevod AntiSpam');
    Res := MsgBox('������� ���� ��������� ?', mbConfirmation, MB_YESNO) = idYes;
    if Res =True then
     begin
      RegQueryStringValue(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'AppData', ResultStr);
      ResultStr:=ResultStr+'\Nevilon Software\Nevod AntiSpam\messages.ndb';
      DeleteFile(ResultStr);
     end;
  end;
end;

procedure WriteRegKeys;
begin
 RegWriteStringValue(HKEY_CURRENT_USER, 'Software\Nevilon Software\Nevod AntiSpam',
    'First','True');
end;


[INI]
Filename: "{app}\Nevod.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://www.nevilon.com"

[Icons]
Name: "{group}\Nevod AntiSpam"; Filename: "{app}\Nevod.exe"
Name: "{group}\{cm:ProgramOnTheWeb,Nevod AntiSpam}"; Filename: "{app}\Nevod.url"
Name: "{userdesktop}\Nevod AntiSpam"; Filename: "{app}\Nevod.exe"; Tasks: desktopicon
Name: "{group}\{cm:UninstallProgram,My Program}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\Nevod.exe"; Description: "{cm:LaunchProgram,Nevod AntiSpam}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\Nevod.url"

