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
SetWindowTitle( "AGK PluginKIT Labyrinth GAME demonstration" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// Set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 0, 0, 1, 0 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Wall1 As Integer
Wall1 = PKLoadTile( "2dpk_lab_wall1.png", 1 )
PKLoadTileMask( PKTile.length, "2dpk_lab_wall1[mask].png" )

// Load the tile for the simple default ground. No Mask (=no collisions)
PKLoadTile( "2dpk_lab_ground1.png", 1 )

// Load the tile for the Hole (killing place with mask for killing player)
Hole1 As Integer = -1
Hole1 = PKLoadTile( "2dpk_lab_hole1.png", 1 )
PKLoadTileMask( PKTile.length, "2dpk_lab_hole1[mask].png" )

// Load the tile for the stone (=same than walls=same mask than walls)
Stone1 As Integer 
Stone1 = PKLoadTile( "2dpk_lab_stone1.png", 1 )
PKLoadTileMask( PKTile.length, "2dpk_lab_wall1[mask].png" )

// Load the tile for the Ladder with mask for level completion
Ladder As Integer = -1
Ladder = PKLoadTile( "2dpk_lab_ladder.png", 1 ) 
PKLoadTileMask( PKTile.length, "2dpk_lab_ladder[mask].png" )

// Load the 2nd ground that slowdown player movements (with mask for slowdown effect)
SlowGround As Integer = -1
SlowGround = PKLoadTile( "2dpk_lab_ground2.png", 1 )
PKLoadTileMask( PKTile.length, "2dpk_lab_ground2[mask].png" )

// Load other simple grounds tiles
PKLoadTile( "2dpk_lab_ground3.png", 1 )
PKLoadTile( "2dpk_lab_ground4.png", 1 )
PKLoadTile( "2dpk_lab_ground5.png", 1 )
PKLoadTile( "2dpk_lab_ground6.png", 1 )

// Load Bonus 1 ( = +10 pts )
Bonus1 As Integer = -1
Bonus1 = PKLoadTile( "2dpk_lab_bonus1.png", 1 )

// Load Bonus 2 ( = +25 pts )
Bonus2 As Integer = -1
Bonus2 = PKLoadTile( "2dpk_lab_bonus2.png", 1 )

// Load the wall ceiling texture (with wall mask)
Wall2 As Integer
Wall2 = PKLoadTile( "2dpk_lab_wall2.png", 1 )
PKLoadTileMask( PKTile.length , "2dpk_lab_wall1[mask].png" )

// Load the bridge for the 3rd layer above player (no collision=no masks)
PKLoadTile( "2dpk_lab_pont.png", 1 )
PKLoadTile( "2dpk_lab_pont2.png", 1 )

// Create the labyrinth using tiles
LayerID1 As Integer = -1
LayerID1 = PKCreateNewLayer( "NewLayer1", 20, 15 )
PKSetLayerTilesSizes( LayerID1, 32, 32 )
myArray As Integer[ 20, 15 ] 
myArray[ 0 ]  = [ 13, 01, 01, 13, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 13, 05, 13 ]
myArray[ 1 ]  = [ 13, 10, 07, 13, 10, 07, 03, 07, 06, 07, 07, 07, 06, 06, 07, 07, 07, 13, 10, 13 ]
myArray[ 2 ]  = [ 13, 01, 09, 13, 09, 13, 01, 01, 01, 13, 09, 01, 01, 13, 01, 01, 09, 13, 09, 13 ]
myArray[ 3 ]  = [ 13, 10, 08, 13, 09, 13, 10, 07, 07, 13, 09, 07, 07, 13, 10, 07, 08, 13, 09, 13 ]
myArray[ 4 ]  = [ 13, 09, 13, 01, 09, 13, 09, 13, 09, 01, 01, 01, 09, 13, 09, 01, 01, 01, 06, 13 ]
myArray[ 5 ]  = [ 13, 09, 01, 10, 08, 13, 09, 13, 09, 07, 07, 07, 08, 13, 09, 02, 02, 02, 02, 13 ]
myArray[ 6 ]  = [ 13, 09, 07, 08, 01, 01, 09, 01, 01, 01, 01, 01, 01, 01, 01, 13, 01, 13, 06, 13 ]
myArray[ 7 ]  = [ 13, 09, 13, 09, 07, 07, 08, 07, 07, 07, 07, 07, 07, 07, 07, 13, 10, 13, 09, 13 ]
myArray[ 8 ]  = [ 13, 09, 13, 01, 13, 01, 01, 01, 13, 03, 13, 01, 13, 01, 09, 13, 09, 13, 09, 13 ]
myArray[ 9 ]  = [ 13, 09, 01, 02, 13, 10, 07, 07, 01, 09, 13, 04, 13, 10, 08, 13, 06, 13, 09, 13 ]
myArray[ 10 ] = [ 13, 09, 02, 02, 01, 09, 13, 09, 07, 08, 13, 09, 13, 09, 01, 01, 09, 01, 09, 13 ]
myArray[ 11 ] = [ 13, 09, 13, 06, 07, 08, 13, 09, 02, 02, 13, 06, 13, 09, 07, 06, 08, 07, 08, 13 ]
myArray[ 12 ] = [ 13, 09, 01, 01, 01, 01, 01, 09, 13, 09, 01, 09, 13, 09, 01, 01, 01, 01, 01, 13 ]
myArray[ 13 ] = [ 13, 09, 07, 07, 07, 07, 07, 08, 13, 09, 07, 08, 13, 09, 07, 07, 07, 07, 07, 13 ]
myArray[ 14 ] = [ 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01 ]
XLoop As Integer = 0 : YLoop As Integer = 0
For YLoop = 0 to 14
	For XLoop = 0 to 19
		readVal = MyArray[ YLoop, XLoop ]
		PKSetLayerTile( LayerID1, XLoop, YLoop, readVal -1 )
	Next XLoop
Next YLoop

// Create the 2nd layer for bonuses
BonusLayer As Integer = -1
BonusLayer = PKCreateNewLayer( "Bonus Layer", 20, 15 )
PKSetLayerTilesSizes( BonusLayer, 32, 32 )
myArray[ 0 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 1 ]  = [ 00, 00, 00, 00, 00, 12, 00, 11, 00, 00, 00, 00, 00, 00, 00, 11, 00, 00, 11, 00 ]
myArray[ 2 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 3 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 11, 00, 00, 00 ]
myArray[ 4 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 5 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 6 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 7 ]  = [ 00, 00, 00, 11, 00, 00, 11, 00, 00, 00, 11, 00, 00, 11, 00, 00, 11, 00, 00, 00 ]
myArray[ 8 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 9 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 11, 00, 00, 00, 00, 00, 00 ]
myArray[ 10 ] = [ 00, 00, 00, 12, 00, 00, 00, 11, 00, 11, 00, 12, 00, 11, 00, 00, 00, 00, 00, 00 ]
myArray[ 11 ] = [ 00, 11, 00, 00, 00, 00, 00, 00, 11, 00, 00, 00, 00, 00, 00, 00, 00, 00, 11, 00 ]
myArray[ 12 ] = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 13 ] = [ 00, 00, 00, 11, 11, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 11, 11, 00 ]
myArray[ 14 ] = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]

readVal As Integer = -1
For YLoop = 0 to 14
	For XLoop = 0 to 19
		readVal = MyArray[ YLoop, XLoop ]
		If readVal > 0
			PKSetLayerTile( BonusLayer, XLoop, YLoop, readVal - 1 )
		Else
			PKSetLayerTile( BonusLayer, XLoop, YLoop, -1 )
		Endif
	Next XLoop
Next YLoop

// Create the 3rd layer for bridges view
EffectLayer As Integer = -1
EffectLayer = PKCreateNewLayer( "Ceil Layer", 20, 15 )
PKSetLayerTilesSizes( EffectLayer, 32, 32 )
myArray[ 0 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 1 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 2 ]  = [ 00, 00, 00, 00, 14, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 3 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 14, 15, 15, 00, 14, 15, 15, 00, 00, 00 ]
myArray[ 4 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 14, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 5 ]  = [ 00, 00, 00, 14, 15, 00, 14, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 6 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 7 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 8 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 15, 00, 00, 00 ]
myArray[ 9 ]  = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 10 ] = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 15, 00, 00, 15, 00, 00, 00 ]
myArray[ 11 ] = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 12 ] = [ 00, 00, 00, 00, 00, 00, 00, 14, 00, 15, 00, 15, 00, 15, 00, 00, 00, 00, 00, 00 ]
myArray[ 13 ] = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]
myArray[ 14 ] = [ 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 ]

For YLoop = 0 to 14
	For XLoop = 0 to 19
		readVal = MyArray[ YLoop, XLoop ]
		If readVal > 0
			PKSetLayerTile( EffectLayer, XLoop, YLoop, readVal - 1 )
		Else
			PKSetLayerTile( EffectLayer, XLoop, YLoop, -1 )
		Endif
	Next XLoop
Next YLoop

// Load the player blitter object
PlayerID As Integer
PlayerID = PKLoadBlitterObjectEx3( "2dpk_lab_character.png", 4, 6, 1 )
if ( PlayerID > -1 )
	PKAttachBobToLayer( PlayerID, BonusLayer ) // Mean that player bob will be drawn just after the BonusLayer refresh.
	PKPositionBOB( PlayerID, 32, 32 )
Endif
CurrentAnim As Integer = -1

// Create Animations for player.
AnimationUP As Integer
AnimationUP = PKNewAnimation( "ANIM;1;2;3;4;" )
PKSetAnimationSpeed( AnimationUP, 10 )
AnimationRight As Integer
AnimationRight = PKNewAnimation( "ANIM;5;6;7;8;" )
PKSetAnimationSpeed( AnimationRight, 10 )
AnimationDown As Integer
AnimationDown = PKNewAnimation( "ANIM;9;10;11;12;" )
PKSetAnimationSpeed( AnimationDown, 10 )
AnimationLeft As Integer
AnimationLeft = PKNewAnimation( "ANIM;13;14;15;16;" )
PKSetAnimationSpeed( AnimationLeft, 10 )
AnimationFall As Integer
AnimationFall = PKNewAnimation( "ANIM;17;18;19;20;21;" )
PKSetAnimationSpeed( AnimationFall, 10 )

// Setup default layers scrollings values
PKSetGameLayer( BonusLayer )

PlayerSpeed As Float = 1.0
XPos As Float : Xpos = PKGetBobPosX( PlayerID )
YPos As Float : Ypos = PKGetBobPosY( PlayerID )

// Setup default ingame values
Escape As Integer = 0
GameScore As Integer = 0
StartTime As Integer : StartTime = Timer() + 101
dbInkEx( 255, 255, 255 )

ImageID As Integer 
ImageID = XTCreateImageFromMemblock( PKSetup.MaskBlock )
SaveImage( ImageID, "MaskBlock.png" )
DeleteImage( ImageID )


// Main game loop
Repeat
	ClearScreen()
	DBSetCursor( 0, 0 )
	CurrentTime As Integer : CurrentTime = Timer()
	GameTime As Integer : GameTime = ( StartTime - CurrentTime )


	// We create the 4 variables that will be used for collisions with environment.
	TopLEFT As Integer : TopRIGHT As Integer
	BottomLEFT As Integer : BottomRIGHT As Integer

	// Now, we get joystick information to knwo which movements were requested by user/player
	XMove As Integer : YMove As Integer

	XMove = GetRawKeyState( 39 )  - getrawkeystate( 37 )
	YMove = GetRawKeyState( 40 )  - getrawkeystate( 38 )

	// Now we calculate movements Transforming X, Y movements to direction ID
	//              Y = -1                  7   1   4
    //    X = -1  X = Y = 0   X = +1        6   0   3
    //              Y = +1                  8   2   5
	Direction As Integer
	Direction = ( ( XMove = -1 ) * 6 ) + ( ( XMove = 1 ) * 3 ) + ( YMove = -1 ) + ( ( YMove = 1 ) * 2 )
	// If no movement is required
	if Direction = 0
		if CurrentANIM > -1
			PKStopAnimation( CurrentANIM )
			CurrentANIM = -1
		Endif
	// Else, if movements are required
	Else
		Value As Integer = 0
		Value = PKGetLayerTileIDFromCoordinates( LayerID1, XPos + 15, YPos + 24 )

		// Slow down player movements ?
		if Value = SlowGround Then PlayerSpeed = 0.25 else PlayerSpeed = 1.0

		// Game over for player ?
		if Value = Hole1
			Escape = 1 // Game Over
			If CurrentANIM > -1 Then PKStopAnimation( CurrentANIM )
			PKSetAnimationToBob( AnimationFall, PlayerID )
			PKPlayAnimation( AnimationFall )
			PKLoopAnimation( AnimationFall, FALSE )
			CurrentANIM = AnimationFall
			Direction = 0
		Endif

		// If Time is over ... "Game Over"
		if GameTime < 1
			Escape = 1 // Game Over
			If CurrentANIM > -1 Then PKStopAnimation( CurrentANIM )
		Endif

		// Game finished/completed for player ?
		if Value = Ladder then Escape = 2 // Gagné

		// Get tile from layer 2 (BonusLayer) and check if player got a new bonus
		TileID As Integer
		TileID = PKGetLayerTileIDFromCoordinates( BonusLayer, XPos + 15, YPos + 24 )
		if TileID = Bonus1 then GameScore = GameScore + 10
		if TileID = Bonus2 then GameScore = GameScore + 25
		if TileID = Bonus1 or TileID = Bonus2 then PKSetLayerTileIDFromCoordinates( BonusLayer, XPos + 15, YPos + 24, -1 ) // Remove the bonus from the map.


		// UP directions
		If Direction = 7 or Direction = 1 or Direction = 4
			TopLEFT = PKGetLayerMaskPixel( LayerID1, XPos, YPos + 20 )
			TopRIGHT = PKGetLayerMaskPixel( LayerID1, XPos + 23, YPos + 20 )
			DebugText( "Top Left, Top Right = " + Str( TopLEFT ) + ", " + Str( TopRIGHT ) )
			if ( TopLEFT || TopRIGHT ) < 255
				YPos = YPos - PlayerSpeed
				if CurrentANIM <> AnimationUP 
					If CurrentANIM > -1 Then PKStopAnimation( CurrentANIM )
					PKSetAnimationToBob( AnimationUp, PlayerID )
					PKPlayAnimation( AnimationUP )
					PKLoopAnimation( AnimationUP, TRUE )
					CurrentANIM = AnimationUP
				Endif
			Endif
		Endif
		// DOWN Directions
		If Direction = 8 or Direction = 2 or Direction = 5
			BottomLEFT = PKGetLayerMaskPixel( LayerID1, XPos, YPos + 32 )
			BottomRIGHT = PKGetLayerMaskPixel( LayerID1, XPos + 23, YPos + 32 )
			DebugText( "Bottom Left, Bottom Right = " + Str( BottomLEFT ) + ", " + Str( BottomRIGHT ) )
			if ( BottomLEFT || BottomRIGHT ) < 255
				YPos = YPos + PlayerSpeed
				if CurrentANIM <> AnimationDown
					If CurrentANIM > -1 Then PKStopAnimation( CurrentANIM )
					PKSetAnimationToBob( AnimationDown, PlayerID )
					PKPlayAnimation( AnimationDown )
					PKLoopAnimation( AnimationDown, TRUE )
					CurrentANIM = AnimationDown
				Endif
			Endif
		Endif
		// RIGHT Direction
		If Direction = 3 or Direction = 4 or Direction = 5
			TopRIGHT = PKGetLayerMaskPixel( LayerID1, XPos + 24, YPos + 21 )
			BottomRIGHT = PKGetLayerMaskPixel( LayerID1, XPos + 24, YPos + 31 )
			DebugText( "Top Right, Bottom Right = " + Str( TopRIGHT ) + ", " + Str( BottomRIGHT ) )
			if ( TopRIGHT || BottomRIGHT ) < 255
				XPos = XPos + PlayerSpeed
				if CurrentANIM <> AnimationRight
					If CurrentANIM > -1 Then PKStopAnimation( CurrentANIM )
					PKSetAnimationToBob( AnimationRight, PlayerID )
					PKPlayAnimation( AnimationRight )
					PKLoopAnimation( AnimationRight, TRUE )
					CurrentANIM = AnimationRight
				Endif
			Endif
		Endif
		// LEFT direction
		If Direction = 6 or Direction = 7 or Direction = 8
			TopLEFT = PKGetLayerMaskPixel( LayerID1, XPos - 1, YPos + 21 )
			BottomLEFT = PKGetLayerMaskPixel( LayerID1, XPos - 1, YPos + 31 )
			DebugText( "Top Left, Bottom Left = " + Str( TopLEFT ) + ", " + Str( BottomLEFT ) )
			if ( TopLEFT || BottomLEFT ) < 255
				XPos = XPos - PlayerSpeed
				if CurrentANIM <> AnimationLeft // For each direction we check if current animation is the direction.
					If CurrentANIM > -1 Then PKStopAnimation( CurrentANIM ) // If not we stop the current animation
					PKSetAnimationToBob( AnimationLeft, PlayerID ) // Set the new animation to use to player's bob
					PKPlayAnimation( AnimationLeft ) // Start play the animation
					PKLoopAnimation( AnimationLeft, TRUE ) // Makes it loop infinitely if player moves
					CurrentANIM = AnimationLeft // Set current animation to be the new one
				Endif
			Endif
		Endif
	Endif
	
	// Update the player position inside the layer
	PKPositionBOB( PlayerID, XPos, YPos )

	// Refresh display and display some ingame textx
	// DBSetCursor( 0, 0 ) // These are DarkBASIC Professional emulated commands. They require the dbRefresh() method called above.
	dbPrint( "Time Passed = " + Str( GameTime ) )
// 	dbSetCursor( 256, dbGetCursorXPos() )
	DBPrint( "Score : " + Str( GameScore ) )
	// DBSetCursor( 0, 32 )
	DBPrint( "Frame Rate : " + Str( ScreenFPS() ) )

	// Update all layers view positions (scrollings values)
	PKSetGameLayerScroll( XPos - 320, YPos - 240 )
	PKFullUpdate( TRUE )
until Escape > 0

	// Display "YOU WIN" or "GAME OVER" during 4 seconds depending on the value of Escape.
	iLoop As Integer
	For iLoop = 0 to 240
		ClearScreen()
		dbSetCursor( 280, 128 )
		if Escape = 1 then dbPrint( "GAME OVER" )
		if Escape = 2 then dbPrint( " YOU WIN " )
		PKUpdateAnimations()
		PKTraceAllLayers()
		dbRefresh()
		Sync()
	Next iLoop
