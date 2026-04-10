unit DesignPanel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TPanelToggleCallback = reference to procedure(AVisible: Boolean);

  TDesignPanelFrame = class(TFrame)
    lblHeading: TLabel;
    layoutHeading: TLayout;
    layoutContents: TLayout;
    btnCollapse: TSpeedButton;
    procedure btnCollapseClick(Sender: TObject);

  public
    constructor Create(AOwner: TComponent; AMinWidth: Single = 100.0);
    procedure ToggleCollapsed();

  public
    procedure OnPanelResize(Sender: TObject);

  private
    FMinWidth: Single;
    FPreviousWidth, FPreviousHeight: Single;
    FCollapsed: Boolean;

    FToggleCallback: TPanelToggleCallback;

  public
    property ToggleCallback: TPanelToggleCallback read FToggleCallback write FToggleCallback;
  end;

implementation

{$R *.fmx}

{ TDesignPanelFrame }

procedure TDesignPanelFrame.btnCollapseClick(Sender: TObject);
begin
  ToggleCollapsed();
end;

constructor TDesignPanelFrame.Create(AOwner: TComponent; AMinWidth: Single);
begin
  inherited Create(AOwner);

  FMinWidth := AMinWidth;
  FPreviousWidth := Self.Width;
  FPreviousHeight := Self.Height;
end;

procedure TDesignPanelFrame.ToggleCollapsed;
begin
  var Panel := TPanel(Self.Parent);

  FCollapsed := not FCollapsed;

  if FCollapsed then
  begin
    FPreviousWidth := Panel.Width;
    FPreviousHeight := Panel.Height;

    Panel.Width := 0.0;
    Panel.Height := 0.0;
  end else
  begin
    Panel.Width := FPreviousWidth;
    Panel.Height := FPreviousHeight;
  end;

  FToggleCallback(not FCollapsed);
end;

procedure TDesignPanelFrame.OnPanelResize(Sender: TObject);
begin
  if FCollapsed then
    Exit;

  var Panel := TPanel(Sender);

  if Panel.Width < FMinWidth then
  begin
    Panel.Width := FMinWidth;
  end;
end;

end.
