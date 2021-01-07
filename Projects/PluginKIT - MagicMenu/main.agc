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
#insert  "../../PluginKIT/PluginKIT_Setup.agc"
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
// 5. Then add'in all the 2DPluginKIT Methods.
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
// 6. And finally add all the PluginKIT specials methods :
#include "../../PluginKIT/PKMagicMenu.agc"
#include "../../PluginKIT/PKCompilerStuffs.agc"

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "PluginKIT [ 2DPluginKIT + eXtends ] for AppGameKIT Alpha 0.9 - 2020.04.05" )
PKSetWindowSize( 1280, 960, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
PKSetVirtualResolution( 1280, 960 )
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// Load the tiles images each as separate image.
PKSetDefaultTileSizes( 32, 32 )
PKSetDefaultTileTransparency( 1 )
// Create the map


	dbSetTextSize( 12 )
do 
	dbSetCursor( 0, 0 )
	callCompilerForFile( "d:\test", "main.agc" )
	PKFullUpdate( TRUE ) // TRUE -> With Sync() call
loop

End
