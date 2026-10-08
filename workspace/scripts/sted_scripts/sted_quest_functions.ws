
quest function STED_KillActor(actorTag : name) {
	var actor : CActor;
	
	actor = (CActor)theGame.GetEntityByTag(actorTag);
	actor.Kill('STED', true);
}


quest function STED_PopUp_Message(message : String) {
	NNS(message);
}

function NNS(message : String) {
	theGame.GetGuiManager().ShowNotification(message, 5000.f, false);
	LogChannel('STED_Notify', "(" + FloatToStringPrec(theGame.GetEngineTimeAsSeconds(), 3) + "): " + message);
}

