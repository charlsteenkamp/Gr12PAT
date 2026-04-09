unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Platform.Win,
  CobaltBindings, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    btnInit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
  private
    FCobaltBindings: TCobaltBindings;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnInitClick(Sender: TObject);
begin
  FCobaltBindings.Init(WindowHandleToPlatform(Self.Handle).Wnd, true);
  Timer1.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCobaltBindings := TCobaltBindings.Create();
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  FCobaltBindings.Render();
end;

end.
