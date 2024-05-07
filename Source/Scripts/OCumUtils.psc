ScriptName OCumUtils


Function WriteLog(string In) global
	MiscUtil.PrintConsole("OCum: " + In)
EndFunction


Bool Function ChanceRoll(Int Chance) global ; input 60: 60% of returning true
	return Utility.RandomInt(0, 99) < Chance
EndFunction


Bool Function StringContains(string str, string contains) global
	return StringUtil.Find(str, contains) != -1
EndFunction


Bool Function IsPlayerInFreeCam() global
	return Game.GetCameraState() == 3
EndFunction


int Function GetLoadSizeFromML(float percentage) global
	; Load size
	; none: 0%-1% of max storage
	; Small: 1-10% of max storage
	; Medium: 10-20% of max storage
	; Large: 20-35% of max storage
	; Massive 35%+ of max storage

	if percentage < 0.01
		return 0
	elseif percentage < 0.1
		return 1
	elseif percentage < 0.2
		return 2
	elseif percentage < 0.35
		return 3
	else
		return 4
	endif
EndFunction


float Function ThreeDeeDistance(float[] pointSet1, float[] pointSet2) global
	return math.sqrt( ((pointset2[0] - pointSet1[0]) * (pointset2[0] - pointSet1[0])) +  ((pointset2[1] - pointSet1[1]) * (pointset2[1] - pointSet1[1])) + ((pointset2[2] - pointSet1[2]) * (pointset2[2] - pointSet1[2])))
EndFunction


float[] Function GetNodeLocation(actor act, string node) global
	float[] ret = new float[3]
	NetImmerse.GetNodeWorldPosition(act, node, ret, false)
	return ret
EndFunction


string Function GetCumTexture(string filename) global
	return "CumOverlays\\" + filename + ".dds"
EndFunction


string Function GetCumTextureUBE(string filename) global
	return "CumOverlaysUBE\\" + filename + ".dds"
EndFunction


Int Function GetNumSlots(String Area) global
	If Area == "Body"
		Return NiOverride.GetNumBodyOverlays()
	ElseIf Area == "Face"
		Return NiOverride.GetNumFaceOverlays()
	ElseIf Area == "Hands"
		Return NiOverride.GetNumHandOverlays()
	Else
		Return NiOverride.GetNumFeetOverlays()
	EndIf
EndFunction


Int Function GetEmptySlot(Actor akTarget, Bool Gender, String Area) global
	Int i = 0
	Int NumSlots = GetNumSlots(Area)
	String TexPath
	Bool FirstPass = true

	While i < NumSlots
		TexPath = NiOverride.GetNodeOverrideString(akTarget, Gender, Area + " [ovl" + i + "]", 9, 0)

		If TexPath == "" || TexPath == "actors\\character\\overlays\\default.dds"
			WriteLog("Slot " + i + " chosen for area: " + area)
			Return i
		EndIf
		i += 1
		If !FirstPass && i == NumSlots
			FirstPass = true
			i = 0
		EndIf
	EndWhile
	Return -1
EndFunction


Function ApplyOverlay(Actor akTarget, Bool Gender, String Area, String OverlaySlot, String TextureToApply) global
	WriteLog("ApplyOverlay " + TextureToApply)

	float alpha = Utility.RandomFloat(0.75, 1.0)

	String Node = Area + " [ovl" + OverlaySlot + "]"

	NiOverride.AddNodeOverrideString(akTarget, Gender, Node, 9, 0, TextureToApply, true)
	NiOverride.AddNodeOverrideInt(akTarget, Gender, Node, 7, -1, 0, true)
	NiOverride.AddNodeOverrideInt(akTarget, Gender, Node, 0, -1, 0, true)
	NiOverride.AddNodeOverrideFloat(akTarget, Gender, Node, 8, -1, Alpha, true)
	NiOverride.AddNodeOverrideFloat(akTarget, Gender, Node, 2, -1, 0.0, true)
	NiOverride.AddNodeOverrideFloat(akTarget, Gender, Node, 3, -1, 0.0, true)

	NiOverride.ApplyNodeOverrides(akTarget)
EndFunction


int Function ReadyOverlay(Actor akTarget, Bool Gender, String Area, String TextureToApply, int Slot) global
	int slotToUse

	if Slot < 0
		slotToUse = GetEmptySlot(akTarget, Gender, Area)
	else
		slotToUse = Slot
	endif

	If slotToUse >= 0
		ApplyOverlay(akTarget, Gender, Area, slotToUse, TextureToApply)
	Else
		WriteLog("No slots available for area " + Area)
	EndIf

	return slotToUse
EndFunction


Function RemoveCumOverlay(Actor Act, Bool Gender, String NodeArea, Int NumOverlays) global
	int i = 0

	while i < NumOverlays
		String Node = nodeArea + " [ovl" + i + "]"

		string tex = NiOverride.GetNodeOverrideString(Act, Gender, Node, 9, 0)

		If StringContains(tex, "CumOverlays")
			NiOverride.AddNodeOverrideString(Act, Gender, Node, 9, 0, "actors\\character\\overlays\\default.dds", false)
			NiOverride.RemoveNodeOverride(Act, Gender, node , 9, 0)
			NiOverride.RemoveNodeOverride(Act, Gender, Node, 7, -1)
			NiOverride.RemoveNodeOverride(Act, Gender, Node, 0, -1)
			NiOverride.RemoveNodeOverride(Act, Gender, Node, 8, -1)
			NiOverride.RemoveNodeOverride(Act, Gender, Node, 2, -1)
			NiOverride.RemoveNodeOverride(Act, Gender, Node, 3, -1)
		EndIf

		i += 1
	endwhile
EndFunction


Function RemoveCumDecals(Actor Act, Bool Gender) global
	Writelog("RemoveCumDecals")

	RemoveCumOverlay(Act, Gender, "Body", NiOverride.GetNumBodyOverlays())
	RemoveCumOverlay(Act, Gender, "Face", NiOverride.GetNumFaceOverlays())
	RemoveCumOverlay(Act, Gender, "Feet", NiOverride.GetNumFeetOverlays())
	RemoveCumOverlay(Act, Gender, "Hands", NiOverride.GetNumFeetOverlays())
EndFunction


Function RemoveItem(Actor Act, Armor Item) global
	Act.RemoveItem(Item as form, 99, true, none)
EndFunction


Function PlaySound(Actor Act, Sound SoundToPlay) global
	Int soundID = (SoundToPlay).Play(Act)
	Sound.SetInstanceVolume(soundID, 1.0)
EndFunction
