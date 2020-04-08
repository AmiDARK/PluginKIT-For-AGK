//
// *******************************************************
// *                                                     *
// * eXtends Ver 2.0 Include File : eXtends XFont System *
// *                                                     *
// *******************************************************
// Start Date : 2019.05.08 23:29
// Description : Ce système gère des bitmaps virtuels au travers de RenderImage
//
// Author : Frédéric Cordier

/* ************************************************************************
 * @Description : This method will create an emulation of DarkBASIC Professional's BITMAPS
 *
 * @Param : Name = The name that will be given to the new XBitmap
 * @Param : Width = The width in pixels of the new XBitmap
 * @Param : Height = The height in pixels of the new XBitmap
 * @Param : UseMipMaps = Flag to set (=1) or unset (=0) the use of mipmaps
 *
 * @Return : The ID of the new XBitmap
 *
 * @Author : Frédéric Cordier
*/
Function XTCreateXBitmapEx( Name As String, Width as Integer, Height As Integer, UseMipMaps As Integer )
	bLength As Integer
	newBitmap As XBitmap_Type
	newBitmap.RenderImage = CreateRenderImage( Width, Height, 0, UseMipMaps )
	newBitmap.Width = Width
	newBitmap.Height = Height
	newBitmap.Name = Name
	XBitmap.insert( newBitmap )
	bLength = XBitmap.length
	// On rends le nouveau XBitmap créé actif
	XTCurrentXBitmap = bLength
	SetRenderToImage( newBitmap.RenderImage, 0 )
EndFunction bLength

/* ************************************************************************
 * @Description : This method will create an emulation of DarkBASIC Professional's BITMAPS
 *
 * @Param : Name = The name that will be given to the new XBitmap
 * @Param : Width = The width in pixels of the new XBitmap
 * @Param : Height = The height in pixels of the new XBitmap
 *
 * @Return : The ID of the new XBitmap
 *
 * @Author : Frédéric Cordier
*/
Function XTCreateXBitmap( Name As String, Width As Integer, Height As Integer )
	bLength As Integer = -1
	bLength = XTCreateXBitmapEx( Name, Width, Height, 0 )
EndFunction bLength

/* ************************************************************************
 * @Description : This method will delete a previously created XBitmap
 *
 * @Param : Name = The name that will be given to the new XBitmap
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXBitmap( Name As String )
	BitmapID As Integer = -1
	BitmapID = XTFindXBitmapIDByName( Name )
	if ( BitmapID > -1 )
		DeleteImage( XBitmap[ BitmapID ].RenderImage )
		if XTCurrentXBitmap = BitmapID 
			XTCurrentXBitmap = -1
			SetRenderToScreen()
		Endif
		if XTCurrentXBitmap > BitmapID
			Dec XTCurrentXBitmap, 1
			SetRenderToImage( XBitmap[ XTCurrentXBitmap ].RenderImage, 0 )
		Endif
		XBitmap.remove( BitmapID )
	Endif
EndFunction

/* ************************************************************************
 * @Description : This method makes all render to be sent to a XBitmap
 *
 * @Param : Name = The name that will be given to the new XBitmap
 *
 * @Author : Frédéric Cordier
*/
Function XTSetCurrentBitmap( Name As String )
	if Name = "" or Name = NULL
		XTCurrentXBitmap = -1
		SetRenderToScreen()
	Else
		XTCurrentXBitmap = XTFindXBitmapIDByName( Name )
		SetRenderToImage( XBitmap[ XTCurrentXBitmap ].RenderImage, 0 )
	Endif
EndFunction XTCurrentXBitmap

/* ************************************************************************
 * @Description : This method will return the ID of a XBitmap if eists
 *
 * @Param : Name = The name that will be given to the new XBitmap
 *
 * @Return : thisBitmapID = the ID of the XBitmap if exists, otherwise -1
 *
 * @Author : Frédéric Cordier
 */
 Function XTFindXBitmapIDByName( Name As String )
	thisBitmapID As Integer = -1
	wLoop As Integer = 0
	if Name = "" or Name = NULL
		thisBitmapID = -1
	Else
		If XBitmap.length > -1
			For wLoop = 0 to XBitmap.length Step 1
				If XBitmap[ wLoop ].Name = Name
					thisBitmapID = wLoop
				Endif
			Next wLoop
		Else
			Message( "XTFindBitmapIDByName Erreur : Aucune Bitmap Virtuel XBitmap n'existe" )
		Endif
	Endif
EndFunction thisBitmapID

/* ************************************************************************
 * @Description : This method will return TRUE (=1) if the specified XBitmap exists, otherwise FALSE (=0)
 *
 * @Param : Name = The name that will be given to the new XBitmap
 *
 * @Return : isExist = TRUE (=1) if XBitmap exists, otherwise FALSE (=0)
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXBitmapExists( Name As String )
	isExist As Integer = 0
	if XTFindXBitmapIDByName( Name ) > -1 then isExist = TRUE
EndFunction isExist

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXBitmapWidth( Name As String )
	thisBitmapID As Integer = 0
	returnValue As Integer = -1
	if XTGetXBitmapExists( Name ) = TRUE
		returnValue = XBitmap[ XTFindXBitmapIDByName( Name ) ].Width
	Else
		returnValue = getVirtualWidth()
	Endif
EndFunction returnValue

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXBitmapHeight( Name As String )
	thisBitmapID As Integer = 0
	returnValue As Integer = -1
	if XTGetXBitmapExists( Name ) = TRUE
		returnValue = XBitmap[ XTFindXBitmapIDByName( Name ) ].Height
	else
		returnValue = getVirtualHeight()
	Endif
EndFunction returnValue

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTLoadBitmapEx( Name As String, FileName As String, MipMapMode As Integer )
	NewImage As Integer = -1
	BmpSprite As Integer = -1
	NewBitmapID As Integer = -1
	if GetFileExists( FileName ) = TRUE
		NewImage = LoadImage( FileName )
		NewBitmapID = XTCreateXBitmapEx( Name, GetImageWidth( NewImage ), GetImageHeight( NewImage ), MipMapMode )
		if NewBitmapID > -1
			BmpSprite = CreateSprite( NewImage )
			SetSpritePosition( BmpSprite, 0, 0 )
			DrawSprite( BmpSprite )
			DeleteSprite( BmpSprite )
			BmpSprite = -1
		Endif
		DeleteImage( NewImage )
		NewImage = -1
	Endif
EndFunction NewBitmapID

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTLoadBitmap( Name As String, FileName As String )
	NewBitmapID As Integer = -1
	NewBitmapID = XTLoadBitmapEx( Name, FileName, 0 )
EndFunction NewBitmapID
