//
// *********************************************************************
// *                                                                   *
// * eXtends Ver 2.0 Include File : 2DPluginKIT Blitter Objects System *
// *                                                                   *
// *********************************************************************
// Start Date : 2019.05.08 23:29
// Last Update : 2020.03.21 15:25
// Description : Ce système gère les bobs virtuels 
//
// Author : Frédéric Cordier
// -------------------------------------------------------------------------------------
//
// ******** Bobs Displaying :
// internalPKDrawBOB( BlitterID, XPos, YPos, forceTransparency, Transparency ) * INTERNAL USE ONLY *
// PKDrawBOB( BobID )
// PKDrawBOBEx( BobID, XPos, YPos )
// PKDrawBOBEx2( BobID, XPos, YPos, Transparency )
// 
// ******** Bobs Loading/Creation :
// BobID = PKLoadBlitterObject( FileName )
// BobID = PKLoadBlitterObjectEx( FileName, TransparencyFlag )
// BobID = PKLoadBlitterObjectEx2( FileName, TilesXAmount, TilesYAmount )
// BobID = PKLoadBlitterObjectEx3( FileName, TilesXAmount, TilesYAmount, TransparencyFlag )
//
// ******** Bobs insertion in bob definition list :
// BobID = PKAddBlitterObject( ImageID )
// BobID = PKAddBlitterObjectEx( ImageID, TilesXAmount, TilesYAmount )
// BobID = PKAddBlitterObjectEx2( ImageID, TilesXAmount, TilesYAmount, TransparencyFlag )
// BobID = PKInstanceBlitterObject( SourceBobID )
// BobID = PKInstanceBlitterObjectEx( SourceBobID, XPos, YPos )
//
// ******** Bobs to layers relationship methods by ID :
// PKAttachBobToLayer( BobID, LayerID )
// PKDetachBobFromLayer( BobID )
//
// ******** Bobs Updates :
// PKPositionBOB( BobID, XPos, YPos )
// PKHideBOB( BobID )
// PKShowBOB( BobID )
// PKSetBobImage( BobID, ImageID )
// PKSetBobFrame( BobID, FrameID )
//
// ******** Bobs checkings :
// TRUE/FALSE = PKGetBobExists( BobID )
// xPos = PKGetBobPosX( BobID )
// yPos = PKGetBobPosY( BobID )
// FrameID = PKGetBobFrame( BobID )
// TRUE/FALSE = PKGetBobTransparent( BobID )

//
// ******** Bobs Displaying By Bame:
// PKDrawBOB( BobName )
// PKDrawBOBEx( BobName, XPos, YPos )
// PKDrawBOBEx2( BobName, XPos, YPos, Transparency )
//
// ******** Bobs insertion in bob definition list methods by Name :
// BobID = PKAddBlitterObjectEx3( BobName, ImageID, TilesXAmount, TilesYAmount )
// BobID = PKAddBlitterObjectEx4( BobName, ImageID, TilesXAmount, TilesYAmount, TransparencyFlag )
// PKInstanceBlitterObjectByName( BobName )
// PKInstanceBlitterObjectByNameEx( BobName, XPos, YPos )
//
// ******** Bobs to Layers relationship methods by Name :
// PKAttachBobToLayerBothByName( BobName, LayerName )
// PKAttachBobToLayerBothByName( BobName )
//
// ******** Bobs Updates by Name :
// PKPositionBOBByName( BobName, XPos, YPos )
// PKHideBOBByName( BobName )
// PKShowBOBByName( BobName )
// PKSetBobImageByName( BobName, ImageID )
// PKSetBobFrameByName( BobName, FrameID )
//
// ******** Bobs Checkings by Name :
// BobID = PKFindBlitterObjectByName( BobName )
// xPos = PKGetBobPosXByName( BobName )
// yPos = PKGetBobPosYByName( BobName )
// FrameID = PKGetBobFrameByName( BobName )
// TRUE/FALSE = PKGetBobTransparentByName( BobName )

Function internalPKDrawBOB( BlitterID As Integer, XPos As Integer, YPos As Integer, forceTransparency As Integer, Transparency As Integer )
	// Use default blitter object positions
	if XPos = 32768 then XPos = Bobs[ BlitterID ].Xpos
	if YPos = 32768 then YPos = Bobs[ BlitterID ].YPos
	// Define the tile within the whole blitter object image
	TileID As Integer
	TileID = Bobs[ BlitterID ].CurrentFrame - 1 // To force Tiles IDs to start at index 0.
	YTile As Integer : YTile = TileID / Bobs[ BlitterID ].XTiles
	XTile As Integer : XTile = TileID - ( YTile * Bobs[ BlitterID ].YTiles )
	// DBSizeSprite( Bobs[ BlitterID ].DBSprite, Bobs[ BlitterID ].TilesWIDTH, Bobs[ BlitterID ].TilesHEIGHT )
	XMin As Float : XMin = ( XTile * Bobs[ BlitterID ].TilesWIDTH ) / Bobs[ BlitterID ].Width
	YMin As Float : YMin = ( YTile * Bobs[ BlitterID ].TilesHEIGHT ) / Bobs[ BlitterID ].Height
	XMax As Float : XMax = ( ( XTile + 1 ) * Bobs[ BlitterID ].TilesWIDTH ) / Bobs[ BlitterID ].Width
	YMax As Float : YMax = ( ( YTile + 1 ) * Bobs[ BlitterID ].TilesHEIGHT ) / Bobs[ BlitterID ].Height
	If ( SpriteForBobs = 0 )
		SpriteForBobs = CreateSprite( SpriteForBobs )
	Endif
	SetSpriteImage( SpriteForBobs, Bobs[ BlitterID ].ImageID )
	AnimAmount As Integer : AnimAmount = ( Bobs[ BlitterID ].Width / Bobs[ BlitterID ].TilesWIDTH ) * ( Bobs[ BlitterID ].Height / Bobs[ BlitterID ].TilesHEIGHT )
	SetSpriteanimation( SpriteForBobs, Bobs[ BlitterID ].TilesWIDTH, Bobs[ BlitterID ].TilesHEIGHT, AnimAmount )
	// Set Transparency depending on default bob parameter or forced external one
	TransparencyToUse As Integer
	if forceTransparency = TRUE
		TransparencyToUse = Transparency
	Else
		TransparencyToUse = Bobs[ BlitterID ].Transparency
	Endif
	SetSpriteTransparency( SpriteForBobs, TransparencyToUse )
	SetSpritePosition( SpriteForBobs, XPos, YPos )
	SetSpriteFrame( SpriteForBobs, Bobs[ BlitterID ].CurrentFRAME )
	// DBSetTextureCoordinates( Bobs[ BlitterID ].DBSprite, 0, XMin, YMin )
	// DBSetTextureCoordinates( Bobs[ BlitterID ].DBSprite, 1, XMax, YMin )
	// DBSetTextureCoordinates( Bobs[ BlitterID ].DBSprite, 2, XMin, YMax )
	// DBSetTextureCoordinates( Bobs[ BlitterID ].DBSprite, 3, XMax, YMax )
	DrawSprite( SpriteForBobs )
	DeleteSprite( SpriteForBobs )
	SpriteForBobs = 0
EndFunction


//
//**************************************************************************************************************
//
Function PKDrawBOB( BlitterID As integer )
	If PKGetBobExists( BlitterID ) = 1
		internalPKDrawBOB( BlitterID, 32768, 32768, FALSE, FALSE )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKDrawBOBEx( BlitterID As integer, XPos As Integer, YPos As Integer )
	If PKGetBobExists( BlitterID ) = 1
		internalPKDrawBOB( BlitterID, XPos, YPos, FALSE, FALSE )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKDrawBOBEx2( BlitterID As integer, XPos As Integer, YPos As Integer, TransparencyFlag As Integer )
	If PKGetBobExists( BlitterID ) = 1
		internalPKDrawBOB( BlitterID, XPos, YPos, TRUE, TransparencyFlag )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKLoadBlitterObject( FileNAMESTR As String )
	BlitterID As Integer
	BlitterID = PKLoadBlitterObjectEx3( FileNAMESTR, 1, 1, PKSetup.BobsDefTrans )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKLoadBlitterObjectEx( FileNAMESTR As String, TransparencyFLAG As Integer )
	BlitterID As Integer
	BlitterID = PKLoadBlitterObjectEx3( FileNAMESTR, 1, 1, TransparencyFLAG )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKLoadBlitterObjectEx2( FileNAMESTR As String, TilesXCount As Integer, TilesYCount As Integer )
	BlitterID As Integer
	BlitterID = PKLoadBlitterObjectEx3( FileNAMESTR, TilesXCount, TilesYCount, PKSetup.BobsDefTrans )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKLoadBlitterObjectEx3( FileNAMESTR As String, TilesXCount As Integer, TilesYCount As Integer, TransparencyFLAG As Integer )
	IMAGEID As Integer
	BlitterID As Integer
	IMAGEID = LoadImage( FileNAMESTR )
	BlitterID = PKAddBlitterObjectEx3( IMAGEID, TilesXCount, TilesYCount, TransparencyFLAG )
	Bobs[ BlitterID ].Transparency = TransparencyFLAG
	// Bobs[ BlitterID ].EXTLoaded = 2
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKAddBlitterObject( ImageID As Integer )
	BlitterID As Integer
	BlitterID = PKAddBlitterObjectEx5( Str( ImageID ), ImageID, 1, 1, PKSetup.BobsDefTrans )
EndFunction BlitterID


//
//**************************************************************************************************************
//
Function PKAddBlitterObjectEx( ImageID As Integer, TransparencyFLAG As Integer )
	BlitterID As Integer
	BlitterID = PKAddBlitterObjectEx5( Str( ImageID ), ImageID, 1, 1, TransparencyFLAG )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKAddBlitterObjectEx2( ImageID As Integer, TilesXCount As Integer, TilesYCount As Integer )
	BlitterID As Integer
	BlitterID = PKAddBlitterObjectEx5( Str( ImageID ), ImageID, TilesXCount, TilesYCount, PKSetup.BobsDefTrans )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKAddBlitterObjectEx3( ImageID As Integer, TilesXCount As Integer, TilesYCount As Integer, TransparencyFlag As Integer )
	BlitterID As Integer
	BlitterID = PKAddBlitterObjectEx5( Str( ImageID ), ImageID, TilesXCount, TilesYCount, TransparencyFlag )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKInstanceBlitterObject( SourceBobID As Integer )
	BlitterID As Integer = -1
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKInstanceBlitterObjectEx( SourceID As Integer, XPos As Integer, YPos As Integer )
	BlitterID As Integer = -1
	If PKGetBobExists( SourceID ) = 1
		newBob As Bobs_Type
		newBob.Name = Bobs[ SourceID ].Name + "_Instance"
		newBob.Active = 1
		newBob.XPos = XPos
		newBob.YPos = YPos
		newBob.InstanceID = SourceID
		newBob.Width = Bobs[ SourceID ].Width
		newBob.Height = Bobs[ SourceID ].Height
		Bobs.insert( newBob )
		BlitterID = Bobs.length
	Else
		CastError( "PluginKIT Instance Blitter Object Error : Source Bob does not exist or is invalid" )
	EndIf
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKAttachBobToLayer( BobID As Integer, LayerID As Integer )
	if PKGetBobExists( BobID ) = TRUE
		if Bobs[ BobID ].LayerID > -1
			PKDetachBobFromLayer( BobID )
		Endif
		if PKGetLayerExists( LayerID ) = TRUE
			// Insert the bob inside the LayersBobs list
			LayerBob As PKLayersObjects_Type
			LayerBob.ObjectID = BobID
			LayerBob.ObjectName = Bobs[ BobID ].Name
			PKLayer[ LayerID ].PKLayersBobs.insert( LayerBob )
			// Save chosen layer informations inside the bob
			Bobs[ BobID ].LayerID = LayerID
			Bobs[ BobID ].LayerName = PKLayer[ LayerID ].Name
		Else
			CastError( "PluginKIT Attach Bob To Layer Error : The requested Layer #" + Str( LayerID ) + " does not exists" )
		Endif
	Else
		CastError( "PluginKIT Attach Bob To Layer Error : The requested Bob #" + Str( BobID ) + " does not exists" )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKDetachBobFromLayer( BobID As Integer )
	if PKGetBobExists( BobID ) = TRUE
		if Bobs[ BobID ].LayerID > -1 or Bobs[ BobID ].LayerName <> NULL
			LayerID As integer
			LayerID = Bobs[ BobID ].LayerID
			if PKGetLayerExists( LayerID ) = TRUE
				if PKLayer[ LayerID ].PKLayersBobs.length > -1
					bLoop As Integer
					for bLoop = 0 to PKLayer[ LayerID ].PKLayersBobs.length Step 1
						if PKLayer[ LayerID ].PKLayersBobs[ bLoop ].ObjectName = Bobs[ BobID ].Name
							PKLayer[ LayerID ].PKLayersBobs.remove( bLoop )
							exit // Quit the loop.
						Endif
					Next bLoop			
				Endif
			Endif
		Endif
	Else
		CastError( "PluginKIT Detach Bob from layer error : The requested Bob #" + Str( BobID ) + " does not exists" )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKPositionBOB( BlitterID As Integer, XPos As Integer, YPos As Integer )
	If PKGetBobExists( BlitterID ) = 1
		Bobs[ BlitterID ].XPos = XPos
		Bobs[ BlitterID ].YPos = YPos
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKHideBOB( BlitterID As Integer )
	If PKGetBobExists( BlitterID ) = 1
		Bobs[ BlitterID ].Hide = 1
	EndIf
EndFunction
//
//**************************************************************************************************************
//
Function PKShowBOB( BlitterID As Integer )
	If PKGetBobExists( BlitterID ) = 1
		Bobs[ BlitterID ].Hide = 0
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetBobImage( BlitterID As Integer, ImageID As Integer )
	If PKGetBobExists( BlitterID ) = 1 And GetImageExists( ImageID ) = 1
		Bobs[ BlitterID ].CurrentFRAME = ImageID
	EndIf
EndFunction
//
//**************************************************************************************************************
//
Function PKSetBobFrame( BlitterID As Integer, FrameID As Integer )
	If PKGetBobExists( BlitterID ) = 1
		If FrameID <= Bobs[ BlitterID ].FramesCOUNT
			Bobs[ BlitterID ].CurrentFRAME = FrameID
		EndIf
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKGetBobExists( BlitterID As Integer )
	Retour As Integer
	If BlitterID > -1 and BlitterID < ( Bobs.length + 1 )
		If Bobs[ BlitterID ].Active = TRUE
			Retour  = TRUE
		Else
			Retour = FALSE
			CastError( "PKGetBobExists Error : The Blitter Object does not exist" )
		EndIf
	Else
		Retour = FALSE
		CastError( "PKGetBobExists Error : Blitter Object number (" + Str( BlitterID ) + ") is invalid" )
	EndIf
EndFunction Retour

//
//**************************************************************************************************************
//
Function PKGetBobPosX( BlitterID As Integer )
	Retour As Integer = -1
	If PKGetBobExists( BlitterID ) = 1
		Retour = Bobs[ BlitterID ].XPos
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetBobPosY( BlitterID As Integer )
	Retour As Integer = -1
	If PKGetBobExists( BlitterID ) = 1
		Retour = Bobs[ BlitterID ].YPos
	EndIf
EndFunction Retour

//
//**************************************************************************************************************
//
Function PKGetBobFrame( BlitterID As Integer )
	Retour As Integer = -1
	If PKGetBobExists( BlitterID ) = 1
		Retour = Bobs[ BlitterID ].CurrentFRAME
	EndIf
EndFunction Retour

//
//**************************************************************************************************************
//
Function PKGetBobTransparent( BlitterID As Integer )
	Retour As Integer = -1
	If PKGetBobExists( BlitterID ) = 1
		Retour = Bobs[ BlitterID ].Transparency
	EndIf
EndFunction Retour




//
//**************************************************************************************************************
//
Function PKDrawBOBByName( BobName As String )
	BlitterID As Integer
	BlitterID = PKFindBlitterObjectByName( BobName )
	if PKGetBobExists( BlitterID )
		internalPKDrawBOB( BlitterID, 32768, 32768, FALSE, FALSE )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKDrawBOBByNameEx( BobName As String, XPos As Integer, YPos As Integer )
	BlitterID As Integer
	BlitterID = PKFindBlitterObjectByName( BobName )
	if PKGetBobExists( BlitterID )
		internalPKDrawBOB( BlitterID, XPos, YPos, FALSE, FALSE )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKDrawBOBByNameEx2( BobName As String, XPos As Integer, YPos As Integer, TransparencyFlag As Integer )
	BlitterID As Integer
	BlitterID = PKFindBlitterObjectByName( BobName )
	if PKGetBobExists( BlitterID )
		internalPKDrawBOB( BlitterID, XPos, YPos, TRUE, TransparencyFlag )
	Endif
EndFunction

//
//**************************************************************************************************************
//
Function PKAddBlitterObjectEx4( BobName As String, ImageID As Integer, TilesXCount As Integer, TilesYCount As Integer )
	BlitterID As Integer
	BlitterID = PKAddBlitterObjectEx5( BobName, ImageID, TilesXCount, TilesYCount, PKSetup.BobsDefTrans )
EndFunction BlitterID 

//
//**************************************************************************************************************
//
Function PKAddBlitterObjectEx5( BobName As String, ImageID As Integer, TilesXCount As Integer, TilesYCount As Integer, TransparencyFLAG As Integer )
	BlitterID As Integer = -1
	if getImageExists( ImageID ) = 1
		newBob As Bobs_Type
		newBob.Name = BobName
		newBob.Active = 1
		newBob.ImageID = ImageID
		newBob.EXTLoaded = 0
		newBob.AnimationID = 0
		newBob.LayerID = -1
		newBob.LayerName = NULL
		newBob.XPos = 0
		newBob.YPos = 0
		newBob.Hide = FALSE
		newBob.Transparency = TransparencyFLAG
		newBob.Width = GetImageWidth( ImageID )
		newBob.Height = GetImageHeight( ImageID )
		newBob.XTiles = TilesXCount
		newBob.Ytiles = TilesYCount
		newBob.TilesWIDTH = newBob.Width / TilesXCount
		newBob.TilesHEIGHT = newBob.Height / TilesYCount
		newBob.FramesCOUNT = TilesXCount * TilesYCount
		newBob.CurrentFRAME = 1
		Bobs.insert( newBob )
		BlitterID = Bobs.length
	else
		CastError( "PKAddBlitterObject Error : The requested ImageID does not exists" )
	EndIf
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKAttachBobToLayerBothByName( BobName As String, LayerName As String )
	BobID As Integer
	BobID = PKFindBlitterObjectByName( BobName )
	LayerID As Integer
	LayerID = PKGetLayerIDByName( LayerName )
	PKAttachBobToLayer( BobID, LayerID )
EndFunction

//
//**************************************************************************************************************
//
Function PKDetachBobByNameFromLayer( BobName As String )
	BobID As Integer
	BobID = PKFindBlitterObjectByName( BobName )
	PKDetachBobFromLayer( BobID )
EndFunction

//
//**************************************************************************************************************
//
Function PKInstanceBlitterObjectByName( BobName As String )
	BobID As Integer = -1
	BobID = PKFindBlitterObjectByName( BobName )
	BlitterID As Integer = -1
	BlitterID = PKInstanceBlitterObject( BlitterID )
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKInstanceBlitterObjectExByName( BobName As String, XPos As Integer, YPos As Integer )
	BobID As Integer = -1
	BobID = PKFindBlitterObjectByName( BobName )
	if PKGetBobExists( BobID ) = TRUE 
		BlitterID As Integer = -1
		BlitterID = PKInstanceBlitterObjectEx( BobID, XPos, YPos )
	Endif
EndFunction BlitterID

//
//**************************************************************************************************************
//
Function PKPositionBOBByName( BobName As String, XPos As Integer, YPos As Integer )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	PKPositionBOB( BlitterID, XPos, YPos )
EndFunction

//
//**************************************************************************************************************
//
Function PKHideBOBByName( BobName As String )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	PKHideBOB( BlitterID )
EndFunction
//
//**************************************************************************************************************
//
Function PKShowBOBByName( BobName As String )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	PKShowBOB( BlitterID )
EndFunction

//
//**************************************************************************************************************
//
Function PKSetBobImageByName( BobName As String, ImageID As Integer )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	PKSetBobImage( BlitterID, ImageID )
EndFunction
//
//**************************************************************************************************************
//
Function PKSetBobFrameByName( BobName As String, FrameID As Integer )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	PKSetBobFrame( BlitterID, FrameID )
EndFunction

//
//**************************************************************************************************************
//
Function PKFindBlitterObjectByName( bobName As String )
	thisBobID As Integer = -1
	bLoop As Integer = -1
	if bobName = "" or bobName = NULL
		thisBobID = -1
	Else
		if Bobs.Length > -1
			for bLoop = 0 To Bobs.Length Step 1
				if Bobs[ bLoop ].Name = bobName
					thisBobID = bLoop
					exit // Quit the loop
				Endif
			Next bLoop
		Else
			CastError( "PKFindBobIDByName Error : No blitter object defined" )
		Endif
	Endif
EndFunction thisBobID

//
//**************************************************************************************************************
//
Function PKGetBobPosXByName( BobName As String )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	Retour As Integer = -1
	Retour = PKGetBobPosX( BlitterID )
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetBobPosYByName( BobName As String )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	Retour As Integer = -1
	Retour = PKGetBobPosY( BlitterID )
EndFunction Retour

//
//**************************************************************************************************************
//
Function PKGetBobFrameByName( BobName As String )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	Retour As Integer = -1
	Retour = PKGetBobFrame( BlitterID )
EndFunction Retour

//
//**************************************************************************************************************
//
Function PKGetBobTransparentByName( BobName As String )
	BlitterID As Integer = -1
	BlitterID = PKFindBlitterObjectByName( BobName )
	Retour As Integer = -1
	Retour = PKGetBobTransparent( BlitterID )
EndFunction Retour

// 
// **************************************************************************************************************
// 
function internalPKDrawLayerBobs( LayerID As Integer, XS As Integer, YS As Integer, XE As Integer, YE As Integer, XDisplay As Integer, YDisplay As Integer )
	if PKLayer[ LayerID ].PKLayersBobs.length > -1
		//  Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
		DisplayWIDTH As Integer : DisplayWIDTH = XE - XS 
		DisplayHEIGHT As Integer : DisplayHEIGHT = YE - YS
		//  Calcul des 4 extrémités pour l'affichage des lumières.
		DispLEFT As Integer : DispLEFT = XDisplay // PKLayer[ LayerID ].XDisplay
		DispTOP As Integer : DispTOP = YDisplay // PKLayer[ LayerID ].YDisplay
		DispRIGHT As Integer : DispRIGHT = XDisplay + DisplayWIDTH // PKLayer[ LayerID ].XDisplay + DisplayWIDTH
		DispBOTTOM As Integer : DispBOTTOM = YDisplay + DisplayHEIGHT // PKLayer[ LayerID ].YDisplay + DisplayHEIGHT
		InPOS As Integer
		for InPos = 0 to PKLayer[ LayerID ].PKLayersBobs.length Step 1
			CurrentBOB As Integer
			CurrentBOB = PKFindBlitterObjectByName( PKLayer[ LayerID ].PKLayersBobs[ InPos ].ObjectName )
//			CurrentBOB = PKLayer[ LayerID ].PKLayersBobs[ InPos ].ObjectID
			If PKGetBobExists( CurrentBOB ) = TRUE 
				if Bobs[ CurrentBob ].Active = TRUE And Bobs[ CurrentBob ].Hide = 0
					XBob As Integer : XBob = Bobs[ CurrentBob ].XPos - XDisplay + XS
					YBob As Integer : YBob = Bobs[ CurrentBob ].YPos - YDisplay + YS
					If XBob > 0 - Bobs[ CurrentBob ].Width And XBob < ( XE - XS ) + Bobs[ CurrentBob ].Width
						If YBob > 0 - Bobs[ CurrentBob ].Height And YBob < ( YE - YS ) + Bobs[ CurrentBob ].Height
							internalPKDrawBOB( CurrentBOB, XBob, YBob, FALSE, FALSE )
						Endif
					Endif
				Endif
			Endif
		Next 
	Endif
EndFunction
