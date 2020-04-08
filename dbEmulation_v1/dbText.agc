//
// ************************************************************************
// *                                                                      *
// * DarkBASIC Professional Emulation Ver 1.0 Include File : Text methods *
// *                                                                      *
// ************************************************************************
// Start Date : 2019.05.14 22:27
// Description : This class will contain all texts methods
// 
// Author : Frédéric Cordier
//

// ****************************************** To Do :
// Checker pourquoi les valeurs par défaut de prtSystem ne sont pas bonnes.
// Intégrer la création de font par défaut dans le createText si non défini.


// ************************************************************************************************ Create a new font if needed ans insert it in the PrintStack
/* ************************************************************************
 * @Description : Tell the engine to use the specified font.
 *
 * @Param : fontName = the name of the font to use
 *
 * @Author : Frédéric Cordier
*/
Function dbSetTextFont( fontName As String )
	existingFontID as Integer : existingFontID = findFont( fontName )
	// if the requested font already exist in the loaded font list, we directly set it in the prtStack
	if ( existingFontID > 0 )
		// Before inserting it, we check it does not correspond to the latest font setup requested in the stack
		if ( prtSystem.idFont <> existingFontID )
			insertPrint( chr( 255 ) + "setFont:" + str( existingFontID ) )
			prtSystem.idFont = existingFontID
		Endif
	Else
		// Otherwise we try to load the font ans set it in the prtStack
		tFont As Integer : tFont = loadfont( fontName )
		if ( tFont > 0 )
			if GetFontExists( tFont )
				newFontID As Integer : newFontID = insertFont( tFont, fontName )
				insertPrint( chr( 255 ) + "setFont:" + str( newFontID ) )
				prtSystem.idFont = newFontID
				prtSystem.fontName = fontName
				prtSystem.fontSize = 16
			else
			//	xtError( "dbSetTextFont : Font '" + fontName + "' does not exist" )
			endif
		else
		//	xtError( "dbSetTextFont : Font '" + fontName + "' cannot be loaded" )
		endif
	endif
		
EndFunction

/* ************************************************************************
 * @Description : Return the name of the current font used for dbText commands
 *
 * @Return : fontName = The name of the current font
 *
 * @Author : Frédéric Cordier
*/
Function dbTextFont()
	fontName as String : fontName = "default"
	if prtSystem.idFont > 0
		fontName = fntSystem[ prtSystem.idFont ].fontName
	Endif
EndFunction fontName

// ************************************************************************************************ Cursor functions

/* ************************************************************************
 * @Description : put the text cursor at specific X,Y coordinate
 *
 * @Param : xPos, yPos = The coordinates to position the text/print cursor.
 *
 * @Author : Frédéric Cordier
*/
Function dbSetCursor( xPos As Integer, yPos As Integer )
	prtSystem.xCursor = xPos
	prtSystem.yCursor = yPos
	insertPrint( chr( 255 ) + "setCursor:" + str( prtSystem.xCursor ) + ";" + str( prtSystem.yCursor ) )
EndFunction

/* ************************************************************************
 * @Description : Return the current X coordinate of the text/print cursor
 *
 * @Return : xCursor = the current X coordinate of the text/print cursor
 *
 * @Author : Frédéric Cordier
*/
Function dbGetCursorX()
EndFunction prtSystem.xCursor

/* ************************************************************************
 * @Description : Return the current Y coordinate of the text/print cursor
 *
 * @Return : xCursor = the current Y coordinate of the text/print cursor
 *
 * @Author : Frédéric Cordier
*/
Function dbGetCursorY()
EndFunction prtSystem.yCursor

// ************************************************************************************************ Ink functions

/* ************************************************************************
 * @Description : emulate DarkBASIC Professionals Ink( foreground, background ) command
 *
 * @Param : rgbColor = the foreground color used to write text/print on screen
 * @Param : rgbBackColor = the background color used arount writtent text/print on screen (not available)
 *
 * @Author : Frédéric Cordier
*/
Function dbInk( rgbColor as Integer, rgbBackColor As Integer )
	if ( rgbColor <> prtSystem.rgbBb )
		prtSystem.rgbA = ( rgbColor / 16777216 ) // And 255
		prtSystem.rgbR = ( rgbColor / 65536 ) // And 255
		prtSystem.rgbG = ( rgbColor / 255 ) // and 255
		prtSystem.rgbb = rgbColor // and 255
		insertPrint( chr( 255 ) + "ink:" + str( prtSystem.RgbR ) + ";" + str( prtSystem.RgbG ) + ";" + str( prtSystem.RgbB ) + ";" + str( prtSystem.RgbA ) )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Set the RGB Color used to print text on screen
 *
 * @Param : Red, Green, Blue = The three color component to create the RGB color used 
 *
 * @Author : Frédéric Cordier
*/
Function dbInkEx( Red As Integer, Green As Integer, Blue As Integer )
	dbInkEx2( 255, Red, Green, Blue )
EndFunction

/* ************************************************************************
 * @Description : Set the RGB Color with alpha channel, used to print text on screen
 *
 * @Param : Red, Green, Blue = The three color component to create the RGB color used 
 * @Param : Alpha = the alpha channel component
 *
 * @Author : Frédéric Cordier
*/
Function dbInkEx2( Alpha As Integer, Red As Integer, Green As Integer, Blue As Integer )
	fullRGBA As Integer
	fullRGBA = dbrgbex( Alpha, Red, Green, Blue )
	if ( fullRGBA <> prtSystem.rgbBb )
		prtSystem.rgbA = 255
		prtSystem.rgbR = Red
		prtSystem.rgbG = Green
		prtSystem.rgbB = Blue
		prtSystem.rgbBb = fullRGBA
		insertPrint( chr( 255 ) + "ink:" + str( fullRGBA ) )
	Endif
EndFunction

// ************************************************************************************************** db rgb functions
/* ************************************************************************
 * @Description : Emulate the DarkBASIC Professional Rgb command
 *
 * @Param : Red, Green, Blue color component to create the RGB color value
 *
 * @Return : rgbColor = the RGB color composed with the three entered components
 *
 * @Author : Frédéric Cordier
*/
Function dbrgb( red As Integer, green As Integer, blue As Integer )
	rgbColor As Integer
	rgbColor = dbrgbex( 255, rangeByte( red ), rangeByte( green ), rangeByte( blue ) )
EndFunction rgbColor

Function dbRGBA( red As Integer, green As Integer, blue As Integer )
	rgbColor As Integer
	rgbColor = dbrgbaex( rangeByte( red ), rangeByte( green ), rangeByte( blue ), 255 )
EndFunction rgbColor

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

Function rangeByte( Value As Integer )
	Min As Integer = 0 : Max As Integer = 255
	if Value > Max then Value = Max
	if Value < Min then Value = Min
EndFunction Value
	

Function dbrgbex( alpha As Integer, red As Integer, green As Integer, blue As Integer )
	rgbColor As Integer
	alpha = rangeByte( alpha ) * 16777216
	red = rangeByte( red ) * 65536
	green = rangeByte( green ) * 256
	blue = rangeByte( blue )
	rgbColor = alpha + red + green + blue
EndFunction rgbColor

Function dbRGBAex( red As Integer, green As Integer, blue As Integer, alpha As Integer )
	rgbColor As Integer = 0
	// Message( "Sources : RED = " + Hex( red ) + ", GREEN = " + Hex( green ) + ", BLUE = " + Hex( blue ) )
	red = rangeByte( red ) * 16777216
	green = rangeByte( green ) * 65536
	blue = rangeByte( blue ) * 256
	alpha = rangeByte( alpha )
	rgbColor = red + green + blue + alpha
	// Message( "Hex RGBA Color = " + Hex( rgbColor ) + " ( r = " + Hex( red ) + " )" )
EndFunction rgbColor

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
Function dbGetRGBA( )
EndFunction prtSystem.rgbA

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
Function dbGetRGBR( )
EndFunction prtSystem.rgbR

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
Function dbGetRGBG( )
EndFunction prtSystem.rgbG

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
Function dbGetRGBB( )
EndFunction prtSystem.rgbB

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
Function dbGetRGBAex()
	rgbAColor As Integer
	rgbAColor = ( prtSystem.rgbA * 16777216 ) + ( prtSystem.rgbR * 65536 )
	rgbAColor = rgbAColor + ( prtSystem.rgbG * 256 ) + prtSystem.rgbB
EndFunction rgbAColor

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
Function dbRGBAa( rgbAColor As Integer )
	rgbAColor = rgbAColor && 0xFF
EndFunction rgbAColor

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
Function dbRGBR( rgbColor As Integer )
	rgbColor  = rangeByte( rgbColor / 65536 )
EndFunction rgbColor

Function dbRGBAr( rgbColor As Integer )
	rgbOutColor As Integer = 0
//	Message( "RGBColor decimal value = " + Str( rgbColor ) + ", Hex = " + Hex( rgbColor ) )
	if rgbColor < 0
		rgbSTR As String : rgbSTR = Left( Hex( rgbColor ), 2 ) // Force rgbSTR to by 0xRRGGBBAA
		// Message( "RGBStr = " + rgbSTR )
		rgbOutColor = val( rgbSTR, 16 )
	Else
		rgbOutColor  = rangeByte( rgbColor / 16777216 )
	Endif
	// Message( "dbRGBAr = " + Hex( rgbOutColor ) + " source = " + Hex( rgbColor ) ) // = TESTE OK
EndFunction rgbOutColor

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
Function dbRGBG( rgbColor As Integer )
	rgbColor = ( rgbColor && 0xFF00 ) / 256
EndFunction rgbColor

Function dbRGBAg( rgbColor As Integer )
	rgbColor = ( rgbColor && 0xFF0000 ) / 65536
EndFunction rgbColor

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
Function dbRGBB( rgbColor As Integer )
	rgbColor = rgbColor && 0xFF
EndFunction rgbColor

Function dbRGBAb( rgbColor As Integer )
	rgbColor = ( rgbColor && 0xFF00 ) / 256
EndFunction rgbColor

// ************************************************************************************************** Text Size functions
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
Function dbSetTextSize( textSize As Integer )
	if textSize > 0
		if ( textSize <> prtSystem.fontSize )
			insertPrint( chr( 255 ) + "setFontSize:" + str( textSize ) )
			prtSystem.fontSize = textSize
		Endif
	Endif
EndFunction

Function dbTextSize()
EndFunction prtSystem.fontSize

// ************************************************************************************************** Text background functions
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
Function dbSetTextOpaque()
	if ( prtSystem.tTransparent = 1 )
		insertPrint( chr( 255 ) + "SetTextOpaque" )
		prtSystem.tTransparent = 0
	Endif
EndFunction

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
Function dbSetTextTransparent()
	if ( prtSystem.tTransparent = 0 )
		insertPrint( chr( 255 ) + "SetTextTransparent" )
		prtSystem.tTransparent = 1
	Endif
EndFunction

// ************************************************************************************************** Text style functions

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
Function dbSetTextToNormal()
	if ( prtSystem.tBold = 1 or prtSystem.tItalic = 1)
		insertPrint( chr( 255 ) + "SetTextToNormal" )
		prtSystem.tBold = 0
	Endif
EndFunction

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
Function dbSetTextToItalic()
	if ( prtSystem.tItalic = 0 )
		insertPrint( chr( 255 ) + "SetTextToItalic" )
		prtSystem.tItalic = 1
		prtSystem.tBold = 0
	Endif
EndFunction

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
Function dbSetTextToBold()
	if ( prtSystem.tBold = 0 )
		insertPrint( chr( 255 ) + "SetTextToBold" )
		prtSystem.tBold = 1
		prtSystem.tItalic = 0
	Endif
EndFunction

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
Function dbSetTextToBoldItalic()
	if ( prtSystem.tBold = 0 or prtSystem.tItalic = 0 )
		insertPrint( chr( 255 ) + "SetTextToBoldItalic" )
		prtSystem.tBold = 1
	Endif
EndFunction

// ************************************************************************************************** Text informations functions
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
Function dbTextWidth( textToWrite As String )
	textToReturn As String = ""
	if ( prtSystem.prtText = 0 )
		prtSystem.prtText = intCreateText( "" )
		SetTextSize( prtSystem.prtText, prtSystem.fontSize )
	else
		textToReturn = GetTextString( prtSystem.prtText )
	endif
	setTextString( prtSystem.prtText, textToWrite )
	feedBack As Integer
	feedBack = GetTextTotalWidth( prtSystem.prtText )
	SetTextString( prtSystem.prtText, textToReturn )
EndFunction feedBack

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
Function dbTextHeight( textToWrite As String )
	textToReturn As String = ""
	if ( prtSystem.prtText = 0 )
		prtSystem.prtText = intCreateText( "" )
		SetTextSize( prtSystem.prtText, prtSystem.fontSize )
	else
		textToReturn = GetTextString( prtSystem.prtText )
	endif
	setTextString( prtSystem.prtText, textToWrite )
	feedBack As Integer : feedBack = GetTextTotalHeight( prtSystem.prtText )
	SetTextString( prtSystem.prtText, textToReturn )
EndFunction feedBack
	

// ************************************************************************************************** Print functions
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
Function dbPrint( textToWrite As String )
	// Si aucun texte n'a été crée, on mets le Setup en place
	insertPrint( textToWrite )
EndFunction
  

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
Function dbText( x As Integer, y As Integer, textToWrite As String )
	xCursor As Integer : xCursor = prtSystem.xCursor
	yCursor As Integer : yCursor = prtSystem.yCursor
	dbSetCursor( x, y )
	dbPrint( textToWrite )
	dbSetCursor( xCursor, yCursor )
EndFunction
	
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
Function dbCenterText( x As Integer, y As Integer, textToWrite As String )
	tWidth As Integer
	tWidth = dbTextWidth( textToWrite )
	dbText( x - ( tWidth / 2 ), y, textToWrite )
EndFunction


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
Function xtGetLeftFrom( InText As String, Char As String )
	OutText As String = ""
	Pos As Integer = 0
	If Len( InText ) > 0
		Pos = Len( InText ) +1
		Repeat
			Pos = Pos - 1
		Until Mid( InText, Pos, 1 ) = Char Or Pos = 1
		If Mid( InText, Pos, 1 ) = Char
			OutText = Left( InText, Pos-1 )
		EndIf
	EndIf
EndFunction OutText

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
Function xtGetRightFrom( InText As String, Char As String )
	OutText As String =""
	Pos As Integer = 0
	If Len( InText ) > 0
		Pos = Len( InText ) +1
		Repeat
			Pos = Pos - 1
		Until Mid( InText, Pos, 1 ) = Char Or Pos = 1
		If Mid( InText, Pos, 1 ) = Char
			OutText = Right( InText, Len( InText ) - Pos )
		EndIf
	EndIf
EndFunction OutText

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
Function xtExtractFileName( Full As String )
	Pos As Integer = 0
	FileName As String = ""
	If Len( Full ) > 0
		Pos = Len( Full )
		Repeat
			Pos = Pos - 1
		Until Mid( Full, Pos, 1 ) = "\" Or Pos = 0
		FileName = Right( Full, ( Len( Full ) ) - Pos )
	EndIf
EndFunction FileName


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
Function xtExtractDrawer( Full As String )
	Pos As Integer
	Drawer As String = ""
	If Len( Full ) > 0
		Pos = Len( Full )
		Repeat
			Pos = Pos - 1
		Until Mid( Full, Pos, 1 ) = "\" Or Pos = 0
		If Pos > 0
			Drawer = Left( Full, Pos )
		Endif
	EndIf
EndFunction Drawer
  
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
Function xtGetFileWithoutExtension( InText As String )
	FileName As String = ""
	FileName = xtGetLeftFrom( InText, "." )
EndFunction FileName

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
Function xtGetFileExtension( InText As String )
	FileName As String = ""
	FileName = xtGetRightFrom( InText, "." )
EndFunction FileName
 
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
Function xtGetCharPosition( InText As String, InChar As String, Occurence As Integer )
	InPos As Integer = 1
	Repeat
		If Mid( InText, InPos, 1 ) = InChar
			Occurence = Occurence - 1
			If Occurence > 0
				InPos = InPos + 1
			EndIf
		Else
			InPos = InPos + 1
		EndIf
	Until Occurence = 0 Or InPos > Len( InText )
	If InPos > Len( InText ) : InPos = 0 : EndIf
EndFunction InPos

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
Function xtGetMiddle( InText As String, Start As Integer, Lon As Integer )
	XLoop As Integer
	OutText As String = ""
	If Lon > 0 And Lon+Start <= Len( InText )
		If Lon = 1
			OutText = Mid( InText, Start, 1 )
		Else
			For XLoop = Start To ( Start + Lon ) - 1
				OutText = OutText + Mid( InText, XLoop, 1 )
			Next XLoop
		EndIf
	EndIf
EndFunction OutText



// ************************************************************ INTERNAL FONT METHODS. DO NOT USE THEM.
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
Function findFont( fontName As String )
	iLoop As Integer = 0
	fExist as Integer = -1
	if ( fntSystem.length > 0 )
		for iLoop = 1 to fntSystem.length
			if fntSystem[ iLoop ].fontName = fontName
				fExist = iLoop
			Endif
		Next iLoop
	Endif
EndFunction fExist

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
Function insertFont( loadedFont as Integer, fontName As String )
	newFont as fontSystem
	newFont.fontName = fontName
	newFont.used = loadedFont
	fntSystem.insert( newFont )
	index As Integer : index = fntSystem.length
EndFunction index

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
Function insertPrint( inText As String )
	prtSystem.prtStack.insert( inText )
EndFunction

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

Function intCreateText( textToCreate As String )
	// Si aucun texte n'a été créé, on le créé
	if ( prtSystem.prtText = 0 )
		prtSystem.prtText = CreateText( textToCreate )
		SetTextFont( prtSystem.prtText, prtSystem.idFont )
		if prtSystem.fontSize < 8
			prtSystem.fontSize = 8
			SetTextSize( prtSystem.prtText, prtSystem.fontSize )
		Endif
	Else
		prtSystem.prtText = prtSystem.prtText
		SetTextString( prtSystem.prtText, textToCreate )
	Endif
EndFunction prtSystem.prtText

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
Function dbRefresh()
	CurrentWidth As Integer = 0
	SetScissor( 0, 0, getVirtualWidth(), getVirtualHeight() )
	if prtSystem.prtStack.length > 0
		// Firstly, we check if a text output is created or not
		if prtRender.prtText = 0
			if prtSystem.prtText = 0
				prtSystem.prtText = intCreateText( "" )
				// SetTextFont( prtSystem.prtText, prtSystem.fontName )
				SetTextSize( prtSystem.prtText, prtSystem.fontSize )
				prtRender.fontSize = prtSystem.fontSize
				SetTextColor( prtSystem.prtText, prtSystem.rgbR, prtSystem.rgbG, prtSystem.rgbB, prtSystem.rgbA )
				prtRender.prtText = prtSystem.prtText
			else
				prtRender.prtText = prtSystem.prtText
			endif
		Endif
		prtRender.xCursor = prtSystem.xCursor
		prtRender.yCursor = prtsystem.yCursor
		
		xRead As Integer : xRead = 1
		while xRead < ( prtSystem.prtStack.length + 1 )
			eXecuted as Integer : eXecuted = 0
	
			newCommand As String : newCommand = prtSystem.prtStack[ xRead ]

			if mid( newCommand, 1, 1 ) = chr( 255 )
				CTE As String
				CTE = mid( newCommand, 2, len( newCommand ) - 1 )
				// 1ère passe, les commandes simples
				Select( CTE )
					Case "SetTextOpaque"
						SetTextTransparency( prtRender.prtText, 0 )
						eXecuted = 1
					EndCase
					Case "SetTextTransparent"
						SetTextTransparency( prtRender.prtText, 1 )
						eXecuted = 1
					EndCase
					Case "SetTextToNormal"
						SetTextBold( prtRender.prtText, 0 )
						eXecuted = 1
					EndCase
					Case "SetTextToItalic"
					EndCase
					Case "SetTextToBold"
						SetTextBold( prtRender.prtText, 1 )
						eXecuted = 1
					EndCase
					Case "SetTextToBoldItalic"
						SetTextBold( prtRender.prtText, 1 )
						eXecuted = 1
					EndCase
					Case Default
					EndCase
				EndSelect
				// 2ème passe, les commandes complexes
				if eXecuted = 0
					// On regarde s'il s'agit d'une commande avec une valeur (après :)
					Checker As Integer = -1
					Checker = indexOf( CTE, ":" ) + 1
					Value As String : Value = ""
					if ( Checker > 0 )
						Value = Mid( CTE, Checker, 1 + Len( CTE ) - Checker )
						if contains( CTE, "setFont:" ) = 1
							SetTextFont( prtRender.prtText, val( Value ) )
							eXecuted = 1
						Endif
						if contains( CTE, "setFontsize:" ) = 1
							SetTextSize( prtRender.prtText, val( Value ) )
							eXecuted = 1
						Endif
						if contains( CTE, "ink:" ) = 1
							index1 As Integer = -1
							index1 = indexOf( Value, ";" ) // 1er ;
							index2 As Integer = -1
							index2 = indexOf2( Value, ";", index1 + 1 )
							index3 As Integer = -1
							index3 = indexOf2( Value, ";", index2 + 1 )
							frgbR As String : frgbR = mid( Value, 1, index1 -1 )
							frgbG As String : frgbG = mid( Value, index1 + 1, ( index2 - index1 ) -1 )
							frgbB As String : frgbB = mid( Value, index2 + 1, ( index3 - index2  ) -1 )
							frgbA As String : frgbA = mid( Value, index3 + 1, ( len( Value ) -  index3 ) +1 )
							SetTextColor( prtRender.prtText, val( frgbR ), val( frgbG ), val( frgbB ), val( frgbA ) )
							eXecuted = 1
						Endif
						if contains( CTE, "setCursor:" ) = 1
							Checker2 As Integer = -1
							Checker2 = indexOf( Value, ";" )
							xPos As Integer : xPos = val( mid( value, 1, checker2 ) )
							yPos as Integer : yPos = val( mid( value, checker2 + 1, ( len( value ) - checker2 ) + 1)  )
							prtRender.xCursor = xPos 
							prtRender.yCursor = yPos
							SetTextPosition( prtRender.prtText, xPos, yPos )
							eXecuted = 1
						Endif
					Endif
				Endif
			Endif
			SetTextColor( prtRender.prtText, 255, 255, 255, 255 )

			// 3ème passe, le print.
			if eXecuted = 0
				While Len( Newcommand ) > 0
					DrawableWidth As Integer
					DrawableWidth = GetDeviceWidth() - prtRender.xCursor
					// S'il n'y a pas de place pour écrire ne serait-ce qu'un seul caractère, on envoie de suite à la ligne suivante.
					if DrawableWidth < prtRender.fontSize 
						prtRender.yCursor = prtRender.yCursor + prtRender.fontSize
						prtRender.xCursor = 0
					Endif
					// 1. Si le texte n'est pas plus long que la largeur d'écriture disponible, on écrit simplement le texte.
					if dbTextWidth( newCommand ) < DrawableWidth
						SetTextPosition( prtRender.prtText, prtRender.xCursor, prtRender.yCursor )
						SetTextString( prtRender.prtText, newCommand )
						DrawText( prtRender.prtText )
						prtRender.yCursor = prtRender.yCursor + prtRender.fontSize
						prtRender.xCursor = 0
						NewCommand = "" // On clear le contenu de la variable commande pour valider la fin d'écriture
					// 2. On doit écrire le texte sur plusieurs lignes (au moins 2).
					Else
						// 2.1 On définit les limites maxi et mini.
						MaxLen As Integer
						MaxLen = len( newCommand ) // On récupère la longueur maximale en nombre de caractères (le texte total).
						MinLen As Integer = 1      // On récupère la quantité minimal à écrire
						success As Integer = 0
						// 2.2 Puis on exécute par itérations 1/2 du restant
						while success = 0
							Median As Integer : Median = ( ( MaxLen - MinLen ) / 2 )  + MinLen
							currentWidth = dbTextWidth( Mid( newCommand, 1, Median ) )
							// 2.2.1 S'il reste de l'espace on calibre sur l'espace supérieur Median-MaxLen
							if currentWidth < DrawableWidth
								MinLen = Median
								// 2.2.1.2 En additionnel, si après calcul, il ne reste pas assez de place pour ajouter un caractère, on valide
								if ( DrawableWidth - currentWidth ) < prtRender.fontSize
									// Message( "Success 1" )
									success = 1
								Endif
							// 2.2.2 Si le texte est trop grand, on calibre sur l'espace inférieur MinLen-Media
							Else
								MaxLen = Median
								// 2.2.2.1 Idem pour le filtre haut, si on dépasse de moins d'1 caractère, on valide en supprimant 1 caractère
								if abs( DrawableWidth - currentWidth ) < prtRender.fontSize
									// Message( "Success 2" )
									success = 1
									Median = Median - 1
								Endif
							Endif
						EndWhile 
						// 2.3 Une fois qu'on a définir la parcelle de texte a écrire, on l'écrit
						WriteText As String
						WriteText = mid( newCommand, 1, Median )
						SetTextPosition( prtRender.prtText, prtRender.xCursor, prtRender.yCursor )
						// 2.4 On renvoie à la ligne pour le reste à écrire
						SetTextString( PrtRender.prtText, WriteText )
						DrawText( PrtRender.prtText )
						prtRender.yCursor = prtRender.yCursor + prtRender.fontSize
						prtRender.xCursor = 0
						// 2.4 On réajuste le contenu de texte à écrire en supprimant ce qui a déjà été écrit
						NewCommand = mid( NewCommand, Median + 1, -1 )
					Endif
				EndWhile
				// 2.5 Fin de boucle d'écriture, on valide le texte en exécuté
				eXecuted = 1
			Endif
			
			if eXecuted = 0
				SetTextString( prtRender.prtText, "WARNING some data were not handled WARNING" )
				DrawText( prtRender.prtText )
			Endif

			xRead = xRead + 1
		EndWhile
		
		while prtSystem.prtStack.length > 0
			prtSystem.prtStack.remove()
		EndWhile
		
		prtSystem.xCursor = prtRender.xCursor
		prtSystem.yCursor = prtRender.yCursor
	Endif
EndFunction




