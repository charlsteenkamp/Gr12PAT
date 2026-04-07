#pragma once
#include "Module.hpp"
#include "CameraController.hpp"
#include "Vulkan/ShaderStructs.hpp"
#include <GLFW/glfw3.h>

namespace Cobalt
{

	class RenderModule : public Module
	{
	public:
		RenderModule();
		~RenderModule();

	public:
		void OnInit() override;
		void OnShutdown() override;
		void OnUpdate(GLFWwindow* window, float deltaTime);
		void OnRender() override;
		void OnUIRender() override;
		void OnMouseMove(float x, float y) override;
		void OnResize(uint32_t width, uint32_t height) override;

	private:
		CameraController mCameraController;
		GPUScene mScene;

		Mesh* mCubeMesh = nullptr;
		Mesh* mSphereMesh = nullptr;
	};

}
