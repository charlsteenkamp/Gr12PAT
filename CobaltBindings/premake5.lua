project "CobaltBindings"
    kind "SharedLib"
	flags { "MultiProcessorCompile" }

	files
	{
		"Source/**.cpp",
		"Source/**.hpp",
	}

	includedirs
	{
		"Source",
		"%{wks.location}/Cobalt/Source",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.VulkanSDK}",
		"%{IncludeDir.GLM}",
		"%{IncludeDir.stb_image}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.fastgltf}",
		"%{IncludeDir.Optick}",
		"%{IncludeDir.slang}"
	}

	links
	{
        "Cobalt",
        "ImGui",
        "GLFW",
        "stb_image",
		"fastgltf",
		"%{Library.slang}",
		"%{Library.Vulkan}",
		"%{Library.Optick}"
	}

    postbuildcommands
	{
		"{COPY} %{wks.location}/bin/" .. outputdir .. "/%{prj.name}/CobaltBindings.dll %{wks.location}/PAT/Win64/Debug",
		"{COPY} %{wks.location}/bin/" .. outputdir .. "/%{prj.name}/CobaltBindings.pdb %{wks.location}/PAT/Win64/Debug"
	}