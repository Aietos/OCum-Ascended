ScriptName OCumSceneDataUtils


bool Function IsVaginalSex(string sceneID) global
	return OMetadata.FindAction(sceneID, "vaginalsex") != -1
EndFunction


bool Function IsBlowjob(string sceneID) global
	return OMetadata.FindAction(sceneID, "blowjob") != -1
EndFunction

bool Function IsBlowjobReceiver(string sceneID, int position) global
	int[] actionIndices = OMetadata.FindAllActionsForTarget(sceneID, position, "blowjob")
	int i = actionIndices.length
	While i
		i -= 1
		If position == OMetadata.GetActionTarget(sceneID, actionIndex)
			return true
		EndIf
	EndWhile
	return false
EndFunction

bool Function IsInternalSexGiver(string sceneID, int position) global
	int[] actionIndices = OMetadata.FindAllActionsForActorCSV(sceneID, position, "vaginalsex,analsex")
	int i = actionIndices.length
	While i
		i -= 1
		If position == OMetadata.GetActionActor(sceneID, actionIndices[i])
			return true
		EndIf
	EndWhile
	return false
EndFunction

bool Function IsHandjob(string sceneID) global
	return OMetadata.FindAction(sceneID, "handjob") != -1
EndFunction


bool Function IsOralSex(string sceneID) global
	string[] oralArray = new string[4]
	oralArray[0] = "blowjob"
	oralArray[1] = "lickingpenis"
	oralArray[2] = "lickingtesticles"
	oralArray[3] = "rubbingpenisagainstface"

	return OMetadata.FindAnyAction(sceneID, oralArray) != -1
EndFunction


bool Function IsAnalSex(string sceneID) global
	return OMetadata.FindAction(sceneID, "analsex") != -1 || OMetadata.FindAction(sceneID, "buttjob") != -1
EndFunction


bool Function IsBreastJob(string sceneID) global
	return OMetadata.FindAction(sceneID, "boobjob") != -1
EndFunction


bool Function IsFootJob(string sceneID) global
	return OMetadata.FindAction(sceneID, "footjob") != -1
EndFunction


bool Function IsThighJob(string sceneID) global
	return OMetadata.FindAction(sceneID, "grindingthigh") != -1 || OMetadata.FindAction(sceneID, "thighjob") != -1
EndFunction


bool Function IsMasturbatingMale(string sceneID) global
	return OMetadata.FindAction(sceneID, "malemasturbation") != -1
EndFunction


bool Function IsVaginalPullout(string sceneID) global
	return OMetadata.FindAction(sceneID, "vaginalpullout") != -1
EndFunction


bool Function IsAnalPullout(string sceneID) global
	return OMetadata.FindAction(sceneID, "analpullout") != -1
EndFunction
