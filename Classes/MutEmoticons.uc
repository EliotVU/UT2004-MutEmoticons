/* Copyright (c) 2007-2023 Eliot van Uytfanghe. All rights reserved. */
class MutEmoticons extends LocalPatcher
	config(MutEmoticons);

struct sSmileyMessageType
{
	var string Event;
	var Texture Icon;
	var Material MatIcon;
};
var() config array<sSmileyMessageType> Smileys;

// Can't use 'Replication'
var transient EmoticonsReplicationInfo EmoticonsState;

function ServerTraveling(string URL, bool bItems)
{
    super.ServerTraveling(URL, bItems);

    if (Role == ROLE_Authority) {
        // Prevent memory leaks
        default.EmoticonsState = none;
    }
}

function bool CheckReplacement(Actor other, out byte bSuperRelevant)
{
	if (bool(PlayerController(other)) && bool(MessagingSpectator(other)) == false)
	{
		Spawn(Class'EmoticonsReplicationInfo', other).Mutator = self;
		return true;
	}

	return super.CheckReplacement(other, bSuperRelevant);
}

#exec obj load file="SmileSkins.utx" package=MutEmoticons

defaultproperties
{
	FriendlyName="Emoticons"
	bAddToServerPackages=true

    // LocalPatcherInteractionClass=Class'EmoticonsInteraction'
    LocalPatches(0)=(Source=Function'Engine.HUD.DisplayMessages',Destination=Function'HUDProxy.DisplayMessagesProxy')
    LocalPatches(1)=(Source=Function'Engine.HUD.DrawTypingPrompt',Destination=Function'HUDProxy.DrawTypingPromptProxy')
    
	Smileys(0)=(Event=">:(",Icon=Texture'MAD')
	Smileys(1)=(Event=":(",Icon=Texture'11_FROWN')
	Smileys(2)=(Event=":)",Icon=Texture'19_GREENLI2')
	Smileys(3)=(Event=":p",Icon=Texture'17_TONGUE1')
	Smileys(4)=(Event=":d",Icon=Texture'19_GREENLI1')
	Smileys(5)=(Event=":D",Icon=Texture'16_BIGGRIN')
	Smileys(6)=(Event=":|",Icon=Texture'12_INDIFFE')
	Smileys(7)=(Event=":/",Icon=Texture'13_OHWELL')
	Smileys(8)=(Event=":-",Icon=Texture'18_REDFACE')
	Smileys(9)=(Event="B)",Icon=Texture'COOL')
	Smileys(10)=(Event="xD",Icon=Texture'SCREAM6')
	// Smileys(11)=(Event="BAN",Icon=Texture'Ban')
	// Smileys(12)=(Event="HM",Icon=Texture'HM')
	// Smileys(13)=(Event="SPAM",Icon=Texture'SPAM')
}
