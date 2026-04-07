#include "copch.hpp"
#include "CobaltBindings.hpp"
#include "Window.hpp"
#include "Vulkan/GraphicsContext.hpp"
#include "Vulkan/ShaderCompiler.hpp"
#include "AssetManager.hpp"
#include "Vulkan/Renderer.hpp"

#include "RenderModule.hpp"
#include "Vulkan/ImGuiPass.hpp"

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
    std::unique_ptr<ImGuiPass> mImGuiPass;
};

static Context* sContext = nullptr;

void CobaltInit(HWND hwnd, bool enableImGui)
{
    sContext = new Context();

    sContext->mWindow = std::make_unique<Window>(hwnd);
    sContext->mWindow->OnMouseMove([](float x, float y) { sContext->mRenderModule->OnMouseMove(x, y); });
    sContext->mWindow->OnWindowResize([](float width, float height) { sContext->mRenderModule->OnResize(width, height); });
    sContext->mWindow->Create();

    sContext->mGraphicsContext = std::make_unique<GraphicsContext>(*sContext->mWindow);
    sContext->mGraphicsContext->Init();

    ShaderCompiler::Init();
    AssetManager::Init();
    Renderer::Init();

    sContext->mRenderModule = std::make_unique<RenderModule>();
    sContext->mRenderModule->OnInit();

	if (enableImGui)
	{
		sContext->mImGuiPass = std::make_unique<ImGuiPass>();
		sContext->mImGuiPass->Init(sContext->mWindow->GetWindow());
		sContext->mGraphicsContext->SetImGuiPass(sContext->mImGuiPass.get());
	}
}

void CobaltShutdown()
{
	sContext->mImGuiPass->Shutdown();
    sContext->mRenderModule->OnShutdown();
    sContext->mGraphicsContext->Shutdown();

    delete sContext;
}

void CobaltRender()
{
	static float lastFrameTime = 0.0f;

	float currentTime = glfwGetTime();
	float deltaTime = currentTime - lastFrameTime;
	lastFrameTime = currentTime;

	sContext->mRenderModule->OnUpdate(sContext->mWindow->GetWindow(), deltaTime);

	if (sContext->mGraphicsContext->ShouldRecreateSwapchain())
	{
		sContext->mGraphicsContext->OnResize();
		Renderer::OnResize();

		if (sContext->mImGuiPass)
			sContext->mImGuiPass->OnResize();
	}

	if (sContext->mImGuiPass)
	{
		sContext->mImGuiPass->BeginFrame();
		sContext->mRenderModule->OnUIRender();
		sContext->mImGuiPass->EndFrame();
	}

	sContext->mGraphicsContext->RenderFrame({ sContext->mRenderModule.get() });
	sContext->mGraphicsContext->PresentFrame();
}