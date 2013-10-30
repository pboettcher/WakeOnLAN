program WOL;

uses WakeOnLAN,Windows;

{$R *.res}

begin
  if ParamCount>0 then WakeUpComputer(ParamStr(1))
  else begin
    MessageBox(0, 'Wake On LAN - wakes the remote computer up by sending a Magic Packet.'#13#10'Syntax: WOL.exe MAC_ADDRESS'#13#10#10'Example: WOL 001485607ff6','Wake On LAN', 0);
  end;
end.
