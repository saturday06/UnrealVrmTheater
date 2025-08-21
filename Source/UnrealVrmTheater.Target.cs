using UnrealBuildTool;
using System.Collections.Generic;

public class UnrealVrmTheaterTarget : TargetRules
{
	public UnrealVrmTheaterTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Game;
		DefaultBuildSettings = BuildSettingsVersion.V5;
		IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_6;
		ExtraModuleNames.Add("UnrealVrmTheater");
	}
}
