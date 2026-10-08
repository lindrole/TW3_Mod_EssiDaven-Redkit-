latent storyscene function STED_PlayMusicScene( player : CStoryScenePlayer, areaName : CName, eventName : string, optional saveType : string, optional repeatDelay : float ) {
	STED_PlayMusic(areaName, eventName, saveType);
	if (repeatDelay > 0.0f) {
		Sleep(repeatDelay);
		STED_PlayMusic(areaName, eventName, saveType);
	}
}
quest function STED_PlayMusic(areaName: CName, eventName: string, optional saveType: string) {
    if (areaName == 'toussaint') {
        theSound.InitializeAreaMusic('AN_Bob');
    } else {
        theSound.InitializeAreaMusic(areaName);
    }

    switch (saveType) {
        case "SESB_Save":
            SoundEventQuest(eventName, SESB_Save);
            break;
        case "SESB_ClearSaved":
            SoundEventQuest(eventName, SESB_ClearSaved);
            break;
        default: 
            SoundEventQuest(eventName, SESB_DontSave);
            break;
    }
} 


