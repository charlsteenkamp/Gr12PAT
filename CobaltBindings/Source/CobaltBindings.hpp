#pragma once
#include <Windows.h>

#define CO_API extern "C" __declspec(dllexport)

CO_API void __stdcall CobaltInit(HWND hwnd, bool enableImGui);
CO_API void __stdcall CobaltShutdown();
CO_API void __stdcall CobaltRender();