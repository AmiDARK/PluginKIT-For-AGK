//
// **************************************************
// *                                                *
// * eXtends Ver 2.0 Include File : 2D Tiles System *
// *                                                *
// **************************************************
// Start Date : 2019.04.24 00:21
// Description : A total rewriting of the 2DPluginKIT
//               2D Tiles system
// Author : Frédéric Cordier
//
// **************************************************************************************************************************** Liste des méthodes de la classe :
// PKClearTiles()
// TileID (Integer) = PKCreateTile( ImageID As Integer, TransparencyMODE As Integer )
// TileID (Integer) = PKLoadTile( ImageFile As String, TransparencyMODE As Integer )
// TileID (Integer) = PKLoadTileFromCollectionImage( ImageCollection Ref As PKTileCollection_Type, ImageName As String, TransparencyMODE )
// TileID (Integer) = PKLoadTileFromCollectionImageEx( ImageCollection Ref As PKTileCollection_Type, ImageName As String )
// P2DK_SetTileTransparency( TileID As Integer, TransparencyFLAG As Integer ) *NOT YET*
// TileExist (Integer) = PKTileExists( TileID As Integer )
// TileWidth (Integer) = PKGetTileWidth( TileID As Integer )
// TileHeight (Integer) = PKGetTileHeight( TileID As Integer )
// TileTransp (Integer) = PKGetTileTransparency( TileID As Integer )
// TileImageID (Integer) = PKGetTileImage( TileID As Integer )
// *****
// PKPasteTile( TileID As Integer, XPos As Integer, YPos As Integer )
// *****
// PKCreateTileMask( TileID As Integer, ImageID As Integer )
// PKLoadTileMask( TileID As Integer, MaskFileName As String )
// PKLoadTileMaskFromCollectionImage( TileID As Integer, ImageCollection Ref As PKTileCollection_Type, ImageName As String )
// Internal_AddTileMaskToMaskBlock( TileID As Integer )
// Internal_CreateResizeMaskBlock( RequestedAmountOfTiles As Integer )
// TileMaskImageExist (Integer) = PKGetTileMaskExist( TileID As Integer ) *NOT YET*
// TileMaskImageID = PKGetTileMaskIMAGE( TileID As Integer ) *NOT YET*
// *****
// PKCreateTileNMap( TileID As Integer, ImageID As Integer )
// PKLoadTileNMap( TileID As Integer, NMapFileName As String )
// PKLoadTileNMapFromCollectionImage( TileID As Integer, ImageCollection Ref As PKTileCollection_Type, ImageName As String )
// Internal_AddTileNMapToNMapBlock( TileID As Integer )
// Internal_CreateResizeNMapBlock( RequestedAmountOfTiles As Integer )
// TileNMapImageExist (Integer) = PKGetTileNMapExist( TileID As Integer ) *NOT YET*
// TileNMapImageID = PKGetTileNMapIMAGE( TileID As Integer ) *NOT YET*
// *****

/* ************************************************************************
 * @Description : This method will delete all tiles from memory. Images used for tiles will
 *                be deleted only if they were loaded when creating the tile (using PKLoadTile(...)
 *                method). Same sentence concerning TilesMasks and Normal Mapping images
 * 
 *
 * @Author : Frédéric Cordier
*/
Function PKClearTiles()
	if PKTile.length > -1
		tLoop As Integer = 0
		For tLoop = PKTile.length to 0 Step -1
			// Si l'image existe et ne vient pas d'une collection, on supprime l'image
			if PKTile[ tLoop ].ImageFromCollection.ImageID > 0 And PKTile[ tLoop ].ImageID < 0
				DeleteImage( Abs( PKTile[ tLoop ].ImageID ) )
			Endif
			// Si l'image de masque existe et ne vient pas d'une collection d'images, on la supprimer
			if PKTile[ tLoop ].MaskFromCollection.ImageID > 0 And PKTile[ tLoop ].MaskImageID < 0
				DeleteImage( Abs( PKTile[ tLoop ].MaskImageID ) )
			Endif
			// Si l'image de Normal Mapping existe, ne vient pas d'une collection d'images et a été chargé pour la tile, on la supprime
			If PKTile[ tLoop ].NMapFromCollection.ImageID > 0 And PKTile[ tLoop ].NMapImageID < 0
				DeleteImage( Abs( PKTile[ tLoop ].NMapImageID ) )
			Endif
			// Une fois les suppressions réalisées, on supprime la tile de la liste
			PKTile.remove( tLoop )
		Next tLoop
	Endif
EndFunction


/* ************************************************************************
 * @Description : Créé une nouvelle tile à partir d'une image existante
 *
 * @Param : ImageID = L'image à utiliser pour créer la tile
 * @Param : TransparencyMODE = Mode de transparence (0=pas de transparence, 1=noir invisible)
 *
 * @Return : TileID = Le numéro d'index de la tile créée
 *
 * @Author : Frédéric Cordier
*/
Function PKCreateTile( ImageID As Integer, TransparencyMODE As Integer )
	newTile As PKTiles_Type
	TileID As Integer = -1
	if getImageExists( Abs( ImageID ) ) = 1 // Abs to handle negative values for "loaded for the tile"
		newTile.FileName = NULL
		newTile.ImageID = ImageID
		newTile.ImageFromCollection = EmptyCollection
		newTile.Width = getImageWidth( Abs( ImageID ) )   // Abs to handle negative values for "loaded for the tile"
		newTile.Height = getImageHeight( Abs( ImageID ) ) // Abs to handle negative values for "loaded for the tile"
		newTile.Transparency = TransparencyMODE
		newTile.MaskImageID = 0
		newTile.MaskFromCollection = EmptyCollection
		newTile.NMapImageID = 0
		newTile.NMapFromCollection = EmptyCollection
		newTile.AnimationID = 0
		newTile.AnimFrameID = Abs( ImageID )
		newTile.MaskXPos = 0
		newTile.MaskYPos = 0
		newTile.NMapXPos = 0
		newTile.NMapYPos = 0
		newTile.maskLoaded = -1
		PKTile.insert( newTile )
		TileID = PKTile.length
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTile - Image index '" + Str( ImageID ) + "' does not exists." )
	Endif
EndFunction TileID


/* ************************************************************************
 * @Description : Créé une nouvelle tile à partir d'une image stockée dans un fichier sur disque
 *
 * @Param : ImageFile = Nom du fichier image à utiliser pour créer la tile
 * @Param : TransparencyMODE = Mode de transparence (0=pas de transparence, 1=noir invisible)
 *
 * @Return : TileID = Le numéro d'index de la tile créée
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadTile( ImageFile As String, TransparencyMODE As Integer )
	TileID As Integer = -1
	ImageID As Integer = -1
	If getFileExists( ImageFile ) = 1
		ImageID = LoadImage( ImageFile )
		TileID = PKCreateTile( 0 - ImageID, TransparencyMode )
		If ( TileID > -1 )
			PKTile[ TileID ].FileName = ImageFile
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTile - Tile was not successfully created from Image" )
		Endif
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTile - Image file '" + ImageFile + "' does not exists." )
	Endif
EndFunction TileID

/* ************************************************************************
 * @Description : Change l'image utilisée pour la tile choisie. Si l'image précédente avait été chargée pour
 *                la tile, elle sera alors supprimée de la mémoire
 *
 * @Param : TileID = Le numéro d'index de la tile créée
 * @Param : ImageID = Le numéro d'index de la nouvelle image à appliquer à la tile.
 *
 * @Author : Frédéric Cordier
*/
Function PKSetTileImageEx( TileID As Integer, ImageID As Integer, TransparencyFLAG As Integer )
	// Si la Tile demandée existe et que la nouvelle image existe,
	if PKGetTileExists( TileID ) = TRUE and getImageExists( ImageID ) = TRUE
		// Si l'ancienne image avait été chargée pour la tile ( < 0 ) et existe, on la supprime de la mémoire
		if ( PKTile[ TileID ].ImageID < 0 and getImageExists( PKTile[ TileID ].ImageID ) = TRUE )
			DeleteImage( Abs( PKTile[ TileID ].ImageID ) )
		Endif
		PKTile[ TileID ].ImageID = ImageID // On applique la nouvelle image
		PKTile[ TileID ].Transparency = TransparencyFLAG
		PKTile[ TileID ].FileName = NULL
	Endif
EndFunction

Function PKSetTileImage( TileID As Integer, ImageID As Integer )
	Transp As Integer = 0
	if PKGetTileExists( TileID ) = TRUE Then Transp = PKtile[ TileID ].Transparency
	PKSetTileImageEx( TileID, ImageID, Transp )
EndFunction

/* ************************************************************************
 * @Description : Créé une nouvelle tile à partir d'une image présente dans une collection d'image déjà pré-chargée
 *
 * @Param : ImageCollection = La collection d'image dans laquelle l'image de la tile à créer est présente
 * @Param : ImageName = Nom de l'image dans le fichier d'index de collection 'subimages.txt'
 * @Param : TransparencyMODE = Mode de transparence (0=pas de transparence, 1=noir invisible)
 *
 * @Return : TileID = Le numéro d'index de la tile créée
 *
 * @Author : Frédéric Cordier
*/
// Load from subimage file the data concerning the tile to define a bit like SubImage but makes a copy image to create the target ( Integer CopyImage( fromImage, x, y, width, height ) )
Function PKLoadTileFromCollectionImage( ImageCollection Ref As PKTileCollection_Type, ImageName As String, TransparencyMODE )
	TileID As Integer = -1 : ImageID As Integer = -1
	ImageID = PKLoadSubImageFromCollection( ImageCollection, ImageName )
    TileID = PKCreateTile( ImageID, TransparencyMODE )
    PKTile[ TileID ].ImageFromCollection = ImageCollection
    PKTile[ TileID ].ImageName = ImageName
EndFunction TileID

/* ************************************************************************
 * @Description : Créé une nouvelle tile à partir d'une image présente dans une collection d'image déjà pré-chargée
 *                La transparence est automatiquement désactivée dans cette méthode.
 *
 * @Param : ImageCollection = La collection d'image dans laquelle l'image de la tile à créer est présente
 * @Param : ImageName = Nom de l'image dans le fichier d'index de collection 'subimages.txt'
 *
 * @Return : TileID = Le numéro d'index de la tile créée
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadTileFromCollectionImageEx( ImageCollection Ref As PKTileCollection_Type, ImageName As String )
	TileID As Integer = -1
	TileID = PKLoadTileFromCollectionImage( ImageCollection, ImageName, 0 )
EndFunction TileID

/* ************************************************************************
 * @Description : Affiche une tile à l'écran, aux coordonnées XPos, YPos
 *
 * @Param : TileID = L'index de la tile à afficher à l'écran
 * @Param : XPos = La coordonnée d'abscisse (sur X) de l'endroit dans l'écran où la tile sera affichée
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) de l'endroit dans l'écran où la tile sera affichée
 *
 * @Author : Frédéric Cordier
*/
Function PKPasteTile( TileID As Integer, XPos As Integer, YPos As Integer )
	If PKGetTileExists( TileID ) = TRUE
		if PKSetup.TileSpriteID < 1
			PKSetup.TileSpriteID = CreateSprite( Abs( PKTile[ TileID ].AnimFrameID ) ) // Abs to handle negative values for "loaded for the tile"
		Else
			SetSpriteImage( PKSetup.TileSpriteID, Abs( PKTile[ TileID ].AnimFrameID ) )
		Endif
		// Display Tile Mask when exists instead of the tile image.
		/*if PKTile[ TileID ].MaskImageID > -1 and getImageExists( PKTile[ TileID ].MaskImageID ) = TRUE
			SetSpriteImage( PKSetup.TileSpriteID, Abs( PKTile[ TileID ].MaskImageID ) )
		Endif*/
		SetSpritePosition( PKSetup.TileSpriteID, XPos, YPos )
		SetSpriteTransparency( PKSetup.TileSpriteID, PKTile[ TileID ].Transparency )
		DrawSprite( PKSetup.TileSpriteID )
		SetSpritePosition( PKSetup.TileSpriteID, -2000, -2000 )
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKPastetile - Incorrect TileID " + Str( TileID ) + " ( range 0-" + Str( PKTile.length ) + " )" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Vérifie si la tile demandée existe
 *
 * @Param : TileID = L'index de la tile à vérifier
 *
 * @Return : isExist = TRUE si la tile existe, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileExists( TileID As Integer )
	isExist As Integer : isExist = FALSE
	if TileID > -1 and TileID < ( PKTile.length +1 )
		isExist = TRUE // Abs to handle negative values for "loaded for the tile"
	Endif
EndFunction isExist

/* ************************************************************************
 * @Description : Renvoie la largeur en pixels de la tile demandée, si elle existe
 *
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : feedbackValue = La largeur en pixels de la tile si elle existe, sinon -1
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileWidth( TileID As Integer )
	feedbackValue As Integer = -1
	if PKGetTileExists( TileID ) = TRUE
		feedbackValue = PKTile[ TileID ].Width
	Endif
EndFunction feedbackValue

/* ************************************************************************
 * @Description : Renvoie la hauteur en pixels de la tile demandée, si elle existe
 *
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : feedbackValue = La hauteur en pixels de la tile si elle existe, sinon -1
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileHeight( TileID As Integer )
	feedbackValue As Integer = -1
	if PKGetTileExists( TileID ) = TRUE
		feedbackValue = PKTile[ TileID ].Height
	Endif
EndFunction feedbackValue

/* ************************************************************************
 * @Description : Renvoie le mode de transparence actuellement actif dans la tile demandée
 *
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : feedbackValue = 0 si la transparence est désactivée, 1 si le noir=invisible est activé
 *
 * @Author :
*/
Function PKGetTileTransparency( TileID As Integer )
	feedbackValue As Integer = -1
	if PKGetTileExists( TileID ) = TRUE
		feedbackValue = PKTile[ TileID ].Transparency
	Endif
EndFunction feedbackValue

/* ************************************************************************
 * @Description : Renvoie l'index de l'image actuellement utilisée dans la tile
 *
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : feedbackValue = L'index de l'image actuellement utlisée pour afficher la tile demandée
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileImage( TileID As Integer )
	feedbackValue As Integer = -1
	if PKGetTileExists( TileID ) = TRUE
		feedbackValue = Abs( PKTile[ TileID ].ImageID ) // Abs to handle negative values for "loaded for the tile"
	Endif
EndFunction feedbackValue

/* ************************************************************************
 * @Description : Créé une image de masque de collisions 8 bits pour la tile demandée
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque 8 bits
 * @Param : ImageID = L'index de l'image utilisée pour créer le masque 8 bits
 *
 * @Author : Frédéric Cordier
*/
Function PKCreateTileMask( TileID As Integer, ImageID As Integer )
	If PKGetTileExists( TileID ) = TRUE
		If GetImageExists( Abs( ImageID ) ) = TRUE // Abs to handle negative values for "loaded for the tile"
			PKTile[ TileID ].MaskImageID = ImageID
			Internal_AddTileMaskToMaskBlock( TileID ) // On ajoute le Mask au bloc mémoire des masques d'images.
/*			if PKSetup.LowMemoryMode = TRUE
				DeleteImage( Abs( ImageID ) ) // Abs to handle negative values for "loaded for the tile"
				ImageID = -1
				PKTile[ TileID ].MaskImageID = ImageID // For non loaded image that will not be deleted when clearing Tiles
				PKTile[ TileID ].MaskFileName = NULL
			Endif */
			PKTile[ TileID ].MaskFromCollection = EmptyCollection
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMask - Image index '" + Str( ImageID ) + "' does not exists." )
		Endif
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMask - The requested TileID " + Str( TileID ) + " does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Créé ou modifie une image de masque de collisions 8 bits pour la tile demandée
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque 8 bits
 * @Param : ImageID = L'index de l'image utilisée pour créer le masque 8 bits
 *
 * @Author : Frédéric Cordier
*/
Function PKSetTileMask( TileID As Integer, NewMaskImageID As Integer )
	// Si la Tile demandée existe et que la nouvelle image existe,
	if PKGetTileExists( TileID ) = TRUE
		if getImageExists( NewMaskImageID ) = TRUE
			// Si un masque avait déjà été créé on l'update
			if PKTile[ TileID ].MaskImageID <> 0
				if PKTile[ TileID ].MaskImageID < 0 Then DeleteImage( Abs( PKTile[ TileID ].MaskImageID ) )
				PKTile[ TileID ].MaskImageID = NewMaskImageID
				PKTile[ TileID ].MaskFileName = NULL
				Internal_AddTileMaskToMaskBlock( TileID )
			// Si aucun masque n'avait été crée, on utilise la méthode de création
			Else
				PKCreateTileMask( TileID, NewMaskImageID )
			Endif
		Else
			CastError( "PKSetTileMask Error : The required mask image does not exists" )
		Endif
	else
		CastError( "PKSetTileMask Error : The required tile does not exists" )
	Endif
EndFunction

Function PKGetTileMaskPixel( TileID As Integer, XPos As Integer, YPos As Integer )
	pixelColor As Integer = 0
	if PKGetTileExists( TileID ) = TRUE
		if PKSetup.MaskBlock > -1
			if PKTile[ TileID ].maskLoaded = TRUE
				pixelColor = XTReadMemblockPixel( PKSetup.MaskBlock, PKTile[ TileID ].MaskXPos + XPos, PKTile[ TileID ].MaskYPos + YPos )
			Else
				pixelColor = 0
			Endif
		Else
			CastError( "PKGetTileMaskPixel Error : There is not MaskBlock found for the Tile ID Mask datas" )
		Endif
	Else
		CastError( "PKGetTileMaskPixel Error : The requested tile does not exists" )
	Endif
EndFunction pixelColor


/* ************************************************************************
 * @Description : Créé une image de masque de collisions 8 bits pour la tile demandée à partir d'une image stockée dans un fichier
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque 8 bits
 * @Param : MaskFileName = Le nom du fichier image à utiliser pour créer le masque 8 bits
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadTileMask( TileID As Integer, MaskFileName As String )
	MaskImageID As Integer = -1
	ImageID As Integer = -1
	If PKGetTileExists( TileID ) = TRUE
		If getFileExists( MaskFileName ) = 1
			ImageID = LoadImage( MaskFileName )
			if ( getImageExists( ImageID ) ) = TRUE 
				PKCreateTileMask( TileID, 0 - ImageID ) // To handle negative values for "loaded for the tile"
				PKTile[ TileID ].MaskFileName = MaskFileName
				PKTile[ TileID ].MaskImageID = ImageID
			Else
				CastError( "PKLoadTileMask Error : The requested image file '" + MaskFileName + "' does not exists or cannot be loaded" )
			Endif
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTileMask - Image file '" + MaskFileName + "' does not exists." )
		Endif
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTileMask - The requested TileID " + Str( TileID ) + " does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Créé une image de masque de collisions 8 bits pour la tile demandée à partir d'une collection d'images pré-chargée
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque 8 bits
 * @Param : ImageCollection = La collection d'image dans laquelle l'image de la tile à créer est présente
 * @Param : ImageName = Nom de l'image dans le fichier d'index de collection 'subimages.txt'
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadTileMaskFromCollectionImage( TileID As Integer, ImageCollection Ref As PKTileCollection_Type, ImageName As String )
	ImageID As Integer = -1
	If PKGetTileExists( TileID  ) = TRUE
		ImageID = PKLoadSubImageFromCollection( ImageCollection, ImageName )
		If getImageExists( ImageID ) = 1
			PKCreateTileMask( TileID, ImageID )
			PKTile[ TileID ].MaskName = ImageName
			if PKSetup.LowMemoryMode = 0 Then PKTile[ TileID ].MaskFromCollection = ImageCollection
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMaskFromCollectionImage - The requested Image " +ImageName + " was not found in Image Collection" + ImageCollection.FileName )
		Endif
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMaskFromCollectionImage - The requested TileID " + Str( TileID ) + " does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Méthode interne pour ajouter un masque 8 bits dans le bloc mémoire dédiée au stockage de tous les masques de collisions
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque 8 bits
 *
 * @Author : Frédéric Cordier
*/
Function Internal_AddTileMaskToMaskBlock( TileID As Integer )
	// DebugMessage( "AddTileMaskToMaskBlock Tile #" + Str( TileID ) + " " + PKTile[ TileID ].FileName )
	TempImageBlock As Integer = -1
	MaskBlockTileXPos As Integer = -1
	MaskBlockTileYPos As Integer = -1
	XLoop As Integer = -1 : YLoop As Integer = -1
	HBColor As Integer = 0
	Internal_CreateResizeMaskBlock( TileID )                                                                   // Si la TileID > PKSetup.MaskTileAmount alors Resize or Create
	TempImageBlock = CreateMemblockFromImage( Abs( PKTile[ TileID ].MaskImageID ) )
//	TempImageBlock = CreateMemblockFromImage( Abs( PKTile[ TileID ].ImageID ) )
	MaskBlockTileYPos = Trunc( TileID / 8 ) * PKSetup.TileDefHeight
	MaskBlockTileXPos = ( TileID - ( Trunc( TileID / 8 ) * 8 ) ) * PKSetup.TileDefWidth
	PKTile[ TileID ].MaskXPos = MaskBlockTileXPos
	PKTile[ TileID ].MaskYPos = MaskBlockTileYPos
	PKTile[ TileID ].maskLoaded = TRUE
	For YLoop = 0 to PKSetup.TileDefHeight -1
		For XLoop = 0 to PKSetup.TileDefWidth - 1
			HBColor = XTReadMemblockPixel( TempImageBlock, XLoop, YLoop )
			FinalColor As Integer
			FinalColor = ( dbRGBAr( HBColor ) + dbRGBAg( HBColor ) + dbRGBAb( HBColor ) ) / 3
			XTWriteMemblockPixel( PKSetup.MaskBlock, MaskBlockTileXPos + XLoop, MaskBlockTileYPos + YLoop, FinalColor )
			HBColorR As Integer
			HBColorR = XTReadMemblockPixel( PKSetup.MaskBlock, MaskBlockTileXPos + XLoop, MaskBlockTileYPos + YLoop )
			// DebugMessage( "Source = " + Hex( HBColor ) + " Read = " + Hex( HBColorR ) )
		Next XLoop
	Next YLoop
EndFunction

/* ************************************************************************
 * @Description : Méthode Interne pour créer ou redimensionner le bloc mémoire contenant tous les masques de collisions 8 bits
 *
 * @Param : RequestedAmountOfTiles = Nombre de tiles devant être gérées par le bloc mémoire de masques 8 bits
 *
 * @Author : Frédéric Cordier
*/
Function Internal_CreateResizeMaskBlock( RequestedAmountOfTiles As Integer )
	TilesPerLines As Integer = 8
	NewMaskBlock As Integer = -1
	AmountOfTilesLines As Integer = -1
	AmountOfTiles As Integer = -1
	NewMaskBlockSize As Integer = -1
	if RequestedAmountOfTiles > PKSetup.MaskTileAmount
		AmountOfTilesLines = Trunc( RequestedAmountOfTiles / TilesPerLines ) + 2
		AmountOfTiles = AmountOfTilesLines * TilesPerLines
		NewMaskBlockSize = 12 + ( ( TilesPerLines * PKSetup.TileDefWidth ) * ( PKSetup.TileDefHeight * AmountOfTilesLines ) ) // 8 bits bloc = 1 octet per pixel
		NewMaskBlock = XTCreateImageMemblock( TilesPerLines * PKSetup.TileDefWidth, PKSetup.TileDefHeight * AmountOfTilesLines, 8 )
		if getMemblockExists( PKSetup.MaskBlock )
			CopyMemblock( PKSetup.MaskBlock, NewMaskBlock, 12, 12, getMemblockSize( PKSetup.MaskBlock ) - 12 ) // Copie de l'ancien bloc dans le nouveau plus grand
			DeleteMemblock( PKSetup.MaskBlock )                                                                // Effacement de l'ancien bloc
		Endif
		PKSetup.MaskBlock = NewMaskBlock                                                                       // Mise à jour des informations systèmes 
		PKSetup.MaskTileAmount = AmountOfTiles                                                                 // Mise à jour des informations systèmes
	endif
EndFunction

/* ************************************************************************
 * @Description : Vérifie si un masque spécifique a été créé pour la tile demandée
 *
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : TRUE si le masque a été ajouté au bloc mémoire dédié aux masques 8 bits, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileMaskExist( TileID As Integer )
	isExist As Integer : isExist = FALSE
	If PKGetTileExists( TileID ) = TRUE
		isExist = getMemblockExists( PKSetup.MaskBlock )
	endif
EndFunction isExist

/* ************************************************************************
 * @Description : Renvoie l'index de l'image de masque utilisée pour la tile demandée
 *                Si le mode LowMemoryMode est actif, cette méthode renverra toujours 0 car l'image est supprimée une fois le masque créé dans le bloc mémoire dédié
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : L'index de l'image utilisée pour le masque de collisions 8 bits de la tile demandée.
 *           Sinon : -1 si aucun masque n'a été défini
 *                 ou 0 si l'image de masque a été supprimée de la mémoire (low memory) après création de sa partie memblock 8 bits
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileMaskIMAGE( TileID As Integer )
	imageID As Integer = -1
	If PKGetTileExists( TileID ) = TRUE
		imageID = PKTile[ TileID ].MaskImageID
		if getImageExists( imageID ) = FALSE then imageID = 0
	endif
EndFunction imageID

/* ************************************************************************
 * @Description : Créé une image de masque d'effets de lumière en normal mapping pour la tile demandée
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque de normal mapping
 * @Param : ImageID = L'index de l'image utilisée pour créer le masque de normal mapping
 *
 * @Author : Frédéric Cordier
*/
Function PKCreateTileNMap( TileID As Integer, ImageID As Integer )
	If PKGetTileExists( TileID ) = TRUE
		If GetImageExists( Abs( ImageID ) ) = TRUE       // Abs to handle negative values for "loaded for the tile"
			PKTile[ TileID ].NMapImageID = ImageID
			Internal_AddTileNMapToNMapBlock( TileID ) // On ajoute le Mask au bloc mémoire des masques d'images.
/*			if PKSetup.LowMemoryMode = 1
				DeleteImage( Abs( ImageID ) )         // Abs to handle negative values for "loaded for the tile"
				PKTile[ TileID ].NMapImageID = 0 // put to positive to handle image to not be deleted when Tiles are cleared as it was already deleted
			Endif */
			PKTile[ TileID ].NMapFromCollection = EmptyCollection
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMask - Image index '" + Str( ImageID ) + "' does not exists." )
		Endif
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMask - The requested TileID " + Str( TileID ) + " does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Créé ou modifie une image de Normal Mappint pour la tile demandée
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque de Normal mappint dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque 8 bits
 * @Param : ImageID = L'index de l'image utilisée pour créer le masque de normal mapping
 *
 * @Author : Frédéric Cordier
*/
Function PKSetTileNMap( TileID As Integer, NewNMAPImageID As Integer )
	// Si la Tile demandée existe et que la nouvelle image existe,
	if PKGetTileExists( TileID ) = TRUE
		if getImageExists( NewNMAPImageID ) = TRUE
			// Si un masque de Normal Mapping avait déjà été créé on l'update
			if PKTile[ TileID ].NMapImageID <> 0
				if PKTile[ TileID ].NMapImageID < 0 Then DeleteImage( Abs( PKTile[ TileID ].NMapImageID ) )
				PKTile[ TileID ].NMapImageID = NewNMAPImageID
				PKTile[ TileID ].NMapFileName = NULL
				Internal_AddTileNMapToNMapBlock( TileID )
			Else
				PKCreateTileNMap( TileID, NewNMAPImageID )
			Endif
		Else
			CastError( "PKSetTileMask Error : The required mask image does not exists" )
		Endif
	else
		CastError( "PKSetTileMask Error : The required tile does not exists" )
	Endif
EndFunction



/* ************************************************************************
 * @Description : Créé une image de masque d'effets de lumière en normal mapping pour la tile demandée à partir d'une image stockée dans un fichier
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de normal mapping
 * @Param : MaskFileName = Le nom du fichier image à utiliser pour créer le normal mapping
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadTileNMap( TileID As Integer, NMapFileName As String )
	MaskImageID As Integer = -1
	ImageID As Integer = -1
	If PKGetTileExists( TileID ) = TRUE
		If getFileExists( NMapFileName ) = 1
			ImageID = LoadImage( NMapFileName )
			PKCreateTileNMap( TileID, 0 - ImageID )
			If ( TileID > 0 )
				PKTile[ TileID ].NMAPFileName = NMapFileName
			Else
				CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTileMask - Tile was not successfully created from Image" )
			Endif
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTileMask - Image file '" + NMapFileName + "' does not exists." )
		Endif

	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKLoadTileMask - The requested TileID " + Str( TileID ) + " does not exist" )
	Endif
EndFunction TileID

/* ************************************************************************
 * @Description : Créé une image de masque d'effets de lumière en normal mapping pour la tile demandée à partir d'une collection d'images pré-chargée
 *                Si le mode LowMemoryMode est actif, l'image utilisée est supprimée après la création du masque dans le bloc mémoire dédié.
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de normal mapping
 * @Param : ImageCollection = La collection d'image dans laquelle l'image de la tile à créer est présente
 * @Param : ImageName = Nom de l'image dans le fichier d'index de collection 'subimages.txt'
 *
 * @Author : Frédéric Cordier
*/

Function PKLoadTileNMapFromCollectionImage( TileID As Integer, ImageCollection Ref As PKTileCollection_Type, ImageName As String )
	ImageID As Integer = -1
	If PKGetTileExists( TileID ) = TRUE
		ImageID = PKLoadSubImageFromCollection( ImageCollection, ImageName )
		If getImageExists( ImageID ) = 1
			PKCreateTileNMap( TileID, ImageID )
			PKTile[ TileID ].NMapName = ImageName
		Else
			CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMaskFromCollectionImage - The requested Image " +ImageName + " was not found in Image Collection" + ImageCollection.FileName )
		Endif
	Else
		CastError( "2DPluginKIT Ver 2.0 Error : PKCreateTileMaskFromCollectionImage - The requested TileID " + Str( TileID ) + " does not exist" )
	Endif
EndFunction TileID

/* ************************************************************************
 * @Description : Méthode interne pour ajouter un masque d'effets de lumière en normal mapping dans le bloc mémoire dédiée au stockage de tous les masques de normal mapping
 *
 * @Param : TileID = L'index de la tile pour laquelle on va mettre en place une image de masque normal mapping
 *
 * @Author : Frédéric Cordier
*/
Function Internal_AddTileNMapToNMapBlock( TileID As Integer )
	TempImageBlock As Integer = -1
	NMapBlockTileXPos As Integer = -1
	NMapBlockTileYPos As Integer = -1
	XLoop As Integer = -1 : YLoop As Integer = -1
	RGBColor As Integer = 0
	Internal_CreateResizeNMapBlock( TileID )                                                                   // Si la TileID > PKSetup.NMAPTileAmount alors Resize or Create
	TempImageBlock = CreateMemblockFromImage( PKTile[ TileID ].NMapImageID )
//	TempImageBlock = CreateMemblockFromImage( PKTile[ TileID ].ImageID )
	NMapBlockTileYPos = Trunc( TileID / 8 ) * PKSetup.TileDefHeight
	NMapBlockTileXPos = ( TileID - ( Trunc( TileID / 8 ) * 8 ) ) * PKSetup.TileDefWidth
	PKTile[ TileID ].NMapXPos = NMapBlockTileXPos
	PKTile[ TIleID ].NMapYPos = NMapBlockTileYPos
	PKTile[ TileID ].nmapLoaded = TRUE
	For YLoop = 0 to PKSetup.TileDefHeight -1
		For XLoop = 0 to PKSetup.TileDefWidth - 1
			RGBColor = XTReadMemblockPixel( TempImageBlock, XLoop, YLoop )
			XTWriteMemblockPixel( PKSetup.NMapBlock, NMapBlockTileXPos + XLoop, NMapBlockTileYPos + YLoop, RGBColor )
		Next XLoop
	Next YLoop
EndFunction

/* ************************************************************************
 * @Description : Méthode Interne pour créer ou redimensionner le bloc mémoire contenant tous les masques d'effets de lumière en normal mapping
 *
 * @Param : RequestedAmountOfTiles = Nombre de tiles devant être gérées par le bloc mémoire de masques de normal mapping
 *
 * @Author : Frédéric Cordier
*/
Function Internal_CreateResizeNMapBlock( RequestedAmountOfTiles As Integer )
	NewNMapBlock As Integer = -1
	AmountOfTilesLines As Integer = -1
	AmountOfTiles As Integer = -1
	NewNMapBlockSize As Integer = -1
	if RequestedAmountOfTiles > PKSetup.NMapTileAmount
		AmountOfTilesLines = Trunc( RequestedAmountOfTiles / 8 ) + 2
		AmountOfTiles = AmountOfTilesLines * 8
		NewNMapBlockSize = 12 + ( ( 8 * PKSetup.TileDefWidth ) * ( PKSetup.TileDefHeight * AmountOfTilesLines ) * 4 ) // 32 bits bloc = 4 octet per pixel
		NewNMapBlock = XTCreateImageMemblock( 8 * PKSetup.TileDefWidth, PKSetup.TileDefHeight * AmountOfTilesLines, 32 )
		if getMemblockExists( PKSetup.NMapBlock )
			CopyMemblock( PKSetup.NMapBlock, NewNMapBlock, 12, 12, getMemblockSize( PKSetup.NMapBlock ) - 12 ) // Copie de l'ancien bloc dans le nouveau plus grand
			DeleteMemblock( PKSetup.NMapBlock )                                                                // Effacement de l'ancien bloc
		Endif
		PKSetup.NMapBlock = NewNMapBlock                                                                       // Mise à jour des informations systèmes 
		PKSetup.NMapTileAmount = AmountOfTiles                                                                 // Mise à jour des informations systèmes
	endif
EndFunction

/* ************************************************************************
 * @Description : Vérifie si une image de masque de normal mapping spécifique a été créé pour la tile demandée
 *
 * @Param : TileID = L'index de la tile dont on demande l'information
 *
 * @Return : TRUE si le masque de normal mapping a été ajouté au bloc mémoire dédié aux normal mapping, sinon FALSE
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileNMapExist( TileID As Integer )
	isExist As Integer : isExist = FALSE
	If PKGetTileExists( TileID ) = TRUE
		isExist = getMemblockExists( PKSetup.NMapBlock )
	endif
EndFunction isExist

/* ************************************************************************
 * @Description : Renvoie l'index de l'image de normal mapping utilisée pour la tile demandée
 *                Si le mode LowMemoryMode est actif, cette méthode renverra toujours 0 car l'image est supprimée une fois le normal mapping créé dans le bloc mémoire dédié
 * @Param : TileID = L'index de la tile pour laquelle on demande l'information
 *
 * @Return : L'index de l'image utilisée pour le normal mapping  de la tile demandée.
 *
 * @Author : Frédéric Cordier
*/
Function PKGetTileNMapIMAGE( TileID As Integer )
	imageID As Integer = -1
	If PKGetTileExists( TileID ) = TRUE
		imageID = PKTile[ TileID ].NMapImageID
	endif
EndFunction imageID

//
// ************************************************************************
//
Function PKGetTileNMapPixel( TileID As Integer, XPos As Integer, YPos As Integer )
	pixelColor As Integer = 0
	if PKGetTileExists( TileID ) = TRUE
		if PKSetup.NMapBlock  > -1
			if PKTile[ TileID ].nmapLoaded = TRUE
				pixelColor = XTReadMemblockPixel( PKSetup.NMapBlock, PKTile[ TileID ].NMapXPos + XPos, PKTile[ TileID ].NMapYPos + YPos )
			Else
				pixelColor = dbRGBAex( 127, 127, 255, 255 )
			Endif
		Else
			CastError( "PKGetTileNMapPixel Error : There is no normal mapping Block found for the Tile ID Mask datas" )
		Endif
	Else
		CastError( "PKGetTileNMapPixel Error : The requested tile does not exists" )
	Endif
EndFunction pixelColor


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
Function PKGetTilesCount()
EndFunction PKTile.length

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
Function PKSaveTilesData( fileName As String )
	cLoop As Integer = 0
	FileToWrite As Integer = 0
	if PKTile.length > -1
		// 1. We create the file output
		FileToWrite = OpenToWrite( fileName )
			WriteString( FileToWrite, "[XTPK_TilesData]" )
			// 2. we count for each Image Collection, the amount of times they are used for images, mask and normalmapping
			if ImagesCollections.length > -1
				// 2.A. Reset counter for ImagesCollection useage
				for cLoop = 0 to ImagesCollections.length step 1
					ImagesCollections[ cLoop ].timeUsed = 0
				next cLoop
				// 2.B. Check all tiles, mask and normal map to sy if collection is used
				for cLoop = 0  to PKTile.length step 1
					if PKTile[ cLoop ].ImageFromCollection.ImageID <> 0 // We are not with the EmptyCollection
						inc PKTile[ cLoop ].ImageFromCollection.timeUsed, 1
					endif
				next cLoop
				// 2.C. Write data for images collections that were used
				for cLoop = 0 to ImagesCollections.length step 1
					If ImagesCollections[ cLoop ].timeUsed > 0
						WriteString( FileToWrite, "[AddNewImageCollection]" )
						WriteString( FileToWrite, "FileName=" + ImagesCollections[ cLoop ].FileName )
						WriteString( FileToWrite, "TilesWidth=" + Str( ImagesCollections[ cLoop ].TileWidth ) )
						WriteString( FileToWrite, "TilesHeight=" + Str( ImagesCollections[ cLoop ].TileHeight ) )
					Endif
				next cLoop
			endif
			// 3. Now we insert all tiles data
			for cLoop = 0 to PKTile.length step 1
				// 3.1. We create a new tile data
				WriteString( FiletoWrite, "[AddNew2DTile]" )
				// 3.2. We write the tile data
				if PKTile[ cLoop ].FileName <> NULL
					WriteString( FileToWrite, "LoadedFromFile=" + PKTile[ cLoop ].FileName )
				Else
					WriteString( FileToWrite, "LoadedFromCollection=" + PKTile[ cLoop ].ImageFromCollection.FileName )
					WriteString( FileToWrite, "CollectionImageName=" + PKTile[ cLoop ].ImageName )
				Endif
				// 3.3. We write the tile 8 Bits mask image data if available
				if PKTile[ cLoop ].MaskFileName <> NULL
					WriteString( FileToWrite, "MaskLoadedFromFile=" + PKTile[ cLoop ].MaskFileName )
				Else
					if PKTile[ cLoop ].MaskName <> NULL
						WriteString( FileToWrite, "MaskLoadedFromCollection=" + PKTile[ cLoop ].MaskFromCollection.FileName )
						WriteString( FileToWrite, "MaskCollectionImageName=" + PKTile[ cLoop ].MaskName )
					Endif
				Endif
				// 3.4. We write the tile Normal Mapping image data if available
				if PKTile[ cLoop ].NMapFileName <> NULL
					WriteString( FileToWrite, "NMapLoadedFromFile=" + PKTile[ cLoop ].NMapFileName )
				Else
					if PKTile[ cLoop ].NMAPName <> NULL
						WriteString( FileToWrite, "NMapLoadedFromCollection=" + PKTile[ cLoop ].NMAPFromCollection.FileName )
						WriteString( FileToWrite, "NMapCollectionImageName=" + PKTile[ cLoop ].NMAPName )
					Endif
				Endif
				WriteString( FileToWrite, "[New2DTileDefinitionEnd]" )
			Next cLoop
			// 3.4. We write end of file
			WriteString( FileToWrite, "[EOF]" )
		CloseFile( FileToWrite )
	endif
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
Function PKLoadTilesData( fileName As String )
	FileToLoad As String = "" : TempStr As String = ""
	TileWidth As Integer : TileHeight As Integer
	if getFileExists( fileName ) = TRUE
		if PKTile.length > -1 and PKSetup.MultiTileSets = FALSE
			CastError( "PKLoatTilesData : Some tiles already exists. This method must be used only when no tiles exists (Otherwise set PKSetup.MultiTileSets = TRUE to allow multiple tile sets loads" )
		Else
			fileToRead As Integer = 0
			fileToRead = OpenToRead( fileName )
			inString As String = ""
			Repeat
				inString = ReadString( fileToRead )
				// Nouvelle collection d'image à ajouter.
				if inString = "[AddNewImageCollection]"
					FileToLoad = "" : TileWidth = -1 : TileHeight = -1
					// Get 'FileName' to use to load ImageCollection
					TempStr = ReadString( fileToRead )
					FileToLoad = Replace( TempStr, "FileName=", "" )
					TempStr = ReadString( fileToRead )
					TileWidth = Val( Replace( TempStr, "TilesWidth=", "" ) )
					TempStr = ReadString( fileToRead )
					TileHeight = Val( Replace( TempStr, "TilesHeight=", "" ) )
					PKCreateNewImageCollection( FileToLoad, TileWidth, TileHeight )
				Elseif inString = "[AddNew2DTile]"
					TileFromFile As String = ""
					TileFromCollection As String = ""
					TileFromCollectionImageName As String = ""
					MaskFromFile As String = ""
					MaskFromCollection As String = ""
					MaskFromCollectionImageName As String = ""
					NMapFromFile As String = ""
					NMapFromCollection As String = ""
					NMapFromCollectionImageName As String = ""
					Repeat
						TempStr = ReadString( fileToRead )
						if Contains( TempStr, "LoadedFromFile=" ) = TRUE
							TileFromFile = Replace( TempStr, "LoadedFromFile=", "" )
						ElseIf Contains( TempStr, "LoadedFromCollection=" ) = TRUE
							TileFromCollection = Replace( TempStr, "LoadedFromCollection=", "" )
						ElseIf Contains( TempStr, "CollectionImageName=" ) = TRUE
							TileFromCollectionImageName = Replace( TempStr, "CollectionImageName=", "" )
						ElseIf Contains( TempStr, "MaskLoadedFromFile=" ) = TRUE
							MaskFromFile = Replace( TempStr, "MaskLoadedFromFile=", "" )
						ElseIf Contains( TempStr, "MaskLoadedFromCollection=" ) = TRUE
							MaskFromCollection = Replace( TempStr, "MaskLoadedFromCollection=" , "" )
						ElseIf Contains( TempStr, "MaskCollectionImageName=" ) = TRUE
							MaskFromCollectionImageName = Replace( TempStr, "MaskCollectionImageName=", "" )
						ElseIf Contains( TempStr, "NMapLoadedFromFile=" ) = TRUE
							NMapFromFile = Replace( TempStr, "NMapLoadedFromFile=", "" )
						ElseIf Contains( TempStr, "NMapLoadedFromCollection=" ) = TRUE
							NMapFromCollection = Replace( TempStr, "NMapLoadedFromCollection=" , "" )
						ElseIf Contains( TempStr, "NMapCollectionImageName=" ) = TRUE
							NMapFromCollectionImageName = Replace( TempStr, "NMapCollectionImageName=", "" )
						ElseIf TempStr = "[New2DTileDefinitionEnd]"
						Else
							CastError( " PKLoadTilesData Error : Incorrect data found in [AddNew2DTile] block : " + TempStr )
						Endif
					Until TempStr = "[New2DTileDefinitionEnd]"
					// Now that the new 2DTiles Data are fully read we load the tile
					NewTileCreated As Integer = -1
					if Len( TileFromFile ) > 0
						NewTileCreated = PKLoadTile( TileFromFile, 1 )
					ElseIf Len( TileFromCollection ) > 0 And Len( TileFromCollectionImageName ) > 0
						PKLoadTileFromCollectionImage( PKFindImageCollectionByFileName( TileFromCollection ), TileFromCollectionImageName, 1 )
					Endif
					// Secondly, if tile was created, we check if MASK & NMAP are available
					if NewTileCreated > -1
						// Concerning the 8 Bits collisions mask
						if Len( MaskFromFile ) > 0
							PKLoadTileMask( NewTileCreated, MaskFromFile )
						ElseIf Len( MaskFromCollection ) > 0 And Len( MaskFromCollectionImageName ) > 0
							PKLoadTileMaskFromCollectionImage( NewTileCreated, PKFindImageCollectionByFileName( MaskFromCollection ), MaskFromCollectionImageName )
						Endif
						// Concerning the Normal Mapping mask
						if Len( NMapFromFile ) > 0
							PKLoadTileNMap( NewTileCreated, NMapFromFile )
						ElseIf Len( NMapFromCollection ) > 0 And Len( NMapFromCollectionImageName ) > 0
							PKLoadTileNMapFromCollectionImage( NewTileCreated, PKFindImageCollectionByFileName( NMapFromCollection ), NMapFromCollectionImageName )
						Endif
					Endif
				Endif
			until inString = "[EOF]" or FileEOF( fileToRead ) = 1
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

