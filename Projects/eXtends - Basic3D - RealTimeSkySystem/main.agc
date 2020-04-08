`
` PluginKIT Ver 2.1 for AppGameKIT [2020.03.23]
`===================================================================
`Tiles Demonstration © Frédéric Cordier 2019-2020
`===================================================================
` Real Time 3D Background Sky System
`
` This small sample will show you how to create a real time Sky System for games
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
SetWindowTitle( "eXtends" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Dim OBJ[ 7 ]

dbInkEx( 255, 255, 255 )
StartTextInput()
Repeat
	ClearScreen()
	dbSetCursor( 0,0 )
	dbPrint( "Real Time SkySystem Ver1.0 by Frederic Cordier (c)2006-2020" )
	dbPrint( "Select which skysystem you want to see :" )
	dbPrint( "1 = Big city - polluted" )
	dbPrint( "2 = Snow mountains - Big blue" )
	dbPrint( "3 = Desert mountains" )
	dbRefresh()
	Sync()
Until GetTextInputCompleted() = 1

// Backdrop On
InitializedRTS As Integer = -1
Select getTextInput()
	Case "1" : InitializedRTS = XTSetupRTS( "RTS_BigCity" ) : EndCase
	Case "2" : InitializedRTS = XTSetupRTS( "RTS_SnowMountain" ) : EndCase
	Case "3" : InitializedRTS = XTSetupRTS( "RTS_DesertMountain" ) : EndCase
EndSelect

if InitializedRTS = TRUE

	SetClearColor( 255, 255, 255 )
	XTSetRTSClock( 16 , 0 , 10.0 )
	XTSetRTSWindForce( -0.80, 0.20 )
	XTSetRTSAutoZoom( 0.005 )
	XTSetRTSCloudPersistence( 255 )
	XTSetRTSMistAlpha( 0 )
	XTSetRTSFogControlOn()
	// Set Camera Range 1 , 110000
	// Clear Camera View 0 , Rgb( 0 , 0 , 0 )
	SetCameraPosition( 1, 0 , 0 , 0 )
	SetCameraRange( 1, 10, 50000 )
	SetClearColor( 0, 0, 0 )
	XAngle As Float = 0
	YAngle As Float = 0
	do
		ClearScreen()
		SetCameraPosition( 1, 0, 0, 0 )
		// XAngle As Float : XAngle = ( ( GetPointerY() - GetWindowHeight() ) / 4 ) + 180.0
		// YAngle As Float : YAngle = ( GetPointerX() / 4 ) + 90.0
		YAdd As Integer : YAdd = ( GetRawKeyState( 39 ) - GetRawkeyState( 37 ) )
		XAdd As Integer : XAdd = ( GetRawKeyState( 38 ) - GetRawKeyState( 40 ) )
		YAngle = YAngle + YAdd
		XAngle = XAngle + XAdd
		SetCameraRotation( 1, XAngle , YAngle, 0 )
		XTRTSUpdate()
		dbSetCursor( 0 , 0 )
		dbPrint( "Frame Rate : " + str( ScreenFps() ) )
		dbPrint( "Clock : " + Str( Round( XTGetRTSHour() ) ) + "h" + Str( Round( XTGetRTSMinutes() ) ) + "m" + Str( Round( XTGetRTSSecunds() ) ) + "s" )
		dbPrint( "VIew Angle = " + Str( YAngle ) )
		dbRefresh()
		Sync()
	loop
	XTClearRTSkybox()

Endif
End

