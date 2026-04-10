unit Design;

interface

uses
  CobaltBindings, Viewport, PropertiesPanel, ContentBrowserPanel, MeshViewPanel,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TDesignFrame = class(TFrame)
    pnlProperties: TPanel;
    pnlMeshView: TPanel;
    pnlViewport: TPanel;
    layoutCenter: TLayout;
    pnlContentBrowser: TPanel;
    splitLeft: TSplitter;
    splitRight: TSplitter;
    splitCenter: TSplitter;
  public
    constructor Create(AOwner: TComponent; ACobaltBindings: TCobaltBindings);

  private
    FViewport: TViewport;

    FPropertiesPanel: TPropertiesPanelFrame;
    FContentBrowserPanel: TContentBrowserPanelFrame;
    FMeshViewPanel: TMeshViewPanelFrame;

  public
    property PropertiesPanel: TPropertiesPanelFrame read FPropertiesPanel write FPropertiesPanel;
    property ContentBrowserPanel: TContentBrowserPanelFrame read FContentBrowserPanel write FContentBrowserPanel;
    property MeshViewPanel: TMeshViewPanelFrame read FMeshViewPanel write FMeshViewPanel;
    property Viewport: TViewport read FViewport write FViewport;
  end;

implementation

{$R *.fmx}

{ TDesignFrame }

constructor TDesignFrame.Create(AOwner: TComponent; ACobaltBindings: TCobaltBindings);
begin
  inherited Create(AOwner);

  FPropertiesPanel := TPropertiesPanelFrame.Create(Self);
  FPropertiesPanel.Parent := pnlProperties;
  pnlProperties.OnResize := FPropertiesPanel.OnPanelResize;

  FContentBrowserPanel := TContentBrowserPanelFrame.Create(Self, 'Assets');
  FContentBrowserPanel.Parent := pnlContentBrowser;
  pnlContentBrowser.OnResize := FContentBrowserPanel.OnPanelResize;

  FMeshViewPanel := TMeshViewPanelFrame.Create(Self);
  FMeshViewPanel.Parent := pnlMeshView;
  pnlMeshView.OnResize := FMeshViewPanel.OnPanelResize;

  Exit;
  // Initialize renderer in the background

  TThread.CreateAnonymousThread(procedure()
  begin
    TThread.Queue(nil, procedure
    begin
      FViewport := TViewport.Create(TForm(AOwner), pnlViewport, ACobaltBindings);
    end);
  end).Start();
end;

end.
