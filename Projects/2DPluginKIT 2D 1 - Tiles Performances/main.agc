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
Image1 As Integer = -1
Image1 = PKLoadTile( "2dpk_tileperf_asteroids_001.png", 1 )
// P2DK_PrepareTiles()

AMOUNT As Integer = 1 ` Setup amount of random tiles displayed to 1 for default startup.
dbInkEx( 255, 255, 255 )

Do
	ClearScreen()
	TLoop As Integer = 1
	For TLoop = 1 To AMOUNT
		PKPasteTile( Image1, Random( 0, 1024 ) - 32, Random( 0, 768 ) - 32 )
	Next TLoop
	DBSetCursor( 0, 0 )
	DBPrint( "Amount of Tiles : " + Str( AMOUNT ) )
	DBPrint( "Frame Rate : " + Str( ScreenFPS() ) )
	dbRefresh()
	if ScreenFPS() > 59.0 then AMOUNT = AMOUNT + 2
	if ScreenFPS() < 59.0 then AMOUNT = AMOUNT - 1
	if AMOUNT < 1 Then AMOUNT = 1
	Sync()
Loop
