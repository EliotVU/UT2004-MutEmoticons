// Created by Eliot & Marco a.k.a .:..:
class HUDProxy extends HUD
    abstract
    cacheexempt;

const this = Class'HUDProxy';

final function EmoticonsReplicationInfo GetReplication()
{
    // if (Class'MutEmoticons'.default.EmoticonsState == none) {
    //     foreach DynamicActors(Class'EmoticonsReplicationInfo', Class'MutEmoticons'.default.EmoticonsState) 
    //         break;
    // }

    return Class'MutEmoticons'.default.EmoticonsState;
}

// Modified copy from Engine/Classes/HUD.uc
final function DisplayMessagesProxy(Canvas C)
{
    local int i, j, XPos, YPos, MessageCount;
    local float XL, YL;

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

        // We are re-purposing XL as YYL
		XL = 0;
		C.SetPos( XPos, YPos );
		C.DrawColor = TextMessages[i].TextColor;
		this.static.DrawSmileyText(GetReplication(), TextMessages[i].Text, C,, XL);
		YPos += YL + XL;
	}
}

// Modified copy from Engine/Classes/HUD.uc
final simulated function DrawTypingPromptProxy(Canvas C, String Text, optional int Pos)
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
    this.static.DrawSmileyText(GetReplication(),"(>"@Left(Text, Pos)$chr(4)$Eval(Pos < Len(Text), Mid(Text, Pos),"_"),C);
}

// Borrowed from AssaultPlus by Marco a.k.a .:..: and modified to work with configurable and replicatable emoticons.
static function DrawSmileyText( EmoticonsReplicationInfo replication, string S, canvas C, optional out float XXL, optional out float XYL )
{
	local int i,n;
	local float PX,PY,XL,YL,CurX,CurY,SScale,Sca,AdditionalY,NewAY;
	local string D;
	local color OrgC;
	local Texture EIcon;
	local Material MIcon;

    // Fallback to the default behavior if we have not received the replicated state yet.
    if (replication == none) {
        C.DrawTextClipped(s, true);
        return;
    }

	// Initilize
	C.StrLen("T",XL,YL);
	SScale = YL;
	PX = C.CurX;
	PY = C.CurY;
	CurX = PX;
	CurY = PY;
	OrgC = C.DrawColor;
	// Search for smiles in text
	i = FindNextSmile( replication, S, n );
	While( i!=-1 && replication != None )
	{
		D = Left(S,i);
		S = Mid( S, i+Len( replication.Smileys[n].Event ) );
		// Draw text behind
		C.SetPos(CurX,CurY);
		C.DrawText(D);
		// Draw smile
		C.StrLen(StripColorForTTS(D),XL,YL);
		CurX+=XL;
		While( CurX>C.ClipX )
		{
			CurY+=(YL+AdditionalY);
			AdditionalY = 0;
			CurX-=C.ClipX;
		}
		C.DrawColor = default.WhiteColor;
		C.SetPos(CurX,CurY);
		if( replication.Smileys[n].Icon != None )
		{
			EIcon = replication.Smileys[n].Icon;
			if( EIcon.USize == 16 )
				Sca = SScale;
			else Sca = EIcon.USize/32*SScale;
			C.DrawTile( EIcon, Sca, Sca, 0, 0, EIcon.USize, EIcon.VSize );
		}
		else if( replication.Smileys[n].MatIcon != None )
		{
			MIcon = replication.Smileys[n].MatIcon;
			if( MIcon.MaterialUSize() == 16 )
				Sca = SScale;
			else Sca = MIcon.MaterialUSize()/32*SScale;
			C.DrawTile( MIcon, Sca, Sca, 0, 0, MIcon.MaterialUSize(), MIcon.MaterialVSize() );
		}

		if( Sca>SScale )
		{
			NewAY = (Sca-SScale);
			if( NewAY>AdditionalY )
				AdditionalY = NewAY;
			NewAY = 0;
		}
		CurX+=Sca;
		While( CurX>C.ClipX )
		{
			CurY+=(YL+AdditionalY);
			AdditionalY = 0;
			CurX-=C.ClipX;
		}
		// Then go for next smile
		C.DrawColor = OrgC;
		i = FindNextSmile( replication, S, n );
	}
	// Then draw rest of text remaining
	C.SetPos(CurX,CurY);
	C.StrLen(StripColorForTTS(S),XL,YL);
	C.DrawText(S);
	CurX+=XL;
	While( CurX>C.ClipX )
	{
		CurY+=(YL+AdditionalY);
		AdditionalY = 0;
		CurX-=C.ClipX;
	}
	XYL+=AdditionalY;
	AdditionalY = 0;
	XXL = CurX;
	C.SetPos(PX,PY);
}

// Borrowed from AssaultPlus by Marco a.k.a .:..:
static function string StripColorForTTS( string s )
{
	local int p;

	p = InStr(s,chr(27));
	while ( p>=0 )
	{
		s = left(s,p)$mid(S,p+4);
		p = InStr(s,Chr(27));
	}
	return s;
}

// Borrowed from AssaultPlus by Marco a.k.a .:..:
static function int FindNextSmile( EmoticonsReplicationInfo replication, string S, out int SmileNr )
{
	local int i,j,p,bp;

	bp = -1;
	j = replication.Smileys.Length;
	for( i = 0; i < j; i ++ )
	{
		p = InStr( S, replication.Smileys[i].Event );
		if( p!=-1 && (p<bp || bp==-1) )
		{
			bp = p;
			SmileNr = i;
		}
	}
	return bp;
}

defaultproperties
{

}