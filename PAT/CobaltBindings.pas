unit CobaltBindings;

interface

uses Windows;

type
  TCobaltBindings = class
  public
    constructor Create();

    procedure Init(hwnd: HWND; enableImGui: Boolean);
    procedure Shutdown();
    procedure Render();

  private
    procedure LoadDLL();

  private
    FLibraryHandle: HMODULE;
    FInitFn: procedure(hwnd: HWND; enableImGui: Boolean); stdcall;
    FShutdownFn: procedure(); stdcall;
    FRenderFn: procedure(); stdcall;

    const DLL_PATH = 'CobaltBindings.dll';
  end;

implementation

constructor TCobaltBindings.Create();
begin
  LoadDLL();
end;

procedure TCobaltBindings.Init(hwnd: HWND; enableImGui: Boolean);
begin
  FInitFn(hwnd, enableImGui);
end;

procedure TCobaltBindings.Shutdown();
begin
  FShutdownFn();
end;

procedure TCobaltBindings.Render();
begin
  FRenderFn();
end;

procedure TCobaltBindings.LoadDLL();
begin
  FLibraryHandle := LoadLibrary('CobaltBindings.dll');

  @FInitFn := GetProcAddress(FLibraryHandle, 'CobaltInit');
  @FShutdownFn := GetProcAddress(FLibraryHandle, 'CobaltShutdown');
  @FRenderFn := GetProcAddress(FLibraryHandle, 'CobaltRender');
end;

end.
