unit ContentBrowserPanel;

interface

uses
  DesignPanel, ContentBrowserAssetTile,
  System.Generics.Collections, System.IOUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.Edit, FMX.EditBox,
  FMX.NumberBox, FMX.ExtCtrls;

type
  TContentBrowserPanelFrame = class(TDesignPanelFrame)
    sbAssetTiles: TVertScrollBox;
    pnlAssetTiles: TPanel;
    layoutControls: TLayout;
    btnParentDirectory: TSpeedButton;
    imgParentDirectory: TImage;
    btnForward: TSpeedButton;
    btnBack: TSpeedButton;
    imgBack: TImage;
    imgForward: TImage;
    edtFind: TEdit;
    edtDirectory: TEdit;
    btnFind: TSpeedButton;
    imgFind: TImage;
    procedure sbAssetTilesResize(Sender: TObject);
    procedure btnParentDirectoryClick(Sender: TObject);
    procedure edtDirectoryChange(Sender: TObject);

  public
    constructor Create(AOwner: TComponent; AAssetsDirectory: String);

  private
    procedure ParseDirectory(ADirectory: String);
    procedure AlignAssetTiles();

    procedure OnAssetTileDoubleClick(Sender: TContentBrowserAssetTileFrame);

  private
    FAssetsDirectory: String;
    FCurrentDirectory: String;

    FAssetTiles: TArray<TContentBrowserAssetTileFrame>;
    FScale, FSpacing: Single;
  end;

implementation

{$R *.fmx}

{ TContentBrowserPanelFrame }

constructor TContentBrowserPanelFrame.Create(AOwner: TComponent; AAssetsDirectory: String);
begin
  inherited Create(AOwner, 200);

  FAssetsDirectory := AAssetsDirectory;

  if TDirectory.IsRelativePath(FAssetsDirectory) then
    FAssetsDirectory := System.IOUtils.TPath.Combine(TDirectory.GetCurrentDirectory(), FAssetsDirectory);

  ParseDirectory(FAssetsDirectory);

  FScale := 1.0;
  FSpacing := 5.0;
end;

procedure TContentBrowserPanelFrame.ParseDirectory(ADirectory: String);
begin
  for var i := 0 to High(FAssetTiles) do
  begin
    FAssetTiles[i].Destroy();
    FAssetTiles[i] := nil;
  end;

  SetLength(FAssetTiles, 0);

  FCurrentDirectory := ADirectory;
  edtDirectory.Text := FCurrentDirectory;

  var Directories := TDirectory.GetDirectories(FCurrentDirectory);
  var Files := TDirectory.GetFiles(FCurrentDirectory);

  SetLength(FAssetTiles, Length(Directories) + Length(Files));
  var i := 0;

  for var DirectoryEntry in Directories do
  begin
    FAssetTiles[i] := TContentBrowserAssetTileFrame.Create(Self, DirectoryEntry);
    FAssetTiles[i].Name := Format('ContentBrowserPanelAssetTile_%d', [i]);
    FAssetTiles[i].Parent := sbAssetTiles;
    FAssetTiles[i].DblClickFn := Self.OnAssetTileDoubleClick;

    inc(i);
  end;

  for var FileEntry in Files do
  begin
    FAssetTiles[i] := TContentBrowserAssetTileFrame.Create(Self, FileEntry);
    FAssetTiles[i].Name := Format('ContentBrowserPanelAssetTile_%d', [i]);
    FAssetTiles[i].Parent := sbAssetTiles;

    inc(i);
  end;
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

procedure TContentBrowserPanelFrame.OnAssetTileDoubleClick(Sender: TContentBrowserAssetTileFrame);
begin
  ParseDirectory(Sender.Path);
  AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.sbAssetTilesResize(Sender: TObject);
begin
  inherited;

  AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.btnParentDirectoryClick(Sender: TObject);
begin
  inherited;

  ParseDirectory(TDirectory.GetParent(FCurrentDirectory));
  AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.edtDirectoryChange(Sender: TObject);
begin
  inherited;

  if (TDirectory.Exists(edtDirectory.Text)) and (edtDirectory.Text <> FCurrentDirectory) then
  begin
    ParseDirectory(edtDirectory.Text);
    AlignAssetTiles();
  end;
end;

end.
