unit ContentBrowserPanel;

interface

uses
  DesignPanel, ContentBrowserAssetTile,
  System.Generics.Collections, System.IOUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.Edit, FMX.EditBox,
  FMX.NumberBox;

type
  TContentBrowserPanelFrame = class(TDesignPanelFrame)
    sbAssetTiles: TVertScrollBox;
    pnlAssetTiles: TPanel;
    Layout1: TLayout;
    nbScale: TNumberBox;
    procedure sbAssetTilesResize(Sender: TObject);
    procedure nbScaleChange(Sender: TObject);

  public
    constructor Create(AOwner: TComponent);

  private
    procedure AlignAssetTiles();

  private
    FAssetTiles: TArray<TContentBrowserAssetTileFrame>;
    FScale, FSpacing: Single;
  end;

implementation

{$R *.fmx}

{ TContentBrowserPanelFrame }

constructor TContentBrowserPanelFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, 200);

  FScale := 1.0;
  FSpacing := 5.0;

  nbScale.Value := FScale;

  SetLength(FAssetTiles, 10);

  for var i := 0 to 9 do
  begin
    FAssetTiles[i] := TContentBrowserAssetTileFrame.Create(Self, 'Filename.ext');
    FAssetTiles[i].Name := Format('ContentBrowserAssetTile%d', [i]);
    FAssetTiles[i].Scale.X := FScale;
    FAssetTiles[i].Scale.Y := FScale;
    FAssetTiles[i].Parent := sbAssetTiles;
  end;
end;

procedure TContentBrowserPanelFrame.nbScaleChange(Sender: TObject);
begin
  inherited;

  FScale := nbScale.Value;
  AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.sbAssetTilesResize(Sender: TObject);
begin
  inherited;

  AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.AlignAssetTiles();
begin
  if Length(FAssetTiles) = 0 then
    Exit;

  var iRow := 0;
  var Spacing := FScale * FSpacing;

  FAssetTiles[0].Position.Point := PointF(sbAssetTiles.Padding.Left, sbAssetTiles.Padding.Top);
  FAssetTiles[0].Scale.Point := PointF(FScale, FScale);

  for var i := 1 to High(FAssetTiles) do
  begin
    FAssetTiles[i].Scale.Point := PointF(FScale, FScale);

    var PrevLeft := FAssetTiles[i - 1].Position.X;
    var PrevRight := PrevLeft + FAssetTiles[i - 1].AbsoluteWidth;

    if (PrevRight + FAssetTiles[i].AbsoluteWidth - sbAssetTiles.Padding.Left) > sbAssetTiles.Width then
    begin
      inc(iRow);
      FAssetTiles[i].Position.X := sbAssetTiles.Padding.Left;
    end else
    begin
      FAssetTiles[i].Position.X := PrevRight + Spacing;
    end;

    FAssetTiles[i].Position.Y := sbAssetTiles.Padding.Top + iRow * (FAssetTiles[i].AbsoluteHeight + Spacing);
  end;
end;

end.
