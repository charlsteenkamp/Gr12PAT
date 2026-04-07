unit CobaltBindings;

interface

uses Windows;

procedure CobaltLoadDLL();
procedure CobaltInit(hwnd: HWND);
procedure CobaltShutdown();
procedure CobaltRender();

implementation

const
  COBALT_BINDINGS_DLL = 'CobaltBindings.dll';

var
  CobaltBindingsDLLHandle: HMODULE;
  CobaltInitFn: procedure(hwnd: HWND); stdcall;
  CobaltShutdownFn: procedure(); stdcall;
  CobaltRenderFn: procedure(); stdcall;

procedure CobaltLoadDLL();
begin
  CobaltBindingsDLLHandle := LoadLibrary('CobaltBindings.dll');

  @CobaltInitFn := GetProcAddress(CobaltBindingsDLLHandle, 'CobaltInit');
  @CobaltShutdownFn := GetProcAddress(CobaltBindingsDLLHandle, 'CobaltShutdown');
  @CobaltRenderFn := GetProcAddress(CobaltBindingsDLLHandle, 'CobaltRender');
end;

procedure CobaltInit(hwnd: HWND);
begin
  CobaltInitFn(hwnd);
end;

procedure CobaltShutdown();
begin
  CobaltShutdownFn();
end;

procedure CobaltRender();
begin
  CobaltRenderFn();
end;

end.
