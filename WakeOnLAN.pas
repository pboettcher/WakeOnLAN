unit WakeOnLAN;

interface

function HexToInt(S:String): LongInt;
procedure WakeUPComputer(aMacAddress: string);

implementation

uses
  WinTypes, Messages, SysUtils, Classes, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient;

function HexToInt(S:String):LongInt;
const
  DecDigits:set of '0'..'9'=['0'..'9'];
  HexVals:array[0..$F]of Integer=(0,1,2,3,4,5,6,7,8,9,$A,$B,$C,$D,$E,$F);
  UpCaseHexLetters: set of 'A'..'F'=['A'..'F'];
  LowCaseHexLetters: set of 'a'..'f'=['a'..'f'];
var v:LongInt;
    i,LookUpIndex:integer;
begin
  if length(S)<=8 then begin
    v:=0;
    for i:=1 to Length(S) do begin
      {$R-}
      v:=v shl 4;
      {$R+}
      if S[i] in DecDigits then LookUpIndex:=Ord(S[i])-Ord('0')
      else
         if S[i] in UpCaseHexLetters then LookUpIndex:=Ord(S[i])-Ord('A')+$A
         else
            if S[i] in LowCaseHexLetters then LookUpIndex:=Ord(S[i])-Ord('a')+$A
              else LookUpIndex:=0;
      v:=v or HexVals[LookUpIndex];
    end;
    Result:=v;
  end
  else Result:=0;
end;

procedure ErrMsg(Msg,Caption:String);
begin
  MessageBox(0,PChar(Msg),PChar(Caption),MB_OK or MB_ICONERROR);
end;

procedure WakeUPComputer(aMacAddress:String);
var i,j:Byte;
    lBuffer:array[1..116]of byte;
    lUDPClient:TIdUDPClient;
begin
  try
    for i := 1 to 6 do
      lBuffer[i]:=HexToInt(aMacAddress[(i*2)-1]+aMacAddress[i*2]);
    lBuffer[7] := $00;
    lBuffer[8] := $74;
    lBuffer[9] := $FF;
    lBuffer[10] := $FF;
    lBuffer[11] := $FF;
    lBuffer[12] := $FF;
    lBuffer[13] := $FF;
    lBuffer[14] := $FF;
    for j:=1 to 16 do
      for i:=1 to 6 do lBuffer[15+(j-1)*6+(i-1)]:=lBuffer[i];
    lBuffer[116] := $00;
    lBuffer[115] := $40;
    lBuffer[114] := $90;
    lBuffer[113] := $90;
    lBuffer[112] := $00;
    lBuffer[111] := $40;
    lUDPClient:=TIdUDPClient.Create(nil);
    try
      lUDPClient.BroadcastEnabled:=True;
      lUDPClient.Host := '255.255.255.255';
      lUDPClient.Port := 2050;
      lUDPClient.SendBuffer(lBuffer, 116);
    except
      on E: Exception do ErrMsg(E.Message,'Wake up error');
    end;
    lUDPClient.Free;
  except
    on E: Exception do ErrMsg(E.Message,'Wake up error');
  end;
end;

end.

