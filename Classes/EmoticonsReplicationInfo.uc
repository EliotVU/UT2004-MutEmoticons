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
	{
		Destroy();
		return;
	}

	Super.Tick(dt);
	if( i == Master.Smileys.Length )
		return;

	ClientAddEmoticon( Master.Smileys[i].Event, string( Master.Smileys[i].Icon ), string( Master.Smileys[i].MatIcon ) );
	i ++;
}

// Add a smiley on the client array.
Simulated Function ClientAddEmoticon( string S, string ico, string matico )
{
	local int n;

	n = mySmileys.Length;
	mySmileys.Length = n + 1;
	mySmileys[n].Event = S;
	mySmileys[n].Icon = Texture(DynamicLoadObject( ico, Class'Texture', True ));

	// Not an icon then try if its an material icon.
	if( mySmileys[n].Icon == None )
		mySmileys[n].MatIcon = Material(DynamicLoadObject( matico, Class'Material', True ));
//	Log( "Added Emoticon:"$S@n@ico, Name );
}

DefaultProperties
{
	RemoteRole=Role_SimulatedProxy
	bAlwaysRelevant=True
	bSkipActorPropertyReplication=False
}
