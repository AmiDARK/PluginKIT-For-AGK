//
// ***********************************************************
// *                                                         *
// * eXtends Ver 2.0 Include File : Image Collection Support *
// *                                                         *
// ***********************************************************
// Start Date : 2019.04.23 22:48
// Description : 
// Author : Frédéric Cordier
//
// **************************************************************************************************************************** Liste des méthodes de la classe :
// ImageCollection_Type = PKCreateNewImageCollection( FileName As String, TileWidth As Integer, TileHeight As Integer )
// ImageCollection_Type = PKFindImageCollectionByFileName( FileName As String )
// ImageID (Integer) = PKLoadSubImageFromCollection( ImageCollection As PKTileCollection_Type, ImageName As String )
// SubImageData = PKGetSubImageCoordinatesFromCollection( ImageCollection As PKTileCollection_Type, ImageName As String )
// inPos (Integer) = Internal_FindSubImageInCollectionlist( ImageCollection As PKTileCollection_Type, ImageName As String ) (Used by PKGetSubImageCoordinatesFromCollection)
// Internal_LoadImageCollectionList( ImageCollection ref As PKTileCollection_Type )


/* ************************************************************************
 * @Description : Charge une nouvelle collection d'images depuis un fichier sur disque
 *
 * @Param : FileName = Le nom du fichier d'images à utiliser pour créer une nouvelle collection d'images
 * @Param : TileWidth = La largeur en pixels d'une tile dans la collection d'images
 * @Param : TileHeight = La hauteur en pixels d'une tile dans la collection d'images
 *
 * @Return : NewImageCollection = La nouvelle collection d'image créée.
 *
 * @Author : Frédéric Cordier
*/
Function PKCreateNewImageCollection( FileName As String, TileWidth As Integer, TileHeight As Integer )
	NewImageCollection As PKTileCollection_Type 
	newImageListe As SubImageData_Type[]
	// Check values for default
	If TileWidth = 0 Then TileWidth = PKSetup.TileDefWidth
	If TileHeight = 0 Then TileHeight = PKSetup.TileDefHeight
	If getFileExists( FileName ) = 1
		ImageID As Integer = -1
		ImageID = LoadImage( FileName )
		NewImageCollection.FileName = FileName
		NewImageCollection.ImageID = ImageID
		NewImageCollection.Width = getImageWidth( ImageID )
		NewImageCollection.Height = getImageHeight( ImageID )
		NewImageCollection.TileWidth = TileWidth
		NewImageCollection.TileHeight = TileHeight
		NewImageCollection.TilesAmount = ( NewImageCollection.Width / TileWidth ) * ( NewImageCollection.Height / TileHeight )
		NewImageCollection.ImagesListe = newImageListe
		NewImageCollection.MemblockID = -1 // Le bloc mémoire n'est créé qu'en cas de besoin pour ne pas alourdir la mémoire.
		ImagesCollections.insert( NewImageCollection )
		// Si Mode extraction d'image par CopyImage au lieu de SubImage, récupération des informations d'images dès le chargement de la collection.
		if PKSetup.TileTrueSubImage = 0 Then Internal_LoadImageCollectionList( NewImageCollection )
	Else
		Message( "PKCreateNewImageCollection : File '" + FileName + "' does not exist" )
		NewImageCollection = EmptyCollection
	Endif
EndFunction NewImageCollection

/* ************************************************************************
 * @Description : Retrouve une collection d'images dans la liste des collections d'images chargées
 *
 * @Param : FileName = Le nom du fichier d'images ayant servi à créer une collection d'images
 *
 * @Return : FeedBackImageCollection = La collection d'image trouvée sinon EmptyCollection
 *
 * @Author : Frédéric Cordier
*/
Function PKFindImageCollectionByFileName( FileName As String )
	FeedBackImageCollection As PKTileCollection_Type
	FeedBackImageCollection = EmptyCollection
	fLoop As Integer = 0
	if ImagesCollections.Length > 0
		For fLoop = 1 to ImagesCollections.Length
			if ImagesCollections[ fLoop ].FileName = FileName
				FeedBackImageCollection = ImagesCollections[ fLoop ]
			Endif
		Next fLoop
	Endif
EndFunction FeedBackImageCollection

/* ************************************************************************
 * @Description : Créé une image à partir d'une subimage ou d'un imagecopy depuis les informations de collection d'image
 *                Selon le paramétrage système TiletrueSubImage de 2DPluginKIT, l'image sera créée par un appel LoadSubImage ou un CopyImage
 *
 * @Param : ImageCollection = Collection d'image dans laquelle l'image à créer est présente
 * @Param : ImageName = Le nom de l'image à trouver dans la collection d'images
 *
 * @Return : ImageID = L'index de la nouvelle image créée
 *
 * @Author : Frédéric Cordier
*/
Function PKLoadSubImageFromCollection( ImageCollection As PKTileCollection_Type, ImageName As String )
	ImageID As Integer = -1
	If PKSetup.TileTrueSubImage = 1
		ImageID = LoadSubImage( ImageCollection.ImageID, ImageName )
	Else
		SubImageData As SubImageData_Type
		SubImageData = PKGetSubImageCoordinatesFromCollection( ImageCollection, ImageName )
		if SubImageData.ImageName = ""
			Message( "L'image '" + ImageName + "' n'a pas été trouvée dans la collection de l'image '" + ImageCollection.FileName + "'." )
		Else
			ImageID = CopyImage( ImageCollection.ImageID, SubImageData.XPos, SubImageData.YPos, SubImageData.Width, SubImageData.Height )
		Endif
	Endif
EndFunction ImageID

/* ************************************************************************
 * @Description : Renvoies les coordonnées de la subimage de la collection dans un objet de type SubImageData
 *
 * @Param : ImageCollection = Collection d'images dans laquelle on va chercher une image précise
 * @Param : ImageName = Le nom de l'image à trouver dans la collection d'images
 *
 * @Return : SubImageData = Données de l'image (nom, xpos, ypos, width, height )
 *
 * @Author : Frédéric Cordier
*/
Function PKGetSubImageCoordinatesFromCollection( ImageCollection As PKTileCollection_Type, ImageName As String )
	inPos As Integer
	SubImageData As SubImageData_Type
	// Ouvrir le fichier de définition des subimages et extraire les dimensions depuis la bonne ligne
// Utiliser l'objet ImageCollection.ImagesListe As String[] pour stocker les données si pas encore utilisées.
	if len( ImageCollection.FileName ) > 0
		// Si la liste de données d'image n'a pas encore été trouvée, on la télécharge
		if ImageCollection.TilesAmount < 1 Then Internal_LoadImageCollectionList( ImageCollection )
		// On scanne la liste pour trouver le bon élément et le renvoyer
		inPos = Internal_FindSubImageInCollectionlist( ImageCollection, ImageName )
		if ( inPos > -1 )
			SubImageData.ImageName = ImageCollection.ImagesListe[ inPos ].ImageName
			SubImageData.XPos = ImageCollection.ImagesListe[ inPos ].XPos
			SubImageData.YPos = ImageCollection.ImagesListe[ inPos ].YPos
			SubImageData.Width = ImageCollection.ImagesListe[ inPos ].Width
			SubImageData.Height = ImageCollection.ImagesListe[ inPos ].Height
		Else
			SubImageData = EmptySubImageData
		Endif
	Else
		SubImageData = EmptySubImageData
	Endif
EndFunction SubImageData

/* ************************************************************************
 * @Description : Méthode interne qui retourne la position de l'image dans la liste de collection d'images
 *
 * @Param : ImageCollection = Collection d'images dans laquelle on va rechercher une image
 * @Param : ImageName = Nom de l'image à trouver
 *
 * @Return : inPos = Index de l'image dans la liste de définitions des images de la collection
 *
 * @Author : Frédéric Cordier
*/
Function Internal_FindSubImageInCollectionlist( ImageCollection As PKTileCollection_Type, ImageName As String )
	siLoop As Integer = 0
	inPos As Integer = -1
	SubImageData As SubImageData_Type
	if ImageCollection.ImagesListe.length < 1 Then Internal_LoadImageCollectionList( ImageCollection )
	if ImageCollection.TilesAmount > 0
		repeat
			siLoop = siLoop + 1
			SubImageData = ImageCollection.ImagesListe[ siLoop ]
		until siLoop > ImageCollection.ImagesListe.length or SubImageData.ImageName = ImageName
		if SubImageData.ImageName = ImageName then inPos = siLoop
	Endif
EndFunction inPos

/* ************************************************************************
 * @Description : Méthode Interne qui créé la liste des images internes à partir des informations du fichier subimages.txt
 *
 * @Param : ImageCollection = Collection d'image depuis laquelle on va construire une liste d'images + coordonnées + dimensions
 *
 * @Author : Frédéric Cordier
*/
Function Internal_LoadImageCollectionList( ImageCollection ref As PKTileCollection_Type )
	FileName As String = ""
	rChar As String = ""
	FirstDD As Integer = -1 : SecondDD As Integer = -1 : ThirdDD As Integer = -1 : FourthDD As Integer = -1
	ImageName As String = ""
	XPos As Integer = -1 : YPos As Integer = -1 : Width As Integer = -1 : Height As Integer = -1
	FileName = Left( ImageCollection.FileName, len( ImageCollection.FileName ) - 4 ) + " subimages.txt"
	FileIO As Integer
	If getFileExists( FileName ) = 1
		FileIO = OpenToRead( FileName )
		FileContent As String
		FileContent = ReadString( FileIO )
		CloseFile( FileIO )
		If Len( FileContent ) > 0
			NewImage As String = ""
			iReadPos As Integer = 1
			lineContent As String = ""
			Repeat
				rChar = Mid( FileContent, iReadPos, 1 )
				If Asc( rChar ) = 13 or iReadPos = len( FileContent )
					iReadPos = iReadPos + 1 // Pour sauter automatiquement du 0x0D au 0x0A
					// On recherche ensuite les 4 instance de ":" dans le texte pour les utiliser en délimiteurs
					FirstDD = indexOf( lineContent, ":" )
					SecondDD = indexOf2( lineContent, ":", FirstDD + 1 )
					ThirdDD = indexOf2( lineContent, ":", SecondDD + 1 )
					FourthDD = indexOf2( lineContent, ":", ThirdDD + 1 )
					// Ensuit on va lire les 5 informations présentes dans la ligne dans la structure associée
					mySubImageData As SubImageData_Type
					mySubImageData.ImageName = Mid( lineContent, 1, FirstDD - 1)
					mySubImageData.XPos = Val( Mid( lineContent, FirstDD + 1, SecondDD - FirstDD -1 ) )
					mySubImageData.YPos = Val( Mid( lineContent, SecondDD + 1, ThirdDD - SecondDD -1 ) )
					mySubImageData.Width = Val( Mid( lineContent, ThirdDD + 1, FourthDD - ThirdDD -1 ) )
					mySubImageData.Height = Val( Mid( lineContent, FourthDD + 1, Len( lineContent ) - FourthDD ) )
					// On insère l'objet dans la liste
					// ImageList As SubImageData_Type[]
					ImageCollection.ImagesListe.insert( mySubImageData )
					// On reset le contenu de lecture
					lineContent = ""
				Else
					// On intègre le prochain caractère dans le contenu de lecture
					lineContent = lineContent + rChar
				Endif
				// On incrémente le compteur de position de lecture
				iReadPos = iReadPos + 1
			// Fin de lecture quand le compteur dépasse la dimension de lecture.
			Until iReadPos > Len( FileContent )
		Else
			Message( "No content was found in " + FileName )
		Endif
	Else
		Message( "Collection file " + FileName + " was not found" )
	Endif
EndFunction
