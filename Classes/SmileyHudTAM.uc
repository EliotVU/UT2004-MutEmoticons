// Coded by .:..: and Eliot.
Class SmileyHudTAM Extends TAM_HUD;

#Exec obj load file="SmileSkins.utx" package="MutEmoticons"

var EmoticonsReplicationInfo Master;

Function SetupMaster()
{
	local EmoticonsReplicationInfo Emo;

	ForEach DynamicActors( Class'EmoticonsReplicationInfo', Emo )
	{
		if( Emo.Owner == PlayerOwner )
		{
//			Log( "Master found!", Name );
			Master = Emo;
			return;
		}
	}
//	Log( "Master:"$Master, Name );
}

function DisplayMessages(Canvas C)
{
	local int i, j, XPos, YPos,MessageCount;
	local float XL, YL, YYL,XXL;
//	local string S;

    for( i = 0; i < ConsoleMessageCount; i++ )
    {
        if ( TextMessages[i].Text == "" )
            break;
        else if( TextMessages[i].MessageLife < Level.TimeSeconds )
        {
            TextMessages[i].Text = "";

            if( i < ConsoleMessageCount - 1 )
            {
                for( j=i; j<ConsoleMessageCount-1; j++ )
                    TextMessages[j] = TextMessages[j+1];
            }
            TextMessages[j].Text = "";
            break;
        }
        else
			MessageCount++;
    }

    XPos = (ConsoleMessagePosX * HudCanvasScale * C.SizeX) + (((1.0 - HudCanvasScale) / 2.0) * C.SizeX);
    YPos = (ConsoleMessagePosY * HudCanvasScale * C.SizeY) + (((1.0 - HudCanvasScale) / 2.0) * C.SizeY);

    C.Font = GetConsoleFont(C);
    C.DrawColor = ConsoleColor;

    C.TextSize ("A", XL, YL);

    YPos -= YL * MessageCount+1; // DP_LowerLeft
    YPos -= YL; // Room for typing prompt

	for( i=0; i<MessageCount; i++ )
	{
		if ( TextMessages[i].Text == "" )
			break;

		C.SetPos( XPos, YPos );
		C.DrawColor = TextMessages[i].TextColor;
		YYL = 0;
		XXL = 0;
//		S = TextMessages[i].PRI.PlayerName;
//		DrawSmileyText( S, C, XXL, YYL );
//		C.SetPos( XXL, YPos );
//		C.DrawText(":",False);
		C.SetPos( XXL+XL, YPos );
		if( Master == None )
			SetupMaster();

		Class'HUDScriptContent'.Static.DrawSmileyText(Master,TextMessages[i].Text,C,,YYL);
		YPos += (YL+YYL);
	}
}

simulated function DrawTypingPrompt (Canvas C, String Text, optional int Pos)
{
    local float XPos, YPos;
    local float XL, YL;

    C.Font = GetConsoleFont(C);
    C.Style = ERenderStyle.STY_Alpha;
    C.DrawColor = ConsoleColor;

    C.TextSize ("A", XL, YL);

    XPos = (ConsoleMessagePosX * HudCanvasScale * C.SizeX) + (((1.0 - HudCanvasScale) * 0.5) * C.SizeX);
    YPos = (ConsoleMessagePosY * HudCanvasScale * C.SizeY) + (((1.0 - HudCanvasScale) * 0.5) * C.SizeY) - YL;

    C.SetPos (XPos, YPos);
    if( Master == None )
    	SetupMaster();

    Class'HUDScriptContent'.Static.DrawSmileyText(Master,"(>"@Left(Text, Pos)$chr(4)$Eval(Pos < Len(Text), Mid(Text, Pos),"_"),C);
}

defaultproperties
{
}
