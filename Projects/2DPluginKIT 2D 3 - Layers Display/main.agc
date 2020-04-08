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
SetWindowTitle( "PluginKIT Ver2.1" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// P2DK_ReserveTiles( 64, 32, 32 )
Bgd1 As Integer = -1
Bgd1 = PKLoadTile( "2dpk_layerview_overdose3_001.png", 1 )
Bgd2 As Integer = -1
Bgd2 = PKLoadTile( "2dpk_layerview_overdose3_033.png", 1 )
// P2DK_PrepareTiles()

LayerID As Integer = -1
LayerID = PKCreateNewLayer( "Demo Layer", 20, 15 )
PKSetLayerTilesSizes( LayerID, 32, 32 )

myArray As Integer[ 20, 15 ] 
myArray[ 0 ]  = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
myArray[ 1 ]  = [ 1, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 ,1, 2, 1 ]
myArray[ 2 ]  = [ 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2 ,1, 2, 1 ]
myArray[ 3 ]  = [ 1, 2, 2, 1, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2 ,1, 2, 1 ]
myArray[ 4 ]  = [ 1, 2, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1 ,1, 2, 1 ]
myArray[ 5 ]  = [ 1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2 ,2, 2, 1 ]
myArray[ 6 ]  = [ 1, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1, 2, 1 ]
myArray[ 7 ]  = [ 1, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2 ,1, 2, 1 ]
myArray[ 8 ]  = [ 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 2 ,1, 2, 1 ]
myArray[ 9 ]  = [ 1, 2, 1, 2, 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2 ,1, 2, 1 ]
myArray[ 10 ] = [ 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2 ,1, 2, 1 ]
myArray[ 11 ] = [ 1, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 1, 2, 2, 2, 2 ,2, 2, 1 ]
myArray[ 12 ] = [ 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 1 ,1, 1, 1 ]
myArray[ 13 ] = [ 1, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 2 ,2, 2, 1 ]
myArray[ 14 ] = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
XLoop As Integer = 0 : YLoop As Integer = 0
TileID As Integer = -1
For YLoop = 0 to 14
	For XLoop = 0 to 19
		TileID = myArray[ YLoop, XLoop ]
		Select TileID
			Case 1 : TileID = Bgd1 : EndCase
			Case 2 : TileID = Bgd2 : EndCase
		EndSelect
		PKSetLayerTile( LayerID, XLoop, YLoop, TileID )
	Next XLoop
Next YLoop


REM CreateFileFromMemblock( "Test.raw", Layers[ 1 ].MemoryMBC )

AMOUNT As Integer = 1 ` Setup amount of random tiles displayed to 1 for default startup.
dbInkEx( 255, 255, 255 )

Do
	ClearScreen()
	DBSetCursor( 0, 0 )
	DBPrint( "Frame Rate : " + Str( ScreenFPS() ) )
	PKTraceAllLayers()
	dbRefresh()
	Sync()
Loop
