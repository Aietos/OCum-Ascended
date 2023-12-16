ScriptName OCumFemaleScript extends Quest

import OCumUtils
import OCumSceneDataUtils

; ------------------------ Properties and script wide Vars ------------------------ ;

Actor property PlayerRef auto

Sound property SquirtSound auto

Spell property SquirtSpell auto
Spell property SquirtSpell2 auto
Spell property SquirtSpell3 auto

OSexIntegrationMain property OStim auto

OCumScript property OCum auto


; ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
; ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
; █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
; ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
; ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
; ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝


Event OnInit()
	OnLoad()
EndEvent


Event OnLoad()
	WriteLog("OCum Female init")
	UnregisterForAllModEvents()

	OStim = OUtils.GetOStim()

	RegisterForModEvent("ostim_actor_orgasm", "OStimOrgasm")
EndEvent


Event OStimOrgasm(string eventName, string strArg, float numArg, Form sender)
	int threadID = numArg as int

	if threadID > 0 && !OCum.enableNPCSceneSupport
		return
	endif

	Actor orgasmer = sender as Actor

	if OStim.AppearsFemale(orgasmer) && ChanceRoll(OCum.SquirtChance)
		String sceneID = strArg

		if threadID == 0
			WriteLog("Squirting")
		endif

		Squirt(orgasmer, sceneID)
	endif
EndEvent


; ██╗   ██╗████████╗██╗██╗     ███████╗
; ██║   ██║╚══██╔══╝██║██║     ██╔════╝
; ██║   ██║   ██║   ██║██║     ███████╗
; ██║   ██║   ██║   ██║██║     ╚════██║
; ╚██████╔╝   ██║   ██║███████╗███████║
;  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝


Function SquirtShootFlow(Actor act)
	PlaySound(act, SquirtSound)

	if ChanceRoll(50)
		SquirtSpell2.Cast(act, act)
	else
		SquirtSpell3.Cast(act, act)
	endif
EndFunction


Function SquirtShootSpurt(Actor act)
	PlaySound(act, SquirtSound)

	SquirtSpell.SetNthEffectDuration(0, Utility.RandomInt(1, 7))

	SquirtSpell.Cast(act, act)
EndFunction


Function Squirt(Actor Act, String SceneID)
	Act.SendModEvent("ocum_squirt", StrArg = SceneID)

	if ChanceRoll(50)
		SquirtShootSpurt(act)
	else
		SquirtShootFlow(act)
	endif
EndFunction
