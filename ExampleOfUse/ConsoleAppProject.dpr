program ConsoleAppProject;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  StrUtils,
  Diagnostics,
  SynCommons in '..\Source\SynCommons.pas',
  SynCrypto in '..\Source\SynCrypto.pas',
  SynEcc in '..\Source\SynEcc.pas',
  SynLZ in '..\Source\SynLZ.pas';

procedure Test_JWT(const ASecret: string);
var
  LJWT: TJWTAbstract;
  LToken: RawUTF8;
  LJWTContent: TJWTContent;
begin
  LJWT := TJWTHS256.Create(StringToUTF8(ASecret), 0, [jrcSubject], [], 60);
  try
    LToken := LJWT.Compute(['Claim1', 'First value', 'Claim2', 2], 'TheIssuer', 'ASubject');

    LJWT.Verify(LToken, LJWTContent);
  finally
    LJWT.Free;
  end;
end;

var
  LTime: TStopWatch;
  LIndex, LIterations: Integer;
begin
  LIterations := 100000;

  try
    WriteLn('ConsoleApp mORMot-JWT');
    WriteLn('----------------------------------------');
    WriteLn(' * Running ' + IntToStr(LIterations) + ' Compute/Verify iterations');

    LTime := TStopWatch.StartNew;
    try
      for LIndex := 1 to LIterations do
        Test_JWT('my_little_secret_here');
    finally
      LTime.Stop;
    end;

    WriteLn(Format(' * Elapsed time: %d ms', [LTime.ElapsedMilliseconds]));
    WriteLn(Format(' * Average time: %.4f ms/iteration', [LTime.ElapsedMilliseconds / LIterations]));
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
