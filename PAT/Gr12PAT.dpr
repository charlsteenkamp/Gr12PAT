program Gr12PAT;

uses
  System.StartUpCopy,
  Windows,
  FMX.Forms,
  CobaltBindings in 'CobaltBindings.pas',
  ContentBrowserPanel in 'ContentBrowserPanel.pas' {ContentBrowserPanelFrame: TFrame},
  Design in 'Design.pas' {DesignFrame: TFrame},
  DesignPanel in 'DesignPanel.pas' {DesignPanelFrame: TFrame},
  Materials in 'Materials.pas' {MaterialsFrame: TFrame},
  MeshViewPanel in 'MeshViewPanel.pas' {MeshViewPanelFrame: TFrame},
  Project in 'Project.pas' {ProjectForm},
  PropertiesPanel in 'PropertiesPanel.pas' {PropertiesPanelFrame: TFrame},
  Specifications in 'Specifications.pas' {SpecificationsFrame: TFrame},
  Viewport in 'Viewport.pas';

{$R *.res}

begin
  AllocConsole();
  Application.Initialize;
  Application.CreateForm(TProjectForm, ProjectForm);
  Application.Run;
  FreeConsole();
end.
