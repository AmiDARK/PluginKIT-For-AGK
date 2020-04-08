//
// **********************************************************
// *                                                        *
// * eXtends Ver 2.0 Include File : eXtends XGadgets System *
// *                                                        *
// **********************************************************
// Start Date : 2019.05.04 14:26
// Description : This system allow the use of text, graphic and
//               mixed buttons and gadgets in any XWindow
//
// Author : Frédéric Cordier
//
// ************************************************************************ XGadget Setup & Creation commands
// XTNewMixedGadget( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer, TextToDisplay As String )
// XTNewGadget( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer )
// XTNewTextGadget( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, TextToDisplay As String )
// XTNewMixedGadgetEx( XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer, TextToDisplay As String )
// XTNewGadgetEx( XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer )
// XTNewTextGadgetEx( XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, TextToDisplay As String )
// ************************************************************************ XGadget Render in XWindows and Screen
// Internal_DrawXGadget( ImageID As Integer, XPos As Integer, YPos As Integer, TransparencyMode As Integer )
// XTRefreshXGadgetFast( XGadget As XGadget_Type )
// ************************************************************************ XGadget Deletion Commands ByName
// Integer = XTFindXGadgetIDByName( XWindowName As String, XGadgetName As String )
// Integer = XTFindXGadgetIDByNameEx( XGadgetName As String )
// XTDeleteXGadget( XWindowName As String, XGadgetName As String )
// XTDeleteXGadgetEx( XGadgetName As String )
// ************************************************************************ XGadget Commands ByName
// XTSetXGadgetText( XWindowName As String, XGadgetName As String, TextToUpdate As String )
// XTSetXGadgetTextEx( XGadgetName As String, TextToUpdate As String )
// XTSetXGadgetImage( XWindowName As String, XGadgetName As String, ImageID As Integer )
// XTSetXGadgetImageEx( XGadgetName As String, ImageID As Integer )
// XTSetXGadgetPosition( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer )
// XTSetXGadgetPositionEx( XGadgetName As String, XPos As Integer, YPos As Integer )

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** XGadget Methods SYSTEM
// *
// *************                                                                                                                           *********************
//

/* ************************************************************************
 * @Description : Méthode globale de création de XGadgets qui prends en compte tous
 *                les paramètres et est utilisée par les autres méthodes de création
 *                de XGadgets
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget va être créé. Si NULL ou "", alors le gadget sera créé hors fenêtre XWindow
 * @Param : XGadgetName = Le nom qui sera donné au XGadget.
 * @Param : XPos = La coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : XSize = La largeur en pixels du gadget
 * @Param : YSize = la hauteur en pixels du gadget
 * @Param : ImageID = Le numéro d'index de l'image à utiliser comme XGadget
 * @Param : TextToDisplay = Le texte à afficher à l'intérieur du gadget
 *
 * @Return : le numéro d'index du XGadget dans son repère (sa fenêtre XWindow parent ou l'écran global)
 *
 * @Author : Frédéric Cordier
*/
Function XTNewMixedGadget( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer, TextToDisplay As String )
	newXGadgetID As Integer = -1
	newXGadget As XGadget_Type
	newXGadget.Name = XGadgetName
	newXGadget.XPos = XPos : newXGadget.YPos = YPos
	newXGadget.XSize = XSize : newXGadget.YSize = YSize
	// Gestion du texte (vide ou pas, importe peu)
	newXGadget.TexteToDisplay = TextToDisplay
	// Gestion de l'image selon la demande
	If ImageID > -1
		if getImageExists( ImageID ) = TRUE
			newXGadget.ImageID = ImageID
		Else
			newXGadget.ImageID = -1
			Message( "XTNewMixedGadget Warning : L'image '" + Str( ImageID ) + "' n'existe pas, le gadget sera créé sans image" )
		Endif
	Else
		newXGadget.ImageID = -1
	Endif
	// Si une fenêtre XWindow est demandée
	XWindowNum As Integer = -1
	if XWindowName = NULL or XWindowName = ""
		XWindowNum = -1
	Else
		XWindowNum = XTGetXWindowIDByName( XWindowName )
	Endif
	newXGadget.XWinName = XWindowName
	if XWindowNum > -1
	// Création XGadget in XWindow
		if XTGetXWindowExists( XWindowNum ) = TRUE
			XWindow[ XWindowNum ].XGadget.insert( newXGadget ) // On ajoute le nouveau XGadget à la liste des XGadgets de la fenêtre
			newXGadgetID = XWindow[ XWindowNum ].XGadget.length
		Else
			newXGadgetID = -1
			Message( "XTNewMixedGadget Erreur : Le numéro d'index de fenêtre XWindow '" + Str( XWindowNum ) + "' est incorrect, ou la fenêtre n'existe pas." )
		Endif
	Else
	// Sinon XGadget out of XWindow
		OutGadget.insert( newXGadget )
		newXGadgetID = outGadget.length
	Endif
EndFunction newXGadgetID

/* ************************************************************************
 * @Description : Crée un XGadget de type Graphique
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget va être créé. Si NULL ou "", alors le gadget sera créé hors fenêtre XWindow
 * @Param : XGadgetName = Le nom qui sera donné au XGadget.
 * @Param : XPos = La coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : XSize = La largeur en pixels du gadget
 * @Param : YSize = la hauteur en pixels du gadget
 * @Param : ImageID = Le numéro d'index de l'image à utiliser comme XGadget
 *
 * @Return : le numéro d'index du XGadget dans son repère (sa fenêtre XWindow parent ou l'écran global)
 *
 * @Author : Frédéric Cordier
*/
Function XTNewGadget( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer )
	newXGadgetID As Integer
	newXGadgetID = XTNewMixedGadget( XWindowName, XGadgetName, XPos, YPos, XSize, YSize, ImageID, NULL )
EndFunction newXGadgetID


/* ************************************************************************
 * @Description : Crée un XGadget de type Texte
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget va être créé. Si NULL ou "", alors le gadget sera créé hors fenêtre XWindow
 * @Param : XGadgetName = Le nom qui sera donné au XGadget.
 * @Param : XPos = La coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : XSize = La largeur en pixels du gadget
 * @Param : YSize = la hauteur en pixels du gadget
 * @Param : TextToDisplay = Le texte à afficher à l'intérieur du gadget
 *
 * @Return : le numéro d'index du XGadget dans son repère (sa fenêtre XWindow parent ou l'écran global)
 *
 * @Author : Frédéric Cordier
*/
Function XTNewTextGadget( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, TextToDisplay As String )
	newXGadgetID As Integer
	newXGadgetID = XTNewMixedGadget( XWindowName, XGadgetName, XPos, YPos, XSize, YSize, -1, TextToDisplay )
EndFunction newXGadgetID

/* ************************************************************************
 * @Description : Crée un XGadget  de type Mixte (Texte + Graphique) hors fenêtre XWindow
 *
 * @Param : XGadgetName = Le nom qui sera donné au XGadget.
 * @Param : XPos = La coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : XSize = La largeur en pixels du gadget
 * @Param : YSize = la hauteur en pixels du gadget
 * @Param : ImageID = Le numéro d'index de l'image à utiliser comme XGadget
 * @Param : TextToDisplay = Le texte à afficher à l'intérieur du gadget
 *
 * @Return : le numéro d'index du XGadget dans son repère (sa fenêtre XWindow parent ou l'écran global)
 *
 * @Author : Frédéric Cordier
*/
Function XTNewMixedGadgetEx( XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer, TextToDisplay As String )
	newXGadgetID As Integer
	newXGadgetID = XTNewMixedGadget( NULL, XGadgetName, XPos, YPos, XSize, YSize, ImageID, TextToDisplay )
EndFunction newXGadgetID

/* ************************************************************************
 * @Description : Crée un XGadget de type Graphique hors fenêtre XWindow
 *
 * @Param : XGadgetName = Le nom qui sera donné au XGadget.
 * @Param : XPos = La coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : XSize = La largeur en pixels du gadget
 * @Param : YSize = la hauteur en pixels du gadget
 * @Param : TextToDisplay = Le texte à afficher à l'intérieur du gadget
 *
 * @Return : le numéro d'index du XGadget dans son repère (sa fenêtre XWindow parent ou l'écran global)
 *
 * @Author : Frédéric Cordier
*/
Function XTNewGadgetEx( XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, ImageID As Integer )
	newXGadgetID As Integer
	newXGadgetID = XTNewMixedGadget( NULL, XGadgetName, XPos, YPos, XSize, YSize, ImageID, NULL )
EndFunction newXGadgetID

/* ************************************************************************
 * @Description : Crée un XGadget de type Texte hors fenêtre XWindow
 *
 * @Param : XGadgetName = Le nom qui sera donné au XGadget.
 * @Param : XPos = La coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou l'écran selon le paramètre XWindowNum
 * @Param : XSize = La largeur en pixels du gadget
 * @Param : YSize = la hauteur en pixels du gadget
 * @Param : TextToDisplay = Le texte à afficher à l'intérieur du gadget
 *
 * @Return : le numéro d'index du XGadget dans son repère (sa fenêtre XWindow parent ou l'écran global)
 *
 * @Author : Frédéric Cordier
*/
Function XTNewTextGadgetEx( XGadgetName As String, XPos As Integer, YPos As Integer, XSize As Integer, YSize As Integer, TextToDisplay As String )
	newXGadgetID As Integer
	newXGadgetID = XTNewMixedGadget( NULL, XGadgetName, XPos, YPos, XSize, YSize, -1, TextToDisplay )
EndFunction newXGadgetID

//
// *********************                                                                                                                           *************
// *
// *********************************************************************************************************************** XGadget Render in XWindows and Screen
// *
// *************                                                                                                                           *********************
//

/* ************************************************************************
 * @Description : This method render a XGadget image
 *
 * @Param : ImageID = the image index to draw
 * @Param : XPos = The X coordinate where the image will start to be drawn
 * @Param : YPos = The Y coordinate where the image will start to be drawn
 * @Param : TransparencyMode = 1 for invisible black, otherwise 0
 *
 * @Author : Frédéric Cordier
*/
Function Internal_DrawXGadget( ImageID As Integer, XPos As Integer, YPos As Integer, TransparencyMode As Integer )
	if XWinSystem.XGadgetSprite = 0
		XWinSystem.XGadgetSprite = CreateSprite( ImageID )
	Else
		SetSpriteImage( XWinSystem.XGadgetSprite, ImageID )
	Endif
	SetSpritePosition( XWinSystem.XGadgetSprite, XPos, YPos )
	SetSpriteTransparency( XWinSystem.XGadgetSprite, TransparencyMode )
	DrawSprite( XWinSystem.XGadgetSprite )
	SetSpritePosition( XWinSystem.XGadgetSprite, -16384, -16384 )
EndFunction

/* ************************************************************************
 * @Description : Render a gadget in it's XWindow or in Screen
 *
 * @Param : XGadget : The XGadget to render
 *
 * @Author : Frédéric Cordier
*/
Function XTRefreshXGadgetFast( XGadget As XGadget_Type )
	XShift As Integer : YShift As Integer
	DefaultFont As Integer = -1
	XSize As Integer = 0 : YSize As Integer = 0
	XPos As Integer = 0 : YPos As Integer = 0
	XCount As Integer = 0 : YCount As Integer = 0
	XLoop As Integer = 32 : TESTE As String = ""
	XLines As Integer = 0
	XStart As Integer = 0 : XQuant As Integer = 0
	TEST2 As String = ""
	// 0. On gère le décalage X, Y lié au cadre du skin utilisé, et de la barre de titre.
	WinNumber As Integer : WinNumber = XTGetXWindowIDByName( XGadget.XWinName )
	if WinNumber > -1
		if XWindow[ WinNumber ].Borders = 1
			XShift = 16 : YShift = 16
		Endif
		If XWindow[ WinNumber ].Title = 1 then YShift = 16
	Endif
	// 1. Tracé de l'image du Gadget si définie et existante
	if GetImageExists( XGadget.ImageID ) = TRUE
		Internal_DrawXGadget( XGadget.ImageID, XGadget.XPos + XShift, XGadget.YPos + YShift, 1 )
	Endif
	// 2. Si le gadget contient le Texte du contenu des chats, on l'affiche (multi-lignes possible)
	// if XGadget.ChatWindowGadget = TRUE
	If XWinSystem.ChatWindowWindowName = XGadget.XWinName and XWinSystem.ChatWindowGadgetName = XGadget.Name
		// 2.1 Le rendu des textes peut se faire soit par XFONT
		DefaultFont = XFontSys.CurrentFont
		XFontSys.CurrentFont = XGadget.Xfont
		YSize = XTGetXFontTextHeight( "TEST" )
		if YSize = 0 Then YSize = 8
		YCount = XGadget.YSize / YSize
		XCount = XGadget.XSize / YSize
		if YCount * YSize > XGadget.YSize then YCount = YCount -1
		XPos = XGadget.XPos
		YPos = XGadget.YPos + XGadget.YSize - YSize
		Repeat
			If len( TESTE ) = 0
				TESTE = ChatText[ XLoop ] : Dec XLoop, 1
			Endif
			XTSetXFontCursor( XPos, YPos )
			// Si le texte à écrire n'est pas plus long que la capacité de ligne, on l'écrit en entier
			If Len( TESTE ) <= XCount
				XTPrintXFontFast( TESTE, TRUE )
				TESTE = ""
			Else
			// Si le texte est plus long, on le découpe
				XLines = Len( TESTE ) / XCount
				If XLines * XCount = Len( TESTE ) then Dec XLines, 1
				XStart = XLines * XCount
				XQuant = Len( TESTE ) - XStart
				TEST2 = Right( TESTE, XQuant )
				TESTE = Left( TESTE, Len( TESTE ) - XQuant )
				XTPrintXFontFast( TEST2, 1 )
			Endif
			Dec YPos, YSize : Dec YCount, 1
		Until YCount < 1
		XFontSys.CurrentFont = DefaultFont // Restore la XFont qui était définie avant le tracé de XGadget
	Else
	// 3. Si le gadget est un gadget Texte
		If Len( XGadget.TexteToDisplay ) > 0
			TESTE = XGadget.TexteToDisplay
			If Len( TESTE ) > 0
				// 3.1 Si le texte n'utilise pas de XFont, il sera tracé en texte normal
				If XWindow[ WinNumber ].XFont = 0
					// Si l'objet Texte n'existe pas, on le créé
					if XWinSystem.CurrentGadgetFont = -1
						XWinSystem.CurrentGadgetFont = CreateText( "" )
						SetTextAlignment( XWinSystem.CurrentGadgetFont, 1 )
					Endif
					SetTextSize( XWinSystem.CurrentGadgetFont, XWinSystem.TextSize )
					XSize = GetTextTotalWidth( XWinSystem.CurrentGadgetFont )
					YSize = GetTextTotalHeight( XWinSystem.CurrentGadgetFont )
					// 3.1.1 Si le gadget est un gadget de ChatTextInput
					// if XGadget.ChatGadget = TRUE
					if XWinSystem.ChatGadgetName = XGadget.Name and XWinSystem.ChatGadgetWindowName = XGadget.XWinName
						XPos = XGadget.XPos
						XCount = XGadget.XSize / YSize
						if len( TESTE ) >= XCount then TESTE = Right( TESTE, XCount )
					Else
					// 3.1.2 Si le gadget n'est pas un gadget de ChatTextInput, mais TextSimple
						XPos = XGadget.XPos + ( XGadget.XSize / 2 ) - ( XSize / 2 )
					Endif
					YPos = XGadget.YPos + ( XGadget.YSize / 2 ) - ( YSize / 2 )
					// 3.1.3 On trace le texte à l'écran
					SetTextPosition( XWinSystem.CurrentGadgetFont, XPos + XShift, YPos + ( YShift /2 ) )
					SetTextString( XWinSystem.CurrentGadgetFont, TESTE )
					DrawText( XWinSystem.CurrentGadgetFont )
					SetTextPosition( XWinSystem.CurrentGadgetFont, -16384, -16384 )
				Else
				// 3.2 Si le texte utilise les XFont
					DefaultFont = XFontSys.CurrentFont
					XFontSys.CurrentFont = XWindow[ WinNumber ].XFont
					XSize = XTGetXFontTextWidth( TESTE )
					YSize = XTGetXFontTextHeight( TESTE )
					// 3.2.1 Si le gadget est un gadget de ChatTextInput
					// If XGadget.ChatGadget = TRUE
					if XWinSystem.ChatGadgetName = XGadget.Name and XWinSystem.ChatGadgetWindowName = XGadget.XWinName
						XPos = XGadget.XPos
						XCount = XGadget.XSize / YSize
						if len( TESTE ) >= XCount then TESTE = Right( TESTE, XCount )
					Else
					// 3.2.2 Si le gadget n'est pas un gadget de ChatTextInput, mais TextSimple
						XPos = XGadget.XPos + ( XGadget.XSize / 2 ) - ( XSize / 2 )
					Endif
					// 3.2.3 On trace le texte à l'écran
					YPos = XGadget.YPos + ( XGadget.YSize / 2 ) - ( YSize / 2 )
					XTSetXFontCursor( XPos + XShift, YPos + YShift )
					XTPrintXFontFast( TESTE, 1 )
					XFontSys.CurrentFont = DefaultFont
				Endif
			Endif
		Endif
	Endif
EndFunction	

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** XGadget Methods System
// *
// *************                                                                                                                           *********************
//


/* ************************************************************************
 * @Description : Retrouve un XGadget dans une fenêtre XWindow ou dans l'écran principal à partir de son nom
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget se trouve ou NULL (ou "") pour l'écran principal
 * @Param : XGadgetName = Le nom du gadget à trouver dans la fenêtre XWindow ou dans l'écran principal
 *
 * @Return : l'index du XGadget dans la liste dédiée dans la fenêtre XWindow choisie
 *
 * @Author : Frédéric Cordier
*/
Function XTFindXGadgetIDByName( XWindowName As String, XGadgetName As String )
	xGadgetID As Integer = -1
	xWindowID As Integer = -1
	gLoop As Integer = -1
	if XWindowName = NULL or XWindowName = ""
		if OutGadget.length > -1
			For gLoop = 0 to OutGadget.length
				if OutGadget[ gLoop ].Name = XGadgetName then xGadgetID = gLoop
			Next gLoop
			if xGadgetID = -1 then Message( "XTFindXGadgetIDByName Erreur : Le gadget '" + XGadgetName + "' n'a pas été trouvé dans la liste globale." )
		Else
			Message( "XTFindXGadgetIDByName Erreur : Aucun Gadget n'a été créé pour l'écran global." )
		Endif
	Else
		if XWindow.length > -1
			xWindowID = XTGetXWindowIDByName( XWindowName )
			if xWindowID > -1
				for gLoop = 0 to XWindow[ xWindowID ].XGadget.length
					if XWindow[ xWindowID ].XGadget[ gLoop ].Name = XGadgetName Then xGadgetID = gLoop
				Next gLoop
				if xGadgetID = -1 then Message( "XTFindXGadgetIDByName Erreur : Le gadget '" + XGadgetName + "' n'a pas été trouvé dans la fenêtre XWindow '" + XWindowName + "'." )
			Else
				Message( "XTFindXGadgetIDByName Erreur : La fenêtre XWindow '" + XWindowName + "' n'a pas été trouvée." )
			Endif
		Else
			Message( "XTFindXGadgetIDByName Erreur : Aucune fenêtre XWindow n'a été créée." )
		Endif
	Endif
EndFunction xGadgetID

/* ************************************************************************
 * @Description : Retrouve un XGadget dans la liste globale de XGadget d'écran
 *
 * @Param : XGadgetName = Le nom du gadget à trouver dans l'écran global
 *
 * @Return : l'index du XGadget dans la liste dédiée dans l'écran global
 *
 * @Author : Frédéric Cordier
*/
Function XTFindXGadgetIDByNameEx( XGadgetName As String )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( NULL, XGadgetName )
EndFunction xGadgetID


/* ************************************************************************
 * @Description : Supprime un XGadget présent dans une fenêtre XWindow
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget se trouve ou NULL (ou "") pour l'écran principal
 * @Param : XGadgetName = Le nom du gadget à trouver dans la fenêtre XWindow ou dans l'écran principal
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXGadget( XWindowName As String, XGadgetName As String )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( XWindowName, XGadgetName )
	// Suppression de XGadget dans l'écran principal
	if XWindowName = NULL or XWindowName = ""
		OutGadget.remove( xGadgetID )
	Else
	// Suppression de XGadget dans une fenêtre XWindow
		xWindowID As Integer = -1
		xWindowID = XTGetXWindowIDByName( XWindowName )
		if xGadgetID > -1 and xWindowID > -1
			XWindow[ xWindowID ].XGadget.remove( xGadgetID )
		Endif
	Endif
EndFunction

/* ************************************************************************
 * @Description : Supprime un XGadget présent dans l'écran principal
 *
 * @Param : XGadgetName = Le nom du gadget à trouver dans l'écran principal
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXGadgetEx( XGadgetName As String )
	XTDeleteXGadget( NULL, XGadgetName )
EndFunction

//
// *********************                                                                                                                           *************
// *
// **************************************************************************************************************************************** XGadget Methods User
// *
// *************                                                                                                                           *********************
//

/* ************************************************************************
 * @Description : Modifie le texte présent dans un XGadget d'une fenêtre XWindow ou de l'écran principal
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget se trouve ou NULL (ou "") pour l'écran principal
 * @Param : XGadgetName = Le nom du gadget à trouver dans la fenêtre XWindow ou dans l'écran principal
 * @Param : TextToUpdate = Le texte à mettre dans le XGadget en remplacement du précédent
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXGadgetText( XWindowName As String, XGadgetName As String, TextToUpdate As String )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( XWindowName, XGadgetName )
	xWindowID As Integer = -1
	xWindowID = XTGetXWindowIDByName( XWindowName )
	if xGadgetID > -1
		if xWindowID = -1
			OutGadget[ xGadgetID ].TexteToDisplay = TextToUpdate
		Else
			XWindow[ xWindowID ].XGadget[ xGadgetID ].TexteToDisplay = TextToUpdate
		Endif
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie le texte présent dans un XGadget d'une fenêtre XWindow ou de l'écran principal
 *
 * @Param : XGadgetName = Le nom du gadget à trouver dans la fenêtre XWindow ou dans l'écran principal
 * @Param : TextToUpdate = Le texte à mettre dans le XGadget en remplacement du précédent
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXGadgetTextEx( XGadgetName As String, TextToUpdate As String )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( NULL, XGadgetName )
	if xGadgetID > -1
		OutGadget[ xGadgetID ].TexteToDisplay = TextToUpdate
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie le texte présent dans un XGadget d'une fenêtre XWindow ou de l'écran principal
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget se trouve ou NULL (ou "") pour l'écran principal
 * @Param : XGadgetName = Le nom du gadget à trouver dans la fenêtre XWindow ou dans l'écran principal
 * @Param : ImageID = Le numéro d'index d'image à utiliser dans le XGadget en remplacement du précédent
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXGadgetImage( XWindowName As String, XGadgetName As String, ImageID As Integer )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( XWindowName, XGadgetName )
	xWindowID As Integer = -1
	xWindowID = XTGetXWindowIDByName( XWindowName )
	if xGadgetID > -1
		if xWindowID = -1
			OutGadget[ xGadgetID ].ImageID = ImageID
		Else
			XWindow[ xWindowID ].XGadget[ xGadgetID ].ImageID = ImageID
		Endif
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie le texte présent dans un XGadget d'une fenêtre XWindow ou de l'écran principal
 *
 * @Param : XGadgetName = Le nom du gadget à trouver dans l'écran principal
 * @Param : ImageID = Le numéro d'index d'image à utiliser dans le XGadget en remplacement du précédent
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXGadgetImageEx( XGadgetName As String, ImageID As Integer )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( NULL, XGadgetName )
	if xGadgetID > -1
		OutGadget[ xGadgetID ].ImageID = ImageID
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie la position d'un XGadget dans une fenêtre XWindow ou dans l'écran principal
 *
 * @Param : XWindowName = le nom de la fenêtre XWindow dans laquelle le gadget se trouve ou NULL (ou "") pour l'écran principal
 * @Param : XGadgetName = Le nom du gadget à trouver dans la fenêtre XWindow ou dans l'écran principal
 * @Param : Coordonnée d'abscisse (sur X) du XGadget dans la fenêtre XWindow ou dans l'écran
 * @Param : Coordonnée d'ordonnée (sur Y) du XGadget dans la fenêtre XWindow ou dans l'écran
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXGadgetPosition( XWindowName As String, XGadgetName As String, XPos As Integer, YPos As Integer )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( XWindowName, XGadgetName )
	xWindowID As Integer = -1
	xWindowID = XTGetXWindowIDByName( XWindowName )
	if xGadgetID > -1
		if xWindowID = -1
			OutGadget[ xGadgetID ].XPos = XPos
			OutGadget[ xGadgetID ].YPos = YPos	
		Else
			XWindow[ xWindowID ].XGadget[ xGadgetID ].XPos = XPos
			XWindow[ xWindowID ].XGadget[ xGadgetID ].YPos = YPos
		Endif
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie la position d'un XGadget dans l'écran principal
 *
 * @Param : XGadgetName = Le nom du gadget à trouver dans l'écran principal
 * @Param : Coordonnée d'abscisse (sur X) du XGadget dans l'écran principal
 * @Param : Coordonnée d'ordonnée (sur Y) du XGadget dans l'écran principal
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXGadgetPositionEx( XGadgetName As String, XPos As Integer, YPos As Integer )
	xGadgetID As Integer = -1
	xGadgetID = XTFindXGadgetIDByName( NULL, XGadgetName )
	if xGadgetID > -1
		OutGadget[ xGadgetID ].XPos = XPos
		OutGadget[ xGadgetID ].YPos = YPos	
	Endif
EndFunction

/* ************************************************************************
 * @Description : This method update text of a XGadget and force it's XWindow to refresh XGadgets view
 *
 * @Param : XWinName = The name of the XWindow in which the XGadget is located
 * @Param : XGadgetName = The name of the XGadget to update
 * @Param : Texte = The new text for the chosen XGadget
 *
 * @Author : Frédéric Cordier
*/
Function SetXGadgetText( XWinName As String, XGadgetName As String, inTexte As String )
	WinNumber As Integer = -1
	GadNumber As Integer = -1
	if XTGetXGadgetExists( XWinName, XGadgetName ) = TRUE
		WinNumber = XTGetXWindowIDByName( XWinName )
		GadNumber = XTGetXGadgetIDByName( XWinName, XGadgetName )
		XWindow[ WinNumber ].XGadget[ GadNumber ].TexteToDisplay = inTexte
		If XWindow[ WinNumber ].Refresh < 4 : XWindow[ WinNumber ].Refresh = 4 : EndIf
	EndIf
EndFunction

/* ************************************************************************
 * @Description : This method check if a specified XGadget exists or not
 *
 * @Param : XWinName = The name of the XWindow in which the XGadget is located
 * @Param : XGadgetName = The name of the XGadget to update
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXGadgetExists( XWinName As String, XGadgetName As String )
	isExist As Integer = 0
	WinNumber As Integer = -1
	gLoop As Integer = -1
	if XTGetXWindowExistsByName( XWinName ) = TRUE
		WinNumber = XTGetXWindowIDByName( XWinName )
		if XWindow[ WinNumber ].XGadget.length > -1
			For gLoop = 0 to XWindow[ WinNumber ].XGadget.length
				if XWindow[ WinNumber ].XGadget[ gLoop ].Name = XGadgetName
					isExist = TRUE
				Endif
			Next gLoop
		Endif
	Endif
EndFunction isExist
	
/* ************************************************************************
 * @Description : This method try to find a XGadget object using it's name
 *
 * @Param : XWinName = The name of the XWindows where the XGadget may be located
 * @Param : XGadgetName = The name of the XGadget that will be searched
 *
 * @Return : gID (Integer) = the ID of the XGadget int the XWinName XWindow if found, otherwise -1
 *
 * @Author :
*/
Function XTGetXGadgetIDByName( XWinName As String, XGadgetName As String )
	gID As integer = -1
	gLoop As Integer = -1
	WinNumber As Integer = -1
	if XTGetXWindowExistsByName( XWinName ) = TRUE
		WinNumber = XTGetXWindowIDByName( XWinName )
		if XWindow[ WinNumber ].XGadget.length > -1
			For gLoop = 0 to XWindow[ WinNumber ].XGadget.length
				if XWindow[ WinNumber ].XGadget[ gLoop ].Name = XGadgetName
					gID = gLoop
				Endif
			Next gLoop
			if gID = -1 then Message( "XTGetXGadgetIDByName Error : the specified XGadget '" + XGadgetName + "' was not found in the specified XWindow '" + XWinName + "'." )
		Else
			Message( "XTGetXGadgetIDByName Error : No XGadget was created in the specified XWindow '" + XWinName + "'." )
		Endif
	Else
		Message( "XTGetXGadgetIDByName Error : The specified XWindow '" + XWinName + "' does not exists." )
	Endif
EndFunction gID
