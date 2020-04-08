//
// *************************************************************************
// *                                                                       *
// * DarkBASIC Professional Emulation Ver 1.0 Include File : Image methods *
// *                                                                       *
// *************************************************************************
// Start Date : 2019.05.15 21:48
// Description : This class will contain all images methods
// 
// Author : Frédéric Cordier
//

/* ************************************************************************
 * @Description : This method will draw an image on screen (or in renderImage)
 *
 * @Param : ImageID = the index number of the Image to draw on Screen (or in renderImage)
 * @Param : XPos = The X Coordinate where the image will start to be drawn
 * @Param : YPos = The Y Coordinate where the image will start to be drawn
 * @Param : TransparencyMode = 1 to hide black color, 0 to draw it.
 *
 * @Author : Frédéric Cordier
*/
Function dbPasteImageEx( ImageID As Integer, XPos As Integer, YPos As Integer, TransparencyMode As Integer )
	if GetImagEexists( ImageID ) = TRUE
		if getSpriteExists( dbImageSPR ) = TRUE
			SetSpriteImage( dbImageSPR, ImageID )
			SetSpriteSize( dbImageSPR, -1, -1 )
			SetSpriteVisible( dbImageSPR, TRUE )
		Else
			dbImageSPR = CreateSprite( ImageID )
		Endif
		SetSpritePosition( dbImageSPR, XPos, YPos )
		SetSpriteTransparency( dbImageSPR, TransparencyMode )
		DrawSprite( dbImageSPR )
		SetSpriteVisible( dbImageSPR, FALSE )
	Else
		Message( "dbPasteImageEx Error : Image index '" + Str( ImageId ) + "' is invalid or image does not exists" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : This method will draw an image on screen (or in renderImage)
 *
 * @Param : ImageID = the index number of the Image to draw on Screen (or in renderImage)
 * @Param : XPos = The X Coordinate where the image will start to be drawn
 * @Param : YPos = The Y Coordinate where the image will start to be drawn
 *
 * @Author : Frédéric Cordier
*/
Function dbPasteImage( ImageID As Integer, XPos As Integer, YPos As Integer )
	dbPasteImageEx( ImageID, XPos, YPos, 0 )
EndFunction


Function dbGetImageData( ImageID As Integer )
	if GetImageExists( ImageID ) = 1
		if DBimageData.find( ImageID ) = -1
			newImageData as DBImageData_Type
			newImageData.imageID = ImageID
			newImageData.MemblockID = CreateMemblockFromImage( ImageID )
			newImageData.isModified = 0
			newImageData.Width = GetImageWidth( ImageID )
			newImageData.height = GetImageHeight( ImageId )
			newImageData.Depth = GetMemblockInt( newImageData.MemblockID, 8 ) // 0 = Width, 4 = Height, 8 = Depth
		Endif
	Else
		Message( "dbGetImageData : The requested Image " + Str( ImageID ) + " does not exists" )
	Endif
EndFunction

Function dbWriteImagePixel( ImageID As Integer, XPos As Integer, YPos As Integer, PixelColor As Integer )
	if GetImageExists( ImageID ) = 1
		imageData As Integer
		imageData = DBimageData.find( ImageID )
		if imageData = -1
			Message( "You must use dbGetImageData(ImageID) before using dbWriteImagePixel(...) function" )
		Else
			XTWriteMemblockPixel( DBImageData[ imageData ].MemblockID, XPos, YPos, PixelColor )
			DBImageData[ imageData ].isModified = 1
		Endif
	Endif
EndFunction

Function dbReadImagePixel( ImageID As Integer, XPos As Integer, YPos As Integer )
	PixelColor As Integer = -1
	if GetImageExists( ImageID ) = 1
		imageData As Integer
		imageData = DBimageData.find( ImageID )
		if imageData = -1
			Message( "You must use dbGetImageData(ImageID) before using dbReadImagePixel(...) function" )
		Else
			PixelColor = XTReadMemblockPixel( DBImageData[ imageData ].MemblockID, XPos, YPos )
		Endif
	Endif
EndFunction PixelColor

Function dbUpdateImageData( ImageID As Integer )
	if GetImageExists( ImageID ) = 1
		imageData As Integer
		imageData = DBimageData.find( ImageID )
		if imageData = -1
			Message( "You must use dbGetImageData(ImageID) before using dbUpdateImage(...) function" )
		Else
			if DBImageData[ imageData ].isModified = 1
				CreateImageFromMemblock( ImageID, DBImageData[ imageData ].MemblockID )
			Endif
			DeleteMemblock( DBImageData[ imageData ].MemblockID )
			DBImageData.remove( imageData )
		Endif
	Endif
EndFunction

Function dbClearImageData( ImageID As Integer )
	if GetImageExists( ImageID ) = 1
		imageData As Integer
		imageData = DBimageData.find( ImageID )
		if imageData = -1
			Message( "You must use dbGetImageData(ImageID) before using dbClearImageData(...) function" )
		Else
			DeleteMemblock( DBImageData[ imageData ].MemblockID )
			DBImageData.remove( imageData )
		Endif
	Endif
EndFunction
	
Function dbClearAllImagesData()
	if ( DBImageData.length > -1 )
		Repeat
			DeleteMemblock( DBImageData[ 0 ].MemblockID )
			DBImageData.remove( 0 )
		Until DBimageData.length = -1
	Endif
EndFunction
