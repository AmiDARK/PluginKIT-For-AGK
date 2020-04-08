//
// *****************************************************
// *                                                   *
// * eXtends Ver 2.0 Include File : SYSTEM DEFINITIONS *
// *                                                   *
// *****************************************************
// Start Date : 2019.04.23 22:45
//

// Default eXtends Ver 2.0 System informations

Type XTSystem_Type
	ActualTime As Float
	Oldtime As Float
	TimeFactor As Float
EndType
Global XTSystem As XTSystem_Type
XTSystem.ActualTime = Timer()
XTSystem.TimeFactor = 1.0

//
// *********************                                                                                                                           *************
// *
// **************************************************************************************************************************************** XFont - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** eXtends XFonts System Support Ver 2.0
Type XFontSystem_Type
	XCursor As Integer
	YCursor As Integer
	CurrentFont As Integer
	WhereToRender As Integer
	Opaque As Integer
	AutoReturn As Integer
	SpriteID As Integer
EndType
Global XFontSys As XFontSystem_Type
XFontSys.XCursor = 0 : XFontSys.YCursor = 0
XFontSys.CurrentFont = -1 : XFontSys.WhereToRender = -1
XFontSys.Opaque = FALSE : XFontSys.AutoReturn = TRUE
XFontSys.SpriteID = -1

// ************************************************ eXtends XFonts Support Ver 2.0
Type XFont_Type
	Name As String
	FontSize As Integer
	FirstChar As Integer
	mType As Integer
	ImagesID As Integer[]
EndType
Global XFonts As XFont_Type[]
// Empty XFont
Global EmptyXFont As XFont_Type
EmptyXFont.Name = "" : EmptyXFont.mType = -1
EmptyXFont.FontSize = 0 : EmptyXFont.FirstChar = -1

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** XGadget - System Datas 
// *
// *************                                                                                                                           *********************
//

// *********************************************** eXtends XGadget Support Ver 2.0
Type XGadget_Type
	Name As String
	mType As Integer
	XPos As Integer
	YPos As Integer
	Action As Integer
	ImageID As Integer
	XSize As Integer
	YSize As Integer
	TexteToDisplay As String
	XWinName As String                       // 2019.05.08 Nom de la XWindow dans laquelle le gadget est, sinon NULL
	XFont As Integer                         // 2019.05.08 Reinjecté pour les ChatWindowGadget
EndType
Global EmptyXGadget As XGadget_Type
Global OutGadget As XGadget_Type[] // Représente les gadgetes tracés dans l'écrans sans aucune XWindow parent.

// ****************************************** eXtends Chat System for XGadgets
Global ChatText As String[ 32 ]
Global ChatChar As String[ 256 ]

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** XWindow - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** eXtends Windows System Setup Ver 2.0
Type XWindowSystem_Type
	Skin As String
	SkinLoaded As Integer
	SkinSprite As Integer                    // Le numéro d'index du sprite utilisé pour le rendu des skins dans les fenêtres XWindow (XT Ver 2.0)
	CurrentTextFont As Integer               // 2019.05.06 : Objet Texte (CreateText) pour les XWindow
	XGadgetSprite As Integer                 // 2019.05.06 : Sprite pour les Gadgets
	CurrentGadgetFont As Integer             // 2019.05.07 : Objet Texte (CreateText) pour les XGadget
	TextSize As Integer                      // 2019.05.09 : Default Text Size
	CheckPriorities As Integer
	CurrentWindow As Integer
	OldWindow As Integer
	AllowDragging As Integer
	Dragging As Integer
	DragWindow As Integer
	XDragOrigin As Integer
	YDragOrigin As Integer
	XDragMouse As Integer
	YDragMouse As Integer
	AllowAlphaiser As Integer
	CloseMode As Integer
	OldMouseClick As Integer
	CurrentGadget As Integer
	MipMapMode As Integer
	// Fenêtre de contenu des chats passés
	ChatWindowWindowName As String
	ChatWindowGadgetName As String           // 2019.05.08 -> Moved directly inside the dedicaced XGadget
	// Gadget contenant la ligne de chat en cours
	ChatGadgetExist As Integer               // 2019.05.10 : Added to enable chat calculation. Set to TRUE when a gadget is defined as chat gadget
	ChatGadgetWindowName As String           // 2019.05.10 : Added to send directly to the specified gadget the calculation for texts updates.
	ChatGadgetName As String
	ChatInText As String
	ChatReading As Integer
	ChatScanCode As Integer
	LastKey As Integer
 EndType
Global XWinSystem As XWindowSystem_Type
XWinSystem.skin = "" : XWinSystem.SkinLoaded = FALSE
XWinSystem.CheckPriorities = 0
XWinSystem.SkinSprite = 0
XWinSystem.CurrentTextFont = -1 // Pas de fonte prédéfinie
XWinSystem.TextSize = 16
XWinSystem.CurrentGadgetFont = -1
XWinSystem.XGadgetSprite = 0
XWinSystem.CurrentWindow = -1 : XWinSystem.OldWindow = -1
XWinSystem.ChatWindowWindowName = NULL
XWinSystem.ChatWindowGadgetName = NULL
XWinSystem.ChatGadgetWindowName = NULL
XWinSystem.ChatGadgetName = NULL

//
// *********************                                                                                                                           *************
// *
// *************************************************************************************************************************************** XWindow - Skin System
// *
// *************                                                                                                                           *********************
//

// ***************************************** eXtends XWindows Skin Support Ver 2.0
Type SkinImage_Type
	Fichier As String
	ImageID As Integer
	Width As Integer
	Height As Integer
EndType
Global SkinImage As SkinImage_Type[ 16 ] // Définit en Statique délibérément.

// ****************************************** eXtends XWindows Support Ver 2.0
Type XWindow_Type
	Name As String  // Gestion de noms de fenêtres (pour les recherches)
	Exist As Integer
	Format As Integer
	Refresh As Integer
	XSize As Integer
	YSize As Integer
	Linked As Integer
	Moveable As Integer
	Close As Integer
	Borders As Integer
	Bgd As Integer
	XFont As Integer
	ChildCount As Integer
	Alpha As Integer
	XPos As Integer
	YPos As Integer
	Hidden As Integer        // =TRUE window is hidden, =FALSE window is shown
	SpriteID As Integer      // Sprite used to display the XWindow window
	Title As Integer
	TitleText As String
	Hide As Integer
	XDsize As Integer
	YDSize As Integer
	Parent As String         // Parent XWindow Name [2019.05.26] Changed from Integer to String.
	Alignment As Integer
	XGadget As XGadget_Type[]
	RenderImage As Integer   // Image utilisée dans la v2 pour le rendu de la fenêtre.
	XMin As Integer
	YMin As Integer
	XLimit As Integer
	YLimit As Integer
 EndType
Global XWindow As XWindow_Type[]
Global XWinDisplay As Integer[]     // Define the order the windows will be drawn
// ****************************************** eXtends  Setup default empty window structure
Global EmptyXWindow as XWindow_Type
EmptyXWindow.Name = "" : EmptyXWindow.Exist = FALSE
EmptyXWindow.Format = 0 : EmptyXWindow.Refresh = 0
EmptyXWindow.XSize = 0 : EmptyXWindow.YSize = 0
EmptyXWindow.Linked = 0 : EmptyXWindow.Moveable = 0
EmptyXWindow.Close = 0 : EmptyXWindow.Borders = 0
EmptyXWindow.Bgd = 0 : EmptyXWindow.XFont = 0
EmptyXWindow.ChildCount = 0 : EmptyXWindow.Alpha = 0
EmptyXWindow.Xpos = 0 : EmptyXWindow.YPos = 0
EmptyXWindow.Hidden = 1 : EmptyXWindow.Title = 0 : EmptyXWindow.TitleText = NULL
EmptyXWindow.XDSize = 0 : EmptyXWindow.YDSize = 0
EmptyXWindow.Parent = NULL : EmptyXWindow.Alignment = 0
XWinSystem.CurrentWindow = -1

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** XBitmap - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** eXtends Bitmap Emulation
Type XBitmap_Type
	Name As String
	RenderImage As Integer
	Width As Integer
	Height As Integer
Endtype
Global XBitmap As XBitmap_Type[]
Global XTCurrentXBitmap As Integer
XTCurrentXBitmap = 0

//
// *********************                                                                                                                           *************
// *
// ******************************************************************************************************************************* Read & Restore - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** Default eXtends Ver 2.0 Restore/Data system
Global XTRestoreArray As String[]             // Used to store restored data from File
Global XTRestoreItem As Integer = 0            // Index of which next item to read from restored data from file
Global XTRestoreFile As String = ""            // The file name of the last file that was restored

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************** ImageFX - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** Default eXtends Ver 2.0 ImageFX Variables - Mosaic FX
Global dbMosaicZoomMode As Integer = 0

// ****************************************** Default eXtends Ver 2.0 ImageFX Variables - Wobble FX
Type XWobble_Type
	Amplitude As Integer
	Speed As Integer
	wStep As Integer
	internal As Integer
	XSize As Integer
	YSize As Integer
EndType
Global XWobble As XWobble_Type
XWobble.Amplitude = 1
XWobble.Speed = 1
XWobble.wStep = 1
XWobble.internal = 0
XWobble.Xsize = 0 : XWobble.YSize = 0

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************* Real-Time Sky System - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** eXtends Real-Time Sky System Support Ver 2.0
Type RTSSystem_Type
	Initialized As Integer
	UseShadowsOn As Integer
	DefAutoZoom As Float
	TextureQuality As Integer
	Editor_MasterSkyBox As Integer
	Editor_SkyBoxTexture As Integer
EndType
Global RTSSystem As RTSSystem_Type
RTSSystem.Initialized = FALSE
RTSSystem.UseShadowsOn = FALSE
RTSSystem.DefAutoZoom = 1.0
RTSSystem.TextureQuality = 1
RTSSystem.Editor_MasterSkyBox = 0
RTSSystem.Editor_SkyBoxTexture = 0
// ****************************************** eXtends Real-Time Sky System SkyBox Support Ver 2.0
Type RealTimeSky_Type
	Hour As Float
	Minutes As Float
	Secunds As Float
	Day As Integer
	Year As Integer
	YearDays As Integer
	TimeSpeed As Float
	NewTimer As Integer
	CloudPercent As Float
	SkyHalo As Integer
	Initialized As Integer
	RainDelay As Integer
	RainCycle As Integer
	RainCount As Float
	WindXSpeed As Float
	WindYSpeed As Float
	CloudPersistence As Float
	MistPercent As Float
	SkyBoxfile As String
	SkyBoxDrawer As String
	SkyFile As String
	CloudFile As String
	StarsFile As String
	SunFile As String
	MoonFile As String
	GetUpHalo As String
	GetDownHalo As String
	Aurore1 As String
	Aurore2 As String
	FarAway As String
	Ground As String
	AmbientRed As Integer
	AmbientGreen As Integer
	AmbientBlue As Integer
	FogRed As Integer
	FogGreen As Integer
	FogBlue As Integer
	FogDistance As Float
	FogControl As Integer
	MinAmbientRed As Integer
	MinAmbientGreen As Integer
	MinAmbientBlue As Integer
	MinFogRed As Integer
	MinFogGreen As Integer
	MinFogBlue As Integer
	XView As Float
	YView As Float
	ZView As Float
	CloudsXShift As Float
	CloudsYShift As Float
EndType
Global RTSky As RealTimeSky_Type
// ****************************************** eXtends Real-Time Sky System 3D Objects Support Ver 2.0
Global Dim RTSObjects[ 11 ] // Objets chargés pour le système de Skybox.
// ****************************************** eXtends Real-Time Sky System Textures Images Support Ver 2.0
Global Dim RTSTextures[ 11 ] // Images utilisées pour les textures du système de skyboxes.
// ****************************************** eXtends Real-Time Sky System Camera Support Ver 2.0
Type OldCam_Type
	XPos As Float
	YPos As Float
	ZPos As Float
	XAngle As Float
	YAngle As Float
	ZAngle As Float
	XShift As Float
	YShift As Float
	ZShift As Float
EndType
Global CamMemory As OldCam_Type

//
// *********************                                                                                                                           *************
// *
// ************************************************************************************************************************************* Maths 3D - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** eXtends Maths3D System 
Type Vector2_Type
	X As Float
	Y As Float
EndType

Type Vector3_Type
	X As Float
	Y As Float
	Z As Float
EndType

//
// *********************                                                                                                                           *************
// *
// ********************************************************************************************************************************** Paricles 3D - System Datas 
// *
// *************                                                                                                                           *********************
//

// ****************************************** eXtends 3D Particles System : Files for presets
Global FLAMEPARTICLES As String = "Flame.png"     // 262 156
Global SNOWPARTICLES As String = "snow.png"       //   4.108
Global RAINPARTICLES As String = "rain.png"       //  16.396
Global SPARKLEPARTICLES As String = "sparkle.png" // 262.156

// ****************************************** eXtends 3D Particles System : Informations for 3D Objects
Type ParticleObject_Type
	Number As Integer
	XPos As Float
	YPos As Float
	ZPos As Float
	Duration AS Float
EndType

Type Particle_Type
	Name As String
	mType As Integer
	Count As Integer
	Exist As Integer
	Size As Integer
	XEmitter As Float
	YEmitter As Float
	ZEmitter As Float
	XSize As Float
	YSize As Float
	ZSize As Float
	XMove As Float
	YMove As Float
	ZMove As Float
	XMin As Float
	YMin As Float
	ZMin As Float
	XMax As Float
	YMax As Float
	ZMax As Float
	Duration As Float
	isVisible As Integer                                                             // [2019.05.20] Changes Hide to isVisible
	LoadedImage As Integer                                                           // Use negative value for truly loaded iamge
	UseInternal As Integer
	ParticleObject As ParticleObject_Type[]
EndType
Global XParticle As Particle_Type[]


//
// *********************                                                                                                                           *************
// *
// ******************************************************************************************************************************** Basic 3D - Billboards System 
// *
// *************                                                                                                                           *********************
//

Type Billboard3D_Type
	ObjectID As Integer
	zRoll As Integer
EndType
Global Billboard3D As Billboard3D_Type[]

//
// *********************                                                                                                                           *************
// *
// ******************************************************************************************************************************** Files IO - HighScores System 
// *
// *************                                                                                                                           *********************
//

Type HighScore_Type
	Score As Integer // Set as First to be used for sorting
	Name As String
	Level As Integer
EndType
Global HighScore As HighScore_Type[]

//
// *********************                                                                                                                           *************
// *
// ***************************************************************************************************************************** Basic3D - Virtual Lights System 
// *
// *************                                                                                                                           *********************
//
// ****************************************** eXtends 3D Virtual Lights : True lights system
Type DLightsStruct_Type
	Locked As Integer
	VLight As Integer
	Active As Integer
	HaloObject As Integer
	Range As Integer
	Color As Integer
EndType
Global DLights As DLightsStruct_Type[] // For real lights from 0 to 7
//
// ****************************************** eXtends 3D Virtual Lights : True lights system
Type CLightsStruct_Type
	VLight As Integer
	Distance As Float
EndType
Global CLights As CLightsStruct_Type[] // For real lights from 0 to 7
//
// ****************************************** eXtends 3D Virtual Lights : Virtual lights system
Type VLightsStruct_Type
	Name As String
	Active As Integer
	// On As Integer
	XPos As Float
	YPos As Float
	ZPos As Float
	Range As Float
	Red As Integer
	Green As Integer
	Blue As Integer
	// Style As Integer
	Halo As Integer
	XTile As Integer
	ZTile As Integer
	lightType As Integer
	// ActualState As Float
EndType
Global VLights As VLightsStruct_Type[]
Global VisibilityCam As Integer
Global VisibilityDistance As Integer
// Set Default Values for parameters
VisibilityCam = 0
VisibilityDistance = 1024

