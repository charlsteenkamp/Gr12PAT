unit ContentBrowserAssetTile;

interface

uses
  System.SysUtils, System.IOUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TContentBrowserAssetTileFrame = class(TFrame)
    layoutThumbnail: TLayout;
    rectThumbnail: TRectangle;
    layoutAssetTile: TLayout;
    rectAssetTile: TRectangle;
    Image1: TImage;
    layoutLabel: TLayout;
    lblHeading: TLabel;

  public
    constructor Create(AOwner: TComponent; APath: String);

  private
    FPath: String;
  end;

implementation

{$R *.fmx}

constructor TContentBrowserAssetTileFrame.Create(AOwner: TComponent; APath: string);
begin
  inherited Create(AOwner);

  FPath := APath;
  lblHeading.Text := System.IOUtils.TPath.GetFileName(FPath);
end;

end.
