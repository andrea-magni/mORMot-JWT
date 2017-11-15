program ConsoleAppProject;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  StrUtils, Rtti, TypInfo,
  Diagnostics,
  SynCommons in '..\Source\SynCommons.pas',
  SynCrypto in '..\Source\SynCrypto.pas',
  SynEcc in '..\Source\SynEcc.pas',
  SynLZ in '..\Source\SynLZ.pas';

function Test_Verify(const AToken, ASecret: string; const AVerbose: Boolean = False): Boolean;
var
  LJWT: TJWTAbstract;
  LJWTContent: TJWTContent;
begin
  if AVerbose then WriteLn;
  if AVerbose then WriteLn('--- --- VERIFY --- ---');
  LJWT := TJWTHS256.Create(StringToUTF8(ASecret), 0, [], [], 60);
  try
    LJWT.Options := [joHeaderParse, joAllowUnexpectedClaims];
    if AVerbose then begin
      WriteLn('* Algorithm: ' + LJWT.Algorithm);
      WriteLn('* Token: ' + AToken);
      WriteLn('* Secret: ' + ASecret);
    end;

    LJWT.Verify(StringToUTF8(AToken), LJWTContent);
    if AVerbose then WriteLn('-> Result: ' + TRttiEnumerationType.GetName<TJWTResult>(LJWTContent.result) );

    Result := LJWTContent.result = jwtValid;
    if Result then
    begin
      if AVerbose then begin
        WriteLn('-> Token is valid');
        WriteLn('-> Issuer: ' + LJWTContent.reg[jrcIssuer]);
      end;
    end
    else
      if AVerbose then WriteLn('-> Token is NOT valid! *** *** ***');
  finally
    LJWT.Free;
  end;
end;

function Test_Build(const ASecret: string; const AVerbose: Boolean = False): string;
var
  LJWT: TJWTAbstract;
begin
  if AVerbose then WriteLn;
  if AVerbose then WriteLn('--- --- BUILD --- ---');
  LJWT := TJWTHS256.Create(StringToUTF8(ASecret), 0, [jrcIssuer, jrcSubject], [], 60);
  try
    Result := UTF8ToString( LJWT.Compute(['Claim1', 'First value', 'Claim2', 2], 'TheIssuer', 'ASubject') );

    if AVerbose then WriteLn('-> Built token: ' + Result);
  finally
    LJWT.Free;
  end;
end;

const
  DUMMY_SECRET = 'my_little_secret_here';
var
  LTime: TStopWatch;
  LIndex, LIterations: Integer;
  LToken: string;
begin
  try
    WriteLn('ConsoleApp mORMot-JWT');
    WriteLn('----------------------------------------');

    LToken := Test_Build(DUMMY_SECRET, True);
    Test_Verify(LToken, DUMMY_SECRET, True);

(*
  // custom token verification, beware these tokens may be expired, replace with your own

    Test_Verify(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDbGFpbTEiOiJGaXJzdCB2YWx1ZSIsIkNsYWltMiI6MiwiZXhwIjoxNTEwNjU0Njc4fQ.mSMrZ2fe0asa48i3SMM6qpyRV69eFxuZ88xyYQBPIYI'
    , DUMMY_SECRET
    , True
    );

    Test_Verify(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MTA2NzM2MTcsImlhdCI6MTUxMDU4NzIxNywiTEFOR1VBR0VfSUQiOjEsImlzcyI6Ik1BUlMtQ3VyaW9zaXR5In0.DbPbnWfkl-ELo_VXQ0sioavyzyYCFdnD7SbbGsTLvrc'
    , DUMMY_SECRET
    , True
    );
*)
    WriteLn;
    WriteLn('--- --- PERFORMANCE BENCHMARK --- ---');
    LIterations := 10000;
    WriteLn(' * Running ' + IntToStr(LIterations) + ' Build/Verify iterations');
    LTime := TStopWatch.StartNew;
    try
      for LIndex := 1 to LIterations do
      begin
        LToken := Test_Build(DUMMY_SECRET);
        Test_Verify(LToken, DUMMY_SECRET);
      end;
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
