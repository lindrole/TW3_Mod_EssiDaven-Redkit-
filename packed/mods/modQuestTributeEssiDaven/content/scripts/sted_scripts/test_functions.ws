quest function STED_Notify(message : String) {
	NNS(message);
}

function NNS(message : String) {
	theGame.GetGuiManager().ShowNotification(message, 5000.f, false);
	LogChannel('STED_Notify', "(" + FloatToStringPrec(theGame.GetEngineTimeAsSeconds(), 3) + "): " + message);
}
