//
// ***********************************************
// *                                             *
// * 2DPlugKIT Include File : SYSTEM DEFINITIONS *
// *                                             *
// ***********************************************
// Start Date : 2019.04.23 22:45
// Description : Default 2DPluginKIT Ver 2.0 System informations
// Author : Frédéric Cordier

//
// *********************                                                                                                                           *************
// *
// ***************************************************************************************************************************************** 2DPluginKIT - Setup
// *
// *************                                                                                                                           *********************
//

Type PKSetup_Type
	// ******************** System Parameters
	DebugMode As Integer
	LowMemoryMode As Integer
	DynamicDeletion As Integer
	OutputPATH As String
	// ******************** System Timer variables
	PreviousTimer As Float                                   // Timer de début de mesures
	NewTimer As Float                                        // Timer de fin de mesure (qui sera envoyé au PreviousTimer pour la prochaine mesure)
	// ******************** Tiles System
	TileDefWidth As Integer                                  // Default tile pixel width
	TileDefHeight As Integer                                 // Default tile pixel height
	TileDefTransp As Integer                                 // Default transparency for tiles
	TileAutoMask As Integer                                  // Génère automatiquement une image de masque 8 Bits
	TileAutoNMap As Integer                                  // Génère automatiquement une image de normal mapping pour la tile
	TileTrueSubImage As Integer                              // Si ce paramètre est défini à 1, alosr une tile crée depuis une collection d'image sera en subimage, sinon en copyimage.
	TileSpriteID As Integer                                  // Numéro de Sprite utilisé pour les tiles.
	// ******************** Tiles
	MultiTileSets As Integer
	// ******************** Memblocks for Mask & Normal Mapping
	MaskBlock As Integer
	MaskTileAmount As Integer
	NMapBlock As Integer
	NMapTileAmount As Integer
	// ******************** Layers
	GameLayer As Integer                                     // Layer used for main game support (generally player & enemies)	
	outZoneGivesError As Integer                             // if set to 1, then report errors when try to read layer zone out of defined area with no cycling mode.
	// ******************** Bobs
	BobsDefTrans As Integer
	ImageStartID As Integer
	// ******************** Particles
	defElementsAmount As Integer
	// ******************** Virtual Lights system
	VLRefreshForce As Integer
	// ******************** Display Resolution borders
	VWidth As Integer                                        // virtual Resolution Width
	VHeight As Integer                                       // virtual Resolution Height
	WWidth As Integer                                        // Window Resolution Width
	WHeight As Integer                                       // Window Resolution Height
	zFactor As Float                                         // Default Zoom Factor WindowSizes/VirtualSizes
	rZoom As Integer

EndType
Global PKSetup As PKSetup_Type                               // Création des données réelles
// ******************** 
PKSetup.DebugMode = TRUE                                     // Le mode debug est activé par défaut.
PKSetup.LowMemoryMode = FALSE                                // Si activé à 1, supprime les images de MASQUE et de NORMAL MAPPING une fois le MEMBLOCK associété mis à jour avec les informations de l'image.
PKSetup.OutputPATH = GetReadPath()
SetRawWritePath( PKSetup.OutputPATH )                        // 2020.04.05 To output LightMaps images inside %PROJECT%/media/pklightmaps/
PKSetup.rZoom = FALSE
PKSetup.zFactor = 1.0

// ******************** 
PKSetup.PreviousTimer = timer() : PKSetup.NewTimer = Timer() // Default Timer Setup to avoid big differency on starting calculations
// ******************** 
PKSetup.TileDefWidth = 32 : PKSetup.TileDefHeight = 32       // Default tiles sizes are 16x16 pixels
PKSetup.TileDefTransp = 0                                    // Default to no transparency for tiles
PKSetup.TileAutoMask = -1 : PKSetup.TileAutoNMap = -1        // No Mask nor normal mapping generation on tile loading/creation
PKSetup.TileTrueSubImage = 0                                 // Default to SubImage
PKSetup.TileSpriteID = -1                                    // Default sprite used for tiles.
// ******************** 
PKSetup.MaskBlock = -1 : PKSetup.MaskTileAmount = -1          // Paramètres par défaut des blocs mémoires pour les Mask 8 bits et les Normal Mapping.
PKSetup.NMapBlock = -1 : PKSetup.NMapTileAmount = -1          // Paramètres par défaut des blocs mémoires pour les Mask 8 bits et les Normal Mapping.
// ******************** 
PKSetup.MultiTileSets = FALSE
// ********************
PKSetup.BobsDefTrans = 0
PKSetup.ImageStartID = 100000
// ********************
PKSetup.defElementsAmount = 64
// ********************
PKSetup.VLRefreshForce = FALSE
//
// *********************                                                                                                                           *************
// *
// ******************************************************************************************************************************* Tiles System - SubImage Datas 
// *
// *************                                                                                                                           *********************
//

Type SubImageData_Type
	ImageName As String
	XPos As Integer
	YPos As Integer
	Width As Integer
	Height As Integer
Endtype
Global EmptySubImageData As SubImageData_Type
EmptySubImageData.Imagename = ""

//
// *********************                                                                                                                           *************
// *
// ********************************************************************************************************************Tiles System - Images Collections Support
// *
// *************                                                                                                                           *********************
//

// Utilisé pour gérer les images de collection de tiles, de masques de tiles et de normalmapping.
Type PKTileCollection_Type
	FileName As String                        // Nom du fichier image en cas de chargement d'une collection
	ImageID As Integer                        // Numéro de l'image chargée
	Width As Integer                          // Largeur de l'image en pixels
	Height As Integer                         // Hauteur de l'image en pixels
	TileWidth As Integer                      // Largeur en pixels d'une tile dans l'image
	TileHeight As Integer                     // Hauiteur en pixels d'une tile dans l'image
	MemblockID As Integer                     // Numéro du bloc mémoire utilisé pour le stockage des données 8 bits
	TilesAmount As Integer                    // Quantité de tiles de type Mask dans l'image. ( multiple de 16 car 16 Tiles par lignes
	ImagesListe As SubImageData_Type[]        // Liste des images extraites du fichier de collection d'images.
	timeUsed As Integer                       // Nombre de fois utilisé pour des tiles.
EndType
// Setup default empty collection for default PKTiles collections variables values
Global EmptyCollection As PKTileCollection_Type
EmptyCollection.ImageID = 0
// Liste des collections d'images utilisées pour créer les images
Global ImagesCollections As PKTileCollection_Type[]         // Si plusieurs collections d'images ont été téléchargées. Elles peuvent être utilisées pour les images, les masques et les normal mapping
Global LastCollectionFirstTile As PKTileCollection_Type
global LastCollectionTilesAmount As Integer 
LastCollectionFirstTile = EmptyCollection     // Index de la 1ère tile de la dernière collection chargée
LastCollectionTilesAmount = 0 // Quantité de tiles extraites de la dernière collection chargée

//
// *********************                                                                                                                           *************
// *
// **************************************************************************************************************************************** Tiles System - Tiles 
// *
// *************                                                                                                                           *********************
//

// Utilisé pour créer les informations de chaque tile créée.
Type PKTiles_Type
	FileName As String
	maskLoaded As Integer
	MaskFileName As String
	nmapLoaded As Integer
	NMapFileName As String
	Width As Integer
	Height As Integer
	Transparency As Integer
	ImageID As Integer
	MaskImageID As Integer
	NMapImageID As Integer
	AnimationID As Integer
	AnimFrameID As Integer
	ImageFromCollection As PKTileCollection_Type             // Set to 1 if image was taken from an image collection
	ImageName As String                                      // Le nom de l'image dans la Collection (ImageFromCollection)
	MaskFromCollection As PKTileCollection_Type              // Set to 1 if mask image was taken from an image collection
	MaskName As String                                       // Nom de l'image dans la collection
	NMapFromCollection As PKTileCollection_Type              // Set to 1 if normal map image was taken from an image collection
	NMapName As String                                       // Nom de l'image dans la collection
	MaskXPos As Integer
	MaskYPos As Integer
	NMapXPos As Integer                                      // 2020.03.29 Added for Normal mapping tests
	NMapYPos As Integer                                      // 2020.03.29 Added for Normal mapping tests.
EndType
Global PKTile As PKTiles_Type[]             // Gestion dynamique des tiles.

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************ Blitter Objects To Layers - Bobs & Layers System 
// *
// *************                                                                                                                           *********************
// 2020.03.21 Adding this section

Type PKLayersObjects_Type
	ObjectID As Integer
	ObjectName As String
EndType

//
// *********************                                                                                                                           *************
// *
// *************************************************************************************************************************************** Layer System - Layers
// *
// *************                                                                                                                           *********************
//

Type PKLayer_Type
	Name As String                         // Name of the layer
	MemblockID As Integer                  // Numéro du bloc mémoire utilisé pour stoquer le layer.
	MemorySize As Integer                  // Dimension de la zone mémoire allouée pour créer le layer.
	StoreSize As Integer                   // Dimension de stockage en octets d'une tile du layer ( 8, 16 ou 32 bits )
	Width As Integer                       // Largeur en nombre de tiles du layer.
	Height As Integer                      // Hauteur en nombre de tiles du layer.
	TileWidth As Integer                   // Largeur de tracé des tiles du layer.
	TileHeight As Integer                  // Hauteur de tracé des tiles du layer.
	Hidden As Integer                      // Hide a layer to not draw it when not required.
	XDisplay As Float                      // A partir de quel endroit dans le layer, sur X, on tracera sur l'écran (scrolling).
	YDisplay As Float                      // A partir de quel endroit dans le layer, sur Y, on tracera sur l'écran (scrolling).
	XStart As Integer                      // Début du tracé sur X dans l'écran.
	YStart As Integer                      // Début du tracé sur Y dans l'écran.
	XEnd As Integer                        // Fin du tracé sur X dans l'écran.
	YEnd As Integer                        // Fin du tracé sur Y dans l'écran.
	XCycle As Integer                      // Le layer cycle t-il sur X ?
	YCycle As Integer                      // Le layer cycle t-il sur Y ?
	ScrollMODE As Integer                  // Défini le type de scrolling du layer 0=Statique, 1=Relatif, 2 = Constant
	XSpeed As Float                        // Défini la vitesse de scrolling sur X.
	YSpeed As Float                        // Défini la vitesse de scrolling sur Y.
	CameraLOCK As Integer                  // Définit si la caméra peut afficher des zones hors layer ou si elle se bloque en bordure.
	BobsID As Integer[]                    // Tableau contenant les index des bobs rattachés au Layer
	PKLayersBobs As PKLayersObjects_Type[] // 2020.03.21 Added to allow bobs to be attached to layers
	PKParticles As Integer[]               // 2020.03.27 Added to allow Particles to be attached to layers
	PKLights As Integer[]                  // 2020.03.28 Added to allow Virtual Lights to be attached to layers
EndType
Global PKLayer As PKLayer_Type[]
Global EmptyLayer As PKLayer_Type
EmptyLayer.MemblockID = -1
EmptyLayer.MemorySize = -1
EmptyLayer.Hidden = TRUE

//
// *********************                                                                                                                           *************
// *
// ********************************************************************************************************************************* Sprites System - Collisions
// *
// *************                                                                                                                           *********************
//

Type SPCollision_Type
	ImageID As Integer
	srcFileName As String                                    // The fileName used to load original Image
	MemblockID As Integer
EndType
Global SprCollision As SPCollision_Type[]

// ****************************************** Sprites Advanced Collision System Ver 2.0
Type Spot_Struct
	XPos As Float
	YPos As Float
EndType
global SpotA as Spot_Struct [ 4 ]
global SpotB as Spot_Struct [ 4 ]

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************** Virtual 2D Light - 2D Light System 
// *
// *************                                                                                                                           *********************
//

Type P2DLights_Type
	Name As String                // The name given to the virtual light
//	Active As Integer             // La lumière existe ou pas.
	PlayMODE As Integer           // 0 = Statique, 1 = Torche, 2 = Pulse, 3 = Défectueuse/Random
	CyclePOS As Integer           // Position dans le cycle ... 
	XPos As Integer               // abscisse de la lumière dans le layer.
	YPos As Integer               // Ordonnée de la lumière dans le layer.
	Rouge As Integer              // Composante rouge de la couleur de la lumière virtuelle.
	Vert As Integer               // Composante verte de la couleur de la lumière virtuelle.
	Bleu As Integer               // Composante bleue de la couleur de la lumière virtuelle.
	Intensite As Integer          // Intensité de la lumière virtuelle.
	Range As Integer              // Range de l'image
	ImgWIDTH As Integer           // Largeur et hauteur de l'image, utilisée pour les calculs de positionnement de la lumière.
	Mode As Integer               // Mode utilisé pour la lumière.
	Hide As Integer               // La lumière doit-elle être tracée dans l'écran ou pas ?
	ImageLOADED As Integer        // Image qui sert à rendre la lumière dans la zone de jeu.
	LayerID As Integer            // Layer auquel l'image sera rattachée.
	XDisplayPOS As Integer        // Position de la lumière lors du dernier tracé dans l'écran.
	YDisplayPOS As Integer        // Position de la lumière lors du dernier tracé dans l'écran.
	CastSHADOWS As Integer        // If the light cast shadows.
	CastNMAP As Integer           // If the light case Normal mapping.
	CastBRIGHT As Integer         // If the max brightness is enabled
	DBSprite As Integer           // Si nous utilisons le mode SPRITES de DarkBASIC Professional.
Endtype
Global P2DLights As P2DLights_Type[]

Type AmbientLight_Type
	Red As Integer                // Composante rouge de la lumière d'ambiance.
	Green As Integer              // Composante verte de la lumière d'ambiance.
	Blue As Integer               // Composante Bleue de la lumière d'ambiance.
Endtype
Global Ambient As AmbientLight_Type


//
// *********************                                                                                                                           *************
// *
// ******************************************************************************************************************************* Blitter Objects - Bobs System 
// *
// *************                                                                                                                           *********************
//

Type Bobs_Type
	Index As Integer
	Name As String
	Active As Integer               // L'objet blitter existe.
	InstanceID As Integer           // Si le bob est une instance d'un autre bob.
	ImageID As Integer              // Numéro de l'image à utiliser dessus.
	EXTLoaded As Integer            // = 1 si l'image à été chargée par eXtends via 2DPlugKIT.
	Width As Integer                // Largeur de l'image utilisée pour le bob.
	Height As Integer               // Hauteur de l'image utilisées pour le bob.
	AnimationID As Integer          // Add an animation Type to the tile.
	LayerID As Integer              // Numéro du layer dans lequel le bob sera affiché (juste au dessus du Layer)
	LayerName As String             // Nom du Layer dans lequel le bob sera affiché (juste au dessus du Layer)
	XPos As Integer                 // Position sur X dans le layer.
	YPos As Integer                 // Position sur Y dans le layer.
	Hide As Integer                 // Définit si l'objet doit être caché ou pas.
	Transparency As Integer         // Tracer l'image en utilisant la transparence.
	M2ESprite As Integer            // Utiliser les sprites M2E pour le tracé.
	DBSprite As Integer             // Utiliser les sprites de DBPro pour le tracé.
	XTiles As Integer               // Nombre d'images par lignes sur X (de gauche à droite )
	YTiles As Integer               // Nombre de lignes d'images sur Y (de haut en bas)
	TilesWIDTH As Integer
	TilesHEIGHT As Integer
	FramesCOUNT As Integer          // Nombre d'images découpées dans le bob
	CurrentFRAME As Integer         // Numéro de l'image ou de la frame dans le sprite à afficher.
Endtype
Global Bobs As Bobs_Type[]
Global SpriteForBobs As Integer = 0

//
// *********************                                                                                                                           *************
// *
// **************************************************************************************************************** Bobs and Tiles Animations - Animation System 
// *
// *************                                                                                                                           *********************
//

Type PKAnimation_Type
	Active As Integer               // L'animation existe.
	LoopMODE As Integer             // Défini si l'animation se joue en boucle.
	FrameCount As Integer           // Nombre de frames présentes dans l'animation
	LastFRAME As Integer            // Position dans la séquence d'animation de la tile.
	ImageIDShift As Integer         // Décalage de numérotation d'images pour les animations.
	PlayANIM As Integer             // Est-ce que l'on a commandé d'activer la séquence d'animation de la tile.
	StartTIMER As Integer           // Valeur du timer au lancement de l'animation.
	ObjectID As Integer             // ID de la Tile, du Sprite, du Bob
	ObjectName As String            // Nom de la tile, du sprite ou du bob
	ObjectType As Integer           // 1 = Tile, 2 = Bob, 3 = Sprite
	Speed As Integer                // Défini la vitesse d'animation.
	FramesList As Integer[]         // Définit la liste des frames d'animation
EndType
Global PKAnimations As PKAnimation_Type[]

Type PKObjectType_Type
	Undefined As Integer
	Tile As Integer
	Bob As Integer
	Sprite As Integer
EndType
Global PKObjectType As PKObjectType_Type
PKObjectType.Undefined = 0
PKObjectType.Tile = 1
PKObjectType.Bob = 2
PKObjectType.Sprite = 3

//
// *********************                                                                                                                           *************
// *
// ********************************************************************************************************************* 2D Particles Effects - Particles System 
// *
// *************                                                                                                                           *********************
//

// Définit un type de particules prédéfinies ou standard
Type PKParticleType_Type
	Initial As Integer
	Flames As Integer
	Smoke As Integer
	Snow As Integer
	Rain As Integer
	Sparkles As Integer
	RainDrop As Integer
EndType
Global PKParticleType as PKParticleType_Type
PKParticleType.Initial = 0
PKParticleType.Flames = 1
PKParticleType.Smoke = 2
PKParticleType.Snow = 3
PKParticleType.Rain = 4
PKParticleType.Sparkles = 5
PKParticleType.RainDrop = 6


// Définition d'un élément d'un jeu de particules
Type PKParticleObject_Type
	xPos As Float
	yPos As Float
	Duration As Float
EndType

// Définition d'un jeu de particules
Type PKParticle_Type
	Name As String                  // The Name given to the Particle
	mType As Integer                // Type de particule : Uses PKParticleType defined values
	Count As Integer                // Nombre d'objets composant la particule
	pSize As Integer                // Dimension de la particule
	xEmitter As Integer             // Coordonnée sur X de l'émetteur de particules
	yEmitter As Integer             // Coordonnée sur Y de l'émetteur de particules
	xSize As Float                  // Dimension sur X du cadre de création/action des particules
	ySize As Float                  // Dimension sur Y du cadre de création/action des particules
	xMove As Float                  // Mouvement des particules sur X
	yMove As Float                  // Mouvement des particules sur Y
	XMin As Float                   // Coordonnée minimale sur X d'une particule (Mur gauche)
	YMin As Float                   // Coordonnée minimale sur Y d'une particule (Plafond)
	XMax As Float                   // Coordonnée maximale sur X d'une particule (Mur droite)
	YMax As Float                   // Coordonnée maximale sur Y d'une particule (Sol)
	Duration As Float               // Durée de vie d'une particule
	Hide As Integer                 // Cache la particule
	ImageID As Integer              // Image utilisée pour les particules
	SpriteID As Integer             // Sprite utilisé pour le jeu de particules.
	LayerID As Integer              // Layer de rattachement du jeu de particules
	OldTime As Integer              // Timer interne pour la vitesse d'animation de la particule
	ActualTime As Integer           // Timer interne pour la vitesse d'animation de la particule
	TimeChange As Integer           // Timer interne pour la vitesse d'animation de la particule
	TimeFactor As Float             // Timer interne pour la vitesse d'animation de la particule
	pElement As PKParticleObject_Type[] // Liste des éléments de la particule
EndType
// Textures par défaut des types de particules prédérinies.
Global PKParticle As PKParticle_Type[]

global iPKFlame As String = "ipk_flame.png"
global iPKSnow As String = "ipk_snow.png"
global iPKRain As String = "ipk_rain.png"
global iPKSparkle As String = "ipk_sparkle.png"
global iPKRainDrop As String  = "ipk_raindrop.png"
global iPKBubble As String = "ipk_bubble.png"

// Définition des textures de particules
Type PKParticlesTextures_Type
	pkFlames As Integer
	pkFlamesCount As Integer
	pkSmoke As Integer
	pkSmokeCount As Integer
	pkSnow As Integer
	pkSnowCount As Integer
	pkRain As Integer
	pkRainCount As Integer
	pkSparkles As Integer
	pkSparklesCount As Integer
	pkRainDrop As Integer
	pkRainDropCount As Integer
EndType
Global PKParticlesTextures as PKParticlesTextures_Type
PKParticlesTextures.pkFlames = -1
PKParticlesTextures.pkFlamesCount = 0
PKParticlesTextures.pkSmoke = -1
PKParticlesTextures.pkSmokeCount = 0
PKParticlesTextures.pkSnow = -1
PKParticlesTextures.pkSnowCount = 0
PKParticlesTextures.pkRain = -1
PKParticlesTextures.pkRainCount = 0
PKParticlesTextures.pkSparkles = -1
PKParticlesTextures.pkSparklesCount = 0
PKParticlesTextures.PkRainDrop = -1
PKParticlesTextures.PkRainDropCount = 0

