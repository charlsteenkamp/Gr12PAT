#include "copch.hpp"
#include "RenderModule.hpp"
#include "Vulkan/GraphicsContext.hpp"
#include "Model.hpp"
#include "Vulkan/Renderer.hpp"
#include "AssetManager.hpp"
#include "Vulkan/MaterialSystem.hpp"

#include <imgui.h>

namespace Cobalt
{


	RenderModule::RenderModule()
		: Module("RenderModule")
	{
		VkExtent2D extent = GraphicsContext::Get().GetSwapchain().GetExtent();

		mCameraController = CameraController(extent.width, extent.height);

		mScene.Camera.CameraTranslation = mCameraController.GetTranslation();
		mScene.Camera.ViewProjectionMatrix = mCameraController.GetViewProjectionMatrix();

		mScene.DirectionalLight.Direction = glm::vec3(0.0f, -1.0f, 0.0f);
		mScene.DirectionalLight.Intensity = glm::vec3(1.0f);
	}

	RenderModule::~RenderModule()
	{
	}

	void RenderModule::OnInit()
	{
		Model cubeModel = Model("Assets/Models/Cube.glb");
		Model sphereModel = Model("Assets/Models/Sphere.glb");
		
		mCubeMesh = AssetManager::GetMesh(cubeModel.GetMeshAssetHandle());
		mSphereMesh = AssetManager::GetMesh(sphereModel.GetMeshAssetHandle());

		auto& materialSystem = Renderer::GetMaterialSystem();

		mCubeMesh->SetMaterial(materialSystem.GetMaterial("PBR"));

		const Texture* defaultTexture = AssetManager::GetTexture("Default");
		Image defaultTextureImage = { defaultTexture->GetSampler(), defaultTexture->GetImageView(), defaultTexture->GetImageLayout() };

		MaterialInfo sphereMaterialInfo;
		sphereMaterialInfo.SampledTextures = { defaultTextureImage };
		sphereMaterialInfo.ShaderEffectName = "Opaque";
		sphereMaterialInfo.PackedMaterial.BaseColorFactor = { 0.3f, 0.3f, 0.3f, 1.0f };
		sphereMaterialInfo.PackedMaterial.MetallicFactor = 1.0f;
		sphereMaterialInfo.PackedMaterial.RoughnessFactor = 0.1f;

		Material* sphereMaterial = materialSystem.BuildMaterial("Sphere Material", sphereMaterialInfo);
		mSphereMesh->SetMaterial(sphereMaterial);

		CubemapInfo cubemapInfo;
		cubemapInfo.FilePaths.EquirectangularMap = "Assets/Textures/HDR/newport_loft.hdr";
		cubemapInfo.CubeMesh = mCubeMesh;

		Cubemap* skybox = AssetManager::GetCubemap(AssetManager::RegisterCubemap("Skybox", cubemapInfo));
		Renderer::SetSkybox(skybox);
	}

	void RenderModule::OnShutdown()
	{
	}

	void RenderModule::OnUpdate(GLFWwindow* window, float deltaTime)
	{
		mCameraController.OnUpdate(window, deltaTime);
	}

	void RenderModule::OnRender()
	{
		mScene.Camera.CameraTranslation = mCameraController.GetTranslation();
		mScene.Camera.ViewProjectionMatrix = mCameraController.GetViewProjectionMatrix();

		mScene.DirectionalLight.Direction = glm::normalize(mScene.DirectionalLight.Direction);

		Renderer::BeginScene(mScene, mCameraController.GetProjectionMatrix(), mCameraController.GetViewMatrix());
		Renderer::DrawMesh({ .Translation = { -2.0f, 0.0f, 0.0f } }, mCubeMesh);
		Renderer::DrawMesh({ .Translation = {  2.0f, 0.0f, 0.0f } }, mSphereMesh);
		Renderer::EndScene();
	}

	void RenderModule::OnUIRender()
	{
		ImGui::Begin("Debug");

		auto& materialSystem = Renderer::GetMaterialSystem();

		auto drawMaterialControls = [&](const std::string& materialName, Material* material)
		{
			MaterialInfo materialInfo = material->GetMaterialInfo();
			bool changed = false;

			ImGui::BeginChild(materialName.c_str(), ImVec2(ImGui::GetWindowContentRegionWidth(), 150), true);
			ImGui::Text(materialName.c_str());
			changed |= ImGui::ColorEdit3("Base Color", &materialInfo.PackedMaterial.BaseColorFactor.x);
			changed |= ImGui::DragFloat("Roughness", &materialInfo.PackedMaterial.RoughnessFactor, 0.001f, 0.0f, 1.0f);
			changed |= ImGui::DragFloat("Metallicness", &materialInfo.PackedMaterial.MetallicFactor, 0.001f, 0.0f, 1.0f);
			ImGui::EndChild();

			if (changed)
			{
				materialSystem.UpdateMaterial(material->GetMaterialHandle(), materialInfo);
			}
		};

		drawMaterialControls("Cube Material", mCubeMesh->GetMaterial());
		drawMaterialControls("Sphere Material", mSphereMesh->GetMaterial());

		ImGui::End();
	}

	void RenderModule::OnMouseMove(float x, float y)
	{
		mCameraController.OnMouseMove(x, y);
	}

	void RenderModule::OnResize(uint32_t width, uint32_t height)
	{
		mCameraController.OnResize(width, height);
	}

}