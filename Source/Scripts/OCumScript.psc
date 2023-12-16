ScriptName OCumScript Extends OStimAddon Conditional

import OCumUtils
import OCumSceneDataUtils

; ------------------------ Properties and script wide Vars ------------------------ ;

string cumStoredKey
string lastCumCheckTimeKey

OSexBar property CumBar auto
OBarsScript OBars

Faction property HasCumFaction auto

spell property OCumSpell auto

keyword property AppliedCumKeyword auto

int property checkCumKey auto
int property squirtChance auto
int property creampieChance auto
int property analpieChance auto

float property cumBarMaxAmountNPCs auto
float property cumBarMaxAmountPlayer auto
float property cumCleanupTimer auto
float property cumRegenSpeed auto

bool property enableNPCSceneSupport auto
bool property disableCumshot auto
bool property disableCumDecal auto
bool property disableCumMeshes auto
bool property enableVagAnOverlays auto
bool property disableFacialsForElins auto
bool property cleanCumEnterWater auto

bool property isRemovingCumFromAllActors auto

GlobalVariable property GameDaysPassed auto


;  ██████╗  ██████╗██╗   ██╗███╗   ███╗
; ██╔═══██╗██╔════╝██║   ██║████╗ ████║
; ██║   ██║██║     ██║   ██║██╔████╔██║
; ██║   ██║██║     ██║   ██║██║╚██╔╝██║
; ╚██████╔╝╚██████╗╚██████╔╝██║ ╚═╝ ██║
;  ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝

; ------------------------ Main OCum logic functions ------------------------ ;


float Function GetCumStoredAmount(actor npc)
	if OActorUtil.HasSchlong(npc)
		float lastCheckTime = GetNPCDataFloat(npc, LastCumCheckTimeKey)

		float currentTime = GameDaysPassed.GetValue()

		StoreNPCDataFloat(npc, LastCumCheckTimeKey, currentTime)

		if lastCheckTime <= 0
			float maxCum = GetMaxCumStoragePossible(npc)
			StoreNPCDataFloat(npc, CumStoredKey, maxCum)
			return maxCum
		endif

		float cum = GetNPCDataFloat(npc, CumStoredKey)

		; sperm will regen at a rate of max storage/day
		float timePassed = currentTime - lastCheckTime
		float max = GetMaxCumStoragePossible(npc)

		float cumToAdd = timePassed * max

		cum = cum + (cumToAdd * cumRegenSpeed)
		if cum > max
			cum = max
		endif

		StoreNPCDataFloat(npc, CumStoredKey, cum)

		return cum
	endif

	return 0.0
EndFunction


Function AdjustStoredCumAmount(actor npc, float amount, float currentAmount)
	float set
	float max = GetMaxCumStoragePossible(npc)

	if (currentAmount + amount) > max
		set = max
	elseif (currentAmount + amount) < 0
		set = 0
	else
		set = currentAmount + amount
	endif

	StoreNPCDataFloat(npc, CumStoredKey, set)
EndFunction


; ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
; ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
; █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
; ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
; ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
; ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
; Events that add more features to OCum based on OStim scenes stages and player actions

Event OnInit()
	OnLoad()
EndEvent


Function OnLoad()
	CumStoredKey = "CumStoredAmountV2"
	LastCumCheckTimeKey = "CumLastCalcTimeV2"

	if HasCumFaction == None
		HasCumFaction = Game.GetFormFromFile(0xF46, "OCum.esp") As Faction
	endif

	OStim = OUtils.GetOStim()
	PlayerRef = Game.GetPlayer()

	OBars = Ostim.GetBarScript()

	UnregisterForAllModEvents()

	RegisterForKey(CheckCumKey)
	OCumSpell.SetNthEffectDuration(0, (cumCleanupTimer * 60) as int)

	Utility.Wait(1)
	InitBar()
EndFunction


Event OnKeyDown(Int KeyPress)
	; Event which listens for the cum bar key press
	if (KeyPress != 1 && KeyPress == CheckCumKey)
		TempDisplayBar()
	endif
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	; clean cum when actor enters water
	if asEventName == "SoundPlay.FSTSwimSwim"
		Actor act = akSource as Actor

		if act.HasMagicEffectWithKeyWord(AppliedCumKeyword)
			act.DispelSpell(OCumSpell)
		else
			CleanCumTexturesFromActor(act)
		endif
	endIf
endEvent


Event OnUpdate()
	if (OBars.IsBarVisible(CumBar))
		OBars.SetBarVisible(CumBar, False)
	endif
endEvent


;  ██████╗██╗   ██╗███╗   ███╗    ██████╗  █████╗ ██████╗ 
; ██╔════╝██║   ██║████╗ ████║    ██╔══██╗██╔══██╗██╔══██╗
; ██║     ██║   ██║██╔████╔██║    ██████╔╝███████║██████╔╝
; ██║     ██║   ██║██║╚██╔╝██║    ██╔══██╗██╔══██║██╔══██╗
; ╚██████╗╚██████╔╝██║ ╚═╝ ██║    ██████╔╝██║  ██║██║  ██║
;  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


Function InitBar()
	CumBar.HAnchor = "left"
	CumBar.VAnchor = "bottom"
	CumBar.X = 980.0
	CumBar.Alpha = 0.0
	CumBar.SetPercent(0.0)
	CumBar.FillDirection = "Left"

	CumBar.Y = 120.0
	CumBar.SetColors(0xb0b0b0, 0xfff5fd)

	OBars.SetBarVisible(CumBar, False)
EndFunction


Function TempDisplayBar()
	If !OBars.IsBarVisible(CumBar)
		float amount = GetCumStoredAmount(playerref)

		CumBar.SetPercent(amount / GetMaxCumStoragePossible(playerref))

		OBars.SetBarVisible(CumBar, True)

		; make bar disappear in 5 seconds
		RegisterForSingleUpdate(5.0)
	EndIf
Endfunction


; ██╗   ██╗████████╗██╗██╗     ███████╗
; ██║   ██║╚══██╔══╝██║██║     ██╔════╝
; ██║   ██║   ██║   ██║██║     ███████╗
; ██║   ██║   ██║   ██║██║     ╚════██║
; ╚██████╔╝   ██║   ██║███████╗███████║
;  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝


Function updateCheckCumKey(int newKey)
	UnregisterForKey(CheckCumKey)

	CheckCumKey = newKey
	RegisterForKey(newKey)
EndFunction


Function StoreNPCDataFloat(actor npc, string keys, Float num)
	StorageUtil.SetFloatValue(npc, keys, num)
EndFunction


Float Function GetNPCDataFloat(actor npc, string keys)
	return StorageUtil.GetFloatValue(npc, keys, -1)
EndFunction

Function UnsetActorDataFloats(Actor Act)
	StorageUtil.UnsetFloatValue(Act, CumStoredKey)
	StorageUtil.UnsetFloatValue(Act, LastCumCheckTimeKey)
EndFunction


float Function GetMaxCumStoragePossible(actor npc)
	if npc == PlayerRef
		return cumBarMaxAmountPlayer
	else
		return cumBarMaxAmountNPCs
	endif
EndFunction


Function CleanCumTexturesFromActor(Actor Act)
	bool gender = OStim.AppearsFemale(Act)

	RemoveCumDecals(Act, gender)
	UnregisterForAnimationEvent(act, "SoundPlay.FSTSwimSwim")

	Act.RemoveFromFaction(HasCumFaction)
endFunction


Function RegisterForCleaningOnEnteringWater(actor act)
	UnregisterForAnimationEvent(act, "SoundPlay.FSTSwimSwim")

	if (cleanCumEnterWater)
		RegisterForAnimationEvent(act, "SoundPlay.FSTSwimSwim")
	endif
EndFunction
