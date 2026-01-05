using UnrealBuildTool;
using System.Collections.Generic;

public class UnrealVrmTheaterEditorTarget : TargetRules
{
	public UnrealVrmTheaterEditorTarget( TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.V6;
		IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_7;
		ExtraModuleNames.Add("UnrealVrmTheater");
	}
}
