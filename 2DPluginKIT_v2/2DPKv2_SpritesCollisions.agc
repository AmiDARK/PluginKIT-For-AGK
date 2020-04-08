//
// ******************************************************************************
// *                                                                            *
// * 2DPluginKIT Ver 2.0 Include File : Sprites/Images Collision System methods *
// *                                                                            *
// ******************************************************************************
// Start Date : 2019.04.23 23:15
// Description : This class will contain mathematics methods
// 
// Author : Frédéric Cordier
//

/* ************************************************************************
 * @Description : This method will create a memblock for Image/Sprite collision data directly from file
 *
 * @Param : ImageID = The index number of the image we will create a collision data
 *
 * @Author : Frédéric Cordier
*/
Function PKCreateImageCollisionData( ImageID As Integer )
	iData As Integer = -1
	if GetImageExists( ImageID ) = TRUE 
		if getImageCollisionDataExists( ImageID ) = FALSE
			newICData As SPCollision_Type
			newICData.ImageID = ImageID
			newICData.srcFileName = GetImageFilename( ImageID )
			newICData.MemblockID = CreateMemblockFromImage( ImageID )
			SprCollision.insert( newICData )
			iData = SprCollision.length
		else
			iData = Internal_FindImageCollisionData( ImageID )
		Endif // No error message if image collision data already exists.
	Else
		Message( "PKCreateImageCollisionData Error : ImageID is incorrect or Image does not exist." )
	Endif
EndFunction iData

/* ************************************************************************
 * @Description : This method will create a memblock for Image/Sprite collision data using an image file
 *
 * @Param : ImageID = The index number of the image we will create a collision data
 * @Param : ImageFile = the image to load to create the collision data
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadImageCollisionDataFromImageFile( ImageID As Integer, ImageFile As String )
	iData As Integer = -1
	if GetFileExists( Imagefile ) = TRUE
		if GetImageExists( ImageID ) = TRUE
			if getImageCollisionDataExists( ImageID ) = FALSE
				newICData As SPCollision_Type
				newICData.ImageID = ImageID
				newICData.srcFileName = GetImageFilename( ImageID )
				imageData As Integer
				imageData = LoadImage( ImageFile )
				newICData.MemblockID = CreateMemblockFromImage( imageData )
				SprCollision.insert( newICData )
				iData = SprCollision.length
			else
				iData = Internal_FindImageCollisionData( ImageID )
			Endif
		Else
			Message( "PKLoadImageCollisionDataFromImageFile Error : ImageID is incorrect or Image does not exist." )
		Endif
	Else
		Message( "PKLoadImageCollisionDataFromImageFile Error : Image File '" + ImageFile + "' does not exists" )
	Endif
EndFunction iData

/* ************************************************************************
 * @Description : This method will create a memblock for Image/Sprite collision data using a data file
 *                A data file is an image converted into a Memblock and then saved to disk. It is useful
 *                To save Image Data after they were converted to 8 Bits because 8 bits conversion is slow,
 *                but the use of 8 bits image memblock consume less memory than original 32 bits one.
 *
 * @Param : ImageID = The index number of the image we will create a collision data
 * @Param : dataFile = The name of the file to use to create collision data
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadImageCollisionDataFromDataFile( ImageID As Integer, dataFile As String )
	iData As Integer = -1
	if GetFileExists( dataFile ) = TRUE
		if GetImageExists( ImageID ) = TRUE
			if getImageCollisionDataExists( ImageID ) = FALSE
				newICData As SPCollision_Type
				newICData.ImageID = ImageID
				newICData.srcFileName = GetImageFilename( ImageID )
				newICData.MemblockID = CreateMemblockFromFile( dataFile )
				SprCollision.insert( newICData )
				iData = SprCollision.length
			else
				iData = Internal_FindImageCollisionData( ImageID )
			Endif
		Else
			Message( "PKLoadImageCollisionDataFromImageFile Error : ImageID is incorrect or Image does not exist." )
		Endif
	Else
		Message( "PKLoadImageCollisionDataFromImageFile Error : Data File '" + dataFile + "' does not exists" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : This method will convert a 32 bits collision data into a 8 bits black/transparent collision data
 *
 * @Param : ImageID = The index number of the image we will create a collision data
 *
 * @Author : Frédéric Cordier
*/
Function PKConvertImageCollisionDataTo8Bits( ImageID As Integer )
	index As Integer
	index = Internal_FindImageCollisionData( ImageID )
	if index > -1
		newMBC As Integer = 0
		Width As Integer = 0 : Width = XTGetImageMemblockWidth( SprCollision[ index ].MemblockID )
		Height As Integer = 0 : Height = XTGetImageMemblockHeight( SprCollision[ index ].MemblockID )
		newMBC = XTCreateImageMemblock( Width, Height, 8 )
		YLoop As Integer = 0 : XLoop As Integer = 0
		RGBColor As Integer = 0
		For YLoop = 0 to Height -1
			For XLoop = 0 to Width -1
				RGBColor = XTReadMemblockPixel( SprCollision[ index ].MemblockID, XLoop, YLoop )
				If RGBColor > 0 then RGBColor = 255 Else RGBColor = 0
				XTWriteMemblockPixel( newMBC, XLoop, YLoop, RGBColor )
			Next XLoop
		Next YLoop
		DeleteMemblock( SprCollision[ index ].MemblockID )
		SprCollision[ index ].MemblockID = newMBC
	Else
		Message( "PKConvertImageCollisionDataTo8Bits Error : No Collision Data were created for ImageID " + Str( ImageID ) + "." )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Return TRUE of a collision data was created for the requested image
 *
 * @Param : ImageID = The index number of the image we will create a collision data
 *
 * @Return : isExist = TRUE is the collision data exists, otherwise FALSE
 *
 * @Author : Frédéric Cordier
*/
Function getImageCollisionDataExists( ImageID )
	isExist As Integer = 0
	if Internal_FindImageCollisionData( ImageID ) > -1 then isExist = TRUE
EndFunction isExist

/* ************************************************************************
 * @Description : Return the index of the image collision data in the dedicaced array SprCollision[]
 *
 * @Param : ImageID = The index number of the image we will create a collision data
 *
 * @Return : iPos = The index number of the collision data in the SprCollision[] array is exists, otherwise -1
 *
 * @Author : Frédéric Cordier
*/
Function Internal_FindImageCollisionData( ImageID As Integer )
	iPos As Integer = -1
	if SprCollision.length > -1
		iLoop As Integer = 0
		repeat
			if SprCollision[ iLoop ].ImageID = ImageID then iPos = iLoop
			Inc iLoop, 1
		until iPos > -1 or iLoop > SprCollision.length
	Endif
EndFunction iPos

/* ************************************************************************
 * @Description : Save existing image collision data in a file (on disk)
 *
 * @Param : ImageID = the image index number of which we want to save the collision data on disk
 *
 * @Author : Frédéric Cordier
*/
Function PKSaveImageCollisionData( ImageID As Integer )
	iPos As Integer = -1
	iPos = Internal_FindImageCollisionData( ImageID )
	if iPos > -1
		tempName As String
		tempName = SprCollision[ iPos ].srcFileName
		tempName = Replace( tempName, ".png", "_colData.raw" )
		tempName = Replace( tempName, ".jpg", "_colData.raw" )
		CreateFileFromMemblock( tempName, SprCollision[ iPos ].MemblockID )
	Else
		Message( "PKSaveImageCollisionData Error : No Collision Data were created for ImageID " + Str( ImageID ) + "." )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Delete a memory block that was created to store image collision datas
 *
 * @Param : Image ID = the Image index number of which we want to delete the collisions data
 *
 * @Author : Frédéric Cordier
*/
Function PKClearImageCollisionData( ImageID As Integer )
	iPos As Integer = -1
	iPos = Internal_FindImageCollisionData( ImageID )
	if iPos > -1
		DeleteMemblock( SprCollision[ iPos ].MemblockID )
		SprCollision.remove( iPos )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Delete all collisions data that were previously created
 *
 * @Author : Frédéric Cordier
*/
Function PKClearAllImageCollisionDatas()
	sLoop As Integer = 0
	if SprCollision.length > -1
		for sLoop = SprCollision.length to 0 step -1
			DeleteMemblock( SprCollision[ sLoop ].MemblockID )
			SprCollision.remove( sLoop )
		Next sLoop
	Endif
EndFunction

/* ************************************************************************
 * @Description : Optimised version of the Sprites Collisions detection method.
 *
 * @Param : Sprite1 = The 1st sprite
 * @Param : Sprite2 = The 2nd sprite
 * @Param : _MODE = The collision mode ( 0=Detect collision, 1=Calculate pixels in collisions)
 *
 * @Return : _PIXEL, on _MODE = 0, will return FALSE (0) if no collision is detected, or TRUE (1) if a collision was detected
 *           in _MODE=1, it will return the amount of pixels of 1st sprite that are overlaped by the other sprite (possible Performance hit)
 *
 * @Author : Frédéric Cordier
*/
Function PKGetSpriteCollisionOPT( Sprite1 As Integer, Sprite2 As Integer, _MODE As Integer )
	_CHECK As Integer = 0 : _PIXEL As Integer = 0
	SpriteCOL1 As Integer = 0 : SpriteCOL2 As Integer = 0
	xstart1 As Integer = 0 : xstart2 As Integer = 0
	ystart1 As Integer = 0 : ystart2 As Integer = 0
	xchecksize As Integer = 0 : ychecksize As Integer = 0
	// 1 / On saisit les coordonnées et dimensions pour vérifier si il y a collision des cadres.
	xp1 As Integer : xp1 = GetSpriteX( Sprite1 )
	yp1 As Integer : yp1 = GetSpriteY( Sprite1 )
	xs1 As Integer : xs1 = GetSpriteWidth( Sprite1 )
	ys1 As Integer : ys1 = GetSpriteHeight( Sprite1 )
	xp2 As Integer : xp2 = GetSpriteX( Sprite2 )
	yp2 As Integer : yp2 = GetSpriteY( Sprite2 )
	xs2 As Integer : xs2 = GetSpriteWidth( Sprite2 )
	ys2 As Integer : ys2 = GetSpriteHeight( Sprite2 )
	// 2 / On calcule si il y a collision des cadres.
	If xp2 > ( xp1 + xs1 ) Or xp2 < ( xp1 - xs2 ) : _CHECK = 0 : Else : _CHECK = 1 : EndIf
	If yp2 > ( yp1 + ys1 ) Or yp2 < ( yp1 - ys2 ) : _CHECK = 0 : EndIf
	// 3 / Si il y a collision des cadres, on calcule la collision au pixel près.
	If _CHECK = 1
		// 4A / On Update l'image utilisée par le sprite 1.
		SpriteImage1 As Integer : SpriteImage1 = GetSpriteImageID( Sprite1 )
		If getImageExists( SpriteImage1 )
			SpriteCOL1 = PKCreateImageCollisionData( SpriteImage1 )
		EndIf
		// 4B / Meme manipulation pour le sprite 2.
		SpriteImage2 As Integer : SpriteImage2 = GetSpriteImageID( Sprite2 )
		If getImageExists( SpriteImage2 )
			SpriteCOL2 = PKCreateImageCollisionData( SpriteImage2 )
		EndIf
		// 5 / On lit les coordonnées et dimensions des parties communes des 2 sprites.
		If xp2 > xp1
			xstart1 = xp2 - xp1
			xstart2 = 0 
			xchecksize = xs1 - xstart1
		Else
			xstart1 = 0
			xstart2 = xp1 - xp2
			xchecksize = xs2 - xstart2
		EndIf
		If yp2 > yp1
			ystart1 = yp2 - yp1
			ystart2 = 0
			ychecksize = ys1 - ystart1
		Else
			ystart1 = 0
			ystart2 = yp1 - yp2
			ychecksize = ys2 - ystart2
		EndIf
		// 6 / Maintenant, on compare les pixels communs pour voir si il y a collision et, de combien de pixels.
		XLoop As Integer = 0 : YLoop As Integer = 0
		YLoop = 0 : Repeat
			XLoop = 0 : Repeat
				_pix1 As Integer = 0 : _pix2 As Integer = 0
				xpos As Integer : xpos = xloop + xstart1
				ypos As Integer : ypos = yloop + ystart1
				_pix1 = XTReadMemblockPixel( SpriteCOL1, xpos, ypos )
				xpos = xloop + xstart2 : ypos = yloop + ystart2
				_pix2 = XTReadMemblockPixel( SpriteCOL2, xpos, ypos )
				If _pix1 <> 0 And _pix2 <> 0 : _PIXEL=_PIXEL+1 : EndIf
				If _PIXEL > 0 And _MODE = 0
					xloop = xchecksize : yloop = ychecksize
				EndIf
				XLoop = XLoop + 1
			Until XLoop > xchecksize
			YLoop = YLoop + 1
		Until YLoop > ychecksize
	Else
		_PIXEL = 0
	EndIf
EndFunction _PIXEL

/* ************************************************************************
 * @Description : ADvanced version of the Sprites Collisions detection method.
 *
 * @Param : Sprite1 = The 1st sprite
 * @Param : Sprite2 = The 2nd sprite
 * @Param : _MODE = The collision mode ( 0=Detect collision, 1=Calculate pixels in collisions)
 *
 * @Return : _PIXEL, on _MODE = 0, will return FALSE (0) if no collision is detected, or TRUE (1) if a collision was detected
 *           in _MODE=1, it will return the amount of pixels of 1st sprite that are overlaped by the other sprite (possible Performance hit)
 *
 * @Author : Frédéric Cordier
*/
Function PKGetSpriteCollisionAdvanced( M_Sprite1 As Integer, M_Sprite2 As Integer, COLMODE As Integer )
	_PIXEL As Integer = 0
	XMax1 As Integer = -1 : YMax1 As Integer = -1 : XMax2 As Integer = -1 : YMax2 As Integer = -1
	XMin1 As Integer = 8000 : YMin1 As Integer = 8000 : XMin2 As Integer = 8000 : YMin2 As Integer = 8000
	XLoop As Integer = 0 : YLoop As Integer
	XStart As Integer = -1 : YStart As Integer = -1 : XEnd As Integer = -1 : YEnd As Integer = -1
	Pixel1 As Integer = 0 : Pixel2 As Integer = 0
	// Firstly, we'll calculate the 4 rounding spot positions : SPRITE#1
	XSize As Float : XSize = GetSpriteWidth( M_Sprite1 ) // * DBGetSpriteXScale( _Sprite1 ) / 100.0
	YSize As Float : YSize = GetSpriteHeight( M_Sprite1 ) // * DBGetSpriteYScale( _Sprite1 ) / 100.0
	// Angle1 As Float = Deg2Rad( GetSpriteAngle( M_Sprite1 ) )
	// Angle2 As Float = Deg2Rad( 0.0 - GetSpriteAngle( M_Sprite1 ) ) )
	Angle1 As Float : Angle1 = GetSpriteAngle( M_Sprite1 )
	Angle2 As Float : Angle2 = 0.0 - GetSpriteAngle( M_Sprite1 )
	// Top Left
	SpotA[ 1 ].XPos = 0 + GetSpriteX( M_Sprite1 )
	SpotA[ 1 ].YPos = 0 + GetSpriteY( M_Sprite1 )
	// Top Right
	SpotA[ 2 ].Xpos = ( XSize * Cos( Angle1 ) ) + GetSpriteX( M_Sprite1 )
	SpotA[ 2 ].Ypos = ( XSize * Sin( Angle1 ) ) + GetSpriteY( M_Sprite1 )
	// Bottom Left
	SpotA[ 3 ].XPos = ( YSize * Sin( Angle2 ) ) + GetSpriteX( M_Sprite1 )
	SpotA[ 3 ].YPos = ( YSize * Cos( Angle2 ) ) + GetSpriteY( M_Sprite1 )
	// Bottom Right
	SpotA[ 4 ].Xpos = SpotA[ 3 ].Xpos + ( SpotA[ 2 ].Xpos - SpotA[ 1 ].Xpos )
	SpotA[ 4 ].Ypos = SpotA[ 3 ].Ypos + ( SpotA[ 2 ].Ypos - SpotA[ 1 ].Ypos )

	// Secondly, we'll calculate the 4 rounding spot positions : SPRITE#2
	XSize = GetSpriteWidth( M_Sprite2 ) // * DBGetSpriteXScale( _Sprite2 ) / 100.0
	YSize = GetSpriteHeight( M_Sprite2 ) // * DBGetSpriteYScale( _Sprite2 ) / 100.0
	// Angle1 As Float = Deg2Rad( GetSpriteAngle( M_Sprite2 ) )
	// Angle2 As Float = Deg2Rad( 0.0 - GetSpriteAngle( M_Sprite2 ) )
	Angle1 = GetSpriteAngle( M_Sprite2 )
	Angle2 = 0.0 - GetSpriteAngle( M_Sprite2 )
	// Top Left
	SpotB[ 1 ].XPos = 0 + GetSpriteX( M_Sprite2 )
	SpotB[ 1 ].YPos = 0 + GetSpriteY( M_Sprite2 )
	// Top Right
	SpotB[ 2 ].Xpos = ( XSize * Cos( Angle1 ) ) + GetSpriteX( M_Sprite2 )
	SpotB[ 2 ].Ypos = ( XSize * Sin( Angle1 ) ) + GetSpriteY( M_Sprite2 )
	// Bottom Left
	SpotB[ 3 ].XPos = ( YSize * Sin( Angle2 ) ) + GetSpriteX( M_Sprite2 )
	SpotB[ 3 ].YPos = ( YSize * Cos( Angle2 ) ) + GetSpriteY( M_Sprite2 )
	// Bottom Right
	SpotB[ 4 ].Xpos = SpotB[ 3 ].Xpos + ( SpotB[ 2 ].Xpos - SpotB[ 1 ].Xpos )
	SpotB[ 4 ].Ypos = SpotB[ 3 ].Ypos + ( SpotB[ 2 ].Ypos - SpotB[ 1 ].Ypos )

	// We check now to know if a collision box exist between 2 boxes defined.
	For XLoop = 1 To 4
		If SpotA[ XLoop ].Xpos < XMin1 : XMin1 = SpotA[ XLoop ].Xpos : EndIf
		If SpotA[ XLoop ].Ypos < YMin1 : YMin1 = SpotA[ XLoop ].Ypos : EndIf
		If SpotA[ XLoop ].Xpos > XMax1 : XMax1 = SpotA[ XLoop ].Xpos : EndIf
		If SpotA[ XLoop ].Ypos > YMax1 : YMax1 = SpotA[ XLoop ].Ypos : EndIf
		If SpotB[ XLoop ].Xpos < XMin2 : XMin2 = SpotB[ XLoop ].Xpos : EndIf
		If SpotB[ XLoop ].Ypos < YMin2 : YMin2 = SpotB[ XLoop ].Ypos : EndIf
		If SpotB[ XLoop ].Xpos > XMax2 : XMax2 = SpotB[ XLoop ].Xpos : EndIf
		If SpotB[ XLoop ].Ypos > YMax2 : YMax2 = SpotB[ XLoop ].Ypos : EndIf
	Next XLoop
	If XMin1 < XMin2 : XStart = XMin2 : Else : XStart = XMin1 : EndIf
	If XMax1 < XMax2 : XEnd = XMax1 : Else : XEnd = XMax2 : EndIf
	If YMin1 < YMin2 : YStart = YMin2 : Else : YStart = YMin1 : EndIf
	If YMax1 < YMax2 : YEnd = YMax1 : Else : YEnd = YMax2 : EndIf
	If XMax1 > XMin2 And XMin1 < XMax2
		If YMax1 > YMin2 And YMin1 < YMax2
			SpriteCOL1 As Integer : SpriteCOL2 As Integer
			// SI l'on a détecté qu'une collision était possible, on update les 2 sprites : images&memblocks
			// 4A / On Update l'image utilisée par le sprite 1.
			SpriteImage1 As Integer : SpriteImage1 = GetSpriteImageID( M_Sprite1 )
			If getImageExists( SpriteImage1 )
				SpriteCOL1 = PKCreateImageCollisionData( SpriteImage1 )
			EndIf
			// 4B / Meme manipulation pour le sprite 2.
			SpriteImage2 As Integer : SpriteImage2 = GetSpriteImageID( M_Sprite2 )
			If getImageExists( SpriteImage2 )
				SpriteCOL2 = PKCreateImageCollisionData( SpriteImage2 )
			EndIf
			// Maintenant on procède aux calculs de collisions ...
			YLoop = YStart : Repeat
			// For YLoop = YStart To YEnd
				XLoop = XStart : Repeat
				// For XLoop = XStart To XEnd
					Pixel1 = Internal_GetSpritePixel( M_Sprite1, XLoop, YLoop, SpriteCOL1 )
					Pixel2 = Internal_GetSpritePixel( M_Sprite2, XLoop, YLoop, SpriteCOL2 )
					// Pixel Collision detected ?
					If Pixel1 <> 0 And Pixel2 <> 0
						_PIXEL = _PIXEL + 1
						If COLMODE = 0 : XLoop = XEnd - 1 : YLoop = YEnd - 1 : EndIf
					EndIf
				// Next XLoop
				XLoop = XLoop + 1 : Until XLoop = XEnd
			// Next YLoop
			YLoop = YLoop + 1 : Until YLoop = YEnd
		EndIf
	EndIf
 EndFunction _PIXEL

/* ************************************************************************
 * @Description : Return the color of a pixel of a specified sprite
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_GetSpritePixel( Spr As Integer, XScreen As Integer, YScreen As Integer, SprImageCollisionData )
	// Now we take the coordinate of the screen pixel To see If it's in the memblock image or outside.
	XPosInRot As Float = 0 : XPosInRot = XScreen - GetSpriteX( Spr )
	YPosInRot As Float = 0 : YPosInRot = YScreen - GetSpriteY( Spr )
	// Angle1 As Float = 0 : Angle1 = Deg2Rad( GetSpriteAngle( Spr ) )
	// Angle2 As Float = 0 : Angle2 = Deg2Rad( 0.0 - GetSpriteAngle( Spr ) )
	Angle1 As Float = 0 : Angle1 = GetSpriteAngle( Spr )
	Angle2 As Float = 0 : Angle2 = 0.0 - GetSpriteAngle( Spr )
	XPosInFinal As Float = 0 : XPosInFinal = ( ( Cos( Angle2 ) * XPosInRot ) - ( Sin( Angle2 ) * YPosInRot ) ) / ( GetSpriteScaleX( Spr ) / 100.0 )
	YPosInFinal As Float = 0 : YPosInFinal = ( ( Sin( Angle2 ) * XPosInRot ) + ( Cos( Angle2 ) * YPosInRot ) ) / ( GetSpriteScaleY( Spr ) / 100.0 )
	// Update to handle Mirror sprite
	If GetSpriteFlippedH( Spr ) = 1
		XPosInFinal = GetSpriteWidth( spr ) - XPosInFinal    
	EndIf
	// Update to handle flipped sprite
	If GetSpriteFlippedV( Spr ) = 1
		YPosInFinal = GetSpriteHeight( Spr ) - YPosInFinal
	EndIf
	// Update to handle offset sprite
	XPosInFinal = XPosInFinal + GetSpriteOffsetX( Spr )
	YPosInFinal = YPosInFinal + GetSpriteOffsetY( Spr )
	// Get the pixel color.
	COLOR As Integer : COLOR = XTReadMemblockPixel( SprImageCollisionData, XPosInFinal, YPosInFinal )
EndFunction COLOR
