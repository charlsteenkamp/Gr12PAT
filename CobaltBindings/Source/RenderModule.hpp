#pragma once
#include "Module.hpp"
#include "CameraController.hpp"
#include "Vulkan/ShaderStructs.hpp"

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
		void OnUpdate(float deltaTime) override;
		void OnRender() override;

	private:
		CameraController mCameraController;
		GPUScene mScene;

		Mesh* mCubeMesh = nullptr;
		Mesh* mSphereMesh = nullptr;
	};

}
