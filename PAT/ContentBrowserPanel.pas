unit ContentBrowserPanel;

interface

uses
  DesignPanel,
  System.Generics.Collections, System.IOUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TContentBrowserAssetTile = class(TPanel)
  public
    constructor Create(AOwner: TComponent; APath: String);

  private
    FPath: String;
    FFileNameLabel: TLabel;
    FThumbnail: TImage;
    FSpacing: Single;

  public
    property Spacing: Single read FSpacing write FSpacing;
  end;

  TContentBrowserPanelFrame = class(TDesignPanelFrame)
    sbAssetTiles: TVertScrollBox;
    pnlAssetTiles: TPanel;
    procedure sbAssetTilesResize(Sender: TObject);

  public
    constructor Create(AOwner: TComponent);

  private
    procedure AlignAssetTiles();

  private
    FAssetTiles: TArray<TContentBrowserAssetTile>;
    FScale: Single;
  end;

implementation

{$R *.fmx}

{ TContentBrowserAssetTile }

constructor TContentBrowserAssetTile.Create(AOwner: TComponent; APath: String);
begin
  inherited Create(AOwner);

  Self.Width := 50.0;
  Self.Height := 65.0;
  Self.Padding.Left := 10.0;
  Self.Padding.Top := 10.0;
  Self.Padding.Right := 10.0;
  Self.Padding.Bottom := 10.0;

  FSpacing := 5.0;
  FPath := APath;

  FThumbnail := TImage.Create(Self);
  FThumbnail.Bitmap.Clear(TAlphaColors.Black);
  FThumbnail.Parent := Self;
  FThumbnail.Align := TAlignLayout.Top;
  //FThumbnail.Width :=
  FThumbnail.Height := 60.0;

  FFileNameLabel := TLabel.Create(Self);
  FFileNameLabel.Parent := Self;
  FFileNameLabel.Align := TAlignLayout.Top;
  FFileNameLabel.TextSettings.HorzAlign := TTextAlign.Center;
  FFileNameLabel.Text := System.IOUtils.TPath.GetFileName(APath);
end;

{ TContentBrowserPanelFrame }

constructor TContentBrowserPanelFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, 200);

  FScale := 1.0;

  SetLength(FAssetTiles, 10);

  for var i := 0 to 9 do
  begin
    FAssetTiles[i] := TContentBrowserAssetTile.Create(Self, 'Filename.ext');
    FAssetTiles[i].Parent := sbAssetTiles;
  end;
end;

procedure TContentBrowserPanelFrame.sbAssetTilesResize(Sender: TObject);
begin
  inherited;

  if Length(FAssetTiles) <> 0 then
    AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.AlignAssetTiles();
begin
  var iRow := 0;

  FAssetTiles[0].Position.X := sbAssetTiles.Padding.Left;
  FAssetTiles[0].Position.Y := sbAssetTiles.Padding.Top;

  for var i := 1 to High(FAssetTiles) do
  begin
    var PrevLeft := FAssetTiles[i - 1].Position.X;
    var PrevRight := PrevLeft + FAssetTiles[i - 1].Width;

    if (PrevRight + FAssetTiles[i].Width - sbAssetTiles.Padding.Left) > sbAssetTiles.Width then
    begin
      inc(iRow);
      FAssetTiles[i].Position.X := sbAssetTiles.Padding.Left;
    end else
    begin
      FAssetTiles[i].Position.X := PrevRight + FAssetTiles[i].Spacing;
    end;

    FAssetTiles[i].Position.Y := sbAssetTiles.Padding.Top + iRow * (FAssetTiles[i].Height + FAssetTiles[i].Spacing);
  end;




end;

end.
