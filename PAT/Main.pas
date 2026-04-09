unit Main;

interface

uses
  Windows,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Platform.Win,
  FMX.Controls.Presentation, FMX.StdCtrls,
  CobaltBindings, Viewport;

type
  TForm1 = class(TForm)
    btnInit: TButton;
    pnlViewport: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnInitClick(Sender: TObject);

  private
    FCobaltBindings: TCobaltBindings;
    FViewport: TViewport;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnInitClick(Sender: TObject);
begin
  FViewport := TViewport.Create(Self, pnlViewport, FCobaltBindings);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCobaltBindings := TCobaltBindings.Create();
end;

end.
