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
  PDirectoryNavNode = ^TDirectoryNavNode;

  TDirectoryNavNode = record
    Directory: String;

    PPrev: PDirectoryNavNode;
    PNext: PDirectoryNavNode;
  end;

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
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure edtFindChange(Sender: TObject);

  public
    constructor Create(AOwner: TComponent; AAssetsDirectory: String);

  private
    procedure ParseDirectory(ADirectory: String; AFreeNextChain: Boolean = True);
    procedure AlignAssetTiles();

    procedure OnAssetTileDoubleClick(Sender: TContentBrowserAssetTileFrame);

  private
    FAssetsDirectory: String;
    FCurrentDirectory: String;

    FAssetTiles: TArray<TContentBrowserAssetTileFrame>;
    FScale, FSpacing: Single;

    FDirNavHead, FCurrDirNavNode: PDirectoryNavNode;
  end;

implementation

{$R *.fmx}

{ TContentBrowserPanelFrame }

constructor TContentBrowserPanelFrame.Create(AOwner: TComponent; AAssetsDirectory: String);
begin
  inherited Create(AOwner, 200);

  FScale := 1.0;
  FSpacing := 5.0;
  FAssetsDirectory := AAssetsDirectory;

  if TDirectory.IsRelativePath(FAssetsDirectory) then
    FAssetsDirectory := System.IOUtils.TPath.Combine(TDirectory.GetCurrentDirectory(), FAssetsDirectory);

  New(FDirNavHead);
  New(FCurrDirNavNode);
  FDirNavHead^.Directory := FAssetsDirectory;
  FDirNavHead^.PPrev := nil;
  FDirNavHead^.PNext := nil;
  FCurrDirNavNode := FDirNavHead;

  ParseDirectory(FAssetsDirectory);
end;

procedure TContentBrowserPanelFrame.ParseDirectory(ADirectory: String; AFreeNextChain: Boolean);
begin
  for var i := 0 to High(FAssetTiles) do
  begin
    FAssetTiles[i].Destroy();
    FAssetTiles[i] := nil;
  end;

  SetLength(FAssetTiles, 0);

  FCurrentDirectory := ADirectory;
  edtDirectory.Text := FCurrentDirectory;

  if AFreeNextChain and (FCurrentDirectory <> FCurrDirNavNode^.Directory) then
  begin
    var NodeIter := FCurrDirNavNode.PNext;

    while NodeIter <> nil do
    begin
     var PNext := NodeIter.PNext;
      Dispose(NodeIter);
      NodeIter := PNext;
    end;

    New(FCurrDirNavNode.PNext);
    FCurrDirNavNode^.PNext^.Directory := FCurrentDirectory;
    FCurrDirNavNode^.PNext^.PPrev := FCurrDirNavNode;
    FCurrDirNavNode^.PNext^.PNext := nil;
    FCurrDirNavNode := FCurrDirNavNode^.PNext;
  end;

  btnBack.Enabled := FCurrDirNavNode^.PPrev <> nil;
  btnForward.Enabled := FCurrDirNavNode^.PNext <> nil;

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

  var iPrevIndex := -1;

  FAssetTiles[0].Position.Point := PointF(sbAssetTiles.Padding.Left, sbAssetTiles.Padding.Top);
  FAssetTiles[0].Scale.Point := PointF(FScale, FScale);

  for var i := 1 to High(FAssetTiles) do
  begin
    if not FAssetTiles[i].Visible then
      continue;

    FAssetTiles[i].Scale.Point := PointF(FScale, FScale);

    if iPrevIndex >= 0 then
    begin
      var PrevLeft := FAssetTiles[iPrevIndex].Position.X;
      var PrevRight := PrevLeft + FAssetTiles[iPrevIndex].AbsoluteWidth;

      if (PrevRight + FAssetTiles[i].AbsoluteWidth - sbAssetTiles.Padding.Left) > sbAssetTiles.Width then
      begin
        inc(iRow);
        FAssetTiles[i].Position.X := sbAssetTiles.Padding.Left;
      end else
      begin
        FAssetTiles[i].Position.X := PrevRight + Spacing;
      end;
    end else
    begin
      FAssetTiles[i].Position.X := sbAssetTiles.Padding.Left;
    end;

    FAssetTiles[i].Position.Y := sbAssetTiles.Padding.Top + iRow * (FAssetTiles[i].AbsoluteHeight + Spacing);
    iPrevIndex := i;
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

procedure TContentBrowserPanelFrame.btnBackClick(Sender: TObject);
begin
  inherited;

  FCurrDirNavNode := FCurrDirNavNode^.PPrev;
  ParseDirectory(FCurrDirNavNode^.Directory, False);
  AlignAssetTiles();
end;

procedure TContentBrowserPanelFrame.btnForwardClick(Sender: TObject);
begin
  inherited;

  FCurrDirNavNode := FCurrDirNavNode^.PNext;
  ParseDirectory(FCurrDirNavNode^.Directory, False);
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

procedure TContentBrowserPanelFrame.edtFindChange(Sender: TObject);
begin
  inherited;

  for var AssetTile in FAssetTiles do
  begin
    AssetTile.Visible := AssetTile.Path.Contains(edtFind.Text) or edtFind.Text.IsEmpty;
  end;

  AlignAssetTiles();
end;

end.
