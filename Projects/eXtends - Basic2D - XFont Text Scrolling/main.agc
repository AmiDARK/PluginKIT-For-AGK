`
` PluginKIT Ver 2.1 for AppGameKIT [2020.03.23]
`===================================================================
` XFONT Demonstration © Frédéric Cordier 2019-2020
`===================================================================
` 2D XFont Scrolling Demonstration
`
` This small sample will show you how to use an XFont to create a nice sinus scroller technical demonstration
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
SetWindowSize( 1280, 1024, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1280, 1024 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 120, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Global FullText As String = "                                  HERE IS A SMALL SCROLL TEXT DEMO USING XFONT ORIGINALY DEVELOPED BY FREDERIC CORDIER FOR DARKBASIC PROFESSIONAL EXTENDS PLUGIN AND XQUADEDITOR SOFTWARE. AND NOW PORTED TO APP GAME KIT CLASSICS AND STUDIO ...                                  "
TextShift As Integer = 1
XShift As Integer : yAngle As Integer : yAngle = 0
YPos as Integer : YPos = 512 - 16
// XGui_UseMipMap( 1 )
Feedback As Integer
Feedback = XTCreateNewXFont( "xt_b2d_scroll_font32x32.png" , 32 , 32 , 1 )
if Feedback <> -1
	XTSetXFontReturnMode( FALSE )
	XTSetTextTransparent( TRUE )
	IMG As Integer
	IMG = LoadImage( "xt_b2d_scroll_background.png" )
	Do
		dbSetCursor( 0, 0 )
		dbPrint( " FPS : " + str( ScreenFPS() ) )
		dbPasteImage( IMG, 0, 0 )
		Dec XShift, 1 : Rem shift text to 1 pixel on the left.
		If XShift = -30 : XShift = 0 : Inc TextShift, 1 : Endif : Rem On décale de 1 charactère chaque 16 pixels.
		Inc yAngle, 1
		If TextShift > Len( FullText ) : TextShift = TextShift - Len( FullText ) : Endif : Rem on revient au début du texte si la fin est atteinte.

		TitleText As String = "EXTENDS DEMONSTRATION"
		XTXFontText( TitleText, ( 1280 / 2 ) - ( XTGetXFontTextWidth( TitleText ) / 2 ), 96 + ( Cos( yAngle + 90 ) * 64 ) )
		ScrollTexte( FullText, TextShift, XShift, YPos, yAngle )
		dbRefresh()
		Sync()
	Loop
else
	Message( "XFont Not Initialized : " + Str( Feedback ) )
endif
End


Rem This function will extract the text part to print on screen.
Function ScrollTexte( Texte As String, TextShift As Integer, ScrollShift As Integer, YPos As Integer, yAngle as Integer )
	TilesCount As Integer
	TilesCount = ( 1280 / 32 ) + 1
	Text2Write As String : Text2Write = Mid( Texte, TextShift, TilesCount )
	tLoop As Integer
	for tLoop = 0 to Len( Text2Write ) - 1
		XTSetXFontCursor( ScrollShift , Ypos + ( cos( yAngle ) * 96 ) )
		XTPrintXFontFast( Mid( Text2Write, tLoop+1, 1 ), FALSE )
		ScrollShift = ScrollShift + 32
		yAngle = yAngle + 1
	next tLoop
EndFunction
