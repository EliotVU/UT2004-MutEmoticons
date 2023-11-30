/* Copyright (c) 2007-2023 Eliot van Uytfanghe. All rights reserved. */
class EmoticonsReplicationInfo extends ReplicationInfo
	dependson(MutEmoticons)
	notplaceable;

/** Emoticons that have been replicated to the client. */
var array<MutEmoticons.sSmileyMessageType> Smileys;
var MutEmoticons Mutator;
var transient int nextIndex;

replication
{
	reliable if (Role == ROLE_Authority)
		ClientAddEmoticon;
}

simulated event PreBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer) {
        Class'MutEmoticons'.default.EmoticonsState = self;
    }
}

// Send Smileys to client.
event Tick(float deltaTime)
{
	if (Owner == none) {
		Destroy();
		return;
	}

	if (nextIndex == Mutator.Smileys.Length) {
        // bTearOff = true;
		return;
    }

	ClientAddEmoticon(Mutator.Smileys[nextIndex].Event, string(Mutator.Smileys[nextIndex].Icon), string(Mutator.Smileys[nextIndex].MatIcon));
	nextIndex ++;
}

// Add a smiley on the client array.
simulated function ClientAddEmoticon(string event, string icon, string matIcon)
{
	local int i;

	i = Smileys.Length;
	Smileys.Length = i + 1;
	Smileys[i].Event = event;
	Smileys[i].Icon = Texture(DynamicLoadObject(icon, Class'Texture', true));

	// Not an icon then try if its an material icon.
	if (Smileys[i].Icon == none) {
		Smileys[i].MatIcon = Material(DynamicLoadObject(matIcon, Class'Material', true));
    }
}

defaultproperties
{
    bOnlyRelevantToOwner=true
}
