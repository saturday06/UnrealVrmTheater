#!/usr/bin/env pwsh

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"

$assimpSourceFolderPath = Join-Path $PSScriptRoot "PatchedAssimp"
if (-not (Test-Path $assimpSourceFolderPath)) {
  git -C $PSScriptRoot submodule update --init --recursive
}

$debugAssimpBuildFolderPath = Join-Path $assimpSourceFolderPath "build" "Debug"
New-Item -ItemType Directory $debugAssimpBuildFolderPath -Force

$releaseAssimpBuildFolderPath = Join-Path $assimpSourceFolderPath "build" "Release"
New-Item -ItemType Directory $releaseAssimpBuildFolderPath -Force

$vcVersion = "vc143"
$buildSharedLibs = $IsWindows ? "ON" : "OFF"
$vrm4uAssimpFolderPath = Join-Path $PSScriptRoot "Plugins" "VRM4U" "ThirdParty" "assimp"

New-Item -ItemType Directory (Join-Path $vrm4uAssimpFolderPath "bin" "x64") -Force
New-Item -ItemType Directory (Join-Path $vrm4uAssimpFolderPath "lib" "x64" "Debug") -Force
New-Item -ItemType Directory (Join-Path $vrm4uAssimpFolderPath "lib" "x64" "Release") -Force

if (-not (Test-Path (Join-Path $debugAssimpBuildFolderPath "CMakeCache.txt"))) {
  cmake `
    -DASSIMP_BUILD_ALL_EXPORTERS_BY_DEFAULT=OFF `
    -DASSIMP_WARNINGS_AS_ERRORS=OFF `
    "-DBUILD_SHARED_LIBS=${buildSharedLibs}" `
    -DCMAKE_BUILD_TYPE=Debug `
    -S $assimpSourceFolderPath `
    -B $debugAssimpBuildFolderPath
}
cmake --build $debugAssimpBuildFolderPath --config Debug
if ($IsWindows) {
  Copy-Item (Join-Path $debugAssimpBuildFolderPath "bin" "Debug" "assimp-${vcVersion}-mtd.dll") (Join-Path $vrm4uAssimpFolderPath "bin" "x64")
  Copy-Item (Join-Path $debugAssimpBuildFolderPath "bin" "Debug" "assimp-${vcVersion}-mtd.pdb") (Join-Path $vrm4uAssimpFolderPath "bin" "x64")
  Copy-Item (Join-Path $debugAssimpBuildFolderPath "lib" "Debug" "assimp-${vcVersion}-mtd.lib") (Join-Path $vrm4uAssimpFolderPath "lib" "x64" "Debug")
}
elseif ($IsMacOS) {
  Copy-Item (Join-Path $debugAssimpBuildFolderPath "lib" "libassimpd.a") (Join-Path $vrm4uAssimpFolderPath "lib" "Mac" "libassimp.a")
}

if ($IsWindows) {
  if (-not (Test-Path (Join-Path $releaseAssimpBuildFolderPath "CMakeCache.txt"))) {
    cmake `
      -DASSIMP_BUILD_ALL_EXPORTERS_BY_DEFAULT=OFF `
      -DASSIMP_WARNINGS_AS_ERRORS=OFF `
      "-DBUILD_SHARED_LIBS=${buildSharedLibs}" `
      -DCMAKE_BUILD_TYPE=Release `
      -S $assimpSourceFolderPath `
      -B $releaseAssimpBuildFolderPath
  }
  cmake --build $releaseAssimpBuildFolderPath --config Release
  Copy-Item (Join-Path $releaseAssimpBuildFolderPath "bin" "Release" "assimp-${vcVersion}-mt.dll") (Join-Path $vrm4uAssimpFolderPath "bin" "x64")
  Copy-Item (Join-Path $releaseAssimpBuildFolderPath "bin" "Release" "assimp-${vcVersion}-mt.pdb") (Join-Path $vrm4uAssimpFolderPath "bin" "x64")
  Copy-Item (Join-Path $releaseAssimpBuildFolderPath "lib" "Release" "assimp-${vcVersion}-mt.lib") (Join-Path $vrm4uAssimpFolderPath "lib" "x64" "Release")
}
