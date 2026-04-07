#include "copch.hpp"
#include "RenderModule.hpp"
#include "Vulkan/GraphicsContext.hpp"
#include "Model.hpp"
#include "Vulkan/Renderer.hpp"
#include "AssetManager.hpp"
#include "Vulkan/MaterialSystem.hpp"

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

	void RenderModule::OnUpdate(float deltaTime)
	{
	}

	void RenderModule::OnRender()
	{
		//mCameraController.OnUpdate(16.0f / 1000.0f);

		mScene.Camera.CameraTranslation = mCameraController.GetTranslation();
		mScene.Camera.ViewProjectionMatrix = mCameraController.GetViewProjectionMatrix();

		mScene.DirectionalLight.Direction = glm::normalize(mScene.DirectionalLight.Direction);

		Renderer::BeginScene(mScene, mCameraController.GetProjectionMatrix(), mCameraController.GetViewMatrix());
		Renderer::DrawMesh({ .Translation = { -2.0f, 0.0f, 0.0f } }, mCubeMesh);
		Renderer::DrawMesh({ .Translation = {  2.0f, 0.0f, 0.0f } }, mSphereMesh);
		Renderer::EndScene();
	}

}