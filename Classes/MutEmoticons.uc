// Coded by Eliot.
Class MutEmoticons Extends Mutator
	Config(MutEmoticons);

struct sSmileyMessageType
{
	var string Event;
	var texture Icon;
	var material MatIcon;
};
var() config array<sSmileyMessageType> Smileys;

Function PreBeginPlay()
{
	local string hudType;
	Super.PreBeginPlay();
	//Log( string( Level.Game ), 'MutEmoticons' );
	//Log( Level.Game.HUDType, 'MutEmoticons' );

	hudType = getTAMHUD( Level.Game );
	if( hudType != "" )
	{	
		Level.Game.HUDType = hudType;
		return;
	}

	if( Level.Game.IsA('ASGameInfo') )
		Level.Game.HUDType = string( Class'SmileyHudAS' );
	else if( Level.Game.IsA('CTFGame') )
		Level.Game.HUDType = string( Class'SmileyHudCTF' );
	else if( Level.Game.IsA('ONSOnslaughtGame') )
		Level.Game.HUDType = string( Class'SmileyHudONS' );
	else if( Level.Game.IsA('xBombingRun') )
		Level.Game.HUDType = string( Class'SmileyHudBR' );
	else if( Level.Game.IsA('xDoubleDom') )
		Level.Game.HUDType = string( Class'SmileyHudONS' );
	else if( Level.Game.IsA('Invasion') )
		Level.Game.HUDType = string( Class'SmileyHudINV' );
	else if( Level.Game.IsA('xMutantGame') )
		Level.Game.HUDType = string( Class'SmileyHudMUT' );
	else if( Level.Game.IsA('xLastManStandingGame') )
		Level.Game.HUDType = string( Class'SmileyHudLMS' );
	else if( Level.Game.IsA('xTeamGame') )
		Level.Game.HUDType = string( Class'SmileyHudTDM' );
	else if( Level.Game.IsA('DeathMatch') )
		Level.Game.HUDType = string( Class'SmileyHudDM' );

	//Log( string( Level.Game ), 'MutEmoticons' );
	//Log( Level.Game.HUDType, 'MutEmoticons' );
}

function string getTAMHUD( GameInfo game )
{
	if( game.IsA('Freon') )
		return string(class'SmileyHudFreon');
	else if( game.IsA('TeamArenaMaster') )
		return string(class'SmileyHudTAM');
	else if( game.IsA('ArenaMaster') )
		return string(class'SmileyHudAM');

	return "";
}

Function bool CheckReplacement( Actor Other, byte b )
{
	local EmoticonsReplicationInfo RepInfo;

	if( Other.IsA('PlayerController') && !Other.IsA('MessagingSpectator') )
	{
		RepInfo = Spawn( Class'EmoticonsReplicationInfo', Other );
		RepInfo.Master = Self;
//		Log( "Replicating Smileys to"@Other.GetHumanReadableName(), Self.Name );
		return True;
	}
	return Super.CheckReplacement(Other,b);
}

DefaultProperties
{
	FriendlyName="Emoticons +TAM V1B"
	bAddToServerPackages=True
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
}
