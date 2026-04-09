unit ContentBrowserPanel;

interface

uses
  DesignPanel,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TContentBrowserPanelFrame = class(TDesignPanelFrame)
  public
    constructor Create(AOwner: TComponent);
  end;

implementation

{$R *.fmx}

{ TContentBrowserPanelFrame }

constructor TContentBrowserPanelFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, 200);
end;

end.
