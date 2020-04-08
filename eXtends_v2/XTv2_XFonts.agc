//
// *******************************************************
// *                                                     *
// * eXtends Ver 2.0 Include File : eXtends XFont System *
// *                                                     *
// *******************************************************
// Start Date : 2019.05.03 21:42
// Description : Ce système gère des fontes bitmap
//
// Author : Frédéric Cordier
//
// ************************************************************************ XFont Setup & Creation commands
// XTCreateNewXFont( ImageName As String, FontSize As Integer, FirstChar As Integer, Flag As Integer )
// XTDeleteAllXFonts()
// ************************************************************************ XFont Methods using ID
// XTDeleteXFont( XFontID As Integer )
// BOOLEAN = XTGetXFontExist( XFontID As Integer )
// XTSetCurrentXFont( XFontID As Integer )
// XTSetXFontReturnMode( Mode As Integer )
// INTEGER = XTGetXFontTextWidth( TextToCheck As String )
// INTEGER = XTGetXFontTextHeight( TextToCheck As String )
// XTSetXFontCursor( XCursor As Integer , YCursor As Integer )
// XTPrintXFontFast( TextToPrint As String, ReturnCarriage As Integer )
// XTXFontText( TextToPrint As String, XPos As String, YPos As String )
// ************************************************************************ XFont Methods using Name
// XTGetXFontIDByName( XFontName As String )
// XTDeleteXFontByName( XFontName As String )
// XTGetXFontExistByName( XFontName As String )
// XTSetCurrentXFontByName( XFontName As String )

/* ************************************************************************
 * @Description : Créée une fonte graphique à partir d'un fichier image (.png, .jpg, .bmp, etc.)
 *
 * @Param : ImageName = Nom du fichier image à utiliser pour créer la fonte Bitmap
 * @Param : FontSize = La dimension en pixels d'un caractère de la fonte bitmap
 * @Param : FirstChar = le code ASCII du 1er caractère de la fonte bitmap
 * @Param : Flag = Mode de rendu
 *
 * @Return : newXFontID = Le numéro d'ID d'une font
 *
 * @Author : Frédéric Cordier
*/
Function XTCreateNewXFont( ImageName As String, FontSize As Integer, FirstChar As Integer, Flag As Integer )
	ImageID As Integer : CharImageID As Integer
	newXFont As XFont_Type
	newXFontID As Integer = -1
	XLoop As Integer = 0 : YLoop As Integer = 0
	if getFileExists( ImageName ) = TRUE
		ImageID = LoadImage( ImageName )
		If getImageExists( ImageID ) = TRUE
			if FontSize = 8 or FontSize = 16 or FontSize = 32 or FontSize = 64
				For YLoop = 0 to getImageHeight( ImageID ) - FontSize Step FontSize
					For XLoop = 0 to getImageWidth( ImageId ) - FontSize Step FontSize
						CharImageID = CopyImage( ImageID, XLoop, YLoop, FontSize, FontSize )
						newXFont.ImagesID.insert( CharImageID )
					Next XLoop
				Next YLoop
				DeleteImage( ImageID ) : ImageID = -1
				newXFont.FontSize = FontSize
				newXFont.FirstChar = FirstChar
				newXFont.mType = Flag
				newXFont.Name = ImageName
				XFonts.insert( newXFont )
				newXFontID = XFonts.length
				XFontSys.CurrentFont = newXFontID
			Endif
		Else
			Message( "XTCreateNewXFont Erreur : Impossible de charger l'image à partir du fichier image '" + ImageName + "'." )
		Endif
	Else
		Message( "XTCreateNewXFont Erreur : Le fichier image '" + ImageName + "' n'existe pas" )
	Endif
EndFunction newXFontID

/* ************************************************************************
 * @Description : Supprime toutes les XFont précédemment créées
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteAllXFonts()
	xfLoop As Integer = -1
	if XFonts.length > -1
		for xfLoop = XFonts.length to 0 Step -1
			if XTGetXFontExist( xfLoop ) = TRUE then XTDeleteXFont( xfLoop )
		Next xfLoop
	endif
EndFunction

/* ************************************************************************
 * @Description : Supprime une XFont précédemment créée
 *
 * @Param : XFontID = Le numéro d'index de la XFont à supprimer
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXFont( XFontID As Integer )
	iLoop As Integer = -1
	if XTGetXFontExist( XFontID ) = TRUE
		// On désactive la XFont comme font par défaut
		if XFontSys.CurrentFont = XFontID Then XFontSys.CurrentFont = -1
		// Puis on supprime toutes les images qui ont été utilisées pour créer la XFont bitmap
		for iLoop = XFonts[ XFontID ].ImagesID.length to 0 Step -1
			if getImageExists( XFonts[ XFontID ].ImagesID[ iLoop ] ) = TRUE
				DeleteImage( XFonts[ XFontID ].ImagesID[ iLoop ] )
				XFonts[ XFontID ].ImagesID.remove( iLoop )
			Endif
		Next iLoop
		// On supprime ensuite toutes les données présentes dans la XFont
		XFonts[ XFontID ].FirstChar = -1
		XFonts[ XFontID ].FontSize = 0
		XFonts[ XFontID ].mType = -1
		XFonts[ XFontID ].Name = ""
		// Et l'on termine en supprimant la XFont de la liste de XFonts créées.
		XFonts.remove( XFontID )

	else
		Message( "XTDeleteXFont Erreur : Le numéro d'index de XFont '" + Str( XFontID ) + "' est incorrect ou la XFont n'existe pas" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Renvoie TRUE si la XFont demandée existe, sinon FALSE
 *
 * @Param : XFontID = Le numéro d'index de la XFont à supprimer
 *
 * @Return : isExist = TRUE si la XFont demandée existe, sinon FALSE
 *
 * @Author :
*/
Function XTGetXFontExist( XFontID As Integer )
	isExist As Integer = 0 // FALSE
	if XFontID > -1 and XFontID < XFonts.length+1
		if len( XFonts[ XFontID ].Name ) > 0
			isExist = TRUE
		Endif
	Endif
EndFunction isExist	

/* ************************************************************************
 * @Description : Permet de définir la nouvelle XFont à utiliser pour écrire du texte
 *
 * @Param : XFontID = Le numéro d'index de la XFont à supprimer
 *
 * @Author : Frédéric Cordier
*/
Function XTSetCurrentXFont( XFontID As Integer )
	if XTGetXFontExist( XFontID ) = TRUE
		XFontSys.CurrentFont = XFontID
	Else
		Message( "XTSetCurrentXFont erreur : Le numéro d'index de XFont '" + Str( XFontID ) + "' est incorrect ou la XFont n'existe pas" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Renvoie le numéro d'index de la XFont courante
 *
 * @Return : XFontID = Le numéro d'index de la XFont actuellement utilisée
 *
 * @Author : Frédéric Cordier
*/
Function XTGetCurrentXFont()
	CurrentFont As Integer
	CurrentFont = XFontSys.CurrentFont
EndFunction CurrentFont

/* ************************************************************************
 * @Description : Active ou désactive le mode "retour à la ligne" automatique
 *
 * @Param : Mode = TRUE active le mode retour à la ligne, FALSE le désactive
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXFontReturnMode( Mode As Integer )
		XFontSys.AutoReturn = Mode
EndFunction

/* ************************************************************************
 * @Description : Renvoie la largeur en pixels d'un texte qui serait écrite avec la XFont actuelle/courante
 *
 * @Param : TextToCheck = Le texte dont on désire connaître la largeur en pixels
 *
 * @Return : tWidth = La largeur en pixels du texte demandé
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXFontTextWidth( TextToCheck As String )
	tWidth As Integer = -1
	if XFontSys.CurrentFont > -1
		tWidth = XFonts[ XFontSys.CurrentFont ].FontSize * Len( TextToCheck )
	Else
		Message( "XTgetXFontTextWidth erreur : Aucune XFont n'a été créé" )
	Endif
EndFunction tWidth

/* ************************************************************************
 * @Description : Renvoie la hauteur en pixels d'un texte qui serait écrite avec la XFont actuelle/courante
 *
 * @Param : TextToCheck = Le texte dont on désire connaître la hauteur en pixels
 *
 * @Return : tHeight = La hauteur en pixels du texte demandé
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXFontTextHeight( TextToCheck As String )
	tHeight As Integer = -1
	if XFontSys.CurrentFont > -1
		tHeight = XFonts[ XFontSys.CurrentFont ].FontSize 
	Else
		Message( "XTgetXFontTextHeight erreur : Aucune XFont n'a été créé" )
	Endif
EndFunction tHeight

/* ************************************************************************
 * @Description : Définit la position du curseur graphique pour l'écriture du texte
 *
 * @Param : XCursor = La coordnnée d'abscisse (sur X) pour le début du tracé du texte
 * @Param : YCursor = La coordonnée d'ordonnée (sur Y) pour le début du tracé du texte
 *
 * @Author : Frédéric Cordier
*/
Function XTSetXFontCursor( XCursor As Integer , YCursor As Integer )
	XFontsys.XCursor = XCursor
	XFontsys.YCursor = YCursor
 EndFunction
 
/* ************************************************************************
 * @Description : Ecrit un texte dans l'écran en utilisant les paramètres par défaut
 *
 * @Param : TextToPrint = Texte à écrire à l'écran
 * @Param : ReturnCarriage = bypass le paramètre XFontSys.AutoReturn pour définir s'il y a retour à la ligne (=TRUE) ou pas (=FALSE)
 *
 * @Author : Frédéric Cordier
*/
Function XTPrintXFontFast( TextToPrint As String, ReturnCarriage As Integer )
	tLoop As Integer = 0
	tChar As Integer = -1
	if XFontsys.CurrentFont > -1
		if XTGetXFontExist( XFontSys.CurrentFont ) = TRUE
			If Len( TextToPrint ) > 0
				if XFontSys.SpriteID = -1
					XFontsys.SpriteID = CreateSprite( 0 )
					SetSpritePosition( XFontSys.SpriteID, -1024, -1024 )
				Else
					SetSpriteVisible( XFontSys.SpriteID, TRUE )
				Endif
				for tLoop = 1 to len( TextToPrint )
					tChar = Asc( Mid( TextToPrint, tLoop, 1 ) )
					if tChar > XFonts[ XFontSys.CurrentFont ].FirstChar -1 and ( tChar - XFonts[ XFontSys.CurrentFont ].FirstChar ) < XFonts[ XFontSys.CurrentFont ].ImagesID.length+1
						// Tracé du texte
						SetSpriteImage( XFontSys.SpriteID, XFonts[ XFontSys.CurrentFont ].ImagesID[ tChar - XFonts[ XFontSys.CurrentFont ].FirstChar ] )
						SetSpritePosition( XFontSys.SpriteID, XFontSys.XCursor, XFontSys.YCursor )
						SetSpriteSize( XFontSys.SpriteID, XFonts[ XFontSys.CurrentFont ].FontSize, XFonts[ XFontSys.CurrentFont ].FontSize )
						DrawSprite( XFontSys.SpriteID )
						// Déplacement du curseur
						XFontSys.XCursor = XFontSys.XCursor + XFonts[ XFontSys.CurrentFont ].FontSize
						// Retour à la ligne si besoin est
						If ReturnCarriage = TRUE and XFontsys.XCursor > GetWindowWidth()
							XFontSys.XCursor = 0 : XfontSys.YCursor = XFontSys.YCursor + XFonts[ XFontSys.CurrentFont ].FontSize
						Endif
					Endif
				Next tLoop
				SetSpritePosition( XFontSys.SpriteID, -1024, -1024 )
				SetSpriteVisible( XFontSys.SpriteID, FALSE )
			Endif
		Else
			Message( "XTPrintXFontFast erreur : La XFont courante n'existe pas ou est corrompue" )
		Endif
	Else
		Message( "XTPrintXFontFast erreur : Aucune XFont n'a été créé" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Ecrit un texte à des coordonnées précises sans modifier les valeurs de curseur
 *
 * @Param : TextToPrint = Texte à écrire à l'écran
 * @Param : XPos = La coordnnée d'abscisse (sur X) pour le début du tracé du texte
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) pour le début du tracé du texte
 *
 * @Author : Frédéric Cordier
*/
Function XTXFontText( TextToPrint As String, XPos As Integer, YPos As Integer )
	XCurseur As Integer : YCurseur As Integer
	XCurseur = XFontSys.XCursor : YCurseur = XFontSys.YCursor
	XTSetXFontCursor( XPos, YPos )
	XTPrintXFontFast( TextToPrint, 0 )
	XFontSys.XCursor = XCurseur :  XFontSys.YCursor = YCurseur
EndFunction



//
// *********************                                                                                                                           *************
// *
// **************************************************************************************************************************************** XFont Methods ByName
// *
// *************                                                                                                                           *********************
//

/* ************************************************************************
 * @Description : Renvoie la structure d'une XFont recherchée par son nom
 *
 * @Param : WinName = Le nom (ou titre) qui a été donné à la fenêtre.
 *
 * @Return : thisWindow = La structure XWindows liée à la fenêtre demandée
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXFontByName( XFontName As String )
	thisXFont As XFont_Type : thisXFont = EmptyXFont
	thisXFontID As Integer = -1
	thisXFontID = XTGetXFontIDByName( XFontName )
	If thisXFontID > -1 then thisXFont = XFonts[ thisXFontID ]
EndFunction thisXFont

/* ************************************************************************
 * @Description : Renvoie l'ID d'une XFont recherchée par son nom
 *
 * @Param : XFontName = le nom de la XFont à trouver dans la liste
 *
 * @Return : thisXFontID = Le numéro d'index de la XFont trouvée
 *
 * @Author : Frédéric Cordier
*/
Function XTGetXFontIDByName( XFontName As String )
	thisXFontID As Integer = -1
	wLoop As Integer = 0
	If XFonts.length > -1
		For wLoop = 0 to XFonts.length Step 1
			If XFonts[ wLoop ].Name = XFontName
				thisXFontID = wLoop
			Endif
		Next wLoop
	Else
		Message( "XTGetXWindowsExistsByName Erreur : Aucune fenêtre XWindows n'existe" )
	Endif
EndFunction thisXFontID


/* ************************************************************************
 * @Description : Supprime une XFont précédemment créée
 *
 * @Param : XFontName = le nom de la XFont à trouver dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTDeleteXFontByName( XFontName As String )
	idXFont As Integer
	idXFont = XTGetXFontIDByName( XFontName )
	if XTGetXFontExist( idXFont ) = TRUE
		XTDeleteXFont( idXFont )
	else
		Message( "XTDeleteXFont Erreur : Il n'existe pas de XFont portant le nom '" + XFontName + "'." )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Renvoie TRUE si la XFont demandée existe, sinon FALSE
 *
 * @Param : XFontName = le nom de la XFont à trouver dans la liste
 *
 * @Return : isExist = TRUE si la XFont demandée existe, sinon FALSE
 *
 * @Author :
*/
Function XTGetXFontExistByName( XFontName As String )
	idXFont As Integer : idXFont = XTGetXFontIDByName( XFontName )
	isExist As Integer : isExist = XTGetXFontExist( idXFont )
EndFunction isExist	

/* ************************************************************************
 * @Description : Permet de définir la nouvelle XFont à utiliser pour écrire du texte
 *
 * @Param : XFontName = le nom de la XFont à trouver dans la liste
 *
 * @Author : Frédéric Cordier
*/
Function XTSetCurrentXFontByName( XFontName As String )
	idXFont As Integer : idXFont = XTGetXFontIDByName( XFontName )
	if XTGetXFontExist( idXFont ) = TRUE
		XFontSys.CurrentFont = idXFont
	Else
		Message( "XTDeleteXFont Erreur : Il n'existe pas de XFont portant le nom '" + XFontName + "'." )
	Endif
EndFunction
