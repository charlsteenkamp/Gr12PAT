project "fastgltf"
	kind "StaticLib"
	language "C++"

	targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
	objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

	links
	{
		"simdjson"
	}

	includedirs
	{
		"include",
		"%{IncludeDir.simdjson}"
	}

	files
	{
		"include/fastgltf/base64.hpp",
        "include/fastgltf/core.hpp",
        "include/fastgltf/dxmath_element_traits.hpp",
        "include/fastgltf/glm_element_traits.hpp",
        "include/fastgltf/tools.hpp",
        "include/fastgltf/types.hpp",
        "include/fastgltf/util.hpp",
        "include/fastgltf/math.hpp",
		"src/fastgltf.cpp",
        "src/base64.cpp",
        "src/io.cpp"
	}

	filter "configurations:Debug"
		symbols "on"

	filter "configurations:Release"
		optimize "on"
