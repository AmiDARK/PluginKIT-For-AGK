`
` PluginKIT Ver 2.1 for AppGameKIT [2019.04.08]
`===================================================================
`Tiles Demonstration © Odyssey-Creators 2019 [Frédéric Cordier]
`===================================================================
` 2D Tiles Demo
`
` This small sample will show you how to create tiles and use them everywhere on the screen.
`-----------------------------------------------------------------------------------------------------

// Créer un système de RESTORE / READ data utilisant les fichiers
// le RESTORE va stocker le contenu du fichier dans un array
// Puis le read lira les éléments un à un...

#option_explicit
// #renderer "Advanced" // -> AppGameStudio only [Enable Vulkan Engine]

// 1. Insert SETUPS files
#insert  "dbEmulation_v1/dbSetup.agc"
#insert  "eXtends_v2/XTv2_Setup.agc"
#insert  "2DPluginKIT_v2/2DPKv2_Setup.agc"
// 2. Insert special JAVA emulated methods
#include "javaEmulation_v1/java_String.agc"
// 3. Add some DarkBASIC Professional emulated methods
#include "dbEmulation_v1/dbBasic3D.agc"
#include "dbEmulation_v1/dbImage.agc"
#include "dbEmulation_v1/dbText.agc"
// 4. Now add'in all the eXtends Methods
#include "eXtends_v2/XTv2_Billboards3D.agc"
#include "eXtends_v2/XTv2_HighScores.agc"
#include "eXtends_v2/XTv2_ImageFX.agc"
#include "eXtends_v2/XTv2_Maths3D.agc"
#include "eXtends_v2/XTv2_Memblocks.agc"
#include "eXtends_v2/XTv2_Particles3D.agc"
#include "eXtends_v2/XTv2_RealTimeSkySystem.agc"
#include "eXtends_v2/XTv2_RestoreData.agc"
#include "eXtends_v2/XTv2_VirtualsLights.agc"
#include "eXtends_v2/XTv2_XBitmaps.agc"
#include "eXtends_v2/XTv2_XFonts.agc"
#include "eXtends_v2/XTv2_XGadgets.agc"
#include "eXtends_v2/XTv2_XWindows.agc"
// 5. And finally add'in all the 2DPluginKIT Methods.
#include "2DPluginKIT_v2/2DPKv2_ImageCollection.agc"
#include "2DPluginKIT_v2/2DPKv2_Layers.agc"
#include "2DPluginKIT_v2/2DPKv2_Maths.agc"
#include "2DPluginKIT_v2/2DPKv2_SpritesCollisions.agc"
#include "2DPluginKIT_v2/2DPKv2_TilesVer4.agc"


// show all errors
SetErrorMode(2)
PKSetup.DebugMODE = 1
maxWidth As Integer : maxWidth = GetMaxDeviceWidth()
maxHeight As Integer: maxHeight = GetMaxDeviceHeight()
Ratio As Float : Ratio = ( maxWidth * 1.0 ) / ( maxHeight * 1.0 )
// set window properties
SetWindowTitle( "PluginKIT" )
SetWindowSize( maxWidth, maxHeight, 0 )
SetDisplayAspect( Ratio )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// Set display properties
SetVirtualResolution( maxWidth, maxHeight ) // doesn't have to match the window
SetOrientationAllowed( 1, 0, 0, 0 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts


TileID As Integer = -1
PKSetup.TileDefTransp = TRUE // Set Default Transparency to true
myImageCollection As PKTileCollection_Type 
myImageCollection = PKCreateNewImageCollection( "demo01gfx.png", 32, 32 )
TileID = PKLoadTileFromCollectionImage( myImageCollection, "IMG25", 1 )

XTCreateNewXFont( "Font16x16.png", 16, 32, 1 )

SkinLoaded As Integer = -1
SkinLoaded = XTInitializeXWindowSkin( "ancientblue.skin" )
XWindowID As Integer = -1
	XFontSys.AutoReturn = FALSE

if SkinLoaded = 1
		// XTEnableXWindowsAlpha()
		// XWindow_SetTextTransparent()
		XWindowID = XTCreateNewXWindow( "fenetre1", 320 , 240 )
		XTSetXWindowPosition( XWindowID , 0 , 200 )
		XTSetXWindowProperties( XWindowID, TRUE, TRUE, TRUE, TRUE )
		XTSetXWindowAlpha( XWindowID, 192 )
		// XTSetWindowTitle( "fenetre1", "Première Fenêtre" )
		// XWindowUseXFont( "fenetre1", 1 )
		// XTSetXWindowAlpha( XWindowID, 192 )
		ImageID As Integer = -1
		ImageID = LoadImage( "ab_border_title.png" )
		XTNewMixedGadget( "fenetre1", "xgadget1", 16, 16, 64, 16, ImageID, "Test" )
Endif

RTSLoaded As Integer
RTSLoaded = XTSetupRTS( "rts_bigcity" )
if RTSLoaded = TRUE
	XTSetRTSClock( 16 , 0 , 10.0 )
	XTSetRTSWindForce( -0.80, 0.20 )
	XTSetRTSAutoZoom( 0.005 )
	XTSetRTSCloudPersistence( 255 )
	XTSetRTSMistAlpha( 0 )
	XTSetRTSFogControlOn()
	SetCameraPosition( 1, 0 , 0 , 0 )
	SetCameraRange( 1, 10, 50000 )
	SetClearColor( 0, 0, 0 )
Endif

	XAngle As Float : YAngle As Float : XAdd As Integer : YAdd As Integer


AsteroidID As Integer = -1
AsteroidID = PKLoadTile( "asteroids_001.png", 1 )
Dim Asteroids1[ 64, 2 ]
Aloop As Integer = 0
for aLoop = 0 to 63
	Asteroids1[ aLoop, 0 ] = Random( 1024, 2048 )
	Asteroids1[ aLoop, 1 ] = Random( -20, 760 )
next aLoop


do
	ClearScreen()
	XTRTSUpdate()
	// Asteroids Tiles
	For aLoop = 0 to 63
		PKPasteTile( 1, Asteroids1[ aLoop, 0 ], Asteroids1[ aLoop, 1 ] )
		Asteroids1[ aLoop, 0 ] = Asteroids1[ aLoop, 0 ] - 1
		if Asteroids1[ aLoop, 0 ] < -32
			Asteroids1[ aLoop, 0 ] = Random( GetVirtualWidth(), GetVirtualWidth() + 64 )
			Asteroids1[ aLoop, 1 ] = Random( -20, getVirtualHeight() - 16 )
		Endif
	Next aLoop
	// XTile Text
	PKPasteTile( TileID, 0, 0 )
	PKPasteTile( TileID, 640-32, 0 )
	// XFont Test
	XFontSys.XCursor = 0 : XFontSys.YCursor = 32
	XTPrintXFontFast( "EXTENDS-PLUGINKIT SKY SYSTEM", TRUE )
	W2 as Float : W2 = GetRawRotationVectorW2()
	X2 as Float : X2 = GetRawRotationVectorX2()
	Y2 as Float : Y2 = GetRawRotationVectorY2()
	Z2 as Float : Z2 = GetRawRotationVectorZ2()
	SetCameraRotationQuat( 1, W2, X2, Y2, Z2 )
	XTUpdateXWindows()
	Sync()
Loop
