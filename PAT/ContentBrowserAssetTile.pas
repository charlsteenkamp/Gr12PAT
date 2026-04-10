unit ContentBrowserAssetTile;

interface

uses
  System.SysUtils, System.IOUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TContentBrowserAssetTileFrame = class;
  TContentBrowserAssetTileClickFn = procedure(Sender: TContentBrowserAssetTileFrame) of object;

  TContentBrowserAssetTileFrame = class(TFrame)
    layoutThumbnail: TLayout;
    rectThumbnail: TRectangle;
    layoutAssetTile: TLayout;
    rectAssetTile: TRectangle;
    layoutLabel: TLayout;
    lblHeading: TLabel;
    imgThumbnail: TImage;
    procedure FrameClick(Sender: TObject);
    procedure FrameDblClick(Sender: TObject);

  public
    constructor Create(AOwner: TComponent; APath: String);

  private
    FPath: String;
    FIsFile: Boolean;

    FClickFn: TContentBrowserAssetTileClickFn;
    FDblClickFn: TContentBrowserAssetTileClickFn;

  public
    property Path: String read FPath;
    property IsFile: Boolean read FIsFile;
    property ClickFn: TContentBrowserAssetTileClickFn read FClickFn write FClickFn;
    property DblClickFn: TContentBrowserAssetTileClickFn read FDblClickFn write FDblClickFn;
  end;

implementation

{$R *.fmx}

constructor TContentBrowserAssetTileFrame.Create(AOwner: TComponent; APath: string);
begin
  inherited Create(AOwner);

  FPath := APath;

  if TFile.Exists(FPath) then
  begin
    FIsFile := True;
    imgThumbnail.Bitmap.LoadFromFile('Assets/Icons/File.png');
  end else
  if TDirectory.Exists(FPath) then
  begin
    FIsFile := False;
    imgThumbnail.Bitmap.LoadFromFile('Assets/Icons/Folder.png');
  end;

  lblHeading.Text := System.IOUtils.TPath.GetFileName(FPath);
end;

procedure TContentBrowserAssetTileFrame.FrameClick(Sender: TObject);
begin
  if Assigned(FClickFn) then
    FClickFn(Self);
end;

procedure TContentBrowserAssetTileFrame.FrameDblClick(Sender: TObject);
begin
  if Assigned(FDblClickFn) then
    FDblClickFn(Self);
end;

end.
