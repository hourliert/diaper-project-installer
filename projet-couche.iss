; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Projet Couche"
#define MyAppShortName "ProjetCouche"
#define MyAppVersion "1.0"
#define MyAppPublisher "Thomas Hourlier"
#define MyAppURL "https://git.cnode.fr/hourliert/projet-couche"
#define MyAppPostInstall "win-install.bat"

#define NSSM "nssm.exe"
#define NODE "node-v4.2.2-x64.msi"
#define PYTHON "python-2.7.10.amd64.msi"
#define USERPROFILE "C:\Users\thomashourlier"
#define RESSOURCESPATH "C:\Users\thomashourlier\Documents\projet-couche-installer"
#define PROJECTPATH "C:\Users\thomashourlier\Documents\projet-couche-installer/source"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{01A17C44-33FB-4EBA-840D-CDD3E34A4DDF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir={#RESSOURCESPATH}
OutputBaseFilename={#MyAppShortName}Installer
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Files]
Source: "{#RESSOURCESPATH}\node-v4.2.2-x64.msi"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RESSOURCESPATH}\nssm.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RESSOURCESPATH}\python-2.7.10.amd64.msi"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RESSOURCESPATH}\win-install.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#PROJECTPATH}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Run]
; These all run with 'runascurrentuser' (i.e. admin) whereas 'runasoriginaluser' would refer to the logged in user
; Install Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /i ""{app}\{#NODE}""";
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /i ""{app}\{#PYTHON}""";

; postinstall launch
Filename: "{app}\{#MyAppPostInstall}"; Flags: waituntilterminated

; Add Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Node In"" program=""{pf64}\nodejs\node.exe"" dir=in action=allow enable=yes"; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Node Out"" program=""{pf64}\nodejs\node.exe"" dir=out action=allow enable=yes"; Flags: runhidden;

; Add System Service
Filename: "{app}\{#NSSM}"; Parameters: "install {#MyAppShortName} ""{pf64}\nodejs\node.exe"""; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppDirectory ""{app}"""; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppParameters ""build\server.js"""; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} Start SERVICE_DELAYED_START"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppStdout ""{app}\build\{#MyAppShortName}.stdout.log"""; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppStderr ""{app}\build\{#MyAppShortName}.stderr.log"""; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppStdoutCreationDisposition 4"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppStderrCreationDisposition 4"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppRotateFiles 1"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppRotateOnline 0"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppRotateSeconds 86400"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "set {#MyAppShortName} AppRotateBytes 1048576"; Flags: runhidden;
Filename: "{sys}\net.exe"; Parameters: "start {#MyAppShortName}"; Flags: runhidden;

[UninstallRun]
; Removes System Service
Filename: "{sys}\net.exe"; Parameters: "stop {#MyAppShortName}"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "remove {#MyAppShortName} confirm"; Flags: runhidden;

; Remove Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Node In"" program=""{pf64}\nodejs\node.exe"""; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Node Out"" program=""{pf64}\nodejs\node.exe"""; Flags: runhidden;

; Uninstall Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /x ""{app}\{#NODE}""";
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /x ""{app}\{#PYTHON}""";

; Remove all leftovers
Filename: "{sys}\rd"; Parameters: "/s /q ""{app}\*""";