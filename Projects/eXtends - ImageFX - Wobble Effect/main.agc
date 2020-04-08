`
` PluginKIT Ver 2.1 for AppGameKIT [2020.03.23]
`===================================================================
`Tiles Demonstration © Frédéric Cordier 2019-2020
`===================================================================
` 2D Tiles Demo
`
` This small sample will show you how to create tiles and use them everywhere on the screen.
`-------------------------------------------------------------------------------------------


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
SetWindowTitle( "PluginKIT - Wobble Effect Demonstration" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Rem ***************************************************
Rem *                                                 *
Rem * DarkBasic Professional Extends TPC Pack Ver 1.0 *
Rem *                                                 *
Rem ***************************************************
Rem Author : Frédéric Cordier - Odyssey-Creators
Rem Date   : 2008.February.16
Rem Sample : Wobble Effect
Rem

SourceImage As Integer
SourceImage = LoadImage( "wobbledemo_saf.jpg" )

Rem Set Amplitude, Speed, Step
Amplitude As Integer = 8
Speed As Integer = 1
mStep As Integer = 1
XTSetImageWobbleValues( Amplitude, Speed, mStep )

dbInkEx( 255, 255, 255 )
dbSetTextSize( 16 )
do

	ClearScreen()
	Amplitude = Amplitude + GetRawKeyState( 50 ) - GetRawKeyState( 49 )
	if Amplitude < 1 Then Amplitude = 1 
	Speed = Speed + GetRawKeyState( 53 ) - GetRawKeyState( 52 )
	if Speed < 1 Then Speed = 1
	mStep = mStep + GetRawKeyState( 56 ) - GetRawKeyState( 55 )
	if mStep < 1 Then mStep = 1  
	if GetRawKeyState( 57 ) = 1 Then SetSyncRate( 0, 0 )
	if GetRawKeyState( 54 ) = 1 Then SetSyncRate( 60, 0 )
	XTSetImageWobbleValues( Amplitude, Speed, mStep )
	Image As Integer
	Image = XTGenerateImageWobbleEx( SourceImage, 2 )
	dbPasteImage( 2, 0, 80 )
	dbCenterText( 320, 0, "AGK PluginKIT Technical Demonstration" )
	dbCenterText( 320, 16, "Wobble Effect Demonstration" )
	dbCenterText( 320, 32, "Press 1-2 to decrease/increase amplitude" )
	dbCenterText( 320, 48, "Press 4-5 to decrease/increase speed" )
	dbCenterText( 320, 64, "Press 7-8 to decrease/increase step" )
	dbCenterText( 320, 80, "Press 9-6 to set SyncRate(60)/SyncRate(MAX)" )
 	dbSetCursor( 0, 96 )
	dbPrint( "AMPLITUDE : " + Str( Amplitude ) )
	dbPrint( "SPEED     : " + Str( Speed ) )
	dbPrint( "STEP      : " + Str( mStep ) )
	dbPrint( "FRAMERATE : " + Str( ScreenFPS() ) )
	dbRefresh()          // Call other refresh (dbPrint)
	Sync()
loop

DeleteImage( SourceImage )
DeleteImage( 2 )

End
