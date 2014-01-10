Class HUDScriptContent Extends Object;

Static Function DrawSmileyText( EmoticonsReplicationInfo Master, string S, canvas C, optional out float XXL, optional out float XYL )
{
	local int i,n;
	local float PX,PY,XL,YL,CurX,CurY,SScale,Sca,AdditionalY,NewAY;
	local string D;
	local color OrgC;
	local Texture EIcon;
	local Material MIcon;

	// Initilize
	C.StrLen("T",XL,YL);
	SScale = YL;
	PX = C.CurX;
	PY = C.CurY;
	CurX = PX;
	CurY = PY;
	OrgC = C.DrawColor;
	// Search for smiles in text
	i = FindNextSmile( Master, S, n );
	While( i!=-1 && Master != None )
	{
		D = Left(S,i);
		S = Mid( S, i+Len( Master.mySmileys[n].Event ) );
		// Draw text behind
		C.SetPos(CurX,CurY);
		C.DrawText(D);
		// Draw smile
		C.StrLen(StripColorForTTS(D),XL,YL);
		CurX+=XL;
		While( CurX>C.ClipX )
		{
			CurY+=(YL+AdditionalY);
			XYL+=(YL+AdditionalY);
			AdditionalY = 0;
			CurX-=C.ClipX;
		}
		C.DrawColor = C.MakeColor( 255, 255, 255, 255 );
		C.SetPos(CurX,CurY);
		if( Master.mySmileys[n].Icon != None )
		{
			EIcon = Master.mySmileys[n].Icon;
			if( EIcon.USize == 16 )
				Sca = SScale;
			else Sca = EIcon.USize/32*SScale;
			C.DrawTile( EIcon, Sca, Sca, 0, 0, EIcon.USize, EIcon.VSize );
		}
		else if( Master.mySmileys[n].MatIcon != None )
		{
			MIcon = Master.mySmileys[n].MatIcon;
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
			XYL+=(YL+AdditionalY);
			AdditionalY = 0;
			CurX-=C.ClipX;
		}
		// Then go for next smile
		C.DrawColor = OrgC;
		i = FindNextSmile( Master, S, n );
	}
	// Then draw rest of text remaining
	C.SetPos(CurX,CurY);
	C.StrLen(StripColorForTTS(S),XL,YL);
	C.DrawText(S);
	CurX+=XL;
	While( CurX>C.ClipX )
	{
		CurY+=(YL+AdditionalY);
		XYL+=(YL+AdditionalY);
		AdditionalY = 0;
		CurX-=C.ClipX;
	}
	XYL+=AdditionalY;
	AdditionalY = 0;
	XXL = CurX;
	C.SetPos(PX,PY);
}

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

static Function int FindNextSmile( EmoticonsReplicationInfo Master, string S, out int SmileNr )
{
	local int i,j,p,bp;

	bp = -1;
	if( Master == None )
		return bp;

	j = Master.mySmileys.Length;
	for( i = 0; i < j; i ++ )
	{
		p = InStr( S, Master.mySmileys[i].Event );
		if( p!=-1 && (p<bp || bp==-1) )
		{
			bp = p;
			SmileNr = i;
		}
	}
	return bp;
}
