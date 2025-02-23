exec function checkfact(id : string)
{
    if ( FactsDoesExist( id ) )
        theGame.GetGuiManager().ShowNotification( "Fact ("+id+") has val of "+FactsQuerySum(id) );
    else
        theGame.GetGuiManager().ShowNotification( "Fact ("+id+") doesn't exists" );
}