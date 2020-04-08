//
// **********************************************************
// *                                                        *
// * eXtends Ver 2.0 Include File : eXtends XWindows System *
// *                                                        *
// **********************************************************
// Start Date : -
// Description : This system emulates old basic "Restore LABEL" and "Read DATA"
//               Using disk file that contain Data ??, ??, ... 
// Author : Frédéric Cordier
//
// ************************************************************************ XWindows Setup & Creation commands
// XTCloseXWindowsToClose() // Highly adviced when developper uses ByName methods
// XTCloseXWindowsToHide()  // Highly adviced when developer uses methods that request XWindow's ID
// XTEnableXWindowsAlpha()
// XTDisableXWindowsAlpha()
// SkinLoaded = XTInitializeXWindowSkin( Skin As String )
// SkinInitialized (Boolean) = Internal_XTLoadXWindowSkinGraphics()
// NewXWindowIndex (Boolean) = XTCreateNewXWindow( WinName As String , XSize As Integer , YSize As Integer )
// Internal_XTUpdateXWindow( WWinNumber As Integer )

// ************************************************************************ XWindows methods by ID
// XTDeleteXWindow( WinNumber As Integer )
// isExist (Boolean) = XTGetXWindowExists( WinNumber As Integer )
// XWindow (XWindow_Type) = XTGetXWindow( WinNumber As Integer )
// XTPushXWindowToFront( WinNumber As Integer )
// XTPushXWindowToBack( WinNumber As Integer )
// XTShowXWindow( WinNumber As Integer )
// XTHideXWindow( WinNumber As Integer )
// XTSetWindowAsChat( WinNumber As Integer )
// XTDisableChat()
// XTSetXWindowAlpha( WinNumber As Integer, Alpha As Integer )
// XTSetXWindowPosition( WinNumber As Integer, XPos As Integer, YPos As Integer )
// XTSetXWindowBorder( WinNumber As Integer, Flag as Integer )
// XTSetXWindowTitle( WinNumber As Integer, Flag as Integer )
// XTSetXWindowDragging( WinNumber As Integer, Flag as Integer )
// XTSetXWindowCloseButton( WinNumber As Integer, Flag as Integer )
// XTSetXWindowTitleText( WinNumber As Integer, WindowTitle As String )
// isExist (Boolean) = XTisXWindowVisible( winNumber As Integer )
// XTSetXWindowProperties( WinNumber As Integer, Borders As Integer, Title As Integer, Draggeable As Integer, Close As Integer )
// XTSetXWindowToUseDefaultFont( WinNumber As Integer )
// XTSetXWindowToUseXFont( WinNumber As Integer, XFontID As Integer )
// XTResetXWindowSizesToDefault( WinNumber As Integer )

// ************************************************************************ XWindows methods by Name
// XTDeleteXWindowByName( WinName As String )
// isExist (Boolean) = XTGetXWindowExistsByName( WinName As String )
// XWindow (XWindow_Type) = XTGetXWindowByName( WinName As String )
// XWindowID (Integer) = XTGetXWindowIDByName( WinName As String )
// XTPushXWindowToFrontByName( WinName As String )
// XTPushXWindowToBackByName( WinName As String )
// XTShowXWindowByName( WinName As String )
// XTHideXWindowByName( WinName As String )
// XTSetWindowAsChatByName( WinName As String )
// XTSetXWindowAlphaByName( WinName As String, Alpha As Integer )
// XTSetXWindowBorder( WinName As String, Flag as Integer )
// XTSetXWindowTitle( WinName As String, Flag as Integer )
// XTSetXWindowDragging( WinName As String, Flag as Integer )
// XTSetXWindowCloseButton( WinName As String, Flag as Integer )
// XTSetXWindowTitleText( WinName As String, WindowTitle As String )
// XTisXWindowVisibleByName( WinName As String )
// XTSetXWindowProperties( WinName As String, Borders As Integer, Title As Integer, Draggeable As Integer, Close As Integer )
// XTSetXWindowToUseDefaultFontByName( WinName As String )
// XTSetXWindowToUseXFontByName( WinName As String, XFontID As Integer )
// XTResetXWindowSizesToDefaultByName( WinName As String )

// ************************************************************************ XWindows render methods
// Internal_XTUpdateXWindow( WinNumber As Integer )
// Internal_DrawXWindowTile( ImageID As Integer, XPos As Integer, YPos As Integer )
// XTUpdateXWindows()
// Internal_XTGetXWindowInteractions()

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** XWindow Methods SYSTEM
// *
// *************                                                                                                                           *********************
//

/* ************************************************************************
 * @Description : Active la fermeture réelle (par suppression) des fenêtres XWindow
 *
 * @Author : Frédéric Corider
*/
Function XTCloseXWindowsToClose()
	XWinSystem.CloseMode = 1
EndFunction

/* ************************************************************************
 * @Description : Modifie la fermeture des fenêtres XWindow pour les rendre invisible (cachées) au lieu de les supprimer
 *
 * @Author : Frédéric Corider
*/
Function XTCloseXWindowsToHide()
	XWinSystem.CloseMode = 0
EndFunction

/* ************************************************************************
 * @Description : Active les effets de transparence pour les fenêtres XWindow
 *
 * @Author :  Frédéric Corider
*/
Function XTEnableXWindowsAlpha()
	XWinSystem.AllowAlphaiser = 1
EndFunction

/* ************************************************************************
 * @Description : Désactive les effets de transparence pour les fenêtres XWindow
 *
 * @Author :  Frédéric Corider
*/
Function XTDisableXWindowsAlpha()
	XWinSystem.AllowAlphaiser = 0
EndFunction

/* ************************************************************************
 * @Description : Initialise et télécharge un skin qui sera utilisé pour le rendu graphique des fenêtres XWindow
 *
 * @Param : Skin = Nom du fichier de définition des graphiques du skin
 *
 * @Return : SkinLoaded = TRUE si le skin a pu être initialisé correctement, sinon FALSE.
 *
 * @Author : Frédéric Cordier
*/
Function XTInitializeXWindowSkin( Skin As String )
	ConfigLoaded As Integer = -1
	SkinLoaded As Integer = -1
	FileIO As Integer = -1
	Header As String
	XLoop As Integer = -1
	If GetFileExists( Skin ) = 1
		FileIO = OpenToRead( Skin )
		Header = ReadLine( FileIO )
		If Header = "[XWINDOW_SKIN]"
			XWinSystem.Skin = ReadLine( FileIO )
			For XLoop = 0 To 11
				SkinImage[ XLoop ].Fichier = ReadLine( FileIO )
			Next XLoop
			Sync()
			Header = ReadLine( FileIO )
			ConfigLoaded = TRUE
		Else
			Message( "eXtends - XTInitializeWindowSkin : Le fichier '" + Skin + "' contient des données incorrected" )
		EndIf   
		CloseFile( FileIO )
	Else
		Message( "eXtends - XTInitializeWindowSkin : Le fichier de définition XWindow '" + Skin + "' n'a pas été trouvé" )
	EndIf
	
	If ConfigLoaded = TRUE
		SkinLoaded = Internal_XTLoadXWindowSkinGraphics()
	EndIf
	XWinSystem.OldWindow = -1 : XWinSystem.CurrentWindow = -1
	XWinSystem.DragWindow = - 1 : XWinSystem.AllowDragging = 0
	XWinSystem.SkinLoaded = SkinLoaded
EndFunction SkinLoaded

/* ************************************************************************
 * @Description : Télécharge les images qui composent le skin demandé en initialisation
 *
 * @Return : SkinInit = TRUE si le skin a bien été téléchargé, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function Internal_XTLoadXWindowSkinGraphics()
	SkinInit As Integer = 0 : SkinInit = TRUE // Validé à TRUE tant qu'aucune erreur n'arrive
	Xloop As Integer = 0
	Fichier As String
	For XLoop = 0 To 11
		If GetFileExists( SkinImage[ XLoop ].Fichier ) = 1
			SkinImage[ XLoop ].ImageID = LoadImage( SkinImage[ XLoop ].Fichier , XWinSystem.MipMapMode )
			If SkinImage[ XLoop ].ImageID > 0
				SkinImage[ XLoop ].Width = GetImageWidth( SkinImage[ XLoop ].ImageID )
				SkinImage[ XLoop ].Height = GetImageHeight( SkinImage[ XLoop ].ImageID )
			EndIf
		Else
			Message( "eXtends - XTLoadXWindowSkinGraphics : Le fichier image '" + SkinImage[ XLoop ].Fichier + "' n'a pas été trouvé." )
			SkinInit = FALSE
		EndIf
	Next XLoop
	if SkinInit = FALSE
		for XLoop = 0 To 11
			If SkinImage[ XLoop ].ImageID > 0 Then DeleteImage( SkinImage[ XLoop ].ImageID )
			SkinImage[ XLoop ].Fichier = ""
			SkinImage[ XLoop ].ImageID = 0
			SkinImage[ XLoop ].Width = 0
			SkinImage[ XLoop ].Height = 0
		Next XLoop
		Message( "eXtends - XTLoadXWindowSkinGraphics : Le Skin n'a pas pu être initialisé" )
	Else
	// Si le skin est bien initialisé, on crée le sprite
		if XWinSystem.SkinSprite = 0
			XWinSystem.SkinSprite = CreateSprite( 0 )
		Endif
		SetSpritePosition( XWinSystem.SkinSprite, -1024, -1024 )
	Endif
EndFunction SkinInit

/* ************************************************************************
 * @Description : Créé une nouvelle fenêtre qui sera afiché en utilisant le skin initialisé
 *
 * @Param : WinName = Le nom donné à la fenêtre
 * @Param : XSize = Largeur en pixels de la nouvelle fenêtre
 * @Param : YSize = Hauteur en pixels de la nouvelle fenêtre
 *
 * @Return : L'ID de la nouvelle fenêtre
 *
 * @Author : Frédéric Cordier
*/
Function XTCreateNewXWindow( WinName As String , XSize As Integer , YSize As Integer )
	NewWindow As XWindow_Type
	NewWindow.Exist = TRUE : // Valide la création de la fenêtre.
	NewWindow.Name = WinName : NewWindow.Title = 1 : NewWindow.TitleText = "-= eXtends Ver 2.0 Default XWindow window title =-"
	NewWindow.Format = 0 : // Définit le type de fenêtre ( 0 = Normal , 1 = Chat )
	NewWindow.XSize = XSize : NewWindow.YSize = YSize
	NewWindow.Refresh = 5 : // Force le rafraichissement de l'image complête de la fenêtre.
	NewWindow.Linked = 0 : // La fenêtre est liée à une autre fenêtre .
	NewWindow.Moveable = 1 : // définit la fenêtre comme draggeable ( déplaçable ).
	NewWindow.Close = 1 : // Ajoute le gadget de fermeture de fenêtre.
	NewWindow.Borders = 1 : // Autorise l'affichage des bordures de fenêtre.
	NewWindow.Bgd = 1 : // Autorise l'affichage de la trame de fond de la fenêtre.
	NewWindow.Alpha = 255 : // Valeur d'alpha mapping par défaut.
	NewWindow.Hidden = 0 : // Par défaut, la fenêtre sera visible et pas cachée.
	NewWindow.Xpos = 0 : NewWindow.YPos = 0
	NewWindow.XDSize = 0 : NewWindow.YDSize = 0
	NewWindow.Parent = NULL
	NewWindow.ChildCount = 0
	NewWindow.XFont = 0
	NewWindow.SpriteID = 0
	NewWindow.Hide = 0
	NewWindow.Alignment = 0
	XWindow.insert( NewWindow )
	// On insère la fenêtre créée en fin de liste
	XWinDisplay.insert( XWindow.length )
	newLen As Integer : newLen = XWindow.length
EndFunction newLen

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************ XWindow Methods using ID
// *
// *************                                                                                                                           *********************
//

/* ************************************************************************
 * @Description : Supprime une fenêtre XWindows de la liste des fenêtres
 *
 * @Param : WinNumber = Index de la fenêtre XWindow à Vérifier
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXWindow( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		// On supprime la fenêtre de la liste des fenêtres
		XWindow.remove( WinNumber )
	Endif
EndFunction
/* ************************************************************************
 * @Description : Renvoie TRUE si une fenêtre XWindows existe, sinon FALSE
 *
 * @Param : WinNumber = Index de la fenêtre XWindow à Vérifier
 *
 * @Return : Renvoie TRUE si une fenêtre XWindows existe, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXWindowExists( WinNumber As Integer )
	isExist As Integer : isExist = FALSE
	if WinNumber > -1 and WinNumber < XWindow.length+1
		isExist = XWindow[ WinNumber ].Exist
	Else
		Message( "XTGetXWindowsExists Erreur : Le numéro de fenêtre XWindows #'" + Str( WinNumber ) + "' n'existe pas ou est incorrect" )
	Endif
EndFunction isExist

/* ************************************************************************
 * @Description : Renvoie la structure de la fenêtre XWindow demandée
 *
 * @Param : WinNumber = Index de la fenêtre XWindow à Vérifier
 *
 * @Return : thisWindow = La structure XWindows liée à la fenêtre demandée
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXWindow( WinNumber As Integer )
	thisWindow As XWindow_Type : thisWindow = EmptyXWindow
	if WinNumber > -1 and WinNumber < XWindow.length+1
		thisWindow = XWindow[ WinNumber ]
	Else
		Message( "XTGetXWindowsExists Erreur : Le numéro de fenêtre XWindows #'" + Str( WinNumber ) + "' n'existe pas ou est incorrect" )
	Endif
EndFunction thisWindow

/* ************************************************************************
 * @Description : Positionne une fenêtre XWindows au premier plan (affichée devant toutes les autres)
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTPushXWindowToFront( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		NewWindow As XWindow_Type
		NewWindow = XWindow[ WinNumber ]
		XWindow.remove( WinNumber ) // On supprime la fenêtre XWindow de son emplacement dans la liste
		XWindow.insert( NewWindow ) // On la place directement à la fin de la liste.
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Positionne une fenêtre XWindows au dernier plan (affichée derrière toutes les autres)
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTPushXWindowToBack( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		NewWindow As XWindow_Type
		NewWindow = XWindow[ WinNumber ]
		XWindow.remove( WinNumber ) // On supprime la fenêtre XWindow de son emplacement dans la liste
		XWindow.insert( NewWindow, 0 ) // On la place directement à la fin de la liste.
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Rends à nouveau visible une fenêtre qui était cachée
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTShowXWindow( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		if GetSpriteExists( XWindow[ WinNumber ].SpriteID ) = TRUE
			SetSpriteVisible( XWindow[ WinNumber ].SpriteID, 1 )
			XWindow[ WinNumber ].Hidden = 0
			XWindow[ WinNumber ].Hide = 0
		Else
			XWindow[ WinNumber ].Hide = 3
		Endif
	Else
		Message( "XTShowXWindow error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Cache à nouveau une fenêtre qui était visible
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTHideXWindow( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		if GetSpriteExists( XWindow[ WinNumber ].SpriteID ) = TRUE
			SetSpriteVisible( XWindow[ WinNumber ].SpriteID, 0 )
			XWindow[ WinNumber ].Hidden = 1
			XWindow[ WinNumber ].Hide = 1
		Else
			XWindow[ WinNumber ].Hide = 2
		Endif
	Else
		Message( "XTShowXWindow error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active le mode chat dans une fenêtre XWindow
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTSetWindowAsChat( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		// Si une autre fenêtre était en mode Chat, on désactive cette fonctionnalité pour cette autre fenêtre
		XTDisableChat()
		// On active le chat pour la nouvelle fenêtre choisié
		XWindow[ WinNumber ].Format = 1
		XWinSystem.ChatWindowWindowName = XWindow[ WinNumber ].Name
	Else
		Message( "XTSetWindowAsChat error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Désactive le mode chat (en désactivant la fenêtre où il était actif
 *
 * @Author : Frédéric Cordier
*/
Function XTDisableChat()
	If Len( XWinSystem.ChatWindowWindowName ) > 0
		WinToDisableChat As Integer = -1
		WinToDisableChat = XTGetXWindowIDByName( XWinSystem.ChatWindowWindowName )
		XWindow[ WinToDisableChat ].Format = 0
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie la valeur du canal de transparence Alpha de la fenêtre XWindow
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : Alpha = Valeur de transparence de 0 (invisible) à 255 (opaque)
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowAlpha( WinNumber As Integer, Alpha As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		If Alpha > 255 then Alpha = 255
		If Alpha < 0 Then Alpha = 0
		XWindow[ WinNumber ].Alpha = Alpha
		If XWindow[ WinNumber ].Refresh = 0 Then XWindow[ WinNumber ].Refresh = 1
	Else
		Message( "XTSetXWindowAlpha error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction
	
/* ************************************************************************
 * @Description : Modifie la position de la fenêtre XWindow dans l'écran
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : XPos = Nouvelle coordonnée d'abscisse (sur X) de la fenêtre
 * @Param : YPos = Nouvelle coordonnée d'ordonnée (sur Y) de la fenêtre
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowPosition( WinNumber As Integer, XPos As Integer, YPos As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].XPos = XPos
		XWindow[ WinNumber ].YPos = YPos
		If XWindow[ WinNumber ].Refresh = 0 Then Xwindow[ WinNumber ].Refresh = 1
	Else
		Message( "XTSetXWindowPosition error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive l'affichage de la bordure de la fenêtre XWindow
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : Flag = TRUE pour bordure visible et = FALSE pour bordure invisible
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowBorder( WinNumber As Integer, Flag as Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].Borders = Flag
	Else
		Message( "XTSetXWindowBorder error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive l'affichage du titre de la fenêtre XWindow
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : Flase = TRUE pour affichage du titre et = FALSE pour masquer le titre
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowTitle( WinNumber As Integer, Flag as Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].Title = Flag
	Else
		Message( "XTSetXWindowTitle error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive la possibilité de déplacer une fenêtre en cliquant/tappant sur son titre (et en se déplaçant)
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : Flag = TRUE pour activer le déplacement de la fenêtre et = FALSE pour forcer la position statique de la fenêtre
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowDragging( WinNumber As Integer, Flag as Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].Moveable = Flag
	Else
		Message( "XTSetXWindowDragging error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive l'affichage du bouton de fermeture de la fenêtre XWindow
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : Flag = TRUE pour l'affichage du bouton et = FALSE pour masquer le bouton
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowCloseButton( WinNumber As Integer, Flag as Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].Close = Flag
	Else
		Message( "XTSetXWindowCloseButton error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active l'affichage du titre, et redéfinit ce dernier
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 * @Param : WindowTitle = Le nouveau titre à donner à la fenetre XWindow
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowTitleText( WinNumber As Integer, WindowTitle As String )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].Title = TRUE
		XWindow[ WinNumber ].Borders = TRUE
		XWindow[ WinNumber ].TitleText = WindowTitle
	Else
		Message( "XTSetXWindowTitle error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Renvoie TRUS si la fenêtre XWindow est visible, sinon FALSE
 *
 * @Param : WinNumber = Index de la fenêtre dans la liste
 *
 * @Return : Renvoie TRUE si la fenêtre XWindow est visible, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function XTisXWindowVisible( winNumber As Integer )
	isVisible As Integer = 0
	if XTGetXWindowExists( WinNumber ) = TRUE
		isVisible = XWindow[ WinNumber ].hide
	Else
		Message( "XTSetXWindowTitle error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction isVisible

/* ************************************************************************
 * @Description : This method allow user to change XWindow properties
 *
 * @Param : WinNumber = Index of the XWindow in the list
 * @Param : Borders = 1 to render borders, otherwise 0
 * @Param : Title = 1 to render title, otherwise 0
 * @Param : Draggeable = 1 to makes XWindow moving capability with mouse/tap active, otherwise 0
 * @Param : Close = 1 to allow close gadget, otherwise 0
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowProperties( WinNumber As Integer, Borders As Integer, Title As Integer, Draggeable As Integer, Close As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].Borders = Borders
		XWindow[ WinNumber ].Title = Title
		XWindow[ WinNumber ].Moveable = Draggeable
		XWindow[ WinNumber ].Close = Close
		XWindow[ WinNumber ].Refresh = 5
	Else
		Message( "XTSetXWindowProperties error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Set a XWindow to use default font (no XFont)
 *
 * @Param : WinNumber = Index of the XWindow in the list
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowToUseDefaultFont( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].XFont = 0
		If XWindow[ WinNumber ].Refresh < 3 then XWindow[ WinNumber ].Refresh = 3
	Else
		Message( "XTSetXWindowToUseDefaultFont error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Set a XWindow to use a chosen XFont
 *
 * @Param : WinNumber = Index of the XWindow in the list
 * @Param : XFontID = The index of the XFont to use
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowToUseXFont( WinNumber As Integer, XFontID As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		if XTGetXFontExist( XFontID ) = TRUE
			XWindow[ WinNumber ].XFont = XFontID
			If XWindow[ WinNumber ].Refresh < 3 then XWindow[ WinNumber ].Refresh = 3
		Else
		Message( "XTSetXWindowToUseXFont error : Requested XFont ID '" + Str( WinNumber ) + "' is invalid or XFont does not exist" )
		Endif
	Else
		Message( "XTSetXWindowToUseXFont error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : This method reset a XWindow zoom factor to 100% (=original size)
 *
 * @Param : WinNumber = Index of the XWindow in the list
 *
 * @Author : Frédéric Cordier
*/
Function XTResetXWindowSizesToDefault( WinNumber As Integer )
	if XTGetXWindowExists( WinNumber ) = TRUE
		XWindow[ WinNumber ].XDSize = 0
		XWindow[ WinNumber ].YDSize = 0
		XWindow[ WinNumber ].Refresh = 5
	Else
		Message( "XTResetXWindowSizesToDefault error : Requested Window ID '" + Str( WinNumber ) + "' is invalid or window does not exist" )
	Endif
EndFunction
	


//
// *********************                                                                                                                 *************
// *
// ************************************************************************************************************************ XWindow Methods using NAME
// *
// *************                                                                                                                 *********************
//

/* ************************************************************************
 * @Description : Supprime une fenêtre XWindows de la liste des fenêtres
 *
 * @Param : WinNumber = Index de la fenêtre XWindow à Vérifier
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXWindowByName( WinName As String )
	winNumber As integer = -1
	winNumber = XTGetXWindowIDByName( WinName )
	XTDeleteXWindow( WinNumber )
EndFunction


/* ************************************************************************
 * @Description : Renvoie TRUE si une fenêtre XWindows existe, sinon FALSE
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Return : Renvoie TRUE si une fenêtre XWindows existe, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXWindowExistsByName( WinName As String )
	isExist As Integer : isExist = FALSE
	wLoop As Integer = 0
	If XWindow.length > -1
		For wLoop = 0 to XWindow.length Step 1
			If XWindow[ wLoop ].Name = WinName
				isExist = XWindow[ wLoop ].Exist
			Endif
		Next wLoop
	Else
		Message( "XTGetXWindowsExistsByName Erreur : Aucune fenêtre XWindows n'existe" )
	Endif
EndFunction isExist

/* ************************************************************************
 * @Description : Renvoie la structure de la fenêtre XWindow demandée
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Return : thisWindow = La structure XWindows liée à la fenêtre demandée
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXWindowByName( WinName As String )
	thisWindow As XWindow_Type : thisWindow = EmptyXWindow
	thisWindowID As Integer = -1
	thisWindowID = XTGetXWindowIDByName( WinName )
	If thisWindowID > -1 then thisWindow = XWindow[ thisWindowID ]
EndFunction thisWindow

/* ************************************************************************
 * @Description : Renvoie le numéro d'index de la fenêtre XWindow demandée
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Return : thisWindowID = Le numéro d'index de la fenêtre XWindow demandée, sinon -1 si elle n'existe pas.
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXWindowIDByName( WinName As String )
	thisWindowID As Integer = -1
	wLoop As Integer = 0
	if WinName = "" or WinName = NULL
		thisWindowID = -1
	Else
		If XWindow.length > -1
			For wLoop = 0 to XWindow.length Step 1
				If XWindow[ wLoop ].Name = WinName
					thisWindowID = wLoop
				Endif
			Next wLoop
		Else
			Message( "XTGetXWindowsExistsByName Erreur : Aucune fenêtre XWindows n'existe" )
		Endif
	Endif
EndFunction thisWindowID

/* ************************************************************************
 * @Description : Positionne une fenêtre XWindows au premier plan (affichée devant toutes les autres)
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTPushXWindowToFrontByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTPushXWindowToFront( thisWindow )
	Else
		Message( "XTPushXWindowToFrontByName Erreur : La fenêtre '" + WinName + "' n'a pas été trouvée" )
	Endif
EndFunction 

/* ************************************************************************
 * @Description : Positionne une fenêtre XWindows au dernier plan (affichée derrière toutes les autres)
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTPushXWindowToBackByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTPushXWindowToBack( thisWindow )
	Else
		Message( "XTPushXWindowToBackByName Erreur : La fenêtre '" + WinName + "' n'a pas été trouvée" )
	Endif
EndFunction 

/* ************************************************************************
 * @Description : Rends à nouveau visible une fenêtre qui était cachée
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTShowXWindowByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTShowXWindow( thisWindow )
	Else
		Message( "XTShowXWindowByName Erreur : La fenêtre '" + WinName + "' n'a pas été trouvée" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Cache à nouveau une fenêtre qui était visible
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTHideXWindowByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTHideXWindow( thisWindow )
	Else
		Message( "XTHideXWindowByName Erreur : La fenêtre '" + WinName + "' n'a pas été trouvée" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active le mode chat dans une fenêtre XWindow
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTSetWindowAsChatByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetWindowAsChat( thisWindow )
	Else
		Message( "XTSetWindowAsChatByName Erreur : La fenêtre '" + WinName + "' n'a pas été trouvée" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Modifie la valeur du canal de transparence Alpha de la fenêtre XWindow
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : Alpha = Valeur de transparence de 0 (invisible) à 255 (opaque)
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowAlphaByName( WinName As String, Alpha As Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowAlpha( thisWindow, Alpha )
	Else
		Message( "XTSetWindowAsChatByName Erreur : La fenêtre '" + WinName + "' n'a pas été trouvée" )
	Endif
EndFunction
	
/* ************************************************************************
 * @Description : Modifie la position de la fenêtre XWindow dans l'écran
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : XPos = Nouvelle coordonnée d'abscisse (sur X) de la fenêtre
 * @Param : YPos = Nouvelle coordonnée d'ordonnée (sur Y) de la fenêtre
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowPositionByName( WinName As String, XPos As Integer, YPos As Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowPosition( thisWindow, XPos, YPos )
	Else
		Message( "XTSetXWindowPositionByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive l'affichage de la bordure de la fenêtre XWindow
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : Flag = TRUE pour bordure visible et = FALSE pour bordure invisible
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowBorderByName( WinName As String, Flag as Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowBorder( thisWindow, Flag )
	Else
		Message( "XTSetXWindowBorderByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive l'affichage du titre de la fenêtre XWindow
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : Flase = TRUE pour affichage du titre et = FALSE pour masquer le titre
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowTitleByName( WinName As String, Flag as Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowTitle( thisWindow, Flag )
	Else
		Message( "XTSetXWindowTitleByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive la possibilité de déplacer une fenêtre en cliquant/tappant sur son titre (et en se déplaçant)
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : Flag = TRUE pour activer le déplacement de la fenêtre et = FALSE pour forcer la position statique de la fenêtre
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowDraggingByName(WinName As String, Flag as Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowDragging( thisWindow, Flag )
	Else
		Message( "XTSetXWindowDraggingByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active ou désactive l'affichage du bouton de fermeture de la fenêtre XWindow
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : Flag = TRUE pour l'affichage du bouton et = FALSE pour masquer le bouton
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowCloseButtonByName( WinName As String, Flag as Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowCloseButton( thisWindow, Flag )
	Else
		Message( "XTSetXWindowCloseButtonByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Active l'affichage du titre, et redéfinit ce dernier
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : WindowTitle = Le nouveau titre à donner à la fenetre XWindow
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowTitleTextByName( WinName As String, WindowTitle As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		XTSetXWindowTitleText( thisWindow, WindowTitle )
	Else
		Message( "XTSetXWindowTitleTextByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Renvoie TRUS si la fenêtre XWindow est visible, sinon FALSE
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Return : Renvoie TRUE si la fenêtre XWindow est visible, sinon FALSE
 *
 * @Author :
*/
Function XTisXWindowVisibleByName( WinName As String )
	isVisible As Integer = 0
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on la déplace à l'avant avec la méthode par n° d'index.
	if thisWindow > -1
		isVisible = XTisXWindowVisible( thisWindow )
	Else
		Message( "XTisXWindowVisibleByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction isVisible

/* ************************************************************************
 * @Description : This method allow user to change XWindow properties
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : Borders = 1 to render borders, otherwise 0
 * @Param : Title = 1 to render title, otherwise 0
 * @Param : Draggeable = 1 to makes XWindow moving capability with mouse/tap active, otherwise 0
 * @Param : Close = 1 to allow close gadget, otherwise 0
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowPropertiesByName( WinName As String, Borders As Integer, Title As Integer, Draggeable As Integer, Close As Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XTSetXWindowProperties( thisWindow, Borders, Title, Draggeable, Close )
	Else
		Message( "XTSetXWindowPropertiesByName Erreur : Requested Window ID '" + Str( thisWindow ) + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Set a XWindow to use default font (no XFont)
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowToUseDefaultFontByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XTSetXWindowToUseDefaultFont( thisWindow )
	Else
		Message( "XTSetXWindowToUseDefaultFontByName Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Set a XWindow to use a chosen XFont
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 * @Param : XFontID = The index of the XFont to use
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXWindowToUseXFontByName( WinName As String, XFontID As Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XTSetXWindowToUseXFont( thisWindow, XFontID )
	Else
		Message( "XTSetXWindowToUseDefaultFontByName Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : This method reset a XWindow zoom factor to 100% (=original size)
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Author : Frédéric Cordier
*/
Function XTResetXWindowSizesToDefaultByName( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XTResetXWindowSizesToDefault( thisWindow )
	Else
		Message( "XTSetXWindowToUseDefaultFontByName Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction


//
// *********************                                                                                                                           *************
// *
// ********************************************************************************************************************************** XWindow Methods **********
// *
// *************                                                                                                                           *********************
//


/* ************************************************************************
 * @Description : This method update a single XWindow
 *
 * @Param : WinNumber = the index of the XWindow to refresh for display
 *
 * @Author : Frédéric Cordier
*/
Function Internal_XTUpdateXWindow( WinNumber As Integer )
	XLoop As Integer = 0 : YLoop As Integer = 0
	XPos As Integer = 0
	PreviousFONT As Integer = -1
	XMin As Integer : YMin As Integer
	XMax As Integer : YMax As Integer
	VirtX As Integer : VirtY As Integer
	VirtX = GetVirtualWidth() : VirtY = GetVirtualHeight()
	if XTGetXWindowExists( WinNumber ) = TRUE
		if XWindow[ WinNumber ].Refresh > 0 then SetSpriteVisible( XWinSystem.SkinSprite, 1 )
		// Rafraichissement étape 5 : On Supprime l'image de rendu car elle ne correspond plus aux besoins. Cela force sa re-création à la suite/volée.
		if XWindow[ WinNumber ].Refresh = 5
			If XWindow[ WinNumber ].RenderImage > 0
				DeleteImage( XWindow[ WinNumber ].RenderImage )
				XWindow[ WinNumber ].RenderImage = 0
			Endif
			XWindow[ WinNumber ].Refresh = 4 // On passe à l'étape de rafraichissement suivante : 4
		Endif
		// Rafraichissement étape 5-4-START : Si l'image de rendu n'existe pas, on la créé étape 5->4
		if XWindow[ WinNumber ].RenderImage = 0
			XWindow[ WinNumber ].RenderImage = CreateRenderImage( XWindow[ WinNumber ].XSize, XWindow[ WinNumber ].YSize, 0, 0 )
		Endif
		// Positionne le rendu vers l'image
		if XWindow[ WinNumber ].Refresh > 2
			SetRenderToImage( XWindow[ WinNumber ].RenderImage, 0 )
			SetVirtualResolution( XWindow[ WinNumber ].XSize, XWindow[ WinNumber ].YSize )
			ClearScreen()
		Endif
		// Rafraichissement étape 4 : On redéssine la fenêtre avec le Skin chargé en mémoire.
		if XWindow[ WinNumber ].Refresh = 4
			XWindow[ WinNumber ].Refresh = 3
			// Si la fenêtre XWindow est configuré pour un background.
			if XWindow[ WinNumber ].bgd = 1
				SetSpriteImage( XWinSystem.SkinSprite, SkinImage[ 4 ].ImageID )
				SetSpriteSize( XWinSystem.SkinSprite, -1, -1 )
				YLoop = 0
				Repeat
					XLoop = 0
					Repeat
						SetSpritePosition( XWinSystem.SkinSprite, XLoop, YLoop )
						DrawSprite( XWinSystem.SkinSprite )
						XLoop = XLoop + SkinImage[ 4 ].Width
					Until XLoop > XWindow[ WinNumber ].XSize
					YLoop = YLoop + SkinImage[ 4 ].Height
				Until YLoop > XWindow[ WinNumber ].YSize
			Endif
			// Si les bordures sont activées, on les rafraîchit

			If XWindow[ WinNumber ].Borders = 1
				// Tracé de la bordure HAUTE
				XLoop = 0
				Repeat
					Internal_DrawXWindowTile( SkinImage[ 1 ].ImageID, XLoop, 0 )
					Internal_DrawXWindowTile( SkinImage[ 7 ].ImageID , XLoop, XWindow[ WinNumber ].YSize - SkinImage[ 7 ].Height )
					XLoop = XLoop + SkinImage[ 1 ].Width
				Until XLoop > XWindow[ WinNumber ].XSize
				// Tracé de la bordure BASSE
				/*XLoop = 0
				Repeat
					Internal_DrawXWindowTile( SkinImage[ 7 ].ImageID , XLoop, XWindow[ WinNumber ].YSize - SkinImage[ 7 ].Width )
					XLoop = XLoop + SkinImage[ 7 ].Width
				Until XLoop > XWindow[ WinNumber ].XSize */
				// Tracé de la bordure GAUCHE
				YLoop = 0
				Repeat
					Internal_DrawXWindowTile( SkinImage[ 3 ].ImageID, 0, YLoop )
					Internal_DrawXWindowTile(  SkinImage[ 5 ].ImageID , XWindow[ WinNumber ].XSize - SkinImage[ 5 ].Width, YLoop )
					YLoop = YLoop + SkinImage[ 3 ].Height
				Until YLoop > XWindow[ WinNumber ].YSize
				// Tracé de la bordure DROITE
				/* YLoop = 0
				Repeat
					Internal_DrawXWindowTile(  SkinImage[ 5 ].ImageID , XWindow[ WinNumber ].XSize - SkinImage[ 5 ].Height, YLoop )
					YLoop = YLoop + SkinImage[ 5 ].Height
				Until XLoop > XWindow[ WinNumber ].YSize */
			Endif

			// Tracé du titre si ce dernier est demandé
			if XWindow[ WinNumber ].Title = 1
				// On trace la barre graphique dans laquelle le texte sera présent
				XLoop = 0
				Repeat
					Internal_DrawXWindowTile( SkinImage[ 9 ].ImageID, XLoop, 0 )
					XLoop = XLoop + SkinImage[ 9 ].Width
				Until XLoop > XWindow[ WinNumber ].XSize
				// On trace ensuite le texte de titre de la fenêtre en mode XFont ou Texte Simple
				if XWindow[ WinNumber ].XFont = 0 // Pas de XFont définie pour cette fenêtre, on trace le texte en mode texte simple
					// Ajouter le mode d'écriture texte simple sans aucune XFont
					if XWinSystem.CurrentTextFont = -1
						XWinSystem.CurrentTextFont = CreateText( XWindow[ WinNumber ].TitleText )
					Else
						SetTextString( XWinSystem.CurrentTextFont, XWindow[ WinNumber ].TitleText )
					Endif
					SetTextSize( XWinSystem.CurrentTextFont, 15 )
					SetTextColor( XWinSystem.CurrentTextFont, 255, 255, 255, 255 )
					XPos = ( XWindow[ WinNumber ].XSize - GetTextTotalWidth( XWinSystem.CurrentTextFont ) ) / 2
					SetTextPosition( XWinSystem.CurrentTextFont, XPos, 0 )
					DrawText( XWinSystem.CurrentTextFont )
					SetTextPosition( XWinSystem.CurrentTextFont, -16384, -16384 )
				Else
				// Une XFont a été définie, on trace alors le texte en utilisant la XFont choisie
					PreviousFONT = XTGetCurrentXFont()
					XTSetCurrentXFont( XWindow[ WinNumber ].XFont )
					XPos = ( XWindow[ WinNumber ].XSize - XTGetXFontTextWidth( XWindow[ WinNumber ].TitleText ) ) / 2
					XTSetXFontCursor( XPos, 0 )
					XTPrintXFontFast( XWindow[ WinNumber ].TitleText, 0 )
				Endif

				// Tracé d'un des coins
				Internal_DrawXWindowTile( SkinImage[ 10 ].ImageID, 0, 0 )
			Else
				// Tracé d'un des coins
				Internal_DrawXWindowTile( SkinImage[ 0 ].ImageID, 0, 0 )
			Endif
			// Tracé des 3 autres coins
			If XWindow[ WinNumber ].Close = 0
				If XWindow[ WinNumber ].Title = 0
					Internal_DrawXWindowTile( SkinImage[ 2 ].ImageID , XWindow[ WinNumber ].XSize - SkinImage[ 2 ].Width , 0 )
				EndIf
			Else
				Internal_DrawXWindowTile( SkinImage[ 11 ].ImageID  , XWindow[ WinNumber ].XSize - SkinImage[ 11 ].Width , 0 )
			EndIf
			Internal_DrawXWindowTile( SkinImage[ 6 ].ImageID  , 0 , XWindow[ WinNumber ].YSize - SkinImage[ 6 ].Width )
			Internal_DrawXWindowTile( SkinImage[ 8 ].ImageID  , XWindow[ WinNumber ].XSize - SkinImage[ 8 ].Width , XWindow[ WinNumber ].YSize - SkinImage[ 8 ].Height )
		Endif
		// On rafraîchit les gadgets présents dans la fenêtre XWindow

		If XWindow[ WinNumber ].Refresh = 3
			XWindow[ WinNumber ].Refresh = 2
			if XWindow[ WinNumber ].XGadget.length > -1
				For XLoop = 0 to XWindow[ WinNumber ].XGadget.length
					XTRefreshXGadgetFast( XWindow[ WinNumber ].XGadget[ XLoop ] )
				Next XLoop
			Endif
			// On rafraîchit l'image de la fenêtre XWindow réactualisée - plus nécessaire avec les RenderImage.
			// XWindow[ WinNumber ].ImageID = GetImage( 0 , 0 , XWindow[ WinNumber ].XSize , XWindow[ WinNumber ].YSize ) // , XWinSystem.MipMapMode ) is not supported in AGK
		Endif

		XMin = XWindow[ WinNumber ].XMin 
		YMin = XWindow[ WinNumber ].YMin
		XMax = XTGetXBitmapWidth( NULL ) - XWindow[ WinNumber ].XLimit
		YMax = XTGetXBitmapHeight( NULL ) - XWindow[ WinNumber ].YLimit
		If XWindow[ WinNumber ].Xpos < XMin : XWindow[ WinNumber ].Xpos = XMin : EndIf
		If XWindow[ WinNumber ].Xpos > XMax : XWindow[ WinNumber ].Xpos = XMax : EndIf
		If XWindow[ WinNumber ].Ypos < YMin : XWindow[ WinNumber ].Ypos = YMin : EndIf
		If XWindow[ WinNumber ].Ypos > YMax : XWindow[ WinNumber ].Ypos = YMax : EndIf
		// XWindow_RepositionAttached( WinNum )
		// ImageID As Integer
		// ImageID = GetImage( 0, 0, XWindow[ WinNumber ].XSize, XWindow[ WinNumber ].YSize )
		if XWindow[ WinNumber ].SpriteID = 0
			XWindow[ WinNumber ].SpriteID = CreateSprite( XWindow[ WinNumber ].RenderImage )
		Else
			SetSpriteImage( XWindow[ WinNumber ].SpriteID, XWindow[ WinNumber ].RenderImage )
		Endif
		// DrawSprite( Xwindow[ WinNumber ].SpriteID )

		// Si la fenêtre est en SCALING, alors on applique le Zoom
		If XWindow[ WinNumber ].Refresh = 2
			XWindow[ WinNumber ].Refresh = 1
			If XWindow[ WinNumber ].XDSize > 0 And XWindow[ WinNumber ].YDSize > 0
				XPercent As Float : XPercent = ( 100.0 * XWindow[ WinNumber ].XDSize ) / XWindow[ WinNumber ].XSize
				YPercent As Float : YPercent = ( 100.0 * XWindow[ WinNumber ].YDSize ) / XWindow[ WinNumber ].YSize
				SetSpriteScale( XWindow[ WinNumber ].SpriteID , XPercent , YPercent )
			EndIf
		EndIf
		If XWindow[ WinNumber ].Refresh = 1
			XWindow[ WinNumber ].Refresh = 0
			SetSpriteColorAlpha( XWindow[ WinNumber ].SpriteID, XWindow[ WinNumber ].Alpha )
			SetSpriteVisible( XWinSystem.SkinSprite, 0 )
		Endif
		// DeleteSprite( XWinSystem.SkinSprite )
		// XWinSystem.SkinSprite = 0
	Else
		Message( "Internal_XTUpdateXWindow Erreur : Le numéro d'index '" + Str( WinNumber ) + "' de la fenêtre est invalide ou la fenêtre n'existe pas." )
	Endif
	SetRenderToScreen()
	SetSpriteSize( XWindow[ WinNumber ].SpriteID, -1, -1 )
	SetSpritePosition( Xwindow[ WinNumber ].SpriteID, XWindow[ WinNumber ].XPos, XWindow[ WinNumber ].YPos )
	SetVirtualResolution( VirtX, VirtY )
EndFunction

/* ************************************************************************
 * @Description : Internal method to trace a tile of the XWindow inside the RenderImage created for it
 *
 * @Param : ImageID = The index of the image to draw in the XWindow Render Image
 * @Param : XPos = The X coordinate where the image will start to be drawn
 * @Param : YPos = The Y coordinate where the image will start to be drawn
 *
 * @Author : Frédéric Cordier
*/
Function Internal_DrawXWindowTile( ImageID As Integer, XPos As Integer, YPos As Integer )
	If XWinSystem.SkinSprite = 0
		XWinSystem.SkinSprite = CreateSprite( ImageID )
	Else
		SetSpriteImage( XWinSystem.SkinSprite, ImageID )
	Endif
	SetSpriteSize( XWinSystem.SkinSprite, -1, -1 )
	SetSpritePosition( XWinSystem.SkinSprite, XPos, YPos )
	DrawSprite( XWinSystem.SkinSprite )
EndFunction

/* ************************************************************************
 * @Description : This method will refresh the entire XWindow System
 *
 * @Author : Frédéric Cordier
*/
Function XTUpdateXWindows()
	xwLoop As Integer = -1
	// Refresh all XWindow objects
	if XWindow.length > -1
		For xwLoop = 0 to XWindow.length
			// Update the XWindow Object
			Internal_XTUpdateXWindow( xwLoop )
			// Calculate XWindow visibility
			Select XWindow[ xwLoop ].Hide
				Case 2:
					SetSpriteVisible( XWindow[ xwLoop ].SpriteID, 0 )
					XWindow[ xwLoop ].Hide = 1
				EndCase
				Case 3:
					SetSpriteVisible( XWindow[ xwLoop ].SpriteID, 1 )
					// Display in order or in reversed order.
					if XWinSystem.CheckPriorities = 0
						SetSpriteDepth( XWindow[ xwLoop ].SpriteID, xwLoop + 11 ) // + 11 to be sure that Sprites will be drawn over 2D Graphics
					Else
						SetSpriteDepth( XWindow[ xwLoop ].SpriteID, ( XWindow.length - xwLoop ) + 11 )
					Endif
					XWindow[ xwLoop ].Hide = 0
				EndCase
			EndSelect
		Next xwLoop
		XWinSystem.CheckPriorities = 0

		Internal_XTGetXWindowInteractions() // Calculate all interactions (movements, clicks, etc...)
		// Si l'on est pas en mode saisie de texte, on vérifie si la touche de saisie de texte a été préssée 
		If XWinSystem.ChatGadgetExist > 0
			If XWinSystem.ChatReading = 0
				If XWinSystem.ChatScanCode <> 0
					// Si la touche a été préssée alors on enclenche le mode SAISIE DE TEXTE POUR LE CHAT :)
					If GetRawKeyState( XWinSystem.ChatScanCode ) = 1
						XWinSystem.ChatReading = 1
						XWinSystem.ChatInText = "\"
						XWinSystem.LastKey = XWinSystem.ChatScanCode
					EndIf
				EndIf
			Else
				// Si l'on est dans le mode chat.
				NewKey As Integer : NewKey = GetRawLastKey() : MajMode As Integer = 0 : // MajMode = DBShiftKey()
				If NewKey > 0 And NewKey <> XWinSystem.LastKey
					// On gère tout d'abord les touches systèmes.
					Select NewKey
						// Supprimer le dernier caractère.
						// Touches Escape pour annuler le texte.et désactiver le mode de saisie de texte.
						Case 1
							XWinSystem.ChatInText = " "
							SetXGadgetText( XWinSystem.ChatGadgetWindowName, XWinSystem.ChatGadgetName , XWinSystem.ChatInText )
							NewKey = 0 : XWinSystem.ChatReading = 0
						EndCase
						Case 14
							If Len( XWinSystem.ChatInText ) > 1
								XWinSystem.ChatInText = Left( XWinSystem.ChatInText , Len( XWinSystem.ChatInText ) - 1 )
								SetXGadgetText( XWinSystem.ChatGadgetWindowName, XWinSystem.ChatGadgetName , XWinSystem.ChatInText )
								XWinSystem.ChatInText = "\"
								SetXGadgetText( XWinSystem.ChatGadgetWindowName, XWinSystem.ChatGadgetName , XWinSystem.ChatInText )
							EndIf
							NewKey = 0
						EndCase
						// Touches Entrée 1 pour valider le texte.et désactiver le mode de saisie de texte.
						Case 28
							If Len( XWinSystem.ChatInText ) > 0
								XWinSystem.ChatInText = Right( XWinSystem.ChatInText , Len( XWinSystem.ChatInText ) - 1 )
								// XWindow_TalkToChatInternal( XWinSystem.ChatInText ) // A réinjecter
							EndIf
							XWinSystem.ChatInText = ""
							SetXGadgetText( XWinSystem.ChatGadgetWindowName, XWinSystem.ChatGadgetName , XWinSystem.ChatInText )
							NewKey = 0 : XWinSystem.ChatReading = 0
						EndCase
						// Touches Entrée 2 pour valider le texte.et désactiver le mode de saisie de texte.
						Case 156
							If Len( XWinSystem.ChatInText ) > 0
								XWinSystem.ChatInText = Right( XWinSystem.ChatInText , Len( XWinSystem.ChatInText ) - 1 )
								// XWindow_TalkToChatInternal( XWinSystem.ChatInText ) // A réinjecter
							EndIf
							XWinSystem.ChatInText = ""
							SetXGadgetText( XWinSystem.ChatGadgetWindowName, XWinSystem.ChatGadgetName , XWinSystem.ChatInText )
							NewKey = 0 : XWinSystem.ChatReading = 0
						EndCase
					EndSelect
					// On gère ensuite les textes
					If NewKey > 0
//						XWinSystem.ChatInText = XWinSystem.ChatInText + ChatChar( NewKey )
						If MajMode = 1
							XWinSystem.ChatInText = XWinSystem.ChatInText + Upper( ChatChar[ NewKey ] )
						Else
							XWinSystem.ChatInText = XWinSystem.ChatInText + Lower( ChatChar[ NewKey ] )
						EndIf
						SetXGadgetText( XWinSystem.ChatGadgetWindowName, XWinSystem.ChatGadgetName , XWinSystem.ChatInText )
					EndIf
				EndIf
				XWinSystem.LastKey = NewKey
			EndIf
		EndIf
	Endif
	// Add render for XGadget(s) that are directly on Screen
EndFunction	
		
/* ************************************************************************
 * @Description : This method handle all interactions between XWindow+XGadget and user
 *
 * @Author : Frédéric Cordier
*/
Function Internal_XTGetXWindowInteractions()
	XLoop As Integer = -1
	WinNum As Integer = -1
	XPosIn As Integer : YPosIn As Integer
	XM As Integer : XM = GetRawMouseX()
	YM As Integer : YM = GetRawMouseY()
	MC As Integer : MC = GetRawMouseLeftState()
	If MC = 0 Then XWinSystem.DragWindow = - 1
	XWinSystem.CurrentGadget = 0
	XWinSystem.OldWindow = XWinSystem.CurrentWindow
	If XWinSystem.DragWindow = - 1
		XWinSystem.CurrentWindow = - 1
		// S'il existe au moins 1 fenêtre XWindow d'ouverte
		If XWinDisplay.length > -1
			For XLoop = XWinDisplay.length To 0 Step -1
				WinNum = XWinDisplay[ XLoop ]
				// Si le curseur de la souris se trouve dans la fenêtre alors on active la fenêtre en question comme fenêtre courante
				If XWindow[ WinNum ].Hide = 0
					If XM >= XWindow[ WinNum ].XPos And YM >= XWindow[ WinNum ].YPos
						If XM <= XWindow[ WinNum ].Xpos + XWindow[ WinNum ].XSize
							If YM <= XWindow[ WinNum ].YPos + XWindow[ WinNum ].YSize
								If XWinSystem.CurrentWindow = -1
									XWinSystem.CurrentWindow = WinNum
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next XLoop
		EndIf
		// On vérifie la position de la souris dans la fenêtre. Si on peut déplacer la fenêtre ?
		If XWinSystem.CurrentWindow > -1
			YPosIn = YM - XWindow[ XWinSystem.CurrentWindow ].YPos
			If YPosIn < 16 And XWindow[ XWinSystem.CurrentWindow ].Moveable = 1 // Si la souris est dans la barre de titre et que la fenêtre est déplaçable
				XWinSystem.AllowDragging = 1
			Else
				XWinSystem.AllowDragging = 0
			EndIf
			// Si le curseur de la souris est dans la zone de déplacement alors, on calcule si on la déplace, ferme , etc...
			XPosIn = XM - XWindow[ XWinSystem.CurrentWindow ].XPos
			// Vérifie que la fenêtre ne soit pas une fenêtre attachée à une autre.
			If MC = 1 And XWinSystem.OldMouseClick = 0
				// Lorsque l'on est dans une fenetre, si l'on clique dessus, elle passe auto au premier plan.
				If XWinDisplay[ XWinDisplay[ 0 ] ] <> XWinSystem.CurrentWindow
					XTPushXWindowToFront( XWinSystem.CurrentWindow )
				EndIf
				// Mise en place du déplacement de fenêtre.
				If XPosIn < XWindow[ XWinSystem.CurrentWindow ].XSize - SkinImage[ 11 ].Width And YPosIn <= SkinImage[ 11 ].Height
					If XWinSystem.DragWindow = -1 And XWinSystem.AllowDragging = 1 And XWindow[ XWinSystem.CurrentWindow ].Parent = NULL
						XWinSystem.DragWindow = XWinSystem.CurrentWindow
						XWinSystem.XDragOrigin = XWindow[ XWinSystem.DragWindow ].Xpos
						XWinSystem.YDragOrigin = XWindow[ XWinSystem.DragWindow ].Ypos        
						XWinSystem.XDragMouse = XM : XWinSystem.YDragMouse = YM
					EndIf
				EndIf
				// ON VERIFIE SI L'ON SE TROUVE SUR UN GADGET DANS LA FENETRE.
				If XWindow[ XWinSystem.CurrentWindow ].XGadget.length > 0
					For XLoop = XWindow[ XWinSystem.CurrentWindow ].XGadget.length To 1 Step - 1
						XGad As Integer : XGad = XWindow[ XWinSystem.CurrentWindow ].XGadget[ Xloop ].Xpos
						YGad As Integer : YGad = XWindow[ XWinSystem.CurrentWindow ].XGadget[ Xloop ].Ypos
						If XPosIn >= XGad And YPosIn >= YGad
							If XPosIn <= XGad + XWindow[ XWinSystem.CurrentWindow ].XGadget[ XLoop ].XSize And YPosIn <= YGad + XWindow[ XWinSystem.CurrentWindow ].XGadget[ XLoop ].YSize
								If XWinSystem.CurrentGadget = 0 : XWinSystem.CurrentGadget = XLoop : EndIf
							EndIf
						EndIf
					Next XLoop
				EndIf 
				// Suppression de la fenêtre ???
				If XposIn >= XWindow[ XWinSystem.CurrentWindow ].XSize - SkinImage[ 11 ].Width And YPosIn <= SkinImage[ 11 ].Height
					If XWindow[ XWinSystem.CurrentWindow ].Close = 1
						If XWinSystem.CloseMode = 1
							XTDeleteXWindow( XWinSystem.CurrentWindow )
						Else
							XTHideXWindow( XWinSystem.CurrentWindow )
						EndIf
					EndIf
					XWinSystem.CurrentWindow = -1 : XWinSystem.OldWindow = - 1
				EndIf
			EndIf
		Else
			XWinSystem.AllowDragging = 0
			XWinSystem.DragWindow = -1
		EndIf
	Else
		// Déplacement de la fenêtre ???
		XADD As Integer : XADD = XM - XWinSystem.XDragMouse
		YADD As Integer : YADD = YM - XWinSystem.YDragMouse
		XWindow[ XWinSystem.DragWindow ].Xpos = XWinSystem.XDragOrigin + XADD
		XWindow[ XWinSystem.DragWindow ].Ypos = XWinSystem.YDragOrigin + YADD
		If XWindow[ XWinSystem.DragWindow ].Refresh = 0 : XWindow[ XWinSystem.DragWindow ].Refresh = 1 : EndIf
	EndIf
	XWinSystem.OldMouseClick = MC
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
Function XTSetXWindowXLimit( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	XResult As Integer = -1
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XResult = XWindow[ thisWindow ].XSize
		XLimit As Integer = 0 : XLoop As Integer = 0
		For XLoop = 0 To XWindow.length
			If XWindow[ XLoop ].Parent = WinName And XLoop <> thisWindow
				If XWindow[ XLoop ].Alignment = 8
					If XWindow[ XLoop ].Hide = 0
						XLimit = XWindow[ thisWindow ].XSize + XWindow[ XLoop ].XSize
						If XLimit > XResult : XResult = XLimit : EndIf
					EndIf
				EndIf
			EndIf
		Next XLoop
	Else
		Message( "XTSetXWindowXLimit Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction XResult

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
Function XTSetXWindowXMin( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	XResult As Integer = 0
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XLimit As Integer = 0 : XLoop As Integer = 0
		For XLoop = 0 To XWindow.length
			If XWindow[ XLoop ].Parent = WinName And XLoop <> thisWindow
				If XWindow[ XLoop ].Alignment = 4
					If XWindow[ XLoop ].Hide = 0
						XLimit = XWindow[ XLoop ].XSize
						If XLimit > XResult : XResult = XLimit : EndIf
					EndIf
				EndIf
			EndIf
		Next XLoop
	Else
		Message( "XTSetXWindowXMin Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction XResult

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
Function XTSetXWindowYLimit( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	YResult As Integer = -1
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		YResult = XWindow[ thisWindow ].YSize
		YLimit As Integer = 0 : XLoop As Integer = 0
		For XLoop = 0 To XWindow.length
			If XWindow[ XLoop ].Parent = WinName And XLoop <> thisWindow
				If XWindow[ XLoop ].Alignment = 8
					If XWindow[ XLoop ].Hide = 0
						YLimit = XWindow[ thisWindow ].XSize + XWindow[ XLoop ].YSize
						If YLimit > YResult : YResult = YLimit : EndIf
					EndIf
				EndIf
			EndIf
		Next XLoop
	Else
		Message( "XTSetXWindowYLimit Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction YResult


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
Function XTSetXWindowYMin( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	YResult As Integer = 0
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		YLimit As Integer = 0 : XLoop As Integer = 0
		For XLoop = 0 To XWindow.length
			If XWindow[ XLoop ].Parent = WinName And XLoop <> thisWindow
				If XWindow[ XLoop ].Alignment = 1
					If XWindow[ XLoop ].Hide = 0
						YLimit = XWindow[ XLoop ].YSize
						If YLimit > YResult : YResult = YLimit : EndIf
					EndIf
				EndIf
			EndIf
		Next XLoop
	Else
		Message( "XTSetXWindowYMin Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction YResult

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
Function XTUpdateAttachecXWindowPosition( WinNum As Integer )
	XLoop As Integer = 0
	For XLoop = 0 To XWindow.length
		If XWindow[ XLoop ].Parent = XWindow[ WinNum ].Name And XLoop <> WinNum
			Select XWindow[ XLoop ].Alignment
				Case 1
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos - XWindow[ XLoop ].YSize
				EndCase
				Case 2
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos + XWindow[ WinNum ].YSize
				EndCase
				Case 4
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos - XWindow[ XLoop ].XSize
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos
				EndCase
				Case 8
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos + XWindow[ WinNum ].XSize
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos
				EndCase
			EndSelect
			If XWindow[ XLoop ].Refresh = 0 : XWindow[ XLoop ].Refresh = 1 : EndIf
		EndIf
	Next XLoop
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
Function XTGetCurrentXWindow()
	WinNum As Integer : WinNum = XWinSystem.CurrentWindow
EndFunction WinNum
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
Function XTGetXWindowXPosition( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	Value As Integer = -1
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		Value = XWindow[ thisWindow ].Xpos
	Else
		Message( "XTGetXWindowXPosition Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction Value

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
Function XTGetXWindowYPosition( WinName As String )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	Value As Integer = -1
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		Value = XWindow[ thisWindow ].Ypos
	Else
		Message( "XTGetXWindowYPosition Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction Value

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
Function XTStretchXWindowTo( WinName As String, XSize As Integer, YSize As Integer )
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	Value As Integer = -1
	// Si la fenêtre XWindows a été trouvée dans la liste, on appelle la méthode par ID pour modifier ses paramètres/propriétés
	if thisWindow > -1
		XWindow[ thisWindow ].XDSize = XSize
		XWindow[ thisWindow ].YDSize = YSize
	Else
		Message( "XTStretchXWindowTo Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction Value

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
Function XTAttachXWindows( ParentWinName As String, ChildWinName As String, Position As Integer )
	thisWindow1 As Integer = -1 : thisWindow2 As Integer = -1
	thisWindow1 = XTGetXWindowIDByName( ParentWinName )
	thisWindow2 = XTGetXWindowIDByName( ChildWinName )
	if thisWindow1 > -1 and thisWindow2 > -1
		Inc XWindow[ thisWindow1 ].ChildCount, 1
		XWindow[ thisWindow2 ].Parent = ParentWinName
		XWindow[ thisWindow2 ].Alignment = Position
	Else
		Message( "XTAttachXWindows Erreur : Requested Window Name '" + ParentWinName + "' or '" + ChildWinName + "' is invalid or window does not exist" )
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
Function XTDetachXWindow( ChildWinName As String )
	thisWindow1 As Integer = -1 : thisWindow2 As Integer = -1
	thisWindow2 = XTGetXWindowIDByName( ChildWinName )
	if thisWindow2 > -1
		thisWindow1 = XTGetXWindowIDByName( XWindow[ thisWindow2 ].Parent )
		if thisWindow1 > -1
			Dec XWindow[ thisWindow1 ].ChildCount, 1
			XWindow[ thisWindow2 ].Parent = NULL
			XWindow[ thisWindow2 ].Alignment = 0
		Else
			Message( "XTDetachXWindow Erreur : Requested Window Name '" + XWindow[ thisWindow2 ].Parent + "' is invalid or window does not exist" )
		Endif
	Else
		Message( "XTDetachXWindow Erreur : Requested Window Name '" + ChildWinName + "' is invalid or window does not exist" )
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
Function XTGetXWindowParent( WinName As String )
	ParentXWindowName As String = ""
	thisWindow1 As Integer = -1
	thisWindow1 = XTGetXWindowIDByName( WinName )
	if thisWindow1 > -1
		ParentXWindowName = XWindow[ thisWindow1 ].Parent
	Else
		Message( "XTDetachXWindow Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction ParentXWindowName
	


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
Function XTSetTextTransparent( State As Integer )
	if State = TRUE or State = FALSE
		XFontSys.Opaque = TRUE - State
	Else
		Message( "XTSetTextOpaque Error : The requested state is illegal. Only TRUE/FALSE (1/0) are allowed." )
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
Function XTGetXWindowGadgetAmount( WinName As String )
	gAmount As Integer = 0
	thisWindow As Integer = -1
	thisWindow = XTGetXWindowIDByName( WinName )
	if thisWindow > -1
		gAmount = XWindow[ thisWindow ].XGadget.length
	Else
		Message( "XTDetachXWindow Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
	Endif
EndFunction gAmount

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
Function XTSetXWindowChatXGadget( WinName As String, GadName As String )
	thisGadget As Integer = -1
	thisGadget = XTGetXGadgetIDByName( WinName, GadName )
	if thisGadget > -1 // Mean XWindow & XGadget exists
		XWinSystem.ChatGadgetName = GadName
		XWinSystem.ChatGadgetWindowName = WinName
	Else
		Message( "XTDetachXWindow Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
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
Function XTSetChatXGadget( WinName As String, GadName As String )
	thisGadget As Integer = -1
	thisGadget = XTGetXGadgetIDByName( WinName, GadName )
	if thisGadget > -1 // Mean XWindow & XGadget exists
		XWinSystem.ChatGadgetName = GadName
		XWinSystem.ChatGadgetWindowName = WinName
		XWinSystem.ChatInText = ""
		XWinSystem.ChatReading = 0
	Else
		Message( "XTDetachXWindow Erreur : Requested Window Name '" + WinName + "' is invalid or window does not exist" )
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
Function Internal_TalkToChat( TEXTE As String )
	if len( XWinSystem.ChatGadgetName ) > 0
		// Copy all chat texts up.
		XLoop As Integer = 0
		For XLoop = 1 To 31 Step 1
			ChatText[ XLoop ] = ChatText[ XLoop + 1 ]
		Next XLoop
		ChatText[ 32 ] = TEXTE
		thisWindow As Integer
		thisWindow = XTGetXWindowIDByName( XWinSystem.ChatGadgetWindowName )
		if thisWindow > -1
			if XWindow[ thisWindow ].refresh < 3 then XWindow[ thisWindow ].refresh = 3
		Endif
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
Function XTTalkToChatSystem( TEXTE As String )
	Internal_TalkToChat( TEXTE )
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
Function XTSetChatScanCode( Key As Integer )
	XWinSystem.ChatScanCode = Key
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
Function XTGetChatReadBuffer()
EndFunction XWinSystem.ChatReading

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
Function XTGetLastChatSpeech()
EndFunction ChatText[ 32 ]

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
Function XTClearXWindowSystem()
	// Firstly we delete all XWindows (it includes all XGadgets too)
	if XWindow.length > -1
		xLoop As Integer = -1
		For xLoop = XWindow.length to 0 step -1
			XTDeleteXWindow( xLoop )
			XWinDisplay.remove( xLoop ) // Clear the display list too
		Next xLoop
	EndIf
	// Secondly we clear the Skin
	if SkinImage.length > -1
		sLoop As Integer = -1
		for sLoop = SkinImage.length to 0 step -1
			if getImageExists( SkinImage[ sLoop ].ImageID ) = TRUE then DeleteImage( SkinImage[ sLoop ].ImageID )
			SkinImage.remove( sLoop )
		next sLoop
	EndIf
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

