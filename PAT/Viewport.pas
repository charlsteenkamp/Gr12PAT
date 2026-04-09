unit Viewport;

interface

uses
  Windows, CobaltBindings, System.Classes, System.Types,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Platform.Win;

type
  TViewport = class
  public
    constructor Create(AOwner: TForm; AParent: TControl; ACobaltBindings: TCobaltBindings);
    procedure Resize();

  private
    function CreateChildWindow(): HWND;
    procedure OnTimer(Sender: TObject);

  private
    FOwner: TForm;
    FParent: TControl;
    FCobaltBindings: TCobaltBindings;

    FWindowHandle: HWND;

    FTimer: TTimer;
  end;

implementation

{ TViewport }

constructor TViewport.Create(AOwner: TForm; AParent: TControl; ACobaltBindings: TCobaltBindings);
begin
  FOwner := AOwner;
  FParent := AParent;
  FCobaltBindings := ACobaltBindings;

  FWindowHandle := CreateChildWindow();
  FCobaltBindings.Init(FWindowHandle, true);

  FTimer := TTimer.Create(AOwner);
  FTimer.Interval := 15;
  FTimer.Enabled := True;
  FTimer.OnTimer := Self.OnTimer;
end;

procedure TViewport.Resize;
begin
  var Position := FParent.LocalToAbsolute(TPointF.Zero);
  var Scale := FOwner.Canvas.Scale;

  SetWindowPos(
    FWindowHandle, 0,
    Round(Position.X * Scale), Round(Position.Y * Scale),
    Round(FParent.Width * Scale), Round(FParent.Height * Scale),
    SWP_NOZORDER or SWP_NOACTIVATE
  );
end;

function TViewport.CreateChildWindow(): HWND;
begin
  var Position := FParent.LocalToAbsolute(TPointF.Zero);
  var Scale := FOwner.Canvas.Scale;

  Result := CreateWindowEx(
    0, 'STATIC', nil,
    WS_CHILD or WS_VISIBLE or WS_CLIPSIBLINGS or WS_CLIPCHILDREN,
    Round(Position.X * Scale), Round(Position.Y * Scale),
    Round(FParent.Width * Scale), Round(FParent.Height * Scale),
    WindowHandleToPlatform(FOwner.Handle).Wnd,
    0, GetModuleHandle(nil), nil
  );

  EnableWindow(FWindowHandle, True);
end;

procedure TViewport.OnTimer(Sender: TObject);
begin
  FCobaltBindings.Render();
end;

end.
