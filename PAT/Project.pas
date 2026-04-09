unit Project;

interface

uses
  Windows,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Platform.Win,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Menus, System.Generics.Collections,
  CobaltBindings, Viewport, Design, Materials, Specifications;

type
  TProjectForm = class(TForm)
    FTabSelector: TTabControl;
    tiDesign: TTabItem;
    tiMaterials: TTabItem;
    tiSpecifications: TTabItem;
    FMenuBar: TMenuBar;
    miFile: TMenuItem;
    miEdit: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    miFileOpenProject: TMenuItem;
    miFileOpenRecent: TMenuItem;
    miFileSaveProject: TMenuItem;
    miFileExit: TMenuItem;
    miEditPreferences: TMenuItem;
    miHelpAbout: TMenuItem;
    miViewPanels: TMenuItem;
    miViewPropertiesPanel: TMenuItem;
    miViewContentBrowserPanel: TMenuItem;
    miViewMeshViewPanel: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FTabSelectorChange(Sender: TObject);
    procedure miViewContentBrowserPanelClick(Sender: TObject);
    procedure miViewMeshViewPanelClick(Sender: TObject);
    procedure miViewPropertiesPanelClick(Sender: TObject);

  private
    FCobaltBindings: TCobaltBindings;

    FDesignFrame: TDesignFrame;
    FMaterialsFrame: TMaterialsFrame;
    FSpecificationsFrame: TSpecificationsFrame;

    FViewPanelsMenuItems: TDictionary<TTabItem, TArray<TMenuItem>>;
  end;

var
  ProjectForm: TProjectForm;

implementation

{$R *.fmx}

procedure TProjectForm.FormCreate(Sender: TObject);
begin
  FCobaltBindings := TCobaltBindings.Create();

  FDesignFrame := TDesignFrame.Create(Self, FCobaltBindings);
  FDesignFrame.Parent := tiDesign;

  FDesignFrame.PropertiesPanel.ToggleCallback := procedure(AIsVisible: Boolean)
  begin
    miViewPropertiesPanel.IsChecked := AIsVisible;
  end;

  FDesignFrame.ContentBrowserPanel.ToggleCallback := procedure(AIsVisible: Boolean)
  begin
    miViewContentBrowserPanel.IsChecked := AIsVisible;
  end;

  FDesignFrame.MeshViewPanel.ToggleCallback := procedure(AIsVisible: Boolean)
  begin
    miViewMeshViewPanel.IsChecked := AIsVisible;
  end;

  FMaterialsFrame := TMaterialsFrame.Create(Self);
  FMaterialsFrame.Parent := tiMaterials;

  FSpecificationsFrame := TSpecificationsFrame.Create(Self);
  FSpecificationsFrame.Parent := tiSpecifications;

  FViewPanelsMenuItems := TDictionary<TTabItem, TArray<TMenuItem>>.Create();
  FViewPanelsMenuItems.Add(tiDesign, [
    miViewPropertiesPanel,
    miViewContentBrowserPanel,
    miViewMeshViewPanel
  ]);
  FViewPanelsMenuItems.Add(tiMaterials, []);
  FViewPanelsMenuItems.Add(tiSpecifications, []);
end;

procedure TProjectForm.FTabSelectorChange(Sender: TObject);
begin
  for var Iter in FViewPanelsMenuItems do
  begin
    for var MenuItem in Iter.Value do
    begin
      MenuItem.Visible := Iter.Key = FTabSelector.ActiveTab;
    end;
  end;
end;

procedure TProjectForm.miViewContentBrowserPanelClick(Sender: TObject);
begin
  FDesignFrame.ContentBrowserPanel.ToggleCollapsed();
end;

procedure TProjectForm.miViewMeshViewPanelClick(Sender: TObject);
begin
  FDesignFrame.MeshViewPanel.ToggleCollapsed();
end;

procedure TProjectForm.miViewPropertiesPanelClick(Sender: TObject);
begin
  FDesignFrame.PropertiesPanel.ToggleCollapsed();
end;

end.
