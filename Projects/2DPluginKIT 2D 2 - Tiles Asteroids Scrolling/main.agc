`
` PluginKIT Ver 2.1 for AppGameKIT [2019.12.15]
`===================================================================
`Tiles Demonstration © Frédéric Cordier 2019-2020
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
SetWindowTitle( "2DPluginKIT" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// P2DK_ReserveTiles( 64, 32, 32 )
AstImage1 As Integer = -1
AstImage1 = PKLoadTile( "2dpk_astscroll_asteroids_001.png", 1 )
AstImage2 As Integer = -1
AstImage2 = PKLoadTile( "2dpk_astscroll_asteroids_004.png", 1 )
// P2DK_PrepareTiles()


Dim Asteroids1[ 64, 2 ]
Dim Asteroids2[ 64, 2 ]

// Setup random asteroids out of screen
aLoop As Integer = 1
for aLoop = 0 to 63
	Asteroids1[ aLoop, 0 ] = Random( 1024, 2048 )
	Asteroids1[ aLoop, 1 ] = Random( -20, 760 )
	Asteroids2[ aLoop, 0 ] = Random( 1024, 2048 )
	Asteroids2[ aLoop, 1 ] = Random( -20, 760 )
next aLoop

dbInkEx( 255, 255, 255 )

Do
	ClearScreen()
	
	For aLoop = 0 to 63
		PKPasteTile( AstImage1, Asteroids1[ aLoop, 0 ], Asteroids1[ aLoop, 1 ] )
		Asteroids1[ aLoop, 0 ] = Asteroids1[ aLoop, 0 ] - 1
		if Asteroids1[ aLoop, 0 ] < -32
			Asteroids1[ aLoop, 0 ] = Random( 1024, 1060 )
			Asteroids1[ aLoop, 1 ] = Random( -20, 760 )
		Endif
	Next aLoop
	For aLoop = 0 to 63
		PKPasteTile( AstImage1, Asteroids2[ aLoop, 0 ], Asteroids2[ aLoop, 1 ] )
		Asteroids2[ aLoop, 0 ] = Asteroids2[ aLoop, 0 ] - 2
		if Asteroids2[ aLoop, 0 ] < -32
			Asteroids2[ aLoop, 0 ] = Random( 1024, 1060 )
			Asteroids2[ aLoop, 1 ] = Random( -20, 760 )
		Endif
	Next aLoop
	DBSetCursor( 0, 0 )
	DBPrint( "Amount of Tiles : 128" )
	DBPrint( "Frame Rate : " + Str( ScreenFPS() ) )
	dbRefresh()
	Sync()
Loop
