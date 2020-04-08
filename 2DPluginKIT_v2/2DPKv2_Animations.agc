
// *********************************************************
// *                                                       *
// * eXtends Ver 2.0 Include File : Animations Methods     *
// *                                                       *
// *********************************************************
// Start Date : 2020.03.22 21:53
// Description : These methods will add extra functionalities
//               to tiles and bobs to handle animations
// Author : Frédéric Cordier
//

//
// AnimationID = PKNewAnimation( FrameList )
// PKSetAnimationFrame( AnimationID, FrameID, ImageID )
// ImageID = PKGetAnimationFrameID( AnimationID, FrameID )
// ImageID = PKGetFrameImage( FrameList, FrameID )
// P2DK_UpdateAnimation( AnimationID )
// PKUpdateAnimations()
// internalPKSetAnimation( AnimationID, ObjectID, ObjectType, ObjectName )
// PKSetAnimationToTile( AnimationID, TileID )
// PKSetAnimationToBob( AnimationID, BlitterID )
// PKSetAnimationToSprite( AnimationID, SpriteID )
// PKSetAnimationSpeed( AnimationID, PlaySpeed )
// PKPlayAnimation( AnimationID )
// PKStopAnimation( AnimationID )
// PKLoopAnimation( AnimationID, TRUE/FALSE )
// PKDetachAnimationFromObject( AnimationID )
// TRUE/FALSE = PKGetAnimationPlaying( AnimationID )
// TRUE/FALSE = PKGetAnimationExists( AnimationID )
//

/* ************************************************************************
 * @Description : 
*/
Function PKNewAnimation( FrameList As String )
	// Create the object for the new animation
	newAnimation As PKAnimation_Type
    newAnimation.PlayANIM = 0
    newAnimation.ObjectID = 0
    newAnimation.ObjectType = 0
    newAnimation.ObjectName = NULL
    newAnimation.Speed = 10
    newAnimation.Active = 1
	newAnimation.ImageIDShift = 0
	// Now we get the frames to define them in the new animation
	FrameCount As Integer
	FrameCount = PKGetQuantity( FrameList, ";" ) - 1
	if FrameCount > 0
		fLoop As Integer = 0
		ImageID As Integer = 0
		TrueCount As Integer = 0
		for fLoop = 1 to FrameCount Step 1
			ImageID = PKGetframeImage( FrameList, fLoop )
			if ImageID > -1
				TrueCount = TrueCount + 1
				newAnimation.FramesList.insert( ImageID ) // Insère le nouvelle frame d'animation en fin de liste
			Else
				Message( "PKNewAnimation Error : There is a wrong FrameID in the list" )
				exit
			Endif
		Next fLoop
		newAnimation.FrameCount = FrameCount
	Else
		Message( "PKNewAnimation Error : The specified framelist does not contain any animation frame" )
	Endif
    // We insert the new object in the list
	PKAnimations.insert( newAnimation )
	// We get the animation ID
	AnimationID As Integer
	AnimationID = PKAnimations.length
	PKAnimations[ AnimationID ].LastFrame = PKGetAnimationFrameID( AnimationID, 1 )
EndFunction AnimationID	
	
	
Function PKSetAnimationFrameShift( AnimationID As Integer, ImageIDShift As Integer )
	if PKGetAnimationExists( AnimationID ) = TRUE
		PKAnimations[ AnimationID ].ImageIDShift = ImageIDShift
	Endif
EndFunction
/* ************************************************************************
 * @Description : 
*/
Function PKSetAnimationFrame( AnimationID As Integer, FrameID As Integer, ImageID As Integer )
	if PKGetAnimationExists( AnimationID ) = TRUE
		if FrameID > -1 and FrameID < ( PKAnimations[ AnimationID ].FramesList.length + 1 )
			PKAnimations[ AnimationID ].FramesList[ FrameID ] = ImageID
		Else
			Message( "PKSetAnimationFrame Error : The Requested FrameID does not exists in the specified AnimationID" )
		Endif
	Else
		Message( "PKSetAnimationFrame Error : The Requested AnimationID does not exists" )
	Endif
 EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKGetAnimationFrameID( AnimationID As Integer, FrameID As Integer )
	ImageID As Integer = -1
	if PKGetAnimationExists( AnimationID ) = TRUE
		if FrameID > -1 and FrameID < ( PKAnimations[ AnimationID ].FramesList.length + 1 )
			ImageID = PKAnimations[ AnimationID ].FramesList[ FrameID ]
		Else
			Message( "PKSetAnimationFrame Error : The Requested FrameID does not exists in the specified AnimationID" )
		Endif
	Else
		Message( "PKSetAnimationFrame Error : The Requested AnimationID does not exists" )
	Endif
 EndFunction ImageID 

/* ************************************************************************
 * @Description : 
*/
Function PKGetFrameImage( FrameLIST As String, FrameID As Integer )
	Retour As Integer = -1
	If Len( FrameLIST ) > 0
		POS1 As Integer = 0 : POS2 As Integer = 0
		InPOS As Integer = 1 : InCHAR As Integer = 0
		Repeat
			If Mid( FrameLIST, InPOS, 1 ) = ";"
				InCHAR = InCHAR + 1
				If InCHAR = FrameID : POS1 = InPOS + 1 : EndIf
				If InCHAR = FrameID + 1 : POS2 = InPOS : EndIf
			EndIf
			InPOS = InPOS + 1
		Until InPOS > Len( FrameLIST ) Or ( POS1 > 0 And POS2 > 0 )
		If POS1 > 0 And POS2 > 0
			Retour = Val( Mid( FrameLIST, POS1, POS2 - POS1 ) )
		Else
			Retour = 0
		EndIf
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function P2DK_UpdateAnimation( AnimationID As Integer )
	RealFRAME As Integer = 0
	FrameID As Integer = 0
	If PKAnimations[ AnimationID ].Speed <> 0 and PKAnimations[ AnimationID ].PlayANIM = TRUE
		Delay As Float : Delay = abs( ( PKSetup.NewTIMER - PKAnimations[ AnimationID ].StartTIMER ) / 1000.0 )
		Frame As Float : Frame = Delay * Abs( PKAnimations[ AnimationID ].Speed )
		Count As Integer : Count = Trunc( Frame / PKAnimations[ AnimationID ].FrameCOUNT )
		RealFRAME = Trunc( Frame - ( Count * PKAnimations[ AnimationID ].FrameCOUNT ) )
		If PKAnimations[ AnimationID ].LoopMODE = FALSE And RealFRAME = ( PKAnimations[ AnimationID ].FrameCOUNT - 1)
			RealFRAME = PKAnimations[ AnimationID ].FrameCOUNT - 1
			PKAnimations[ AnimationID ].PlayANIM = 0
			PKAnimations[ AnimationID ].Speed = 0
			PKAnimations[ AnimationID ].StartTIMER = -1
		EndIf
		FrameID = PKGetAnimationFrameID( AnimationID, RealFRAME )
		If FrameID > -1
			PKAnimations[ AnimationID ].LastFRAME = FrameID
			Select PKAnimations[ AnimationID ].ObjectType
				// Update de la frame d'animation dans la tile affectée
				Case PKObjectType.Tile
					PKTile[ PKAnimations[ AnimationID ].ObjectID ].AnimFrameID = FrameID + PKAnimations[ AnimationID ].ImageIDShift
				EndCase
				Case PKObjectType.Bob
				// Update de la frame d'animation dans le Blitter Object affecté.
					// If Bobs[ PKAnimations[ AnimationID ].ObjectID ].Active = 1
						Bobs[ PKAnimations[ AnimationID ].ObjectID ].CurrentFrame = FrameID + PKAnimations[ AnimationID ].ImageIDShift
					// EndIf
				EndCase
				Case PKObjectType.Sprite
				// Update de la frame d'animation dans le sprite affecté.
					If GetImageExists( PKAnimations[ AnimationID ].ObjectID ) = 1 // And GetImageExists( ImageID ) = 1 // ****************  to be commented or not ???
						// SetSpriteImage( PKAnimations[ AnimationID ].ObjectID, ImageID )
						SetSpritePosition( PKAnimations[ AnimationID ].ObjectID, getSpriteX( PKAnimations[ AnimationID ].ObjectID ), GetSpriteY( PKAnimations[ AnimationID ].ObjectID ) )
						// DBSprite( PKAnimations[ AnimationID ].ObjectID, DBGetSpritePositionX( PKAnimations[ AnimationID ].ObjectID ), DBGetSpritePositionY( PKAnimations[ AnimationID ].ObjectID ), ImageID )
					EndIf
				EndCase
			EndSelect
		EndIf
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKUpdateAnimations()
	AnimPlayer As Integer = 0
	if PKAnimations.length > -1
		For AnimPLAYER = 0 To PKAnimations.length
			If PKAnimations[ AnimPLAYER ].PlayANIM = 1
				If PKAnimations[ AnimPLAYER ].StartTIMER = 0 then PKAnimations[ AnimPLAYER ].StartTIMER = PKSetup.NewTimer
				P2DK_UpdateAnimation( AnimPLAYER )
			EndIf
		Next AnimPLAYER
	Endif
EndFunction


/* ************************************************************************
 * @Description : 
*/
Function internalPKSetAnimation( AnimationID As Integer, ObjectID As Integer, ObjectType As Integer, ObjectName As String )
	PKAnimations[ AnimationID ].Active = 1
	PKAnimations[ AnimationID ].LoopMODE = 1
//	PKAnimations[ AnimationID ].FrameCount = 0
//	PKAnimations[ AnimationID ].LastFRAME = 0
	PKAnimations[ AnimationID ].PlayANIM = FALSE
	PKAnimations[ AnimationID ].StartTIMER = 0
	PKAnimations[ AnimationID ].ObjectID = ObjectID
	PKAnimations[ AnimationID ].ObjectName = ObjectName
	PKAnimations[ AnimationID ].ObjectType = ObjectType
EndFunction
	
/* ************************************************************************
 * @Description : 
*/
Function PKSetAnimationToTile( AnimationID As Integer, TileID As Integer )
	If PKGetTileExists( TileID ) = TRUE
		internalPKSetAnimation( AnimationID, TileID, PKObjectType.Tile, PKTile[ TileID ].FileName )
        PKTile[ TileID ].AnimationID = AnimationID
	Else
		Message( "PluginKIT Error : Tile does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetAnimationToBob( AnimationID As Integer, BlitterID As Integer )
    If PKGetBobExists( BlitterID ) = TRUE
		internalPKSetAnimation( AnimationID,BlitterID, PKObjectType.Bob, Bobs[ BlitterID ].Name )
        Bobs[ BlitterID ].AnimationID = AnimationID
	Else
		Message( "PluginKIT Error : Blitter Object does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetAnimationToSprite( AnimationID As Integer, SpriteID As Integer )
    If GetSpriteExists( SpriteID ) = TRUE
		internalPKSetAnimation( AnimationID,SpriteID, PKObjectType.Sprite, NULL )
	Else
		Message( "PluginKIT Error : AGK Sprite does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetAnimationSpeed( AnimationID As Integer, PlaySPEED As Integer )
	if PKGetAnimationExists( AnimationID ) = TRUE
		PKAnimations[ AnimationID ].Speed = PlaySPEED
	Else
		Message( "PluginKIT Error : Animation sequence does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKPlayAnimation( AnimationID As Integer )
	if PKGetAnimationExists( AnimationID ) = TRUE
		PKAnimations[ AnimationID ].PlayANIM = TRUE
		PKAnimations[ AnimationID ].StartTIMER = Timer() * 1000  // Timer is in seconds from start of APPGameKit. So *1000 for 1/1000s precision.
	Else
		Message( "PluginKIT Error : Animation sequence does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKStopAnimation( AnimationID As Integer )
	if PKGetAnimationExists( AnimationID ) = TRUE
		PKAnimations[ AnimationID ].PlayANIM = 0
		PKAnimations[ AnimationID ].StartTIMER = -1
	Else
		Message( "PluginKIT Error : Animation sequence does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKLoopAnimation( AnimationID As Integer, LoopMODE As Integer )
	if PKGetAnimationExists( AnimationID ) = TRUE
		PKAnimations[ AnimationID ].LoopMODE = LoopMODE
	Else
		Message( "PluginKIT Error : Animation sequence does not exist" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKDetachAnimationFromObject( AnimationID )
	if PKGetAnimationExists( AnimationID ) = TRUE
		PKAnimations[ AnimationID ].ObjectID = -1
		Select PKAnimations[ AnimationID ].ObjectType
			Case PKObjectType.Tile
				If PKGetTileExists( PKAnimations[ AnimationID ].ObjectID  ) = TRUE
					PKTile[ PKAnimations[ AnimationID ].ObjectID  ].AnimationID = -1
				Else
					Message( "PluginKIT Error : Tile does not exist" )
				EndIf
			EndCase
			Case PKObjectType.Bob
				If PKGetBobExists( PKAnimations[ AnimationID ].ObjectID  ) = TRUE
					Bobs[ PKAnimations[ AnimationID ].ObjectID  ].AnimationID = AnimationID
				Else
					Message( "PluginKIT Error : Blitter Object does not exist" )
				EndIf
			EndCase
			Case PKObjectType.Sprite
			EndCase
		EndSelect
		PKAnimations[ AnimationID ].ObjectType = PKObjectType.Undefined
		PKAnimations[ AnimationID ].PlayANIM = FALSE
	Else
		Message( "PluginKIT Error : Animation sequence does not exist" )
	EndIf

EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKGetAnimationPlaying( AnimationID As Integer )
	Retour As Integer = 0
	if PKGetAnimationExists( AnimationID ) = TRUE
		Retour = PKAnimations[ AnimationID ].PlayANIM
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description : 
*/
Function PKGetAnimationExists( AnimationID As Integer )
	isExists As Integer
	if AnimationID > -1 and AnimationID < ( PKAnimations.length + 1 )
		isExists = TRUE
	Else
		isExists = FALSE
	Endif
EndFunction isExists
