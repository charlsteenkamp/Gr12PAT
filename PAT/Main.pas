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
    btnRender: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnRenderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnInitClick(Sender: TObject);
begin
  var hwnd := WindowHandleToPlatform(Self.Handle).Wnd;
  CobaltInit(hwnd);
end;

procedure TForm1.btnRenderClick(Sender: TObject);
begin
  CobaltRender();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  var hwnd := WindowHandleToPlatform(Self.Handle).Wnd;

  CobaltLoadDLL();
  //CobaltInit(hwnd);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //CobaltRender();
end;

end.
