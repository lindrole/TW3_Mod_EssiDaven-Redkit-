
quest function STED_KillActor(actorTag : name) {
	var actor : CActor;
	
	actor = (CActor)theGame.GetEntityByTag(actorTag);
	actor.Kill('STED', true);
}

