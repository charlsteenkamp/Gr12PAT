program Gr12PAT;

uses
  System.StartUpCopy,
  Windows,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  CobaltBindings in 'CobaltBindings.pas';

{$R *.res}

begin
  AllocConsole();
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
  FreeConsole();
end.
