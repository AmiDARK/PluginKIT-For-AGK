`
` PluginKIT Ver 2.1 for AppGameKIT [2020.03.23]
`===================================================================
` XFONT Demonstration © Frédéric Cordier 2019-2020
`===================================================================
` 2D XFont Scrolling Demonstration
`
` This small sample will show you how to use an XFont to create a nice sinus scroller technical demonstration
`-------------------------------------------------------------------------------------------
// To Do : 
// - Objects based layer (no tiles, only specified objects, that can also handle animations. Best for asteroids, ponctual models, ets...
// - ForceClear option to clear screen before drawing layers TRUE/FALSE .. if the 1st layer to draw cover the whole screen ForceClear = FALSE optimise performances.
// - Smooth lights borders (blur effect ?)
// - Autoload when no changes are done. 
// - Capability to Zoom layers.
// - Use clipping to limit Layers drawing to the specified area.

#option_explicit
// #renderer "Advanced" // -> AppGameStudio only [Enable Vulkan Engine]

// 1. Insert SETUPS files
#insert  "../../dbEmulation_v1/dbSetup.agc"
#insert  "../../eXtends_v2/XTv2_Setup.agc"
#insert  "../../2DPluginKIT_v2/2DPKv2_Setup.agc"
// 2. Insert special JAVA emulated methods
#include "../../javaEmulation_v1/java_String.agc"
// 3. Add some DarkBASIC Professional emulated methods
#include "../../dbEmulation_v1/dbBasic3D.agc"
#include "../../dbEmulation_v1/dbImage.agc"
#include "../../dbEmulation_v1/dbText.agc"
// 4. Now add'in all the eXtends Methods
#include "../../eXtends_v2/XTv2_Billboards3D.agc"
#include "../../eXtends_v2/XTv2_HighScores.agc"
#include "../../eXtends_v2/XTv2_ImageFX.agc"
#include "../../eXtends_v2/XTv2_Maths3D.agc"
#include "../../eXtends_v2/XTv2_Memblocks.agc"
#include "../../eXtends_v2/XTv2_Particles3D.agc"
#include "../../eXtends_v2/XTv2_RealTimeSkySystem.agc"
#include "../../eXtends_v2/XTv2_RestoreData.agc"
#include "../../eXtends_v2/XTv2_VirtualsLights.agc"
#include "../../eXtends_v2/XTv2_XBitmaps.agc"
#include "../../eXtends_v2/XTv2_XFonts.agc"
#include "../../eXtends_v2/XTv2_XGadgets.agc"
#include "../../eXtends_v2/XTv2_XWindows.agc"
// 5. And finally add'in all the 2DPluginKIT Methods.
#include "../../2DPluginKIT_v2/2DPKv2_System.agc"
#include "../../2DPluginKIT_v2/2DPKv2_Core.agc"
#include "../../2DPluginKIT_v2/2DPKv2_BlitterObjects.agc"
#include "../../2DPluginKIT_v2/2DPKv2_ImageCollection.agc"
#include "../../2DPluginKIT_v2/2DPKv2_Layers.agc"
#include "../../2DPluginKIT_v2/2DPKv2_Maths.agc"
#include "../../2DPluginKIT_v2/2DPKv2_SpritesCollisions.agc"
#include "../../2DPluginKIT_v2/2DPKv2_TilesVer4.agc"
#include "../../2DPluginKIT_v2/2DPKv2_VirtualLights.agc"
#include "../../2DPluginKIT_v2/2DPKv2_Animations.agc"
#include "../../2DPluginKIT_v2/2DPKv2_Particles.agc"

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "PluginKIT [ 2DPluginKIT + eXtends ] for AppGameKIT Alpha 0.9 - 2020.04.05" )
PKSetWindowSize( 1280, 960, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
PKSetVirtualResolution( 640, 480 )
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// Load the tiles images each as separate image.
PKSetDefaultTileSizes( 32, 32 )
PKSetDefaultTileTransparency( 1 )
// Create the map

` ******************************************* 1. Prepare Graphics (Images then Tiles)
Global FirstTileImageID As Integer = -1
Global LastTileImageID As Integer = -1
PrepareGRAPHICS( "demo01gfx_v3.png" )
Global FirstTileID As Integer = -1
Global AnimFlames1 As Integer = -1
Global AnimFlames2 As Integer = -1
Global AnimFlames3 As Integer = -1
PrepareTILES()

` ******************************************* 2. Create all the required layers
Global BackgroundLayer As Integer
BackgroundLayer = PrepareLayer( 1, "Background" ) 
PKSetLayerUVMode( BackgroundLayer, 1, 1 )
PKSetLayerArea( BackgroundLayer, 0, 0, 640, 352 )
PKSetLayerScrollMode( BackgroundLayer, 3 ) // No movement, always 0,0

Global CloudyLayer As Integer
CloudyLayer = PrepareLayer( 2, "Clouds" )
PKSetLayerUVMode( CloudyLayer, 1, 0 )
PKSetLayerScrollSpeedXY( CloudyLayer, 0.025, 0.0 )
PKSetLayerArea( CloudyLayer, 0, 64, 640, 256 )
PKSetLayerScrollMode( CloudyLayer, 0 )

Global MountainsLayer As Integer
MountainsLayer = PrepareLayer( 3, "Mountains" )
PKSetLayerUVMode( MountainsLayer, 1, 0 )
PKSetLayerScrollSpeedXY( MountainsLayer, 0.33, 0.0 )
PKSetLayerArea( MountainsLayer, 0, 288, 640, 416 ) // 288
PKSetLayerScrollMode( MountainsLayer, 1 )

Global TreesLayer As Integer
TreesLayer = PrepareLayer( 4, "Trees" )
PKSetLayerUVMode( TreesLayer, 1, 0 )
PKSetLayerScrollSpeedXY( TreesLayer, 0.66, 0.0 )
PKSetLayerArea( TreesLayer, 0, 336, 640, 448 ) // 336
PKSetLayerScrollMode( TreesLayer, 1 )

Global FrontLayer As Integer
FrontLayer = PrepareLayer( 5, "Front" )
PKSetLayerUVMode( FrontLayer, 1, 0 )
PKSetLayerCameraMODE( FrontLayer, 1 )
PKSetLayerArea( FrontLayer, 0, 0, 640, 480 )
PKSetGameLayer( FrontLayer )

` ******************************************* 3. Create all the particles
Global Particle1 As Integer
Global Particle2 As Integer
Global Particle3 As Integer
Global Particle4 As Integer
Global Particle5 As Integer
Global Particle6 As Integer
Global Particle7 As Integer
PreparePARTICLES()

` ******************************************* 4. Create the 2D Lights
Global LightID1 As Integer
Global LightID2 As Integer
Global LightID3 As Integer
Global LightID4 As Integer
PrepareV2DLights()

// Demonstration variables.
XPos As Float = 0.0
inKey As Integer
XCloud As Float
LWidth As Integer
UpKey As Integer : DownKey As Integer
LeftKey As Integer : RightKey As Integer

do 
//	ClearScreen()
	dbSetCursor( 0, 0 )
	dbPrint( "FPS=" + Str( ScreenFPS() ) )
	// UpKey = GetRawKeyState( 38 )
	// DownKey = GetRawKeyState( 40 )
	LeftKey = GetRawKeyState( 39 )
	RightKey = getrawkeystate( 37 )
  ` Scroll the clouds
	inKey = ( RightKey = TRUE ) - ( LeftKey = TRUE )
	XPos = XPos - inKey
	XCloud = PKGetLayerXScroll( CloudyLayer ) + 0.10
	LWidth = PKGetLayerWidth( CloudyLayer ) * PKGetLayerTileWidth( CloudyLayer )
	if XCloud < 0 then XCloud = XCloud + LWidth
	if XCloud > LWidth then XCloud = XCloud - LWidth
	PKSetLayerViewPosition( CloudyLayer, XCloud, 0.0 )
	PKSetGameLayerScroll( XPos, 0 )
	PKFullUpdate( TRUE ) // TRUE -> With Sync() call
loop

End

Function PrepareGRAPHICS( FileIO As String )
	XLoop As Integer : YLoop As Integer
	NewImageID As Integer : NewTileID As Integer
	If GetFileExists( FileIO ) = 1
		imageID As Integer : imageID = LoadImage( FileIO )
		// Message( "File " + FileIO + " Loaded as image #" + Str( imageID) )
		For Yloop = 0 to GetImageHeight( imageID ) - 32 Step 32
			For XLoop = 0 To GetImageWidth( imageID ) - 32 Step 32
				// LoadSubImage( CurrentTile + 10, imageID, "IMG" + Str( CurrentTile ) )
				newImageID = CopyImage( imageID, XLoop, YLoop, 32, 32 )
				if FirstTileImageID = -1 then FirstTileImageID = newImageID // Push pointer for first TileID
				if newImageID > LastTileImageID then LastTileImageID = newImageID   // Push pointer for last TileID
			Next XLoop
		Next YLoop
	Endif
EndFunction 

// Create all tiles from the large picture.
Function PrepareTILES()
	TileID As Integer
	tLoop As Integer = -1
	newTileID As Integer = -1
	For tLoop = 0 to 71
		newTileID = PKCreateTile( FirstTileImageID + tLoop, TRUE )
		if FirstTileID = -1 then FirstTileID = newTileID
	Next tLoop
	// Ajout du normal mapping pour les tiles du château
	PKSetTileNMap( FirstTileID + 0, FirstTileImageID + 74 )
	PKSetTileNMap( FirstTileID + 1, FirstTileImageID + 75 )
	PKSetTileNMap( FirstTileID + 2, FirstTileImageID + 82 )
	PKSetTileNMap( FirstTileID + 3, FirstTileImageID + 83 )
	PKSetTileNMap( FirstTileID + 4, FirstTileImageID + 76 )
	PKSetTileNMap( FirstTileID + 5, FirstTileImageID + 77 )
	PKSetTileNMap( FirstTileID + 6, FirstTileImageID + 84 )
	PKSetTileNMap( FirstTileID + 7, FirstTileImageID + 85 )
	// Ajout du normal mapping et du masque d'ombrage pour les tiles du flambeau
	PKSetTileMask( FirstTileID + 8, FirstTileImageID + 81 )
	PKSetTileMask( FirstTileID + 9, FirstTileImageID + 89 )
	PKSetTileNMap( FirstTileID + 8, FirstTileImageID + 80 )
	PKSetTileNMap( FirstTileID + 9, FirstTileImageID + 88 )
	// Ajout du normal mapping pour les tiles de la statue
	PKSetTileMask( FirstTileID + 10, FirstTileImageID + 72 )
	PKSetTileMask( FirstTileID + 11, FirstTileImageID + 90 )
	PKSetTileMask( FirstTileID + 12, FirstTileImageID + 91 )
	PKSetTileNMap( FirstTileID + 10, FirstTileImageID + 79 )
	PKSetTileNMap( FirstTileID + 11, FirstTileImageID + 87 )
	PKSetTileNMap( FirstTileID + 12, FirstTileImageID + 95 )
	// Ajout du normal mapping pour les tiles des arbustes.
	PKSetTileNMap( FirstTileID + 13, FirstTileImageID + 93 )
	PKSetTileNMap( FirstTileID + 14, FirstTileImageID + 94 )
	PKSetTileNMap( FirstTileID + 15, FirstTileImageID + 86 )
EndFunction

// Prepare all layers depending on their data stored at the end of the source code.
Function PrepareLAYER( LayerCode As Integer, LayerName As String )
	LayerXSize As Integer : LayerYSize As Integer
	XLoop As Integer : YLoop As Integer
	LayerDATA As Integer
	finalLayerID As Integer
	Select LayerCode
		Case 1 : Restore( "demo01_backgroundpart" ): EndCase
		Case 2 : Restore( "demo01_cloudypart" ): EndCase
		Case 3 : Restore( "demo01_mountainpart" ): EndCase
		Case 4 : Restore( "demo01_treespart" ): EndCase
		Case 5 : Restore( "demo01_decorationpart" ): EndCase
	EndSelect
	LayerXSize = ReadI() : LayerYSize = ReadI()
	finalLayerID = PKCreateNewLayer( LayerName, LayerXSize, LayerYSize )
	For YLoop = 0 To LayerYSize - 1
		For XLoop = 0 To LayerXSize - 1
			LayerDATA = ReadI()
			PKSetLayerTile( finalLayerID, XLoop, YLoop, LayerDATA + FirstTileID )
		Next XLoop
	Next YLoop
EndFunction finalLayerID

// It's here that F2L system is created and images are pre-calculated
Function PrepareV2DLights()
	PKForceVirtualLightRefresh()
	LightID1 = PKAddVirtual2DLight( "Flame1", 80, 378, dbRgbA( 0, 255, 255 ), 100, 128, FrontLayer, FALSE, FALSE, TRUE )
	PKSetVirtual2DLightAsStaticLight( LightID1 )
	LightID2 = PKAddVirtual2DLight( "Flame2", 208+32, 378, dbRgbA( 255, 0, 255 ), 100, 128, FrontLayer, FALSE, TRUE, TRUE )
	PKSetVirtual2DLightAsPulseLight( LightID2 )
	LightID3 = PKAddVirtual2DLight( "Flame3", 368+32, 378, dbRgbA( 128, 255, 128 ), 100, 128, FrontLayer, TRUE, TRUE, TRUE )
	PKSetVirtual2DLightAsFlashLight( LightID3 ) 
	LightID4 = PKAddVirtual2DLight( "Flame4", 528+32, 378, dbRGBA( 255, 255, 0 ), 100, 129, FrontLayer, TRUE, TRUE, TRUE ) // Normal/Shadow/Bright
	PKSetVirtual2DLightAsFlameLight( LightID4 )
 EndFunction

Function PreparePARTICLES()
	// Flame particle 1
	Particle1 = PKAddParticleEx2( 24, -1, 32, PKParticleType.Flames, 64, 16+256, 40, 200 )
	PKAttachParticleToLayer( Particle1, FrontLayer )
	// Flame particle 2
	Particle2 = PKAddParticleEx2( 24, -1, 32, PKParticleType.Flames, 7*32, 16+256, 40, 200 )
	PKAttachParticleToLayer( Particle2, FrontLayer )
	// Flame particle 3
	Particle3 = PKAddParticleEx2( 24, -1, 32, PKParticleType.Flames, 12*32, 16+256, 40, 200 )
	PKAttachParticleToLayer( Particle3, FrontLayer )
	// Flame particle 4
	Particle4 = PKAddParticleEx2( 24, -1, 32, PKParticleType.Flames, 17*32, 16+256, 40, 200 )
	PKAttachParticleToLayer( Particle4, FrontLayer )
	// Rain particles
	Particle5 = PKAddParticleEx2( 128, -1, 4, PKParticleType.Rain, 320, 222, 640, 444 )
	PKAttachParticleToLayer( Particle5, FrontLayer )
	// Rain drop particles on the frontlayer ground
	Particle6 = PKAddParticleEx2( 48, -1, 12, PKParticleType.RainDrop, 320, 418, 640, 12 )
	PKAttachParticleToLayer( Particle6, FrontLayer )
	// Sparkles particles linked to the trees layer.
	Particle7 = PKAddParticleEx2( 32, -1, 16, PKParticleType.Sparkles, 320, 32, 160, 64 )
	PKAttachParticleToLayer( Particle7, TreesLayer )
 EndFunction
