Scriptname OCumMCMScript extends SKI_ConfigBase

import OCumUtils

; Settings
int setEnableNPCSceneSupport
int setCleanCumEnterWater
int setDisableCumShot
int setDisableCumDecals
int setDisableCumMeshes
int setEnableVagAnOverlays
int setCumRegenSpeed
int setCumCleanupTimer
int setCumBarKey
; int setCleanCumDecals
int setResetActor
int setSquirtChance
int setCreampieChance
int setAnalpieChance
int setResetDefaults
int setDisableFacialsForElins
int setEnableHigherCumRegenSpeed
int setCumBarMaxAmountNPCs
int setCumBarMaxAmountPlayer

bool enableHigherCumRegenSpeed

OCumScript property OCum auto
OCumMaleScript property OCumMale auto


event OnInit()
	parent.OnInit()

	Modname = "OCum Ascended"
endEvent


event OnGameReload()
	parent.onGameReload()
endevent


event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)

	AddColoredHeader("$ocum_header_main_settings")
	setEnableNPCSceneSupport = AddToggleOption("$ocum_option_enable_npc_scene_support", OCum.enableNPCSceneSupport)
	setDisableCumShot = AddToggleOption("$ocum_option_disable_cum_shots", OCum.disableCumshot)
	setDisableCumDecals = AddToggleOption("$ocum_option_disable_cum_decals", OCum.disableCumDecal)
	setDisableCumMeshes = AddToggleOption("$ocum_option_disable_cum_meshes", OCum.disableCumMeshes)
	setEnableVagAnOverlays = AddToggleOption("$ocum_option_enable_vag_an_overlays", OCum.enableVagAnOverlays)
	setDisableFacialsForElins = AddToggleOption("$ocum_option_disable_facials_elins", OCum.disableFacialsForElins)
	setCleanCumEnterWater = AddToggleOption("$ocum_option_clean_water_enter", OCum.cleanCumEnterWater)
	setCumBarKey = AddKeyMapOption("$ocum_option_cum_bar_key", OCum.checkCumKey)
	AddEmptyOption()

	Actor actorInCrosshair = Game.GetCurrentCrosshairRef() as Actor

	if actorInCrosshair == none
		actorInCrosshair = OCum.PlayerRef
	endif

	AddColoredHeader("$ocum_header_reset")
	; setCleanCumDecals = AddToggleOption("$ocum_option_clean_cum_decals", false)
	setResetActor = AddTextOption("$ocum_option_reset_actor", actorInCrosshair.GetActorBase().GetName())
	setResetDefaults = AddToggleOption("$ocum_option_reset_defaults", false)

	SetCursorPosition(1)

	AddColoredHeader("$ocum_header_adjustments")
	setSquirtChance = AddSliderOption("$ocum_option_squirt_chance", OCum.squirtChance, "{0}")
	setCreampieChance = AddSliderOption("$ocum_option_creampie_chance", OCum.creampieChance, "{0}")
	setAnalpieChance = AddSliderOption("$ocum_option_analpie_chance", OCum.analpieChance, "{0}")
	setCumCleanupTimer = AddSliderOption("$ocum_option_cum_cleanup_timer", OCum.cumCleanupTimer, "{1}")
	AddEmptyOption()

	setEnableHigherCumRegenSpeed = AddToggleOption("$ocum_option_enable_higher_cum_regen_speed", enableHigherCumRegenSpeed)
	setCumRegenSpeed = AddSliderOption("$ocum_option_cum_regen_speed", OCum.cumRegenSpeed, "{1}")

	AddEmptyOption()
	setCumBarMaxAmountNPCs = AddSliderOption("$ocum_option_cum_bar_max_amount_npcs", OCum.cumBarMaxAmountNPCs, "{0}")

	AddEmptyOption()
	setCumBarMaxAmountPlayer = AddSliderOption("$ocum_option_cum_bar_max_amount_player", OCum.cumBarMaxAmountPlayer, "{0}")
endEvent


event OnOptionSelect(int option)
	if (option == setEnableNPCSceneSupport)
		OCum.enableNPCSceneSupport = !OCum.enableNPCSceneSupport
		SetToggleOptionValue(setEnableNPCSceneSupport, OCum.enableNPCSceneSupport)
	elseif (option == setCleanCumEnterWater)
		OCum.cleanCumEnterWater = !OCum.cleanCumEnterWater
		SetToggleOptionValue(setCleanCumEnterWater, OCum.cleanCumEnterWater)
	elseif (option == setDisableCumShot)
		OCum.DisableCumshot = !OCum.DisableCumshot
		SetToggleOptionValue(setDisableCumShot, OCum.DisableCumshot)
	elseif (option == setDisableCumDecals)
		OCum.DisableCumDecal = !OCum.DisableCumDecal
		SetToggleOptionValue(setDisableCumDecals, OCum.DisableCumDecal)
	elseif (option == setDisableCumMeshes)
		OCum.disableCumMeshes = !OCum.disableCumMeshes
		SetToggleOptionValue(setDisableCumMeshes, OCum.disableCumMeshes)
		if (!OCum.disableCumMeshes)
			ShowMessage("$ocum_message_cum_meshes_warning", false)
		endif
	elseif (option == setEnableVagAnOverlays)
		OCum.enableVagAnOverlays = !OCum.enableVagAnOverlays
		SetToggleOptionValue(setEnableVagAnOverlays, OCum.enableVagAnOverlays)
	elseif (option == setDisableFacialsForElins)
		OCum.DisableFacialsForElins = !OCum.DisableFacialsForElins
		SetToggleOptionValue(setDisableFacialsForElins, OCum.DisableFacialsForElins)
	elseif (option == setEnableHigherCumRegenSpeed)
		enableHigherCumRegenSpeed = !enableHigherCumRegenSpeed
		SetToggleOptionValue(setEnableHigherCumRegenSpeed, enableHigherCumRegenSpeed)
	; elseif (option == setCleanCumDecals)
	; 	OCum.CleanCumTexturesFromAllActors()
	; 	ShowMessage("$ocum_message_cum_cleaned", false)
	elseif (option == setResetActor)
		Actor actorInCrosshair = Game.GetCurrentCrosshairRef() as Actor

		if actorInCrosshair == none
			actorInCrosshair = OCum.PlayerRef
		endif

		if (actorInCrosshair)
			OCum.CleanCumTexturesFromActor(actorInCrosshair)
			OCum.UnsetActorDataFloats(actorInCrosshair)

			RemoveItem(actorInCrosshair, OCumMale.CumMeshPussy)
			RemoveItem(actorInCrosshair, OCumMale.CumMeshAnal)
			RemoveItem(actorInCrosshair, OCumMale.UrethraNode)
		endif

		ShowMessage("$ocum_message_reset_actor", false)
	elseif (option == setResetDefaults)
		ResetDefaults()
		ShowMessage("$ocum_message_defaults_reset", false)
	endIf
endEvent


event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	If (option == setCumBarKey)
		bool continue = true

		if (keyCode != 1 && conflictControl != "")
			string msg

			if (conflictName != "")
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
			endIf

			continue = ShowMessage(msg, true, "$ocum_message_box_option_yes", "$ocum_message_box_option_no")
		endIf

		if (continue)
			OCum.updateCheckCumKey(keyCode)
			SetKeymapOptionValue(setCumBarKey, keyCode)
		endIf
	EndIf
endEvent


event OnOptionSliderOpen(int option)
	If (option == setCumRegenSpeed)
		SetSliderDialogStartValue(OCum.cumRegenSpeed)

		if (!enableHigherCumRegenSpeed)
			SetSliderDialogDefaultValue(1.0)
			SetSliderDialogRange(0.1, 10)
			SetSliderDialogInterval(0.1)
		else
			SetSliderDialogDefaultValue(10.0)
			SetSliderDialogRange(1, 50.0)
			SetSliderDialogInterval(1)
		endif
	elseif (option == setSquirtChance)
		SetSliderDialogStartValue(OCum.squirtChance)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == setCreampieChance)
		SetSliderDialogStartValue(OCum.creampieChance)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == setAnalpieChance)
		SetSliderDialogStartValue(OCum.analpieChance)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == setCumCleanupTimer)
		SetSliderDialogStartValue(OCum.cumCleanupTimer)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1, 220)
		SetSliderDialogInterval(1)
	elseif (option == setCumBarMaxAmountNPCs)
		SetSliderDialogStartValue(OCum.cumBarMaxAmountNPCs)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(20, 100)
		SetSliderDialogInterval(1)
	elseif (option == setCumBarMaxAmountPlayer)
		SetSliderDialogStartValue(OCum.cumBarMaxAmountPlayer)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(20, 100)
		SetSliderDialogInterval(1)
	EndIf
endEvent


event OnOptionSliderAccept(int option, float value)
	If (option == setCumRegenSpeed)
		OCum.cumRegenSpeed = value
		SetSliderOptionValue(setCumRegenSpeed, value, "{1}")
	elseif (option == setSquirtChance)
		OCum.squirtChance = value as int
		SetSliderOptionValue(setSquirtChance, value, "{0}")
	elseif (option == setCreampieChance)
		OCum.creampieChance = value as int
		SetSliderOptionValue(setCreampieChance, value, "{0}")
	elseif (option == setAnalpieChance)
		OCum.analpieChance = value as int
		SetSliderOptionValue(setAnalpieChance, value, "{0}")
	elseif (option == setCumCleanupTimer)
		OCum.cumCleanupTimer = value
		OCum.OCumSpell.SetNthEffectDuration(0, (value * 60) as int)
		SetSliderOptionValue(setCumCleanupTimer, value, "{1}")
	elseif (option == setCumBarMaxAmountNPCs)
		OCum.cumBarMaxAmountNPCs = value
		SetSliderOptionValue(setCumBarMaxAmountNPCs, value, "{0}")
	elseif (option == setCumBarMaxAmountPlayer)
		OCum.cumBarMaxAmountPlayer = value
		SetSliderOptionValue(setCumBarMaxAmountPlayer, value, "{0}")
	EndIf
endEvent


event OnOptionHighlight(int option)
	if (option == setEnableNPCSceneSupport)
		SetInfoText("$ocum_highlight_enable_npc_scene_support")
	elseif (option == setCleanCumEnterWater)
		SetInfoText("$ocum_highlight_clean_water_enter")
	elseif (option == setDisableCumShot)
		SetInfoText("$ocum_highlight_disable_cum_shots")
	elseif (option == setDisableCumDecals)
		SetInfoText("$ocum_highlight_disable_cum_decals")
	elseif (option == setDisableCumMeshes)
		SetInfoText("$ocum_highlight_disable_cum_meshes")
	elseif (option == setEnableVagAnOverlays)
		SetInfoText("$ocum_highlight_enable_vag_an_overlays")
	elseif (option == setDisableFacialsForElins)
		SetInfoText("$ocum_highlight_disable_facials_elins")
	elseif (option == setCumRegenSpeed)
		SetInfoText("$ocum_highlight_cum_regen_speed")
	elseif (option == setSquirtChance)
		SetInfoText("$ocum_highlight_squirt_chance")
	elseif (option == setCreampieChance)
		SetInfoText("$ocum_highlight_creampie_chance")
	elseif (option == setAnalpieChance)
		SetInfoText("$ocum_highlight_analpie_chance")
	elseif (option == setCumCleanupTimer)
		SetInfoText("$ocum_highlight_cum_cleanup_timer")
	elseif (option == setCumBarKey)
		SetInfoText("$ocum_highlight_cum_bar_key")
	; elseif (option == setCleanCumDecals)
	; 	SetInfoText("$ocum_highlight_clean_cum_decals")
	elseif (option == setResetActor)
		SetInfoText("$ocum_highlight_reset_actor")
	elseif (option == setEnableHigherCumRegenSpeed)
		SetInfoText("$ocum_highlight_enable_higher_cum_regen_speed")
	elseif (option == setCumBarMaxAmountNPCs)
		SetInfoText("$ocum_highlight_cumbar_max_amount")
	elseif (option == setCumBarMaxAmountPlayer)
		SetInfoText("$ocum_highlight_cumbar_max_amount")
	endif
endEvent


bool Color1
function AddColoredHeader(String In)
	string Blue = "#6699ff"
	string Pink = "#ff3389"
	string Color

	If Color1
		Color = Pink
		Color1 = False
	Else
		Color = Blue
		Color1 = True
	EndIf

	AddHeaderOption("<font color='" + Color +"'>" + In)
endFunction


function ResetDefaults()
	OCum.enableNPCSceneSupport = false
	SetToggleOptionValue(setEnableNPCSceneSupport, OCum.enableNPCSceneSupport)

	OCum.cleanCumEnterWater = true
	SetToggleOptionValue(setCleanCumEnterWater, OCum.cleanCumEnterWater)

	OCum.DisableCumshot = false
	SetToggleOptionValue(setDisableCumShot, OCum.disableCumshot)

	OCum.DisableCumDecal = false
	SetToggleOptionValue(setDisableCumDecals, OCum.disableCumDecal)

	OCum.disableCumMeshes = true
	SetToggleOptionValue(setDisableCumMeshes, OCum.disableCumMeshes)

	OCum.enableVagAnOverlays = false
	SetToggleOptionValue(setEnableVagAnOverlays, OCum.enableVagAnOverlays)

	OCum.DisableFacialsForElins = false
	SetToggleOptionValue(setDisableFacialsForElins, OCum.disableFacialsForElins)

	OCum.updateCheckCumKey(157) ; Right Control
	SetKeymapOptionValue(setCumBarKey, 157)

	enableHigherCumRegenSpeed = false
	SetToggleOptionValue(setEnableHigherCumRegenSpeed, enableHigherCumRegenSpeed)

	OCum.cumRegenSpeed = 1.0
	SetSliderOptionValue(setCumRegenSpeed, 1.0, "{1}")
	
	OCum.squirtChance = 25
	SetSliderOptionValue(setSquirtChance, 25.0, "{0}")

	OCum.creampieChance = 30
	SetSliderOptionValue(setCreampieChance, 30.0, "{0}")

	OCum.analpieChance = 25
	SetSliderOptionValue(setAnalpieChance, 30.0, "{0}")

	OCum.cumCleanupTimer = 5
	OCum.OCumSpell.SetNthEffectDuration(0, 5 * 60)
	SetSliderOptionValue(setCumCleanupTimer, 5.0, "{1}")

	OCum.cumBarMaxAmountNPCs = 30.0
	SetSliderOptionValue(setCumBarMaxAmountNPCs, 30.0, "{0}")

	OCum.cumBarMaxAmountPlayer = 30.0
	SetSliderOptionValue(setCumBarMaxAmountPlayer, 30.0, "{0}")
endFunction
