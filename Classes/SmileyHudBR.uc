//================================================================================
// SmileyHudBR.
//================================================================================
class SmileyHudBR extends HudCBombingRun
	Config(User);

var EmoticonsReplicationInfo Master;
var int Attempts;

function SetupMaster ()
{
	local EmoticonsReplicationInfo Emo;

	if ( Attempts > 10 )
	{
		return;
	}
	foreach DynamicActors(Class'EmoticonsReplicationInfo',Emo)
	{
		if ( Emo.Owner == PlayerOwner )
		{
			Master=Emo;
			return;
		}
	}
	Attempts++;
	return;
}

function string StripColorForTTS (string S)
{
	local int P;

	P=InStr(S,Chr(27));
JL0011:
	if ( P >= 0 )
	{
		S=Left(S,P) $ Mid(S,P + 4);
		P=InStr(S,Chr(27));
		goto JL0011;
	}
	return S;
	return;
}

function DrawSmileyText (string S, Canvas C, optional out float XXL, optional out float XYL)
{
	local int i;
	local int N;
	local float PX;
	local float PY;
	local float XL;
	local float YL;
	local float CurX;
	local float CurY;
	local float SScale;
	local float Sca;
	local float AdditionalY;
	local float NewAY;
	local string D;
	local Color OrgC;
	local Texture EIcon;

	if ( Master == None )
	{
		SetupMaster();
	}
	C.StrLen("T",XL,YL);
	SScale=YL;
	PX=C.CurX;
	PY=C.CurY;
	CurX=PX;
	CurY=PY;
	OrgC=C.DrawColor;
	i=FindNextSmile(S,N);
JL009D:
	if ( (i != -1) && (Master != None) )
	{
		D=Left(S,i);
		S=Mid(S,i + Len(Master.mySmileys[N].Event));
		C.SetPos(CurX,CurY);
		C.DrawText(D);
		C.StrLen(StripColorForTTS(D),XL,YL);
		CurX += XL;
JL0151:
		if ( CurX > C.ClipX )
		{
			CurY += YL + AdditionalY;
			XYL += YL + AdditionalY;
			AdditionalY=0.00;
			CurX -= C.ClipX;
			goto JL0151;
		}
		C.DrawColor=Default.WhiteColor;
		C.SetPos(CurX,CurY);
		EIcon=Master.mySmileys[N].Icon;
		if ( EIcon.USize == 16 )
		{
			Sca=SScale;
		} else {
			Sca=EIcon.USize / 32 * SScale;
		}
		C.DrawTile(EIcon,Sca,Sca,0.00,0.00,EIcon.USize,EIcon.VSize);
		if ( Sca > SScale )
		{
			NewAY=Sca - SScale;
			if ( NewAY > AdditionalY )
			{
				AdditionalY=NewAY;
			}
			NewAY=0.00;
		}
		CurX += Sca;
JL02D9:
		if ( CurX > C.ClipX )
		{
			CurY += YL + AdditionalY;
			XYL += YL + AdditionalY;
			AdditionalY=0.00;
			CurX -= C.ClipX;
			goto JL02D9;
		}
		C.DrawColor=OrgC;
		i=FindNextSmile(S,N);
		goto JL009D;
	}
	C.SetPos(CurX,CurY);
	C.StrLen(StripColorForTTS(S),XL,YL);
	C.DrawText(S);
	CurX += XL;
JL03BE:
	if ( CurX > C.ClipX )
	{
		CurY += YL + AdditionalY;
		XYL += YL + AdditionalY;
		AdditionalY=0.00;
		CurX -= C.ClipX;
		goto JL03BE;
	}
	XYL += AdditionalY;
	AdditionalY=0.00;
	XXL=CurX;
	C.SetPos(PX,PY);
	return;
}

function int FindNextSmile (string S, out int SmileNr)
{
	local int i;
	local int j;
	local int P;
	local int bp;

	bp=-1;
	if ( Master == None )
	{
		return bp;
	}
	j=Master.mySmileys.Length;
	i=0;
JL0038:
	if ( i < j )
	{
		P=InStr(S,Master.mySmileys[i].Event);
		if ( (P != -1) && ((P < bp) || (bp == -1)) )
		{
			bp=P;
			SmileNr=i;
		}
		i++;
		goto JL0038;
	}
	return bp;
	return;
}

function DisplayMessages (Canvas C)
{
	local int i;
	local int j;
	local int XPos;
	local int YPos;
	local int MessageCount;
	local float XL;
	local float YL;
	local float YYL;
	local float XXL;

	i=0;
JL0007:
	if ( i < ConsoleMessageCount )
	{
		if ( TextMessages[i].Text == "" )
		{
			goto JL00E6;
		} else {
			if ( TextMessages[i].MessageLife < Level.TimeSeconds )
			{
				TextMessages[i].Text="";
				if ( i < ConsoleMessageCount - 1 )
				{
					j=i;
JL0086:
					if ( j < ConsoleMessageCount - 1 )
					{
						TextMessages[j]=TextMessages[j + 1];
						j++;
						goto JL0086;
					}
				}
				TextMessages[j].Text="";
				goto JL00E6;
			} else {
				MessageCount++;
			}
		}
		i++;
		goto JL0007;
	}
JL00E6:
	XPos=ConsoleMessagePosX * HudCanvasScale * C.SizeX + (1.00 - HudCanvasScale) / 2.00 * C.SizeX;
	YPos=ConsoleMessagePosY * HudCanvasScale * C.SizeY + (1.00 - HudCanvasScale) / 2.00 * C.SizeY;
	C.Font=GetConsoleFont(C);
	C.DrawColor=ConsoleColor;
	C.TextSize("A",XL,YL);
	YPos -= YL * MessageCount + 1;
	YPos -= YL;
	i=0;
JL0200:
	if ( i < MessageCount )
	{
		if ( TextMessages[i].Text == "" )
		{
			goto JL02DD;
		}
		C.SetPos(XPos,YPos);
		C.DrawColor=TextMessages[i].TextColor;
		YYL=0.00;
		XXL=0.00;
		C.SetPos(XXL + XL,YPos);
		DrawSmileyText(TextMessages[i].Text,C,,YYL);
		YPos += YL + YYL;
		i++;
		goto JL0200;
	}
JL02DD:
	return;
}

function DrawTypingPrompt (Canvas C, string Text, optional int pos)
{
	local float XPos;
	local float YPos;
	local float XL;
	local float YL;

	C.Font=GetConsoleFont(C);
	C.Style=5;
	C.DrawColor=ConsoleColor;
	C.TextSize("A",XL,YL);
	XPos=ConsoleMessagePosX * HudCanvasScale * C.SizeX + (1.00 - HudCanvasScale) * 0.50 * C.SizeX;
	YPos=ConsoleMessagePosY * HudCanvasScale * C.SizeY + (1.00 - HudCanvasScale) * 0.50 * C.SizeY - YL;
	C.SetPos(XPos,YPos);
	DrawSmileyText("(>" @ Left(Text,pos) $ Chr(4) $ UnknownFunction202(pos < Len(Text),Mid(Text,pos),"_"),C);
	return;
}

