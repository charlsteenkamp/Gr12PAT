#include "copch.hpp"
#include "CobaltBindings.hpp"
#include "Window.hpp"
#include "Vulkan/GraphicsContext.hpp"
#include "Vulkan/ShaderCompiler.hpp"
#include "AssetManager.hpp"
#include "Vulkan/Renderer.hpp"

#include "RenderModule.hpp"

#include <thread>

BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
	}

	return TRUE;
}


using namespace Cobalt;

struct Context
{
    std::unique_ptr<Window> mWindow;
    std::unique_ptr<GraphicsContext> mGraphicsContext;
    std::unique_ptr<RenderModule> mRenderModule;
};

static Context* sContext = nullptr;

void CobaltInit(HWND hwnd)
{
    sContext = new Context();

    sContext->mWindow = std::make_unique<Window>(hwnd);
    sContext->mWindow->OnMouseMove([](float x, float y) { sContext->mRenderModule->OnMouseMove(x, y); });
    sContext->mWindow->Create();

    sContext->mGraphicsContext = std::make_unique<GraphicsContext>(*sContext->mWindow);
    sContext->mGraphicsContext->Init();

    ShaderCompiler::Init();
    AssetManager::Init();
    Renderer::Init();

    sContext->mRenderModule = std::make_unique<RenderModule>(sContext->mWindow->GetWindow());
    sContext->mRenderModule->OnInit();

#if 0
    std::thread renderThread([]()
	{
		while (true)
		{
			CobaltRender();
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
		}
	});
#endif
}

void CobaltShutdown()
{
    sContext->mRenderModule->OnShutdown();
    sContext->mGraphicsContext->Shutdown();

    delete sContext;
}

void CobaltRender()
{
    sContext->mGraphicsContext->RenderFrame({ sContext->mRenderModule.get() });
    sContext->mGraphicsContext->PresentFrame();
}