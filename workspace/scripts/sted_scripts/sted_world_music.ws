@wrapMethod(CScriptSoundSystem)
function InitializeAreaMusic(worldArea: EAreaName ) {
  var world_path: string;

  wrappedMethod(worldArea);

  world_path = theGame.GetWorld().GetDepotPath();

  if (world_path == "dlc\dlcsted\data\levels\sted_bremervoord_coast\sted_bremervoord_coast.w2w") {
    // uncomment the music of your choice, or add your own
    // SoundEvent( "play_music_toussaint" );
    SoundEvent( "play_music_nomansgrad" );
    // SoundEvent( "play_music_skellige" );
    //SoundEvent( "play_music_kaer_morhen" );
    //SoundEvent( "play_music_prologue" );
    // SoundEvent( "play_music_wyzima_castle" );
    // SoundEvent( "play_music_misty_island" );
    // SoundEvent( "play_music_spiral" );
  }
}