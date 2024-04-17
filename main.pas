unit main;

{$mode objfpc}{$H+}{$I-}

interface

uses
  Classes, SysUtils, Forms, Graphics, Dialogs, StdCtrls, EditBtn,
  ComCtrls, Menus, Buttons, ActnList, TAGraph, TASeries, Grids,
  TAIntervalSources, TATransformations, TATools, LazSerial,
  DateUtils, TACustomSeries, SynEdit, StepForm, MyIniFile, math, settings,
  typinfo, types, lcltype, connectform, aboutform, ExtCtrls, shortcuthelpform,
  LCLTranslator, Spin, i18nutils, Controls;

const
{$ifdef Windows}
  cFixedFont = 'Consolas';
{$else}
  cFixedFont = 'Liberation Mono';
{$endif}
  cVersion = '2.18';
  cVersionStr= 'EBC Controller '+cVersion;

  cConnectRetries = 10;

  cstVoltage = 0;
  cstCurrent = 2;
  cstPower = 1;
  cstTime = 3;
  cstCapacity = 4;
  cstCapLocal = 5;  // Capacity computed on host
  cstEnergy = 6;
  cstResistance = 8;
  cstdV = 9;
  cstdA = 10;
  //cstDbg1 = 13;
  //cstDbg2 = 14;
  //cstDbg3 = 15;
  cstMax = 10;

  cConn = 'Conn';
  crcsendpos = 9;
  crcrecvpos = 18;
  cChanged = 'Changed';
  cUnChanged = '';
  cA = 'A';
  cP = 'W';
  cR = 'Ω';

  cDefaultCaption = 'EBC Controller';

  cNull = '00.00';

  cName = 'Name';
  cMethod = 'Type';
  cCharge = 'Charge';
  cChargeCV = 'ChargeCV';
  cDischarge = 'Discharge';
  cDischargeCP = 'DischargeCP';
  cDischargeCR = 'DischargeCR';
  cCommand = 'Command';
  cStop = 'Stop';
  cConnect = 'Connect';
  cDisconnect = 'Disconnect';
  cAdjust = 'Adjust';
  cStart = 'Start';
  cCont = 'Cont';
  cTestVal = 'TestVal';
  cEnableNumCells = 'EnableNumCells';
  cDefChargeCurrent = 'DefChargeCurrent';
  cDefDischargeCurrent = 'DefDischargeCurrent';
  cAutoOff = 'AutoOff';
  cVoltInfo = 'CellVoltageInfo';

  cModels = 'Models';
  cIdent = 'Ident';
  cIFactor = 'IFactor';
  cUFactor = 'UFactor';
  cPFactor = 'PFactor';
  cModelName = 'Name_';
  cCommandFormat = 'CommandFormat';
  cMaxChargeVoltage = 'MaxChargeVoltage';
  cMaxChargeCurrent = 'MaxChargeCurrent';
  cMaxDischargeCurrent = 'MaxDischargeCurrent';

  cDefault = 'Default';
  cChargeCurrent = 'ChargeCurrent';
  cChkAccept = 'ChkAccept';
  cDischargeCurrent = 'DischargeCurrent';
  cConstantVoltage = 'ConstantVoltage';
  cCells = 'Cells';
  cDischargePower = 'DischargePower';
  cDischargeResistance = 'DischargeResistance';
  cModeCommand = 'ModeCommand';
  cCutA = 'CutOffA';
  cCutATime = 'CutOffATime';
  cCutV = 'CutOffV';
  cMaxTime = 'MaxTime';
  cIntTime = 'IntegrationTime';

  cStartup = 'Startup';
  cUseLast = 'UseLast';
  cChargeIndex = 'ChargeIndex';
  cDischargeIndex = 'DischargeIndex';
  cStartSelection = 'StartSelection';
  cSelection = 'Selection';
  cChkSetting = 'CheckSetting';
  cSettings = 'Settings';
  cConf = '.conf';
  cInit = '.init';
// for using the same directory/conf file for Linux and Windows
{$ifdef Windows}
  cSaveDir  = 'SaveDir-Win';
  cLogDir   = 'LogDir-Win';
  cStepDir  = 'StepFileDir-Win';
  cProgFile = 'ProgFile-Win';
  cSerial   = 'Serial-Win';
{$else}
  cSaveDir  = 'SaveDir';
  cLogDir   = 'LogDir';
  cStepDir  = 'StepFileDir';
  cProgFile = 'ProgFile';
  cSerial   = 'Serial';
{$endif}
  cLangCode = 'Lang';
  cTabIndex = 'TabIndex';
  cReadOnly = 'ReadOnly';
  cMonitor  = 'Monitor';
  cAutoLog  = 'AutoLog';
  cAutoCsvFileName  = 'AutoCsvFileName';

  cWinMaximized = 'Maximized';
  cWinWidth = 'Width';
  cWinHeight = 'Height';
  cWinTop    = 'Top';
  cWinLeft   = 'Left';
  cAppSec = 'Application';
  cMemStepLogHeight = 'MemStepLogHeight';
  cMemStepLogWidths = 'MemStepLogWidths';


Resourcestring
  cFileExists              = 'File Exists';
  cFatal                   = 'Fatal Error';
  cError                   = 'Error';
  cCurrentHint             = 'Set the charge/discharge current in Ampere';
  cCurrent                 = 'Current';
  cPower                   = 'Power';
  cResistance              = 'Resistance';
  cPowerHint               = 'Set the charge/discharge Power in Watt';
  cResistanceHint          = 'Set the charge/discharge current resistance in Ohm';
  cConnectTimeout          = 'Unable to connect - timeout';
  cChargeLowerCutoff       = 'Charge current (%fA) is lower than cutoff current (%fA)';
  cCutoffGtoeChargeC       = 'Cutoff current (%fA) is greater or equal to charage current (%fA)';
  cChargeCurrExeeded       = 'Charge current (%fA) exceeds the maximum supported by %s (%fA)';
  cChargeVoltageExeeded    = 'Charge voltage (%fV) exceeds the maximum supported by %s (%fV)';
  cNoChargeProfileSelected = 'no charging profile selected';
  cDischargeAmpsExeeded    = 'Discharge current (%fA) exceeds the maximum supported by %s (%fA)';
  cPacketNotInConfFile     = 'packet "%S" not found in config file';
  cErrorReadingModelFromSec= '%s while reading Model= from %s (Section %d)';
  cNoChargeDischargeProfile= 'No charge/discharge profiles defined in configuration file (%s)';
  cIdentModelNotFound      = 'Ident for model %d not found in %s';
  cNoModelsDefined         = 'No models defined in configuration file (%s)';
  cNoConnectPackage        = 'There is no connect packet defined in configuration file (%s)';
  cNoDisconnectPackage     = 'There is no disconnect packet defined in configuration file (%s)';
  cStepLogCreateErr        = 'unable to create step logfile %s (%d)';
  cAutoLogNoAutoFileName   = 'AutoLog is defined but neither a log file name nor Auto CSV Filename is specified';
  cFileOverwrite           = 'file %s already exists'+#13+'Overwrite File ?';
  cUnableToCreateLogFile   = 'unable to create logfile %s (%d)';
  cErrorClosingLogfile     = 'Error %d while closing logfile)';
  cUnableToConnectTo       = 'Unable to connect to %s';
  cConnectionLost          = 'Connection Lost';
  cPacketTimeout           = 'Timout waiting for a packet from charger device';
  cSetBorderName           = 'Set border name';
  cView                    = 'View...';
  cEdit                    = 'Edit...';
  cCapI                    = 'CapI: ';
  cEneI                    = 'EneI: ';
  cInvalidChecksum         = '<%s invalid checksum';
  cDecodeCorrentException  = 'DecodeCurrent raised %s (%2x%2x)';
  cDecodeVoltageException  = 'DecodeVoltage raised %s (%2x%2x)';
  cTime                    = 'Time';
  cStarted                 = 'started';
  cUnknown                 = 'unknown';
  cConnecting              = 'Connecting...';
  cNotConnected            = 'Not connected';
  cConnected               = 'Connected';
  cCopyError               = 'unable to copy'+sLineBreak+'%s'+sLineBreak+'to'+sLineBreak+'%s';




Const
  cst_ConnectionState = 0;
  cst_ConnectionStatus = 1;
  cst_ConnectedModel = 2;
  cst_RunMode = 3;
  cst_LogFileName = 4;



  // Log table headers
//  cColumns = ' Step     CMD      (Ah)    (Wh)       Time     StartV  EndV';
  cColumns = ' Step  |  CMD    | (Ah)  | (Wh)  |    Time    |StartV| EndV | EndA';
  cCol: array [1..8] of Integer = (7, 9, 7, 7, 12, 6, 6, 6);

type
  TCapacity = (caEBC, caLocal);
  TSendMode = (smStart, smAdjust, smCont, smConnect, smDisconnect, smConnStop);
  TMethod = (mNone, mCharge, mChargeCV, mDischarge, mDischargeCP, mDischargeCR);
  TTestVal = (tvCurrent, tvPower, tvResistance);
  TConnState = (csNone, csConnecting, csCapture, csConnected); // csCapture = read settings from instrument

  TConnPacket = record
     Connect: string;
     Disconnect: string;
     Stop: string;
  end;

  TModel = record
     Name: string;
     IFactor: Extended;
     UFactor: Extended;
     Ident: Integer;
     ConnState: TConnState;
     ConnPackets: TConnPacket;
     CommandFormat : integer;
     MaxChargeVoltage: Extended;
     MaxChargeCurrent: Extended;
     MaxDischargeCurrent: Extended;
  end;

  TDeltaValue = record
     Time: TDateTime;
     SumV: Extended;
     SumA: Extended;
     Values: Integer;
  end;

  TCSVData = record
    vTime: Integer;
    vVoltage,vCurrent,CapacityEBC,CapacityLocal: Extended;
  end;

  TPacket = record
    Name: string;
    Command: string;
    Method: TMethod;
    Start: string;
    Adjust: string;
    Cont: string;
    AutoOff: string;
    TestVal: TTestVal;
    VoltInfo: Extended;
    SupportedModels : TIntegerDynArray;
    EnableNumCells : boolean; // for cccv A20/A40
    DefChargeCurrent : Extended;
    DefDischargeCurrent : Extended;
    DefCutoffCurrent : Extended;
  end;


  TChecks = record
     cCurrent: Extended;
     cDwellTime: Integer;
     cEnergy: Extended;
     cCapacity: Extended;
     ThresholdTime: TDateTime;
     TimerRunning: Boolean;
  end;

  type TDefaults = record
     ChargeI: Extended;
     DischargeI: Extended;
     ConstantU: Extended;
     DischargeP: Extended;
     DischargeR: Extended;
     Cells: Integer;
     ModeName: string;
  end;

  { TfrmMain }

  TfrmMain = class(TForm)
    btnAdjust: TButton;
    btnCont: TButton;
    btnProg: TButton;
    btnStart: TButton;
    btnStop: TButton;
    btnSkip: TButton;
    Chart: TChart;
    ChartToolset1: TChartToolset;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    chkCutCap: TCheckBox;
    chkCutEnergy: TCheckBox;
    edtDelim: TEdit;
    edtTestVal: TFloatSpinEdit;
    edtCutEnergy: TFloatSpinEdit;
    edtCutCap: TFloatSpinEdit;
    edtCutV: TFloatSpinEdit;
    edtChargeV: TFloatSpinEdit;
    edtCutA: TFloatSpinEdit;
    gbSettings: TGroupBox;
    gbStatus: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblCutA: TLabel;
    lblChargeV: TLabel;
    lblCells: TLabel;
    lblCutCap2: TLabel;
    lblCutEnergy2: TLabel;
    lblCutTime: TLabel;
    lblTestVal: TLabel;
    lblCapI: TLabel;
    lblProgTime: TLabel;
    Label10: TLabel;
    lblCutCap: TLabel;
    lblCutEnergy: TLabel;
    lblCutoffV1: TLabel;
    lblMin: TLabel;
    lblStep: TLabel;
    lblStepNum: TLabel;
    lblTestUnit: TLabel;
    ChartAxisTransformationsCurrent: TChartAxisTransformations;
    ChartAxisTransformationsCurrentAutoScaleAxisTransform: TAutoScaleAxisTransform;
    ChartAxisTransformationsVoltage: TChartAxisTransformations;
    ChartAxisTransformationsVoltageAutoScaleAxisTransform: TAutoScaleAxisTransform;
    DateTimeIntervalChartSource: TDateTimeIntervalChartSource;
    lblTimer: TLabel;
    lsCurrent: TLineSeries;
    lsInvisibleCurrent: TLineSeries;
    lsInvisibleVoltage: TLineSeries;
    lsVoltage: TLineSeries;
    MainMenu: TMainMenu;
    memLog: TMemo;
    memStepLog: TStringGrid;
    mm_langEnglish: TMenuItem;
    mmm_language: TMenuItem;
    mm_Shortcuts: TMenuItem;
    mm_LogFileDir: TMenuItem;
    mm_skipStep: TMenuItem;
    mm_AutoCsvFileName: TMenuItem;
    mm_stepEdit: TMenuItem;
    mm_stepLoad: TMenuItem;
    mmm_Step: TMenuItem;
    mm_AutoLog: TMenuItem;
    mm_setCsvLogFile: TMenuItem;
    GraphStepslogPanel: TPanel;
    ChargePannel: TPanel;
    DischargePanel: TPanel;
    RightPanel: TPanel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Separator2: TMenuItem;
    mm_saveCsv: TMenuItem;
    mm_savePng: TMenuItem;
    mmm_Data: TMenuItem;
    mm_taskBarName: TMenuItem;
    mm_Settings: TMenuItem;
    mmm_Settings: TMenuItem;
    mm_About: TMenuItem;
    mmm_Help: TMenuItem;
    mmm_File: TMenuItem;
    mm_Quit: TMenuItem;
    Separator1: TMenuItem;
    mm_Disconnect: TMenuItem;
    mm_Connect: TMenuItem;
    pcProgram: TPageControl;
    rgDischarge: TRadioGroup;
    rgCharge: TRadioGroup;
    sdLogCSV: TSaveDialog;
    sdPNG: TSaveDialog;
    sdCSV: TSaveDialog;
    shaCapI: TShape;
    MainStatusBar: TStatusBar;
    ChartStepSplitter: TSplitter;
    edtCutTime: TSpinEdit;
    edtCells: TSpinEdit;
    edtCutM: TSpinEdit;
    stStepFile: TStaticText;
    ReconnectTimer: TTimer;
    ConnectionWatchdogTimer: TTimer;
    tsConsole: TTabSheet;
    tmrWait: TTimer;
    tsProgram: TTabSheet;
    tbxMonitor: TToggleBox;
    tsCharge: TTabSheet;
    tsDischarge: TTabSheet;
    Serial: TLazSerial;
    procedure ConnectionWatchdogTimerTimer(Sender: TObject);
    procedure edtCellsChange(Sender: TObject);
    procedure edtCellsClick(Sender: TObject);
    procedure edtCellsEditingDone(Sender: TObject);
    procedure edtCellsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCellsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCellsExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mm_AboutClick(Sender: TObject);
    procedure FinalizeLanguageSettings;
    procedure SetLanguage(langCode : string);
    procedure mm_langClick(Sender: TObject);
    procedure mm_AutoCsvFileNameClick(Sender: TObject);
    procedure mm_AutoLogClick(Sender: TObject);
    procedure mm_ConnectClick(Sender: TObject);
    procedure mm_LogFileDirClick(Sender: TObject);
    procedure mm_QuitClick(Sender: TObject);
    procedure mm_saveCsvClick(Sender: TObject);
    procedure mm_savePngClick(Sender: TObject);
    procedure mm_setCsvLogFileClick(Sender: TObject);
    procedure mm_SettingsClick(Sender: TObject);
    procedure mm_ShortcutsClick(Sender: TObject);
    procedure mm_stepLoadClick(Sender: TObject);
    procedure mm_taskBarNameClick(Sender: TObject);
    procedure pcProgramChange(Sender: TObject);
    procedure ReconnectTimerTimer(Sender: TObject);
    procedure btnAdjustClick(Sender: TObject);
    procedure btnContClick(Sender: TObject);
    procedure btnProgClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    function doProgramCchecks : boolean;
    procedure btnStopClick(Sender: TObject);
    procedure chkCutCapChange(Sender: TObject);
    procedure chkCutEnergyChange(Sender: TObject);

    procedure edtCutTimeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure rgChargeClick(Sender: TObject);
    procedure rgDischargeClick(Sender: TObject);
    procedure MainStatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
      var Accept: Boolean);
    procedure tbxMonitorChange(Sender: TObject);
    procedure tmrWaitTimer(Sender: TObject);
    procedure tsChargeEnter(Sender: TObject);
    procedure tsDischargeEnter(Sender: TObject);
    procedure fatalError(aMessage : string);


  private
    FRecvStatusIndicator: integer;
    FRecvStatusIndicatorInc : integer;
    FConfFile: string;
    FStartTime: TDateTime;
    FStepTime: TDateTime;
    FLastTime: TDateTime;
    FData: array of TCSVData;
    FAppDir: string;
  public
    FPackets: array of TPacket;
  private
    fLogFileIsOpen : boolean;
    fLogFileName : string;
    FPacketIndex: Integer;
    FLogFile: Text;
    FRunMode: TRunMode;
    FChecks: TChecks;
    FSampleCounter: Integer;
    FLastU: Extended;
    FLastI: Extended;
    FProgramStep: Integer; // Points to next step after LoadStep
    FCurrentStep: Integer; // Points to current/last step
    FDefault: TDefaults;
    FWaitCounter: Integer;
    FInProgram: Boolean;
    FEnergy: Extended;
    FStartU: Extended;
    FCurrentCapacity: array [TCapacity] of Extended;     // The capacity (Ah) measured so far from the current cycle
    FLastDisCapacity: Extended;     // Last capacity from the latest discharge cycle
    FCurrentDisCapacity: Extended;  // The capacity measured from the current discharge cycle
    FBeginWaitVoltage: Extended;
    FEndWaitVoltage: Extended;
    stText: array of TStaticText;
    FModels: array of TModel;
    FModel: Integer;
    FConn: TConnPacket;
    FConnState: TConnState;
    FUFactor: Extended;
    FIFactor: Extended;
    FShowJoule: Boolean;
    FShowCoulomb: Boolean;
    FDelta: array [0..1] of TDeltaValue;
    FDeltaIndex: Integer;
    FIntTime: Integer;
    FConnectRetryCountdown: Integer;
    fLanguageCode: String;
    procedure DoHexLog(AText: string);

    procedure SerialRec(Sender: TObject);
    function InterpretPackage(APacket: string; ANow: TDateTime) : boolean;
    procedure DumpSerialData(prefix,postfix: string; snd: string; Pos: Integer);
    procedure SendData(snd: string);
    function EncodeCurrent(Current: Extended): string;
    function EncodePower(Power: Extended): string;
    function DecodeCurrent(Data: string): Extended;
    function EncodeVoltage(Voltage: Extended): string;
    function DecodeVoltage(Data: string): Extended;
    function DecodeCharge(Data: string): Extended;
    function DecodeTimer(Data: string): Integer;
    function EncodeTimer(Data: Integer): string;
    procedure SaveCSVLine(var f: Text; ATime: Integer; ACurrent: Extended; AVoltage: Extended; CapacityEBC: Extended; CapacityLocal: Extended);
    procedure SaveCSV(AFile: string);
    function GetHexPacketFromIni(AIniFile: TMyIniFile; ASection: string; AIdent: string; ADefault: string = ''): string;
    procedure LoadPackets;
    procedure clearChargeDischargeTypes;
  public
    function PacketSupportedByCharger(chargerModel, PacketIndex : integer) : boolean;
  private
    procedure setChargeDischargeTypes(chargerModel : integer);

//    function MakePacket(AType: TSendMode): string;
    function NewMakePacket(Packet: Integer; AType: TSendMode): string;
    procedure SetupChecks;
    procedure FixLabels(APacket: Integer);
    procedure DoLog(AText: string);
    function StartLogging : boolean;
    procedure StopLogging;
    procedure LoadStep;
    function FindPacket(AName: string): Integer;
    function GetPointer(ARadioGroup: TRadioGroup): Integer;
    function MakePacket2(Packet: Integer; SendMode: TSendMode; TestVal, SecondParam: Extended; ATime: Integer; cutoffCurrent: Extended): string;
    function MakeConnPacket(SendMode: TSendMode): string;
    procedure EBCBreak(Force: Boolean = False; closeLogFile: Boolean = true); // Force = True terminates even if a program is running.
    procedure LogStep;
    procedure OffSetting; // Sets labels and button for "off".
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetSettings;
    function GetStepNum: string;
    function GetModelIndex(AModel: Integer): Integer;
public
    function GetModelIndex(AModel: string): Integer;
private
    procedure stTextClick(Sender: TObject);

    function GetEnergy(AEnergy: Extended): string;
    function GetCharge(ACharge: Extended): string;
    procedure FreezeEdits;
    procedure UnlockEdits;
    procedure RunModeOffOrMonitor;
    procedure SetRunMode(ARunMode: TRunMode);
    procedure TimerOff;
    procedure setStatusLine(Element:integer; txt:string);

    // StringGrid for step log helper routines
    procedure memStepLogClear;
    procedure memStepLogAdd (cmd : string);
    procedure memStepLogNewStep;                                                         // start a step
    procedure memStepLogUpdate  (AH,WH,startV,endV,endA : extended; time : TDateTime);   // updates values in current step
    procedure memStepLogEnd;                                                             // end of current step
    function  memStepLog2csv    (Separator : char) : TStringList;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

const
  cMemStepLog_step   = 0;
  cMemStepLog_cmd    = 1;
  cMemStepLog_AH     = 2;
  cMemStepLog_WH     = 3;
  cMemStepLog_time   = 4;
  cMemStepLog_startV = 5;
  cMemStepLog_endV   = 6;
  cMemStepLog_endA   = 7;


function ValOk(ANum: Extended): Boolean;
begin
  Result := not (IsNan(ANum));// or IsInf(ANum));
end;

function TextFileCopy(AInFile, AOutFile: string): Boolean;
var
  fi, fo: Text;
  s: string;
begin
  result := false;
  try
    if FileExists(AInFile) then
    begin
      AssignFile(fi, AInFile);
      AssignFile(fo, AOutFile);
      Reset(fi);
      ReWrite(fo);
      while not Eof(fi) do
      begin
        ReadLn(fi, s);
        WriteLn(fo, s);
      end;
      Flush(fo);
      CloseFile(fi);
      CloseFile(fo);
      Result := True;
    end;
   except
    Result := False;
  end;
end;

function AlignL(AStr: string; ALen: Integer): string;
begin
  Result := AStr;
  while Length(Result) < ALen do
  begin
    Result := Result + ' ';
  end;
end;

function AlignR(AStr: string; ALen: Integer): string;
begin
  Result := AStr;
  while Length(Result) < ALen do
  begin
    Result := ' ' + Result;
  end;
end;

function Round1V(U: Extended): Extended;
begin
  Result := 1 + Round(U + 0.500);
end;

function Round100mA(I: Extended): Extended;
begin
  Result := 0.1 + Round(I * 10 + 0.50) / 10;
end;

function NumEdtOk(AStr: string; out AVal: Extended): Boolean;
var
  Code: Integer;
begin
  Val(AStr, AVal, Code);
  Result := (Code = 0);
end;

function MyFloatStr(AVal: Extended): string;
begin
  Result := FloatToStrF(AVal, ffFixed, 18, 3);
end;

function MyTimeToStr(ATime: TDateTime): string;
begin
  Result :=  IntToStr(Trunc(ATime)) + ':' + FormatDateTime('hh:mm:ss', ATime);
end;

function HexToOrd(s: string): Integer;
var
  I: Integer;
  M: Integer;
begin
  Result := 0;
  M := 1;
  for I := Length(s) downto 1 do
  begin
    if s[I] in ['0'..'9'] then
    begin
      Result := Result + M * (Ord(s[I]) - Ord('0'));
    end else if s[I] in ['A'..'F'] then
    begin
      Result := Result + M * (Ord(s[I]) - Ord('A') + 10);
    end;
    M := M * $10;
  end;
end;

function FormatPath(APath: string): string; // Removes "//" or "\\" from paths
var
  P: integer;
  s: string;
begin
  s := PathDelim + PathDelim;
  repeat
    P := Pos(s, APath);
    if P > 0 then
    begin
      APath := Copy(APath, 1, P - 1) + Copy(APath, P + 1, Length(APath));
    end;
  until P = 0;
  Result := APath;
end;

function checksum(s: string; Pos: Integer): Char; // Seems EBC uses a stupid XOR CRC
var
  I: Integer;
begin
  Result := #0;
  if length(s) < Pos then exit;   // AD: sigsegv here when usb disconnects
  for I := 2 to Pos - 1 do
    Result := Chr(Ord(Result) xor Ord(s[I]));
  (* AD: EBC-A20 does not accept start/stop chars as checksum
         This happens e.g. for charge @ 4.20/4.22V, 1A and 0.1A cutoff
         The Windows software sends $0a and $0f in that case so lets do the same here *)
  // looks like the A40 never sends checksums >= 0xf0 so lets do the same
  if (byte(result) and $f0 = $f0) then
    result := char(byte(result) and $0f);
end;

{ TfrmMain }

procedure TfrmMain.fatalError(aMessage : string);
begin
  Application.MessageBox(pchar(aMessage),pchar(cFatal),MB_ICONSTOP);
  Application.Terminate;
end;

procedure TfrmMain.SerialRec(Sender: TObject);
var
  s: string;
  r: string;
  N: Integer;
  E: TDateTime;
  startFound: boolean;
  rBuf: string;
begin
  r := '';
  N := 0;
  E := Now;
  startFound := false;
  rBuf := '';

  // AD: wait for start char
  repeat
    s := Serial.ReadData;
    if Length(s) > 0 then
    begin
      rBuf := rBuf + s;
      while (length(s) > 0) and (s[1] <> #$FA) do
        delete(s,1,1);
      if (length(s) > 0) then
      begin
        startFound := true;
        r := s;
      end;
    end;
  until (startFound) or (MillisecondsBetween(Now, E) > 200);
  N := Length(r);

  repeat
    s := Serial.ReadData;
    if Length(s) > 0 then
    begin
      r := r + s;
      rBuf := rBuf + s;
      Inc(N, Length(s));
    end;
  until (N >= 19) or (MillisecondsBetween(Now, E) > 200);
  DumpSerialData('<','', rBuf, 0);
  while N >= 19 do
  begin
    s := copy(r,1,19); delete(r,1,19); dec(N,19);
    if length(s) = 19 then
    begin
      if InterpretPackage(s, E) then  // false if checksum is invalid
      begin
        FRecvStatusIndicator := FRecvStatusIndicator + FRecvStatusIndicatorInc;
        MainStatusBar.invalidate;
        //Application.ProcessMessages;
        if FConnState = csConnecting then
        begin
          FModel := GetModelIndex(Ord(s[17]));
          if FModel > -1 then
          begin
            ReconnectTimer.Enabled:=false;
            ConnectionWatchdogTimer.Enabled:=true;
            setStatusLine(cst_ConnectionStatus,cConnected);
            setStatusLine(cst_ConnectedModel,FModels[FModel].Name);
            tbxMonitor.Enabled := True;
            rgCharge.Enabled := True;
            rgDischarge.Enabled := True;
            FConnState := csConnected;
            FUFactor := FModels[FModel].UFactor;
            FIFactor := FModels[FModel].IFactor;
            setChargeDischargeTypes(FModel);
            edtChargeV.Enabled:=false;
            frmStep.setDevice(FModels[FModel].Name);
            if length(frmStep.fileName) > 0 then
              if frmStep.Compile(fModel,true) = mrOk then
              begin
                pcProgram.ActivePage := tsProgram;
                btnStart.enabled := true;
              end;
          end;
        end else
        begin
          ConnectionWatchdogTimer.Enabled:=false;
          ConnectionWatchdogTimer.Enabled:=true;  // does this reset the timer ?
        end;
      end
      else
        doLog(Format(cInvalidChecksum,[r]));
    end;
  end;
  FLastTime := E;
end;

function TfrmMain.InterpretPackage(APacket: string; ANow: TDateTime) : boolean;
var
  P, tmp: Extended;
  dT: Integer;
  T: TDateTime;
  chkIsValid : boolean;
  chk : char;
  TSec : longint;
begin
  result := false;
  if FSampleCounter > 0 then
  begin
    dT := MillisecondsBetween(ANow, FLastTime);
  end else
    dT := 2000;

  T := ANow - FStartTime;
  TSec := SecondsBetween(ANow,FStartTime);
  if (TSec < 0) then tSec := 0;

  chkIsValid := frmSettings.cgSettings.Checked[cIgnoreCRC];
  if not chkIsValid then
  begin
    chk := checksum(APacket, crcrecvpos);
    chkIsValid := (chk = APacket[crcrecvpos]);
  end;

  if chkIsValid then
  begin
    if frmSettings.cgSettings.Checked[cLogRecData] then
       DumpSerialData('<','',APacket,crcrecvpos);

    result := true;
    try
      FLastI := DecodeCurrent(Copy(APacket, 3, 2));
    except
      on e:exception do  // was for divide by zero check, only visible under windows, fixed
        doLog(format(cDecodeCorrentException,[e.Message,byte(APacket[3]), byte(APacket[4])]));
    end;
    try
      FLastU := DecodeVoltage(Copy(APacket, 5, 2));
    except
      on e:exception do
        doLog(format(cDecodeVoltageException,[e.Message,byte(APacket[5]), byte(APacket[6])]));
    end;

    FCurrentCapacity[caEBC] := DecodeCharge(Copy(APacket, 7, 2));
    FCurrentCapacity[caLocal] := FCurrentCapacity[caLocal] + FLastI * dT / 3600000;

    stText[cstVoltage].Caption := MyFloatStr(FLastU) + 'V';
    stText[cstCurrent].Caption := MyFloatStr(FLastI) + 'A';
    P := FLastU * FLastI;
    stText[cstPower].Caption := FloatToStrF(P, ffFixed, 18, 3) + 'W';

    //if FCurrentCapacity[caEBC] < 10 then
    stText[cstCapacity].Caption := GetCharge(FCurrentCapacity[caEBC]);
    //else
    //  stText[cstCapacity].Caption := 'See device';  // FIXME, AD: fixed GetCharge

    stText[cstCapLocal].Caption := GetCharge(FCurrentCapacity[caLocal]) + '(PC)';
    tmp := (P * dT) / 3600000;
    if ValOk(tmp) then
    begin
      FEnergy := FEnergy + tmp;
      stText[cstEnergy].Caption := GetEnergy(FEnergy);
    end;
    stText[cstTime].Caption := MyTimeToStr(T);

    if FLastI <> 0 then
    begin
      tmp := FLastU / FLastI;
      if ValOk(tmp) then
        stText[cstResistance].Caption := MyFloatStr(tmp) + cR;
    end;


    if FInProgram then
      lblProgTime.Caption := TimeToStr(ANow - FStepTime);

    if not (FRunMode in [rmNone]) then
    begin
      SetLength(FData, Length(FData) + 1);
      with FData[Length(FData) - 1] do
      begin
        //vTime := DecodeTimer(Copy(APacket, 15, 2));
        // AD: use time from PC
        vVoltage := FLastU;
        vCurrent := FLastI;
        CapacityEBC := FCurrentCapacity[caEBC];
        CapacityLocal := FCurrentCapacity[caLocal];
        if fLogFileIsOpen then
        begin
          SaveCSVLine(FLogFile, TSec{vTime}, FLastI, FLastU, FCurrentCapacity[caEBC], FCurrentCapacity[caLocal]);
          Flush(FLogFile);
        end;
      end;
      lsVoltage.AddXY(T, FLastU);
      lsInvisibleVoltage.AddXY(0, Round1V(FLastU));
      lsCurrent.AddXY(T, FLastI);
      lsInvisibleCurrent.AddXY(0, Round100mA(FLastI));
    end;

    FDelta[FDeltaIndex].SumV := FDelta[FDeltaIndex].SumV + FLastU;
    FDelta[FDeltaIndex].SumA := FDelta[FDeltaIndex].SumA + FLastI;
    Inc(FDelta[FDeltaIndex].Values);

{      if dT <> 0 then
    begin
      stText[cstdV].Caption := FloatToStrF((1000000 * (FLastU - lU)) / (dT ), ffFixed, 18, 2) + 'mV/s';
      stText[cstdA].Caption := FloatToStrF((1000000 * (FLastI - lI)) / (dT ), ffFixed, 18, 2) + 'mA/s';
    end;
}

    dT := MillisecondsBetween(FDelta[FDeltaIndex].Time, ANow);
    if dT >= FIntTime then if dT <> 0 then
    begin
      FDelta[FDeltaIndex].SumV := FDelta[FDeltaIndex].SumV / FDelta[FDeltaIndex].Values;
      FDelta[FDeltaIndex].SumA := FDelta[FDeltaIndex].SumA / FDelta[FDeltaIndex].Values;
      if ValOk(FDelta[FDeltaIndex].SumA) then if ValOk(FDelta[FDeltaIndex].SumV) then
      begin
        tmp := (FDelta[FDeltaIndex].SumV - FDelta[FDeltaIndex xor $01].SumV) / dT;
        if ValOk(tmp) then
        begin
          stText[cstdV].Caption := FloatToStrF(60000000 * tmp , ffFixed, 18, 2) + 'mV/m';
        end;
        tmp := (FDelta[FDeltaIndex].SumA - FDelta[FDeltaIndex xor $01].SumA) / dT;
        if ValOk(tmp) then
        begin
          stText[cstdA].Caption := FloatToStrF(60000000 * tmp, ffFixed, 18, 2) + 'mA/m';
        end;
      //  stText[cstDbg1].Caption :=   IntToStr(FDelta[FDeltaIndex].Values);
      //  stText[cstDbg2].Caption := FloatToStr(FDelta[FDeltaIndex].SumV);
      //  stText[cstDbg3].Caption := 'Index: ' + IntToStr(FDeltaIndex) + ' : ' + IntToStr(FDeltaIndex xor $01);
      end;
      FDeltaIndex := FDeltaIndex xor $01;
      FDelta[FDeltaIndex].SumV := 0;
      FDelta[FDeltaIndex].SumA := 0;
      FDelta[FDeltaIndex].Values := 0;
      FDelta[FDeltaIndex].Time := ANow;
    end;

    Inc(FSampleCounter);

    if (FRunMode = rmDischargingCR) and (FSampleCounter mod 3 = 0) then
    begin
      SendData(NewMakePacket(FPacketIndex, smAdjust));
    end;

    // AutoOff check
    if (not (FRunMode in [rmNone, rmMonitor, rmWait, rmLoop])) and
       ((APacket[2] = FPackets[FPacketIndex].AutoOff) or ((FSampleCounter > 3) and (FLastI < 0.0001))) then
         if FInProgram then EBCBreak(false,false) else EBCBreak;

    // Cutoff checks
    if (FRunMode = rmCharging) and (FSampleCounter > 3) then
    begin
      if FLastI < FChecks.cCurrent then
      begin
        if FChecks.TimerRunning then
        begin
          DoLog(cTime+': ' + IntToStr(SecondsBetween(FChecks.ThresholdTime, Now)));
          if SecondsBetween(FChecks.ThresholdTime, Now) div 60 >= FChecks.cDwellTime then
            if FInProgram then EBCBreak(false,false) else EBCBreak;
        end else
        begin
          FChecks.ThresholdTime := Now;
          FChecks.TimerRunning := True;
          DoLog('Timer '+cStarted+'.');
          if FChecks.cDwellTime = 0 then
            if FInProgram then EBCBreak(false,false) else EBCBreak;
        end;
      end;
      if FCurrentCapacity[caEBC] > FChecks.cCapacity then
        if FInProgram then EBCBreak(false,false) else EBCBreak;
    end;
    LogStep;
  end else
  begin
    DumpSerialData('<','CRC '+cError+':', APacket, crcrecvpos);
  end;
end;

procedure TfrmMain.DumpSerialData(prefix,postfix: string; snd: string; Pos: Integer);
var
  s: string;
  I: Integer;
begin
  s := '';
  for I := 1 to Length(snd) do
  begin
    s := s + LowerCase(IntToHex(Ord(snd[I]),2));
//    if I < Length(snd) then s := s + '|';
  end;
  if (pos > 0) and (pos <= length(snd)) then
    DoHexLog(prefix + ' ' + s + ' ' + IntToHex(Ord(checksum(snd, Pos)),2) + ' ' + postfix)
  else
    DoHexLog(prefix + ' ' + s + ' ' + postfix);
end;

procedure TfrmMain.SendData(snd: string);
var
  s: string;
begin
  FRecvStatusIndicator := FRecvStatusIndicator + FRecvStatusIndicatorInc;
  Application.ProcessMessages;
  if Length(snd) > 7 then
  begin
    s := snd;
    s[crcsendpos] := checksum(s, crcsendpos);
    Serial.WriteData(s);
    DumpSerialData('>','', s, crcsendpos);
  end;
end;

function TfrmMain.EncodeVoltage(Voltage: Extended): string;
var
  V: Extended;
  H, L: Integer;
begin
  V := FUFactor * Voltage * 1000;
  H := Trunc(V / 2400);
  L := Trunc(V - (2400 * H)) div 10;
  Result := Chr(H) + Chr(L);
end;

function TfrmMain.EncodeCurrent(Current: Extended): string;
var
  V: Extended;
  H, L: Integer;
begin
  V := FIFactor * Current * 1000; // Convert to mA
  H := Trunc(V / 2400);
  L := Trunc(V - (2400 * H)) div 10;
  Result := Chr(H) + Chr(L);
end;

function TfrmMain.EncodePower(Power: Extended): string;
var
  P: Extended;
  H, L: Integer;
begin
  P := Power;
  H := Round(P / 240);
  L := Trunc(P - (240 * H));
  Result := Chr(H) + Chr(L);
end;

function TfrmMain.EncodeTimer(Data: Integer): string;
var
  H, L: Integer;
begin
  H := Data div 240;
  L := Data - (240 * H);
  Result := Chr(H) + Chr(L);
end;

function TfrmMain.DecodeCurrent(Data: string): Extended;
begin
  Result := (Ord(Data[1])*2400 + 10*Ord(Data[2])) / 1000;
  if FIFactor > 0 then result := Result / FIFactor;
end;

function TfrmMain.DecodeVoltage(Data: string): Extended;
begin
  Result := (Ord(Data[1])*2400 + 10*Ord(Data[2])) / 10000;
  if FUFactor > 0 then Result := Result / FUFactor;
end;

function TfrmMain.DecodeCharge(Data: string): Extended;
begin
  // AD: taken from github.com/dev-strom/esp-ebc-mqtt/blob/main/lib/commands/EbcA20.cpp

  //if (source & 0x8000) {
  if (byte(Data[1]) and $80) = $80 then
  begin
    // capacity >= 10.0 Ah
    // AD: 04/2024 this is not correct at least for the A20 and A40, may be
    // for other chargers ?
    {
    if byte(Data[1]) and $0E = $0E then
    begin
      // capacity >= 200.0 Ah
      //value = ((static_cast<double> ((((source >> 8) & 0x3F) * 240) + (source & 0xFF) - 0x1C00)) / 10.0);
      result := (((byte(Data[1]) and $3F) * 240) + byte(Data[2]) - $1C00) / 10.0;
    end else
    }
    // capacity < 200.0 Ah
    // AD: works as well for >200AH, at least for my 230AH battery
    //value = ((static_cast<double> ((((source >> 8) & 0x7F) * 240) + (source & 0xFF) - 0x0800)) / 100.0);
    result := (((byte(Data[1]) and $7F) * 240) + byte(Data[2]) - $0800) / 100.0;
  end else
    // capacity < 10.0 Ah
    Result := (byte(Data[1])*240 + byte(Data[2])) / 1000;
end;


function TfrmMain.DecodeTimer(Data: string): Integer;
begin
  Result := Ord(Data[1])*240 + Ord(Data[2]);
end;

procedure TfrmMain.SaveCSVLine(var f: Text; ATime: Integer; ACurrent: Extended;
  AVoltage: Extended; CapacityEBC: Extended; CapacityLocal: Extended);
begin
  WriteLn(f, ATime, #9, MyFloatStr(ACurrent), #9, MyFloatStr(AVoltage), #9, MyFloatStr(CapacityEBC), #9, MyFloatStr(CapacityLocal));
end;



procedure TfrmMain.SaveCSV(AFile: string);
var
  f: Text;
  I: Integer;
begin
  AssignFile(f, AFile);
  Rewrite(f);
  for I := 0 to Length(FData) - 1 do
    SaveCSVLine(f, FData[I].vTime, FData[I].vCurrent, FData[I].vVoltage, FData[I].CapacityEBC, FData[I].CapacityLocal);
  Flush(f);
  CloseFile(f);
end;

function TfrmMain.GetHexPacketFromIni(AIniFile: TMyIniFile; ASection: string;
  AIdent: string; ADefault: string): string;
var
  s, r: string;
  P: Integer;
begin
  s := UpperCase(AIniFile.ReadString(ASection, AIdent, ADefault));
  r := '';
  P := 1;
  while P <= Length(s) do
  begin
    r := r + Chr(HexToOrd(Copy(s, P, 2)));
    Inc(P, 2);
    if P <= Length(s) then
    begin
      if s[P] = ' ' then
      begin
        Inc(P);
      end;
    end;
  end;
  Result := r;
end;

procedure TfrmMain.clearChargeDischargeTypes;
begin
  rgCharge.Items.Clear;
  rgDischarge.Items.Clear;
end;


function TfrmMain.PacketSupportedByCharger(chargerModel, PacketIndex : integer) : boolean;
var supportedModel : Integer;
begin
  with FPackets[PacketIndex] do
  begin
    result := (Length(SupportedModels) = 0);   // all models
    if not result then
      for supportedModel in SupportedModels do
        if supportedModel = (chargerModel+1) then result:=true;
  end;
end;

// set the charge/discharge types allowed for the given model in the
// rgCharge/rgDisCharge radio groups
procedure TfrmMain.setChargeDischargeTypes(chargerModel : integer);
var i : Integer;
begin
  clearChargeDischargeTypes;
  for I := Low(FPackets) to High(FPackets) - 1 do
    if PacketSupportedByCharger(chargerModel,i) then
      with FPackets[i] do
        case Method of
          mChargeCV,
          mCharge      : rgCharge.Items.AddObject(Name, TObject(Pointer(i)));
          mDischarge,
          mDischargeCR,
          mDischargeCP : rgDisCharge.Items.AddObject(Name, TObject(Pointer(i)));
        end;
end;

procedure TfrmMain.LoadPackets;
var
  ini: TMyIniFile;
  I, P: Integer;
  N: Integer;
  s,s2,fixedCmd: string;
  Sec: string;

  function findPacketIndex(command:string):integer;
  var
    i : integer;
  begin
     if(command = '') then
     begin
       result := -1; exit;
     end;
     for I := Low(FPackets) to High(FPackets) - 1 do
       //writeln(format('"%S" "%S"',[command,FPackets[i].Command]));
       if FPackets[i].Command = command then
       begin
         result := i;
         exit;
       end;
     Application.MessageBox(pchar(format(cPacketNotInConfFile,[command])),pchar(cError),MB_ICONSTOP);
     result := -1;
  end;

begin
  clearChargeDischargeTypes;
  SetLength(FPackets, 0);
  ini := TMyIniFile.Create(FConfFile);
  N := 0;
  I := 0;
  repeat
    Sec := IntToStr(I);
    s := ini.ReadString(Sec, cCommand, '');
    if s > '' then
    begin
      s2 := AnsiLowerCase(s);
      for fixedCmd in c_FixedCmds do
        if fixedCmd = s2 then s := '';  // ignore fixed commands in old config files
    end;
    if s > '' then
    begin
      N := 0;
      SetLength(FPackets, Length(FPackets) + 1);
      P := Length(FPackets) - 1;
      with FPackets[P] do
      begin
        Command := UpperCase(s);
        Start := GetHexPacketFromIni(ini, Sec, cStart);
        Adjust := GetHexPacketFromIni(ini, Sec, cAdjust);
        Cont := GetHexPacketFromIni(ini, Sec, cCont);
        Name := ini.ReadString(Sec, cName, 'Noname');
        AutoOff := GetHexPacketFromIni(ini, Sec, cAutoOff, 'FF');
        VoltInfo := ini.ReadFloat(Sec, cVoltInfo, 0);
        DefChargeCurrent := ini.ReadFloat(Sec, cDefChargeCurrent, 0);
        DefDischargeCurrent := ini.ReadFloat(Sec, cDefDischargeCurrent, 0);
        DefCutoffCurrent := ini.ReadFloat(Sec, cCutA, 0);
        EnableNumCells := ini.ReadBool(sec,cEnableNumCells,false);
        try
          ini.ReadIntegers(Sec, cModels, SupportedModels);
        except
          on e:exception do
            Application.MessageBox(pchar(Format(cErrorReadingModelFromSec,[e.Message,FConfFile,P])),pchar(cError),MB_ICONSTOP);
        end;
        s := ini.ReadString(Sec, cTestVal, 'I');
        if s = 'P' then
        begin
          TestVal := tvPower;
        end else if s = 'R' then
        begin
          TestVal := tvResistance;
        end else
        begin
          TestVal := tvCurrent;
        end;
        s := ini.ReadString(Sec, cMethod, '');
        if s = cCharge then
          Method := mCharge
        else if s = cDischarge then
          Method := mDischarge
        else if s = cDischargeCP then
          Method := mDischargeCP
        else if s = cDischargeCR then
          Method := mDischargeCR
        else if s = cChargeCV then
          Method := mChargeCV
        else
          Method := mNone;
      end;
    end else
    begin
      Inc(N);
    end;
    Inc(I);
  until N > 10; // Allow for a spacing of 10 in settings file

  if Length(FPackets) < 1 then
  begin
    fatalError(format(cNoChargeDischargeProfile,[FConfFile]));
    exit;
  end;
  // read models
  SetLength(FModels, 0);
  N := 0;
  I := 0;
  frmStep.edtDevice.Items.Clear;
  repeat
    Sec := IntToStr(I);
    s := ini.ReadString(cModels, cModelName + Sec, '');
    if s > '' then
    begin
      N := 0;
      frmStep.edtDevice.Items.Add(s);
      SetLength(FModels, Length(FModels) + 1);
      with FModels[Length(FModels) - 1] do
      begin
        FModels[Length(FModels) - 1].Name := s;
        ConnState := csNone;
        Ident := ini.ReadInteger(s, cIdent, -1);
        if (Ident < 0) then
        begin
          fatalError(format(cIdentModelNotFound,[Length(FModels),FConfFile]));
          Exit;
        end;
        IFactor := ini.ReadFloat(s, cIFactor, 1);
        UFactor := ini.ReadFloat(s, cUFactor, 1);
        ConnPackets.Connect := GetHexPacketFromIni(ini, s, cConnect);
        ConnPackets.Disconnect := GetHexPacketFromIni(ini, s, cDisconnect);
        ConnPackets.Stop := GetHexPacketFromIni(ini, s, cStop);
        CommandFormat := ini.ReadInteger(s, cCommandFormat, 0);
        MaxChargeVoltage := ini.ReadFloat(s,cMaxChargeVoltage,0);
        MaxChargeCurrent := ini.ReadFloat(s,cMaxChargeCurrent,0);
        MaxDischargeCurrent := ini.ReadFloat(s,cMaxDischargeCurrent,0);
      end;
    end else
    begin
      Inc(N);
    end;
    Inc(I);
  until N > 10;
  if length(FModels) < 1 then
  begin
    fatalError(format(cNoModelsDefined,[FConfFile]));
    exit;
  end;
  SetLength(FModels, Length(FModels) + 1);
  FModels[High(FModels)] := FModels[0];
  FModels[High(FModels)].Name := cUnknown;

  FConn.Connect := GetHexPacketFromIni(ini, cConn, cConnect);
  if length(FConn.Connect) < 1 then
  begin
    fatalError(format(cNoConnectPackage,[FConfFile]));
    exit;
  end;
  FConn.Disconnect := GetHexPacketFromIni(ini, cConn, cDisconnect);
  if length(FConn.Disconnect) < 1 then
  begin
    fatalError(format(cNoDisconnectPackage,[FConfFile]));
    exit;
  end;
  FConn.Stop := GetHexPacketFromIni(ini, cConn, cStop);
  ini.Free;
end;

function round2(const Number: extended; const Places: longint): extended;
var t: extended;
begin
   t := power(10, places);
   round2 := round(Number*t)/t;
end;


function TfrmMain.NewMakePacket(Packet: Integer; AType: TSendMode): string;
var
  numCells : integer;
begin
  case FPackets[Packet].Method of
    mCharge    : Result := MakePacket2(Packet, AType, edtTestVal.Value, edtCells.Value, edtCutTime.Value, round2(edtCutA.Value,2));
    mChargeCV  : begin
                   if FPackets[Packet].EnableNumCells then              // A20/A40
                      numCells := edtCells.Value
                   else
                      numCells := 1;
                   if numCells < 1 then numCells := 1;
                   Result := MakePacket2(Packet, AType, edtTestVal.Value, edtChargeV.Value * numCells, edtCutTime.Value, round2(edtCutA.Value,2));
                 end;
    mDischarge,
    mDischargeCR,
    mDischargeCP: Result := MakePacket2(Packet, AType, edtTestVal.Value, edtCutV.Value, edtCutTime.Value, 0);
  end;
end;

function TfrmMain.MakePacket2(Packet: Integer; SendMode: TSendMode; TestVal,
  SecondParam: Extended; ATime: Integer; cutoffCurrent : Extended): string;
var
  p1, p2, p3: string;
  T: Extended;
  LTime: Integer;
begin
  Result := '';
  case SendMode of
  smStart:
    Result := FPackets[Packet].Start;
  smCont:
    Result := FPackets[Packet].Cont;
  smAdjust:
    Result := FPackets[Packet].Adjust;
  smConnStop: begin
    result := FModels[FModel].ConnPackets.Stop;  // AD: was missing
    exit;
  end;
  smConnect:;
  smDisconnect:;
  end;
  if Result > '' then
  begin
    if (FPackets[Packet].Method = mChargeCV) and (FModels[FModel].CommandFormat = 1) then     // AD: for EBC-A20
    begin
      // TODO: make steps work, number of cells
      p1 := EncodeCurrent(round2(TestVal,2));      // current
      p2 := EncodeVoltage(round2(SecondParam,2));  // voltage without round we will get 4.219999999 when 4.22 is requested
      P3 := EncodeCurrent(cutoffCurrent);
      doLog(format('EBC-A20: p1:%g p2:%g p3: %g',[round2(TestVal,2),round2(edtChargeV.Value,2),round2(edtCutA.Value,2)]));
    end else
    begin
      if ATime = 250 then  //250 is a forbidden value for some reason
      begin
        LTime := 249;
       end else
       begin
         LTime := ATime;
      end;
      p3 := EncodeTimer(LTime);
      case FPackets[Packet].TestVal of
        tvCurrent:
        begin
          p1 := EncodeCurrent(TestVal);
          if FPackets[Packet].Method = mCharge then
          begin
            p2 := Chr(0) + Chr(Round(SecondParam));
          end else
          begin
            p2 := EncodeVoltage(SecondParam);
          end;
        end;
        tvPower:
        begin
          p1 := EncodePower(TestVal);
          p2 := EncodeVoltage(SecondParam);
        end;
        tvResistance:
        begin
          T := FLastU / TestVal;
          p1 := EncodeCurrent(T);
          p2 := EncodeVoltage(SecondParam);
        end;
      end;
    end;
    Result[3] := p1[1];
    Result[4] := p1[2];
    Result[5] := p2[1];
    Result[6] := p2[2];
    Result[7] := p3[1];
    Result[8] := p3[2];
    DoLog (format('command paramaters %s %s %s:',
      [inttohex(byte(P1[1]))+inttohex(byte(P1[2])),
       inttohex(byte(P2[1]))+inttohex(byte(P2[2])),
       inttohex(byte(P3[1]))+inttohex(byte(P3[2]))]));
//    Result[crcsendpos] := checksum(Result, crcsendpos);
  end;
end;


function TfrmMain.MakeConnPacket(SendMode: TSendMode): string;
begin
  Result := '';
  if FModel >- 1 then
  begin
    case SendMode of
      smConnStop: Result := FModels[FModel].ConnPackets.Stop;
      smConnect:
      begin
        Result := FConn.Connect; // This should not happen, defaulting to general connect string
        //Result := FModels[FModel].ConnPackets.Connect;
      end;
      smDisconnect: Result := FModels[FModel].ConnPackets.Disconnect;
    end;
  end else
  case SendMode of
    smConnStop   : Result := FConn.Stop;
    smConnect    : Result := FConn.Connect;
    smDisconnect : Result := FConn.Disconnect;
  end;
end;

procedure TfrmMain.EBCBreak(Force: Boolean; closeLogFile: Boolean = true);
var
  fn : string;
  sl: text;
  i : integer;
  lines : TStringList;
begin
  btnSkip.Enabled := False;
  mm_skipStep.Enabled := False;
  if frmSettings.cgSettings.Checked[cForceMon] then
    tbxMonitor.Checked := True;
  FChecks.TimerRunning := False;
  SendData(MakeConnPacket(smConnStop));
  RunModeOffOrMonitor;
  //if mm_AutoLog.Checked then
  //  if closeLogFile then
  //    StopLogging;

  if FInProgram then
  begin
    LogStep;
    memStepLogEnd;
    if Force then
    begin
      FInProgram := False;
      if fLogFileIsOpen then
      begin
        fn := ChangeFileExt(fLogFileName,'.steplog');
        StopLogging;
        // write the step log to the same filename as the csv but with
        // different extension
        if length(fn)>0 then
        begin
          InOutRes := 0;
          System.assign(sl,fn);
          Rewrite(sl);
          if IOResult = 0 then
          begin
            lines := memStepLog2csv(#9);
            for i := 0 to Lines.Count-1 do
              writeln(sl,Lines[i]);
            system.close(sl);
          end else
            MessageDlg(cError,Format(cStepLogCreateErr,[fn,IOResult]), mtError,[mbAbort],0);
        end;
      end;
      beep;
    end else if FWaitCounter = 0 then
      LoadStep;
  end else
  begin
    memStepLogEnd;
    OffSetting;
    StopLogging;
    beep;
  end;
end;

function TfrmMain.GetModelIndex(AModel: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(FModels) to High(FModels) - 1 do
  begin
    if AModel = FModels[I].Ident then
    begin
      Result := I;
      Break;
    end;
  end;
  if Result = -1 then
  begin
    FModels[High(FModels)].Name := IntToStr(AModel) + ' ' + cUnknown;  // AD: is decimal in conf so report it as in conf
    Result := High(FModels);
  end;
end;


function TfrmMain.GetModelIndex(AModel: String): Integer;
var I: Integer;
begin
  Result := -1;
  for I := Low(FModels) to High(FModels) - 1 do
    if AModel = FModels[I].Name then exit(i);
end;


procedure TfrmMain.stTextClick(Sender: TObject);
begin
  if Sender is TStaticText then
  begin
    case (Sender as TStaticText).Tag of
      cstEnergy:
      begin
        FShowJoule := not FShowJoule;
        stText[cstEnergy].Caption := GetEnergy(FEnergy);
      end;
      cstCapacity:
      begin
        FShowCoulomb := not FShowCoulomb;
        stText[cstCapacity].Caption := GetCharge(FCurrentCapacity[caEBC]);
      end;
    end;
  end;
end;

function TfrmMain.GetEnergy(AEnergy: Extended): string;
begin
  if FShowJoule then
    Result := MyFloatStr(AEnergy * 3.600) + 'kJ'
  else
    Result := MyFloatStr(AEnergy) + 'Wh';
end;

function TfrmMain.GetCharge(ACharge: Extended): string;
begin
  if FShowCoulomb then
    Result := FloatToStrF(ACharge * 3600, ffFixed, 18, 1) + 'As'
  else
    Result := MyFloatStr(ACharge) + 'Ah';
end;



procedure TfrmMain.FreezeEdits;
begin
  edtCells.Enabled := False;
  edtChargeV.Enabled := False;
  edtCutA.Enabled := False;
  edtCutM.Enabled := False;
  edtTestVal.Enabled := False;
  edtCutTime.Enabled := False;
  edtCutEnergy.Enabled := False;
  chkCutEnergy.Enabled := False;
  edtCutCap.Enabled := False;
  chkCutCap.Enabled := False;
  edtCutV.Enabled := False;
  rgCharge.Enabled := False;
  rgDischarge.Enabled := False;
  frmSettings.edtIntTime.Enabled := False;
end;

procedure TfrmMain.UnlockEdits;
var
  I: Integer;
begin
  rgCharge.Enabled := True;
  rgDischarge.Enabled := True;
  edtCutA.Enabled := True;
  edtCutM.Enabled := True;
  edtTestVal.Enabled := True;
  edtCutTime.Enabled := True;
  edtCutEnergy.Enabled := True;
  chkCutEnergy.Enabled := True;
  edtCutCap.Enabled := True;
  chkCutCap.Enabled := True;
  edtCutV.Enabled := True;
  frmSettings.edtIntTime.Enabled := True;
  I := GetPointer(rgCharge);
  if I >-1 then if FPackets[I].Method = mChargeCV then
  begin
    edtChargeV.Enabled := True;
    edtCells.Enabled := FPackets[I].EnableNumCells;
    //edtChargeV.Value := FPackets[I].VoltInfo;
  end else
  begin
    edtChargeV.Enabled:=false;
    edtCells.Enabled := True;
    //edtChargeV.Value := dtCells.Value * FPackets[I].VoltInfo;
  end;
end;


procedure TfrmMain.RunModeOffOrMonitor;
begin
  if tbxMonitor.Checked then
    SetRunMode(rmMonitor)
  else
    SetRunMode(rmNone);
end;

procedure TfrmMain.SetRunMode(ARunMode: TRunMode);
begin
  FRunMode := ARunMode;
  case FRunMode of
    rmNone          : setStatusLine(cst_RunMode,'-');
    rmMonitor       : setStatusLine(cst_RunMode,'M');
    rmCharging      : setStatusLine(cst_RunMode,'C');
    rmDischarging   : setStatusLine(cst_RunMode,'D');
    rmDischargingCR : setStatusLine(cst_RunMode,cR);
    rmWait          : setStatusLine(cst_RunMode,'W');
    rmLoop          : setStatusLine(cst_RunMode,'L');
    rmEnd           : setStatusLine(cst_RunMode,'E');
  end;
end;

procedure TfrmMain.TimerOff;
begin
  lblTimer.Caption := '';
  tmrWait.Enabled := False;
  FEndWaitVoltage := FLastU;
  LogStep;
  memStepLogEnd;
  LoadStep;
end;

function TfrmMain.GetStepNum: string;
var
  I: Integer;
begin
  Result := '';
  for I := High(FSteps) downto Low(FSteps) do
  begin
    if FSteps[I].Command = 'LOOP' then
      Result := AlignR(IntToStr(FSteps[I].LoopCounter), 3) + ':' + Result;
  end;
{  if Length(Result) > 0 then
  begin
    if Result[Length(Result)] = ':' then
    begin
      Result := Copy(Result, 1, Length(Result) - 1);
    end;
  end;}
  Result := Result + IntToStr(FProgramStep);
end;

procedure TfrmMain.LogStep;
begin
  if not FInProgram then exit;

  case FSteps[FCurrentStep].Mode of
    rmNone:;
    rmCharging, rmDischarging, rmDischargingCR:
      memStepLogUpdate (FCurrentCapacity[caEBC],FEnergy,FStartU,FLastU,FLastI,Now - FStepTime);
    rmWait:
      memStepLogUpdate (FCurrentCapacity[caEBC],0,FBeginWaitVoltage,FEndWaitVoltage,0,Now - FStepTime);
    rmLoop:
      memStepLogUpdate (0,0,0,0,0,Now - FStepTime);
    rmEnd:;
  end;
end;

procedure TfrmMain.OffSetting;
begin
  tsCharge.Enabled := True;
  tsDisCharge.Enabled := True;
  btnStop.Enabled := False;
  btnStart.Enabled := True;
  btnAdjust.Enabled := False;
  if fConnState = csConnected then
    tbxMonitor.Enabled := True
  else
    tbxMonitor.Enabled := False;
  FInProgram := False;
  frmStep.memStep.Enabled := True;
  btnProg.Caption := cEdit;
  tmrWait.Enabled := False;
  lblTimer.Caption := '';
  lblCapI.Enabled := False;
  shaCapI.Enabled := False;
  shaCapI.Brush.Color := clDefault;
  lblStep.Caption := '';
  lblStepNum.Caption := '';
  btnSkip.Enabled := False;
  mm_skipStep.Enabled := False;
  UnlockEdits;
end;

procedure TfrmMain.LoadSettings;
var
  ini: TMyIniFile;
  s, t: string;
  I,maxI: Integer;
  StepLogWidths:TIntegerDynArray;

  procedure loadFormSize(Sec,Prefix: string; frm: TForm);
  var i : integer;
  begin
    i := ini.ReadInteger(Sec, Prefix+'_Top', frm.Top);
    if i < 0 then i := 0;
    if i > screen.height then i := 100;
    frm.Top := i;

    i := ini.ReadInteger(Sec, Prefix+'_Left', frm.Left);
    if i < 0 then i := 0;
    frm.Left := i;

    i := ini.ReadInteger(Sec, Prefix+'_Width', frm.Width);
    if i < 0 then i := 100;
    if frm.Left + i > screen.width then i := screen.width - frm.Left;
    frm.Width := i;

    i := ini.ReadInteger(Sec, Prefix+'_Height', frm.Height);
    if i < 0 then i := 100;
    if frm.Top + i > screen.height then i := screen.height - frm.Top;
    frm.Height := i;
  end;

begin
  ini := TMyIniFile.Create(FConfFile);

  with FDefault do
  begin
    ChargeI := ini.ReadFloat(cDefault, cChargeCurrent, 0.06);
    DischargeI := ini.ReadFloat(cDefault, cDischargeCurrent, 0.06);
    ConstantU := ini.ReadFloat(cDefault, cConstantVoltage, 5);
    DischargeR := ini.ReadFloat(cDefault, cDischargeResistance, 10.0);
    DischargeP := ini.ReadFloat(cDefault, cDischargePower, 10.0);
    Cells := ini.ReadInteger(cDefault, cCells, 1);
    ModeName := ini.ReadString(cDefault, cModeCommand, '');
  end;

  frmSettings.rgStart.ItemIndex := ini.ReadInteger(cStartup, cStartSelection, 0);
  s := cSelection + '_' + IntToStr(frmSettings.rgStart.ItemIndex);
  rgCharge.ItemIndex := ini.ReadInteger(s, cChargeIndex, -1);
  rgDischarge.ItemIndex := ini.ReadInteger(s, cDischargeIndex, -1);
  edtCells.Value := ini.ReadInteger(s, cCells, 1);
  edtTestVal.Value := ini.ReadFloat(s, cTestVal, 0.06);
  pcProgram.TabIndex := ini.ReadInteger(s, cTabIndex, 0);

  edtCutA.Value := ini.ReadFloat(s, cCutA, FDefault.DischargeI);
  edtCutV.Value := ini.ReadFloat(s, cCutV, 1.00);
  edtCutTime.Value := ini.ReadInteger(s, cMaxTime, 0);
  edtCutM.Value := ini.ReadInteger(s, cCutATime, 0);

  fLanguageCode := ini.ReadString(cSettings,cLangCode, '');
  frmSettings.edtProgFile.Text := ini.ReadString(cSettings, cProgFile, '');
  sdCSV.InitialDir := ini.ReadString(cSettings, cSaveDir, FAppDir);
  sdPNG.InitialDir := sdCSV.InitialDir;
  sdLogCSV.InitialDir := ini.ReadString(cSettings, cLogDir, FAppDir);
  t := ini.ReadString(cSettings, cStepDir, FAppDir);
  frmStep.SetInitialDir(t);

  for I := 0 to frmSettings.cgSettings.Items.Count - 1 do
    frmSettings.cgSettings.Checked[I] := ini.ReadBool(cSettings, cChkSetting + '_' + IntToStr(I), False);

  if frmSettings.cgSettings.Checked[cAutoLoad] then
    if frmStep.loadFile(frmSettings.edtProgFile.FileName) then
      stStepFile.Caption := ExtractFileName(frmSettings.edtProgFile.FileName);
   if frmStep.Compiled then
     pcProgram.ActivePage := tsProgram;

  frmSettings.edtIntTime.Value := ini.ReadInteger(cSettings, cIntTime, 60);
  tbxMonitor.Checked := ini.ReadBool(cSettings, cMonitor, True);

  i := ini.ReadInteger(cAppSec, cWinLeft, frmMain.Left);
  if (i >= screen.Width - 100) or (i < 0) then i := 10;
  frmMain.Left := i;
  frmMain.Top := ini.ReadInteger(cAppSec, cWinTop, frmMain.Top);

  i := ini.ReadInteger(cAppSec, cWinWidth, frmMain.Width);
  if (frmMain.Left + i > screen.Width) or (i < 0) then
    i := screen.Width - frmMain.Left - 10;
  frmMain.Width := i;

  frmMain.Height := ini.ReadInteger(cAppSec, cWinHeight, frmMain.Height);
  if ini.ReadBool(cAppSec, cWinMaximized, False) then
    frmMain.WindowState := wsMaximized;

  memStepLog.Height := ini.ReadInteger(cAppSec, cMemStepLogHeight, MemStepLog.Height);

  loadFormSize(cAppSec,'shortcutsWinPos',frmShortcuts);
  loadFormSize(cAppSec,'stepWinPos',frmStep);
{$ifdef Windows}
  frmconnect.edtDevice.Text := ini.ReadString(cAppSec, cSerial, 'COM1');
{$else}
  frmconnect.edtDevice.Text := ini.ReadString(cAppSec, cSerial, '/dev/ttyUSB0');
{$endif}
  mm_AutoLog.Checked := ini.readBool(cAppSec, cAutoLog, false);
  mm_AutoCsvFileName.Checked := ini.readBool(cAppSec, cAutoCsvFileName, true);

  ini.ReadIntegers(cAppSec,cMemStepLogWidths,StepLogWidths);
  maxI := length(StepLogWidths)-1;
  if (maxI > 0) then
  begin
    if maxI > memStepLog.Columns.Count-1 then maxI := memStepLog.Columns.Count-1;
    for i := 0 to maxI do
      memStepLog.Columns[i].Width:=StepLogWidths[i];
  end;
  setLength(StepLogWidths,0);

  ini.Free;
  SetSettings;
  if length(fLanguageCode) > 0 then SetLanguage(fLanguageCode);
end;

procedure TfrmMain.SaveSettings;
var
  ini: TMyIniFile;
  s: string;
  I: Integer;
  StepLogWidths:TIntegerDynArray;

  procedure saveFormSize(Sec,Prefix: string; frm: TForm);
  begin
    ini.WriteInteger(Sec, Prefix+'_Top', frm.Top);
    ini.WriteInteger(Sec, Prefix+'_Left', frm.Left);
    ini.WriteInteger(Sec, Prefix+'_Width', frm.Width);
    ini.WriteInteger(Sec, Prefix+'_Height', frm.Height);
  end;

begin
  ini := TMyIniFile.Create(FConfFile);
  ini.CacheUpdates:=true;
  ini.WriteInteger(cStartup, cStartSelection, frmSettings.rgStart.ItemIndex);
  s := cSelection + '_' + IntToStr(frmSettings.rgStart.ItemIndex);
  if not ini.ReadBool(s, cReadOnly, True) then
  begin
    ini.WriteInteger(s, cChargeIndex, rgCharge.ItemIndex);
    ini.WriteInteger(s, cDischargeIndex, rgDischarge.ItemIndex);
    ini.WriteInteger(s, cCells, edtCells.Value);
    ini.WriteFloat(s, cTestVal, edtTestVal.Value);
    ini.WriteInteger(s, cTabIndex, pcProgram.TabIndex);
    ini.WriteFloat(s, cCutA, edtCutA.Value);
    ini.WriteFloat(s, cCutV, edtCutV.Value);
    ini.WriteInteger(s, cMaxTime, edtCutTime.Value);
    ini.WriteInteger(s, cCutATime, edtCutM.Value);
  end;
  ini.WriteString(cSettings, cLangCode, fLanguageCode);
  ini.WriteString(cSettings, cProgFile, frmSettings.edtProgFile.Text);
  ini.WriteString(cSettings, cSaveDir, sdCSV.InitialDir);
  ini.WriteString(cSettings, cLogDir, sdLogCSV.InitialDir);
  ini.WriteString(cSettings, cStepDir, frmStep.sdSave.InitialDir);
  ini.WriteInteger(cSettings, cIntTime, frmSettings.edtIntTime.Value);

  for I := 0 to frmSettings.cgSettings.Items.Count - 1 do
    ini.WriteBool(cSettings, cChkSetting + '_' + IntToStr(I), frmSettings.cgSettings.Checked[I]);

  ini.WriteBool(cSettings, cMonitor, tbxMonitor.Checked);

  ini.WriteBool(cAppSec, cWinMaximized, (frmMain.WindowState = wsMaximized));
  ini.WriteInteger(cAppSec, cWinLeft, frmMain.Left);
  ini.WriteInteger(cAppSec, cWinTop, frmMain.Top);
  ini.WriteInteger(cAppSec, cWinWidth, frmMain.Width);
  ini.WriteInteger(cAppSec, cWinHeight, frmMain.Height);

  ini.WriteInteger(cAppSec, cMemStepLogHeight, MemStepLog.Height);

  saveFormSize(cAppSec,'shortcutsWinPos',frmShortcuts);
  saveFormSize(cAppSec,'stepWinPos',frmStep);

  ini.WriteString(cAppSec, cSerial, frmconnect.edtDevice.Text);
  ini.WriteBool(cAppSec, cAutoLog, mm_AutoLog.Checked);
  ini.WriteBool(cAppSec, cAutoCsvFileName, mm_AutoCsvFileName.Checked);

  setLength(StepLogWidths, memStepLog.ColCount);
  for i := 0 to memStepLog.ColCount-1 do
    StepLogWidths[i] := memStepLog.Columns[i].Width;
  ini.WriteIntegers(cAppSec, cMemStepLogWidths,StepLogWidths);
  setLength(StepLogWidths, 0);
  ini.Free;
end;

procedure TfrmMain.SetSettings;
begin
  if frmSettings.cgSettings.Checked[cAutoLoad] then
    if Length(frmSettings.edtProgFile.Text) > 0 then
    begin
      frmStep.memStep.Lines.LoadFromFile(frmSettings.edtProgFile.Text);
      frmStep.Compile(fModel,false);
    end;
  if not frmSettings.cgSettings.Checked[cRememberSaveDir] then
  begin
    sdPNG.InitialDir := FAppDir;
    sdCSV.InitialDir := FAppDir;
  end;
  if not frmSettings.cgSettings.Checked[cRememberAutoLog] then
    sdLogCSV.InitialDir := FAppDir;
  if not frmSettings.cgSettings.Checked[cRememberStepDir] then
    frmStep.SetInitialDir(FAppDir);
  if pcProgram.ActivePage = tsDischarge then
    FixLabels(GetPointer(rgDischarge));
end;

procedure TfrmMain.SetupChecks;
begin
  FChecks.TimerRunning := False;
  if FRunMode = rmCharging then
  begin
    FChecks.cCurrent := edtCutA.Value;
    FChecks.cDwelltime := edtCutM.Value;
  end;
  FChecks.cCapacity := cNaN;
  if chkCutCap.Checked then
  begin
    FChecks.cCapacity := edtCutCap.Value;
    if FChecks.cCapacity < 0.0001 then
      chkCutCap.Checked := False;
  end;
  FChecks.cEnergy := cNaN;
  if chkCutEnergy.Checked then
  begin
    FChecks.cEnergy := edtCutEnergy.Value;
    if FChecks.cEnergy < 0.0001 then
      chkCutEnergy.Checked := False;
  end;
  DoLog('cCurrent: ' + FloatToStr(FChecks.cCurrent));
  DoLog('Time: ' + IntToStr(FChecks.cDwellTime));
  DoLog('cCapacity: ' + FloatToStr(FChecks.cCapacity));
  DoLog('cEnergy: ' + FloatToStr(FChecks.cEnergy));
end;

procedure TfrmMain.FixLabels(APacket: Integer);
begin
  if (APacket > -1) and (APacket < c_fixedBase) then
  begin
    case FPackets[APacket].TestVal of
      tvCurrent:
      begin
        lblTestVal.Caption := cCurrent;
        lblTestVal.Hint := cCurrentHint;
        lblTestUnit.Caption := cA;
      end;
      tvPower:
      begin
        lblTestVal.Caption := cPower;
        lblTestVal.Hint := cPowerHint;
        lblTestUnit.Caption := cP;
      end;
      tvResistance:
      begin
        lblTestVal.Caption := cResistance;
        lblTestVal.Hint := cResistanceHint;
        lblTestUnit.Caption := cR;
      end;
    end;
  end else
  begin
    lblTestVal.Caption := cCurrent;
    lblTestVal.Hint := cCurrentHint;
    lblTestUnit.Caption := cA;
  end;
end;

procedure TfrmMain.DoLog(AText: string);
begin
  if memLog.Lines.Count > 40000 then
    memLog.Lines.Delete(0);
  memLog.Lines.Add(AText);
  memLog.VertScrollBar.Position := 1000000;
end;


procedure TfrmMain.DoHexLog(AText: string);
begin
  if memLog.Lines.Count > 10000 then
    memLog.Lines.Delete(0);
  memLog.Lines.Add(AText);

  memLog.VertScrollBar.Position := 1000000;
//  SendMessage(memLog.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

function TfrmMain.StartLogging : boolean;
var
  fileName,fileDir : string;
  err,i : integer;
  prefix : string;
begin
  result := false;
  StopLogging;
  prefix := '';
  if mm_AutoLog.Checked then
  begin
    if mm_AutoCsvFileName.Checked then
    begin
      // build a file name
      fileName := FormatDateTime('YYYYMMDD_HHMMSS',Now)+'.csv';

      // prefix taksbar name if enabled in settings
      if frmSettings.cgSettings.Checked[cTaskbarCsvPrefix] then
        if Caption <> cDefaultCaption then
        begin
          prefix := Caption;
          if length(prefix)>0 then
          begin
            for i := 1 to length(prefix) do
            begin
              if prefix[i] <= '0' then prefix[i] := '_';
              if prefix[i] in ['\','/'] then prefix[i] := '_';
            end;
            prefix := prefix + '_';
          end;
        end;

      fileDir := sdLogCSV.InitialDir;
      if Length(fileDir) > 0 then
      begin
        if fileDir[length(fileDir)] <> PathDelim then fileDir := fileDir + PathDelim;
        fileName := fileDir + fileName;
      end else
        fileName := ExpandFileName(fileName);
    end else
      fileName := sdLogCSV.FileName;

    if length(fileName) < 1 then
    begin
      Application.MessageBox(pchar(cAutoLogNoAutoFileName),pchar(cError),MB_ICONSTOP);
      exit;
    end;

    fileName := prefix + fileName;

    if FileExists(fileName) then
      if MessageDlg(cFileExists,format(cFileOverwrite,[fileName]), mtConfirmation,[mbYes, mbNo],0) <> mrYes then
        exit;

    // open log file
    InOutRes := 0;
    AssignFile(FLogFile, fileName);
    rewrite(FLogFile);
    err := ioresult;
    if (err <> 0) then
    begin
       MessageDlg(cError,Format(cUnableToCreateLogFile,[fileName,err]), mtError,[mbAbort],0);
       exit;
    end;
    writeln(FlogFile,'Time'+#9+'I'+#9+'U'+#9+'CapEBC'+#9+'CapPC');
    err := ioresult;
    if (err <> 0) then
    begin
       MessageDlg(cError,Format(cUnableToCreateLogFile,[fileName,err]), mtError,[mbAbort],0);
       exit;
    end;

    setStatusLine(cst_LogFileName,fileName);
    fLogFileIsOpen := true;
    fLogFileName := fileName;
    result := true;
  end else
    exit(true);
end;

procedure TfrmMain.StopLogging;
begin
  fLogFileIsOpen := false;
  if fLogFileIsOpen then
  begin
    InOutRes := 0;
    Flush(FLogFile);
    CloseFile(FLogFile);
    if IOResult <> 0 then
      MessageDlg(cError,Format(cErrorClosingLogfile,[IOResult]), mtError,[mbAbort],0);
    setStatusLine(cst_LogFileName,'');
    fLogFileName := '';
  end;
end;

function TfrmMain.FindPacket(AName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Length(FPackets) - 1 do
  begin
    if Pos(AName, FPackets[I].Command) > 0 then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TfrmMain.GetPointer(ARadioGroup: TRadioGroup): Integer;
begin
  Result := -1;
  if Assigned(ARadioGroup) then
    if ARadioGroup.ItemIndex > -1 then
      Result := Integer(Pointer(ARadioGroup.Items.Objects[ARadioGroup.ItemIndex]));
end;


procedure TfrmMain.LoadStep;
var
  I: Integer;
  P2: Extended;
  u: string;
  DoSend: Boolean;
  DoUpdate: Boolean;
begin
//  {$push}
//  {$boolEval off}
//  while (FProgramStep < Length(FSteps)) and (Pos('//', FSteps[FProgramStep].Command) > 0) do
//  {$pop}
//  begin
//    Inc(FProgramStep);
//  end;
  if FProgramStep < Length(FSteps) then
  begin
    DoSend := True;
    DoUpdate := True;

    if FSteps[FCurrentStep].Mode in [rmDischarging, rmDischargingCR] then
      FCurrentDisCapacity := FCurrentCapacity[caEBC];

    FCurrentStep := FProgramStep;

    FEnergy := 0;
    FCurrentCapacity[caLocal] := 0;
    FWaitCounter := 0;
    FStepTime := Now;
    with FSteps[FProgramStep] do
    begin
      I := FSteps[FProgramStep].PacketIndex; //FindPacket(Command);
      lblStepNum.Caption := IntToStr(FProgramStep + 1);
      lblStep.Caption := ' ' + Command + ' ';
      SetRunMode(Mode);
      //if I > -1 then
      begin
        FixLabels(I);
        FPacketIndex := I;
        case Mode of
          rmCharging:
          begin
            if (FPackets[I].Method = mChargeCV)  then
              P2 := CV else
              P2 := Cells;
            u := cA;
            memStepLogNewStep;
          end;
          rmDischarging:
          begin
            P2 := CutVolt;
            if FPackets[I].TestVal = tvPower then
              u := cP else
              u := cA;
            memStepLogNewStep;
          end;
          rmDischargingCR:
          begin
            P2 := CutVolt;
            u := cR;
            memStepLogNewStep;
          end;
          rmWait:
          begin
            FBeginWaitVoltage := FLastU;
            FWaitCounter := CutTime * 60;
            tmrWait.Enabled := True;
            edtTestVal.Value := 0.0;
            DoSend := False;
            memStepLogNewStep;
          end;
          rmLoop:
          begin
            FWaitCounter := 1;
            edtTestVal.Value := 0.0;
            DoSend := False;
            DoUpdate := False;
            if Loop > 0 then
            begin
              if CapI then
              begin
                lblCapI.Enabled := True;
                lblCapI.Caption := cCapI +
                  MyFloatStr(FCurrentDisCapacity) +
                  ' ≥ ' + MyFloatStr(FLastDisCapacity);
                shaCapI.Enabled := True;
                shaCapI.Brush.Color := clLime;
              end;
{              if EneI then
              begin
                lblCapI.Enabled := True;
                lblCapI.Caption := cEneI +
                  FloatToStrF(FCurrentDisEnergy, ffFixed, 18, 3) +
                  ' ≥ ' + FloatToStrF(FLastDisEnergy, ffFixed, 18, 3);
                shaCapI.Enabled := True;
                shaCapI.Brush.Color := clLime;
              end;
}
              if (not (CapI or EneI)) or (FCurrentDisCapacity >= FLastDisCapacity) then
              begin

                FLastDisCapacity := FCurrentDisCapacity;
                memStepLogEnd;
                memStepLogAdd ('LOOP:'+IntToStr(Loop));
                Dec(Loop); Inc(LoopCounter);

                FProgramStep := 0;
                edtTestVal.Value := 0.0;

                LoadStep;
                Dec(FProgramStep); // Increments in end of recursive call and this call.
                //memStepLog.Lines.Add('---');
              end else
              begin
                lblCapI.Enabled := False;
                lblCapI.Caption := cCapI;
                shaCapI.Brush.Color := clDefault;
                tmrWait.Enabled := True; // Triggers next step if loop is finished
                memStepLogEnd;
                memStepLogAdd ('LOOP:'+IntToStr(Loop));
                Inc(LoopCounter);
              end;
            end else
            begin
              tmrWait.Enabled := True; // Triggers next step if loop is finished
              Inc(LoopCounter);
            end;
            //Inc(LoopCounter);
          end;
          rmEnd:
          begin
            //LogStep;
            EBCBreak(true,true);
            FInProgram := False;
            OffSetting;
            DoUpdate := False;
            DoSend := False;
          end;
        end;
        if DoUpdate then
        begin
          edtCutEnergy.Value := CutEnergy;
          chkCutEnergy.Checked := CutEnergy > 0.0001;
          edtCutCap.Value := CutCap;
          chkCutCap.Checked := CutCap > 0.0001;
          edtTestVal.Value := TestVal;
          lblTestUnit.Caption := u;
          edtCutTime.Value := CutTime;
          edtCutA.Value := CutAmp;
          edtCutM.Value := CutAmpTime;
          if Mode = rmCharging then
          begin
            edtChargeV.Value := CV;
            edtCells.Value := Cells;
            {
            if Pos(cCmdCCCV, Command) > 0 then   // AD: FIXME
              edtChargeV.Value := CV
            else
              dtCells.Value := Trunc(P2);
            }
          end else if Mode in [rmDischarging, rmDischargingCR] then
            edtCutV.Value := CutVolt;
        end;
        if DoSend then
        begin
          SetupChecks;
          FSampleCounter := 0;
          //DoLog('Autooff char: ' + IntToHex(Ord(FPackets[FPacketIndex].AutoOff[1]), 2));
          FStartU := FLastU;
          SendData(MakePacket2(I, smStart, TestVal, P2, CutTime, CutAmp));
        end;
      end{ else
      begin
        memStepLog.Lines.Add('Syntax error: ' + Command);
      end};
    end;
    Inc(FProgramStep);
    btnSkip.Enabled := True;
    mm_skipStep.Enabled := True;

  end else
  begin
    FInProgram := False;
    EBCBreak (true,true);
    OffSetting;
    memStepLogEnd;
  end;
end;


procedure TfrmMain.ReconnectTimerTimer(Sender: TObject);
begin
  dec(FConnectRetryCountdown);
  if (FConnectRetryCountdown > 0) then
  Begin
    SendData(MakeConnPacket(smConnect));
  end else
  begin
    mm_ConnectClick(Sender);
    Application.MessageBox(pchar(cConnectTimeout),pchar(cError),MB_ICONSTOP);
  end;
end;

procedure TfrmMain.mm_ConnectClick(Sender: TObject);
begin
  try
    FChecks.TimerRunning := False;
    if FConnState = csNone then
    begin
      if frmConnect.ShowModal = mrOk then
      begin
        setStatusLine(cst_ConnectionStatus,cConnecting);
        FConnState := csConnecting;
        Serial.Device := frmconnect.edtDevice.Text;
        Serial.OnRxData := @SerialRec;
        Serial.Open;
        SendData(MakeConnPacket(smConnStop));
        SendData(MakeConnPacket(smConnect));
        RunModeOffOrMonitor;
        mm_Connect.Enabled:=false;
        mm_Disconnect.Enabled:=true;
        //btnStart.Enabled := True;
        FLastU := 0;
        FConnectRetryCountdown := cConnectRetries;
        ReconnectTimer.Enabled:= true;
      end;
    end else
    begin
      frmStep.edtDevice.Text := '';
      ReconnectTimer.Enabled:= false;
      ConnectionWatchdogTimer.Enabled := false;
      SendData(MakeConnPacket(smDisconnect));
      setStatusLine(cst_ConnectionStatus,cNotConnected);
      setStatusLine(cst_ConnectedModel,'');
      tbxMonitor.Enabled := False;
      FConnState := csNone;
      FModel := -1;
      frmStep.edtDeviceChange(self);
      Serial.Close;
      clearChargeDischargeTypes;
      mm_Connect.Enabled:=true;
      mm_Disconnect.Enabled:=false;
      MainStatusBar.invalidate;
      ConnectionWatchdogTimer.Enabled := false;
      btnStart.Enabled := False;
      FreezeEdits;
    end;
  except
    FConnState := csNone;
    setStatusLine(cst_ConnectionStatus,cNotConnected);
    setStatusLine(cst_ConnectedModel,'');
    ReconnectTimer.Enabled:= false;
    ConnectionWatchdogTimer.Enabled := false;
    Application.MessageBox(pchar(format(cUnableToConnectTo,[frmconnect.edtDevice.Text])),pchar(cError),MB_ICONSTOP);
  end;
end;

procedure TfrmMain.mm_LogFileDirClick(Sender: TObject);
var
  sdd : TSelectDirectoryDialog;
begin
  sdd := TSelectDirectoryDialog.Create(Self);
  try
    sdd.InitialDir := sdLogCSV.InitialDir;
    if sdd.Execute then
      if length(sdd.fileName) < 1 then
        sdLogCSV.initialDir := GetCurrentDir
      else
        sdLogCSV.InitialDir := sdd.FileName;
  finally
    sdd.free;
  end;
end;

procedure TfrmMain.mm_AutoLogClick(Sender: TObject);
begin
  mm_AutoLog.Checked := not mm_AutoLog.Checked;
end;

procedure TfrmMain.mm_AboutClick(Sender: TObject);
var t : TfrmAbout;
begin
  try
    t := TfrmAbout.Create(Self);
    t.ShowModal;
  finally
    t.free;
  end;
end;

procedure TfrmMain.FinalizeLanguageSettings;
begin
  frmShortcuts.setHelpText(Self);
  frmSettings.LoadRecourcestrings;
  frmStep.LoadResourceStrings;
  FixLabels(-1);  // fixme
end;

procedure TfrmMain.SetLanguage(langCode : string);
begin
  fLanguageCode := langCode;
  i18nutils.SetLanguage(langCode);
  FinalizeLanguageSettings;
end;

procedure TfrmMain.mm_langClick(Sender: TObject);
begin
  fLanguageCode := poSelectLanguageMenuClick(Sender);
  FinalizeLanguageSettings;
end;


procedure TfrmMain.ConnectionWatchdogTimerTimer(Sender: TObject);
begin
  ConnectionWatchdogTimer.Enabled := false;
  if fConnState = csConnected then
     mm_ConnectClick(Sender);
  MessageDlg(cConnectionLost,cPacketTimeout, mtError,[mbOk],0);
end;

procedure TfrmMain.mm_AutoCsvFileNameClick(Sender: TObject);
begin
  mm_AutoCsvFileName.Checked:=not mm_AutoCsvFileName.Checked;
end;

procedure TfrmMain.btnContClick(Sender: TObject);
var
  s: string;
begin
  s := NewMakePacket(FPacketIndex, smCont);
  SendData(s);
end;

procedure TfrmMain.btnAdjustClick(Sender: TObject);
var
  s: string;
begin
  s := NewMakePacket(FPacketIndex, smAdjust);
  SendData(s);
end;


procedure TfrmMain.mm_QuitClick(Sender: TObject);
begin
  //Application.Terminate;  // this does not call onClose
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  close;
end;

procedure TfrmMain.mm_saveCsvClick(Sender: TObject);
begin
  if sdCSV.Execute then
    SaveCSV(sdCSV.FileName);
end;

procedure TfrmMain.mm_savePngClick(Sender: TObject);
begin
  if sdPNG.Execute then
    Chart.SaveToFile(TPortableNetworkGraphic, sdPNG.FileName);
end;

procedure TfrmMain.mm_setCsvLogFileClick(Sender: TObject);
begin
  sdLogCSV.Execute;
 // setStatusLine(cst_LogFileName,sdLogCSV.FileName);
end;

procedure TfrmMain.mm_SettingsClick(Sender: TObject);
begin
  frmSettings.ShowModal;
  SaveSettings;
end;

procedure TfrmMain.mm_ShortcutsClick(Sender: TObject);
begin
  frmShortcuts.show;
end;


procedure TfrmMain.mm_stepLoadClick(Sender: TObject);
begin
  frmStep.mniOpenClick(Sender);
  if frmStep.Compiled then
  begin
    pcProgram.ActivePage := tsProgram;  // set active tab to program after loading a valid file
    if FConnState = csConnected then
      btnStart.Enabled:=true;
  end;

  {if frmStep.odOpen.Execute then
  begin
    frmStep.memStep.Lines.LoadFromFile(frmStep.odOpen.FileName);
    frmStep.Caption := frmStep.odOpen.FileName;
    frmStep.sdSave.FileName := frmStep.odOpen.FileName;
    stStepFile.Caption := ExtractFileName(frmStep.odOpen.FileName);
    frmStep.compile;
  end;}
end;

procedure TfrmMain.mm_taskBarNameClick(Sender: TObject);
var s : string;
begin
  s := '';
  if InputQuery(cSetBorderName, cName, s) then
    frmMain.Caption := s;
end;


procedure TfrmMain.pcProgramChange(Sender: TObject);
begin
  if (FInProgram) or (not (FRunMode in [rmNone,rmMonitor])) or (fConnState <> csConnected) then
  begin
    btnStart.Enabled := false;
    exit;
  end;
  case pcProgram.TabIndex of
    0: btnStart.Enabled := rgCharge.ItemIndex > -1;
    1: btnStart.Enabled := rgDischarge.ItemIndex > -1;
    2: btnStart.Enabled := Length(frmStep.memStep.Text) > 2;
  end;
end;


procedure TfrmMain.btnProgClick(Sender: TObject);
begin
  if frmStep.ShowModal = mrOK then
    pcProgram.ActivePage := tsProgram;
  stStepFile.Caption := ExtractFileName(frmStep.odOpen.FileName);
  if not FInProgram then
  begin
    btnStart.Enabled := Length(frmStep.memStep.Text) > 2;
    pcProgram.ActivePage := tsProgram;
  end;
end;

procedure TfrmMain.btnSkipClick(Sender: TObject);
begin
  btnSkip.Enabled := False;
  mm_skipStep.Enabled := False;
  if FInProgram then
  begin
    if FRunMode = rmWait then
    begin
      FWaitCounter := 1;
//      TimerOff;
    end else
      EBCBreak (false,false);
  end;
end;

function TfrmMain.doProgramCchecks : boolean;
var
  i:integer;
begin
  result := true;
  for I := low(FSteps) to high(FSteps) do
  begin
    if FSteps[i].Mode = rmCharging then
      if FSteps[i].CutAmp >= FSteps[i].TestVal then
      begin
        Application.MessageBox(pchar(format(cChargeLowerCutoff,[FSteps[i].TestVal,FSteps[i].CutAmp])),pchar(cFatal),MB_ICONSTOP);
        exit (false);
      end;
  end;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  s: string;
begin
  FPacketIndex := -1;
  memStepLogClear;
  if pcProgram.ActivePage = tsCharge then
  begin
    if edtCutA.Value >= edtTestVal.Value then
    begin
      Application.MessageBox(pchar(Format(cCutoffGtoeChargeC,[edtCutA.Value,edtTestVal.Value])),pchar(cError),MB_ICONSTOP);
      exit;
    end;

//    cMaxChargeVoltage = 'MaxChargeVoltage';
//  cMaxChargeCurrent = 'MaxChargeCurrent';
//  cM

    if rgCharge.ItemIndex > -1 then
    begin;
      FPacketIndex := GetPointer(rgCharge);
      if FModel >= 0 then
      begin
        if FModels[FModel].MaxChargeCurrent > 0 then
          if FModels[FModel].MaxChargeCurrent < edtTestVal.Value then
          Begin
            Application.MessageBox(pchar(Format(cChargeCurrExeeded,[edtTestVal.Value,FModels[FModel].Name,FModels[FModel].MaxChargeCurrent])),pchar(cError),MB_ICONSTOP);
            exit;
          end;
        if FModels[FModel].MaxChargeVoltage > 0 then
          if FModels[FModel].MaxChargeVoltage < edtChargeV.Value then
          Begin
            Application.MessageBox(pchar(Format(cChargeVoltageExeeded,[edtChargeV.Value,FModels[FModel].Name,FModels[FModel].MaxChargeVoltage])),pchar(cError),MB_ICONSTOP);
            exit;
          end;
      end else
      begin
        Application.MessageBox(pchar(cNoChargeProfileSelected),pchar(cError),MB_ICONSTOP);
        exit;
      end;
      if not StartLogging then exit;
      tsDisCharge.Enabled := False;
      SetRunMode(rmCharging);
    end;
  end else if pcProgram.ActivePage = tsDischarge then
  begin
    if FModel >= 0 then
    begin
      if FModels[FModel].MaxDischargeCurrent > 0 then
        if FModels[FModel].MaxDischargeCurrent < edtTestVal.Value then
        Begin
          Application.MessageBox(pchar(Format(cDischargeAmpsExeeded,[edtTestVal.Value,FModels[FModel].Name,FModels[FModel].MaxDischargeCurrent])),pchar(cError),MB_ICONSTOP);
          exit;
        end;
    end;
    if rgDisCharge.ItemIndex > -1 then
    begin;
      if not StartLogging then exit;
      FPacketIndex := GetPointer(rgDisCharge);
      tsCharge.Enabled := False;
      SetRunMode(rmDischarging);
    end;
  end else if pcProgram.ActivePage = tsProgram then
  begin
    if not doProgramCchecks then exit;
    if frmStep.Compile(fModel,false) <> mrOk then exit;
    if not StartLogging then exit;
    frmStep.memStep.Enabled := False;
    btnProg.Caption := cView;
    btnStart.Enabled := False;
    btnAdjust.Enabled := True;
    btnCont.Enabled := False;
    btnStop.Enabled := True;
    btnStart.Enabled := False;
    FProgramStep := 0;
    FInProgram := True;
    memStepLogClear;
  end;

  if FPacketIndex > -1 then
    if FPackets[FPacketIndex].TestVal = tvResistance then
      SetRunMode(rmDischargingCR);

  if FInProgram or (FRunMode in [rmCharging, rmDischarging, rmDischargingCR]) then
  begin
    btnStart.Enabled := False;
    btnAdjust.Enabled := True;
    tbxMonitor.Enabled := False;
    btnStop.Enabled := True;
    SetLength(FData, 0);
    lsCurrent.Clear;
    lsVoltage.Clear;
    lsInvisibleVoltage.Clear;
    lsInvisibleCurrent.Clear;
    SetupChecks;
    //StartLogging;
    FSampleCounter := 0;
    FDeltaIndex := 0;
    FLastDisCapacity := -1;
    FCurrentCapacity[caLocal] := 0;
    FCurrentCapacity[caEBC] := 0;
    FCurrentDisCapacity := 0;
    FEnergy := 0;
    mm_AutoLog.Enabled := False;
    FreezeEdits;
    FIntTime := frmSettings.edtIntTime.Value * 1000;
    FStartTime := Now;
    if pcProgram.ActivePage = tsProgram then
    begin
      LoadStep;
      btnSkip.Enabled := True;
      mm_skipStep.Enabled := True;
    end else
    begin
      s := NewMakePacket(FPacketIndex, smStart);
      FStartU := FLastU;
      SendData(s);
    end;
  end else
    StopLogging;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  //FInProgram := False;
  EBCBreak(True);
  OffSetting;
end;

procedure TfrmMain.chkCutCapChange(Sender: TObject);
begin
  if chkCutCap.Checked then
  begin
    edtCutCap.Enabled := True;
    lblCutCap.Enabled := True;
  end else
  begin
    edtCutCap.Enabled := False;
    lblCutCap.Enabled := False;
  end;
end;

procedure TfrmMain.chkCutEnergyChange(Sender: TObject);
begin
  if chkCutEnergy.Checked then
  begin
    edtCutEnergy.Enabled := True;
    lblCutEnergy.Enabled := True;
  end else
  begin
    edtCutEnergy.Enabled := False;
    lblCutEnergy.Enabled := False;
  end;
end;


procedure TfrmMain.edtCellsChange(Sender: TObject);
var
  I: Integer;
begin
  I := GetPointer(rgCharge);
  if I > -1 then
    edtChargeV.Value := edtCells.Value * FPackets[I].VoltInfo;
end;

procedure TfrmMain.edtCellsClick(Sender: TObject);
begin
  edtCellsChange(Sender)
end;

procedure TfrmMain.edtCellsEditingDone(Sender: TObject);
begin
  edtCellsChange(Sender)
end;

procedure TfrmMain.edtCellsExit(Sender: TObject);
begin
    edtCellsChange(Sender)
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
    case key of
      VK_F1: pcProgram.ActivePage :=tsCharge;
      VK_F2: pcProgram.ActivePage :=tsDischarge;
      VK_F3: pcProgram.ActivePage :=tsProgram;
      VK_F4: pcProgram.ActivePage :=tsConsole;
    end;
end;

procedure TfrmMain.edtCellsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtCellsChange(Sender)
end;

procedure TfrmMain.edtCellsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtCellsChange(Sender)
end;

procedure TfrmMain.edtCutTimeChange(Sender: TObject);
begin
{  if edtCutTime.Value = 250 then
  begin
    edtCutTime.Value := 249;
  end;}
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveSettings;
  if FConnState = csConnected then
  begin
    SendData(MakeConnPacket(smDisconnect));
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
const
  cLeft = 2;
  cRight = 140;
var
  I: Integer;
  N: Integer;
  newTop : integer;
//  A: TAction;
begin
  SetRunMode(rmNone);
  FConnState := csNone;
  FInProgram := False;
  FStartTime := Now;
  FShowJoule := False;
  FShowCoulomb := False;
  FDelta[0].Time := Now;
  FDelta[1].Time := Now;
  Caption := cDefaultCaption;

  // for Windows as async do not exist for Windows
  Serial:= TLazSerial.Create(Self);
  Serial.BaudRate:=br__9600;
  Serial.DataBits := db8bits;
  Serial.FlowControl:=fcNone;
  Serial.Parity := pOdd;
  Serial.RcvLineCRLF:=false;
  Serial.StopBits:=sbOne;


  SetLength(stText, cstMax + 1);
  for I := Low(stText) to High(stText) do
  begin
    stText[I] := TStaticText.Create(Self);
    stText[I].Tag := I;
    stText[I].OnClick := @stTextClick;
    stText[I].Parent := gbStatus;
    stText[I].Font.Name := cFixedFont;
    stText[I].Font.Size := 12;
    stText[I].Font.Style := [fsBold];
    stText[I].Height := 24;
    stText[I].Top := 25*(I div 2)+0;
    if Odd(I) then
    begin
      stText[I].Left := cRight;
      stText[I].SendToBack;
      stText[I].Width := gbStatus.Width - cRight - cLeft;
    end else
    begin
      stText[I].Left := cLeft;
      stText[I].BringToFront;
      stText[I].Width := cRight - cLeft;// + 2 ;
    end;
  end;

  stText[cstVoltage].Caption := '00.000V';
  stText[cstVoltage].Font.Color := clBlue;
  stText[cstCurrent].Caption := '00.000A';
  stText[cstCurrent].Font.Color := clRed;
  stText[cstTime].Caption := '00:00:00';
  stText[cstTime].Font.Color := clMaroon;
  stText[cstPower].Caption := '000.0W';
  stText[cstPower].Font.Color :=  $0050FF;//FF2600;
  stText[cstCapacity].Caption := '000.000Ah';
  stText[cstEnergy].Caption := '000.000Wh';

  setStatusLine(cst_ConnectionStatus,cNotConnected);
  setStatusLine(cst_ConnectedModel,'');
  N := 0;
  for I := 0 to rgCharge.Items.Count -1 do
  begin
    rgCharge.Items.Objects[I] := TObject(Pointer(N));
    Inc(N);
  end;
  for I := 0 to rgDisCharge.Items.Count -1 do
  begin
    rgDisCharge.Items.Objects[I] := TObject(Pointer(N));
    Inc(N);
  end;
  frmStep := TfrmStep.Create(Self);
  frmSettings := TfrmSettings.Create(Self);
  frmConnect := TfrmConnect.Create(Self);
  frmShortcuts := TfrmShortcuts.Create(Self);
  FAppDir := ExtractFilePath(Application.ExeName);
  FConfFile := ChangeFileExt(Application.ExeName, cConf);
  if not FileExists(FConfFile) then
  begin
    if not TextFileCopy(ChangeFileExt(Application.ExeName, cInit), FConfFile) then
    begin
      FatalError(Format(cCopyError,[ChangeFileExt(Application.ExeName, cInit),FConfFile]));
      exit;
    end;
  end;
  FixLabels(-1);
  LoadPackets;
  LoadSettings;
//  SetSettings;

  OffSetting;
  FreezeEdits;
  rgCharge.OnClick := @rgChargeClick;
  rgDischarge.OnClick := @rgDischargeClick;
  btnStart.Enabled := False;
  memStepLogClear;
  clearChargeDischargeTypes;
  FRecvStatusIndicatorInc := 1;
  FRecvStatusIndicatorInc := -1;
  frmStep.setDevice('');

  {$ifdef windows}
  MemStepLog.Font.Name := cFixedFont;
  MemLog.Font.Name := cFixedFont;
  // AD: for whatever reason all controls in
  //     gbSettings are shown with some offset
  //     in Y on Windows (Lazarus 3.0RC2)
  //     so move them up
  {for i :=0 to gbSettings.ControlCount-1 do
    if gbSettings.Controls[i] is TControl then
      with TControl(gbSettings.Controls[i]) do
        Top := Top - 16;}
  {$endif}

  // the edit boxes are different in height on Windows and Linux
  // anchoring will not allign correct so do it here

  newTop := edtTestVal.Top + edtTestVal.Height + 4;
  lblCutEnergy2.Top := newTop;
  lblCutCap2.Top := newTop;
  chkCutEnergy.Top := newTop;
  chkCutCap.Top := newTop;

  newTop := newTop + lblCutEnergy2.Height + 4;
  edtCutEnergy.Top := newTop;
  edtCutCap.Top := newTop;
  newTop := newTop + (edtCutEnergy.Height div 2);
  lblCutEnergy.Top := newTop;
  lblCutCap.Top := newTop;

  newTop := edtCutEnergy.Top + edtCutEnergy.Height + 4;
  btnStart.Top := newTop;
  btnStop.Top := newTop;
  tbxMonitor.Top := newTop;
  newTop := newTop + btnStart.Height;
  btnCont.Top := newTop;
  btnAdjust.Top := newTop;

  // does not work under Windows ?
  gbSettings.Height := tbxMonitor.Top + tbxMonitor.Height + 8;

  poGenerateLanguageSelectMenuEntries(mmm_Language, @mm_langClick);

  //mm_ConnectClick(Self);
end;


procedure TfrmMain.rgChargeClick(Sender: TObject);
var
  I: Integer;
begin
  btnStart.Enabled := True;
  btnAdjust.Enabled := False;
  edtCells.Value := FDefault.Cells;
  edtTestVal.Value := FDefault.ChargeI;
  I := GetPointer(rgCharge);
  if I >-1 then
  begin
    UnlockEdits;
    if FPackets[I].Method = mChargeCV then
    begin
      btnStart.Enabled := True;
      edtChargeV.Enabled := True;
      edtCells.Enabled := FPackets[I].EnableNumCells;
      edtChargeV.Value := FPackets[I].VoltInfo;
      if FModel >= 0 then
        if FModels[FModel].MaxChargeVoltage > 0 then
           if edtChargeV.Value * 2 > FModels[FModel].MaxChargeVoltage then edtCells.Enabled:=false;
    end;
    // set default charge/discharge current if specified in ini file for packet
    if (FPackets[I].Method = mChargeCV) or (FPackets[I].Method = mCharge) then
    begin
      if FPackets[I].DefChargeCurrent > 0.001 then
        edtTestVal.Value := FPackets[I].DefChargeCurrent;
      if FPackets[I].DefCutoffCurrent > 0.001 then
        edtCutA.Value := FPackets[I].DefCutoffCurrent;
    end;
    if FPackets[I].Method = mDischarge then
      if FPackets[I].DefDischargeCurrent > 0.001 then
        edtTestVal.Value := FPackets[I].DefDischargeCurrent;
  end else
  begin
    edtChargeV.Enabled:=false;
    edtCells.Enabled := True;
    edtChargeV.Value := edtCells.Value * FPackets[I].VoltInfo;
  end;
end;

procedure TfrmMain.rgDischargeClick(Sender: TObject);
var
  I: Integer;
begin
  I := GetPointer(rgDischarge);
  FixLabels(I);
  if (I > -1) {and (I <> FPacketIndex)} then
  begin
    UnlockEdits;
    btnStart.Enabled := True;
    case FPackets[I].TestVal of
      tvCurrent:
      begin
        edtTestVal.Value := FDefault.DischargeI;
      end;
      tvPower:
      begin
        edtTestVal.Value := FDefault.DischargeP;
      end;
      tvResistance:
      begin
        edtTestVal.Value := FDefault.DischargeR;
      end;
    end;
  end;
//  FPacketIndex := I;
end;

procedure TfrmMain.MainStatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  drawHeight : integer;
begin
//{$ifdef windows}
  drawHeight := MainStatusBar.height-5;
//{$else}
//  drawHeight := MainStatusBar.Canvas.height-6;
//{$endif}

  if Panel = MainStatusBar.Panels[cst_ConnectionState] then
  begin
    if FConnState = csConnected then
      with MainStatusBar.Canvas do
      begin
        Brush.Color := cldefault;
        rectangle(2,5,MainStatusBar.Panels[cst_ConnectionState].width-2,drawHeight);
        if (FRecvStatusIndicator >= MainStatusBar.Panels[cst_ConnectionState].width-10) then
        begin
          FRecvStatusIndicator := MainStatusBar.Panels[cst_ConnectionState].width-10;
          FRecvStatusIndicatorInc := -1;
        end;
        if (FRecvStatusIndicator < 1) then
        begin
           FRecvStatusIndicator := 0;
           FRecvStatusIndicatorInc := 1;
        end;
        Brush.Color := clblue;
        rectangle(FRecvStatusIndicator+3,6,FRecvStatusIndicator+7,drawHeight-1);
      end;
  end;
end;

procedure TfrmMain.Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
  var Accept: Boolean);
begin
  end;

procedure TfrmMain.tbxMonitorChange(Sender: TObject);
begin
  if FRunMode = rmNone then
  begin
    if tbxMonitor.Checked then
      SetRunMode(rmMonitor);
  end else if FRunMode = rmMonitor then
  begin
    if not tbxMonitor.Checked then
      SetRunMode(rmNone);
  end;
end;

procedure TfrmMain.tmrWaitTimer(Sender: TObject);
begin
  if FWaitCounter > 0 then
  begin
    Dec(FWaitCounter);
    lblTimer.Caption := IntToStr(FWaitCounter);
    if FWaitCounter = 0 then
      TimerOff;
  end;
end;

procedure TfrmMain.tsChargeEnter(Sender: TObject);
begin
  FixLabels(-1);
  if rgCharge.ItemIndex = -1 then
    btnStart.Enabled := False;
end;

procedure TfrmMain.tsDischargeEnter(Sender: TObject);
begin
  FixLabels(GetPointer(rgDischarge));
end;

procedure TfrmMain.setStatusLine(Element:integer; txt:string);
begin
  MainStatusBar.Panels[Element].Text := txt;
end;


procedure TfrmMain.memStepLogClear;
begin
  memStepLog.Options := memStepLog.Options - [goRowSelect];
  memStepLog.RowCount := 1;
end;


procedure TfrmMain.memStepLogAdd (cmd : string);
var row : integer;
begin
  row := memStepLog.RowCount;
  memStepLog.RowCount := row +1;
  memStepLog.Rows[row][cMemStepLog_step] := GetStepNum;
  memStepLog.Rows[row][cMemStepLog_cmd] := cmd;
  memStepLog.Options := memStepLog.Options + [goRowSelect];
  memStepLog.Row := row;
end;


procedure TfrmMain.memStepLogNewStep; // start a step
var row : integer;
    cmd : string;
begin
  cmd := FSteps[FCurrentStep].Command;

  row := memStepLog.RowCount;
  memStepLog.RowCount := row +1;
  memStepLog.Rows[row][cMemStepLog_step] := GetStepNum;
  memStepLog.Rows[row][cMemStepLog_cmd] := cmd;
  memStepLog.Options := memStepLog.Options + [goRowSelect];
  memStepLog.Row := row;
end;



procedure TfrmMain.memStepLogUpdate (AH,WH,startV,endV,endA : extended; time : TDateTime);  // updates values in current step
var row : integer;
begin
  row := memStepLog.RowCount-1;
  if row < 1 then exit;
  if AH > 0 then memStepLog.Rows[row][cMemStepLog_AH] := MyFloatStr(AH) else memStepLog.Rows[row][cMemStepLog_AH] := '';
  if WH > 0 then memStepLog.Rows[row][cMemStepLog_WH] := MyFloatStr(WH) else memStepLog.Rows[row][cMemStepLog_WH] := '';
  if startV > 0 then memStepLog.Rows[row][cMemStepLog_startV] := MyFloatStr(startV) else memStepLog.Rows[row][cMemStepLog_startV] := '';
  if WH > 0 then memStepLog.Rows[row][cMemStepLog_endV] := MyFloatStr(endV) else memStepLog.Rows[row][cMemStepLog_endV] := '';
  //if frac(time) > 0 then memStepLog.Rows[row][cMemStepLog_time] := MyTimeToStr(time) else memStepLog.Rows[row][cMemStepLog_time] := '';
  memStepLog.Rows[row][cMemStepLog_time] := MyTimeToStr(time);
  if endV > 0 then memStepLog.Rows[row][cMemStepLog_endV] := MyFloatStr(endV) else memStepLog.Rows[row][cMemStepLog_endV] := '';
  if endA > 0 then memStepLog.Rows[row][cMemStepLog_endA] := MyFloatStr(endA) else memStepLog.Rows[row][cMemStepLog_endA] := '';
end;

procedure TfrmMain.memStepLogEnd;
begin
  memStepLog.Options := memStepLog.Options - [goRowSelect];
end;

function  TfrmMain.memStepLog2csv (Separator : char) : TStringList;
var t : TStringList;
    row,col : integer;
    line : string;
begin
  t := TStringList.Create;
  for row := 0 to MemStepLog.RowCount-1 do
  begin
    line := '';
    for col := 0 to MemStepLog.ColCount-1 do
    begin
      if length(line) > 0 then line := line + Separator;
      line := line + memStepLog.Rows[row][col];
    end;
    t.Add(line);
  end;
  result := t;
end;



end.

