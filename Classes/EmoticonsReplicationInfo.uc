// Coded by Eliot.
Class EmoticonsReplicationInfo Extends Info
	DependsOn(MutEmoticons)
	NotPlaceable;

var array<MutEmoticons.sSmileyMessageType> mySmileys;
var MutEmoticons Master;
var int i;

Replication
{
	reliable if( Role == ROLE_Authority )
		ClientAddEmoticon;
}

// Send Smileys to client.
Function Tick( float dt )
{
	if( Owner == None )
		Destroy();

	Super.Tick(dt);
	if( i == Master.Smileys.Length )
		return;

	ClientAddEmoticon( Master.Smileys[i].Event, Master.Smileys[i].Icon );
	i ++;
}

// Add a smiley on the client array.
Simulated Function ClientAddEmoticon( string S, Texture ico )
{
	local int n;

	n = mySmileys.Length;
	mySmileys.Length = n + 1;
	mySmileys[n].Event = S;
	mySmileys[n].Icon = ico;
//	Log( "Added Emoticon:"$S@n, Name );
}

DefaultProperties
{
	RemoteRole=Role_SimulatedProxy
	bAlwaysRelevant=True
	bSkipActorPropertyReplication=False
}
