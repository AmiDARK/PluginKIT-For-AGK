//
// ***********************************************
// *                                             *
// * 2DPlugKIT Include File : Layers System      *
// *                                             *
// ***********************************************
// Start Date : 2020.03.01
// Description : Default 2DPluginKIT Ver 2.1 Layers System
// Author : Frédéric Cordier

// To Do : 
// - Objects based layer (no tiles, only specified objects, that can also handle animations. Best for asteroids, ponctual models, ets...
// - ForceClear option to clear screen before drawing layers TRUE/FALSE .. if the 1st layer to draw cover the whole screen ForceClear = FALSE optimise performances.

// LayerID = PKCreateNewLayer( LayerName, LayerWidth, LayerHeight )
// PKDeleteLayer( LayerID )
// NewLayerID = PKCloneLayer( SourceLayerID )

// PKSetLayerTilesSizes( LayerID, Width, Height )
// PKSetLayerTile( LayerID, X, Y, TileID )
// PKSetLayerTileIDFromCoordinates( LayerID, X, Y, TileID )
// PKSetGameLayer( LayerID )
// TileID = PKGetLayerTileID( LayerID, X, Y )
// TileID = PKGetLayerTileIDFromCoordinates( LayerID, X, Y )

// PKSetLayerArea( LayerID, aLeft, aTop, aRight, aBottom )
// PKSetLayerViewPosition( LayerID, XPos, YPos )
// PKSetLayerViewPositionX( LayerID, XPos )
// PKSetLayerViewPositionY( LayerID, YPos )

// PKSetLayerUVMode( LayerID, XC, YC )
// PKSetLayerVisible( LayerID, TRUE/FALSE )

// PKScrollLayer( LayerID, XScroll, YScroll )
// PKScrollLayerX( LayerID, XScroll )
// PKScrollLayerY( LayerID, YScroll )

// PKTraceLayerEx( LayerID, X0, Y0, X1, Y1 )
// PKTraceLayer( LayerID )
// PKTraceAllLayers()

// TRUE/FALSE = PKGetLayerExists( LayerID )
// TRUE/FALSE = PKisLayerVisible( LayerID )

// Width = PKGetLayerWidth( LayerID )
// Height = PKGetLayerHeight( LayerID )
// TileWidth = PKGetLayerTileWidth( LayerID )
// TileHeight = PKGetLayerTileHeight( LayerID )

// XCyclingMode = PKGetLayerXCycling( LayerID )
// YCyclingMode = PKGetLayerYCycling( LayerID )
// XScrollValue = PKGetLayerXScroll( LayerID )
// YScrollValue = PKGetLayerYScroll( LayerID )

// PKSetLayerScrollMode( LayerID, ScrollMODE )
// PKSetLayerScrollSpeedXY( LayerID, XSCR, YSCR )
// PKSetLayerScrollX( LayerID, XSCR )
// PKSetLayerScrollY( LayerID, YSCR )

// LayerID = PKGetGameLayer()
// ScrollMODE = PKGetLayerScrollMode( LayerID )
// XScrollSpeed = PKGetLayerXSpeed( LayerID )
// YScrollSpeed = PKGetLayerYSpeed( LayerID )
// PKSetGameLayerScroll( XPosF, YPosF )
// PKWriteLAYERToFILE( ChannelID, LayerID )
// LayerID = PKCreateLAYERFromFile( ChannelID )
// PKWriteAllLayersToFile( ChannelID2 )
// LayersAmount = PKCreateAllLayersFromFile( ChannelID2 )
// CameraMODE = PKGetLayerCameraMODE( LayerID )
// PKSetLayerCameraMODE( LayerID, CameraMODE )
// LeftLimit = PKGetLayerAreaLEFT( LayerID )
// RightLimit = PKGetLayerAreaRIGHT( LayerID )
// TopLimit = PKGetLayerAreaTop( LayerID )
// BottomLimit = PKGetLayerAreaBOTTOM( LayerID )
// PixelColor = PKGetLayerMaskPixel( LayerID, XPos, YPos )

// TRUE/FALSE = PKGetLayerExistsByName( LayerName )
// LayerID = PKGetLayerIDByName( LayerName )
// PKSetLayerTileByName( LayerName, X, Y, TileID )
// PKSetLayerAreaByName( LayerName, aLeft, aTop, aRight, aBottom )
// PKSetLayerViewPositionByName( LayerName, XPos, YPos )
// PKSetLayerViewPositionXByName( LayerName, XPos )
// PKSetLayerViewPositionYByName( LayerName, YPos )
// PKSetLayerUVModeByName( LayerName, XC, YC )
// PKSetLayerTilesSizesByName( LayerName, Width, Height )
// PKScrollLayerByName( LayerName, XScroll, YScroll )
// PKScrollLayerXByName( LayerName, XScroll )
// PKScrollLayerYByName( LayerName, YScroll )
// PKTraceLayerByNameEx( LayerName, X0, Y0, X1, Y1 )
// PKTraceLayerByName( LayerName )
// PKSetLayerVisibleByName( LayerName, VisibleMODE )
// TRUE/FALSE = PKisLayerVisibleByName( LayerName )
// LayerWidth = PKGetLayerWidthByName( LayerName )
// LayerHeight = PKGetLayerHeightByName( LayerName )
// LayerTileWidth = PKGetLayerTileWidthByName( LayerName )
// LayerTileHeight = PKGetLayerTileHeightByName( LayerName )
// XCyclingMode = PKGetLayerXCyclingByName( LayerName )
// YCyclingMode = PKGetLayerYCyclingByName( LayerName )
// XScrollValue = PKGetLayerXScrollByName( LayerName )
// YScrollValue = PKGetLayerYScrollByName( LayerName )
// TileID = PKGetLayerTileIDByName( LayerName, X, Y )
// TileID = PKGetLayerTileIDFromCoordinatesByName( LayerName, X, Y )
// PKSetLayerTileIDFromCoordinatesByName( LayerName, X, Y, TileID )
// PKSetLayerScrollModeByName( LayerName, ScrollMODE )
// PKSetLayerScrollSpeedXYByName( LayerName, XSCR, YSCR )
// PKSetLayerScrollXByName( LayerName, XSCR )
// PKSetLayerScrollYByName( LayerName, YSCR )
// PKSetGameLayerByName( LayerName )
// LayerName = PKGetGameLayerName()
// ScrollMODE = PKGetLayerScrollModeByName( LayerName )
// XScrollSpeed = PKGetLayerXSpeedByName( LayerName )
// YScrollSpeed = PKGetLayerYSpeedByName( LayerName )
// NewLayerName = PKCloneLayerByName( LayerName )
// CameraMODE = PKGetLayerCameraMODEByName( LayerName )
// PKSetLayerCameraMODEByName( LayerName, CameraMODE )
// LeftLimit = PKGetLayerAreaLEFTByName( LayerName )
// RightLimit = PKGetLayerAreaRIGHTByName( LayerName )
// TopLimit = PKGetLayerAreaTOPByName( LayerName )
// BottomLimit = PKGetLayerAreaBOTTOMByName( LayerName )
/* ************************************************************************
 * @Description : 
*/
Function PKCreateNewLayer( LayerName As String, LayerWidth As Integer, LayerHeight As Integer )
	if Len( LayerName ) > 0 and LayerWidth > 0 and LayerHeight > 0
		newLayer As PKLayer_Type
		newLayer.Name = LayerName
		newLayer.Width = LayerWidth
		newLayer.Height = LayerHeight
		newLayer.StoreSize = 16
		newLayer.MemblockID = CreateMemblock( 12 + ( ( newLayer.StoreSize / 8 ) * LayerWidth * LayerHeight ) )
		newLayer.MemorySIZE = GetMemblockSize( newLayer.MemblockID )
		SetMemblockInt( newLayer.MemblockID, 0, newLayer.Width )
		SetMemblockInt( newLayer.MemblockID, 4, newLayer.Height )
		SetMemblockInt( newLayer.MemblockID, 8, newLayer.StoreSize )
		newLayer.TileWidth = PKSetup.TileDefWidth
		newLayer.TileHeight = PKSetup.TileDefHeight
		newLayer.Hidden = FALSE
		newLayer.XDisplay = 0 : newLayer.YDisplay = 0
		newLayer.XCycle = 0 : newLayer.YCycle = 0
		newLayer.XStart = 0 : newLayer.YStart = 0
		newLayer.XEnd = 0 : newLayer.YEnd = 0
		PKLayer.insert( newLayer )
	Else
		CastError( "PKCreateNewLayer Error : Cannot create layer with incorrect values" )
	Endif
EndFunction PKLayer.length

/* ************************************************************************
 * @Description : 
*/
Function PKDeleteLayer( LayerID As Integer )
	If PKGetLayerExists( LayerID ) = 1
		if PKSetup.DynamicDeletion = TRUE
			PKLayer.remove( LayerID )
		Else
			DeleteMemblock( PKLayer[ LayerID ].MemblockID )
			PKLayer[ LayerID ].MemblockID = NOTSET
			PKLayer[ LayerID ] = EmptyLayer
		Endif
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKCloneLayer( SourceLayerID As Integer )
	newLayerID As Integer = -1
	If PKGetLayerExists( SourceLayerID ) = 1
		newLayerID = PKCreateNewLayer( PKLayer[SourceLayerID ].Name + "_CopyID" + Str( PKLayer.length + 1 ), PKLayer[ SourceLayerID ].Width, PKLayer[ SourceLayerID ].Height )
		if ( PKGetLayerExists( newLayerID ) )
			if getMemblockExists( PKLayer[ SourceLayerID ].MemblockID ) = TRUE And getMemblockExists( PKLayer[ newLayerID ].MemblockID ) = TRUE
				CopyMemblock( PKLayer[ SourceLayerID ].MemblockID, PKLayer[ newLayerID ].MemblockID, 0, 0, GetMemblockSize( PKLayer[ SourceLayerID ].MemblockID ) )
			Endif
			PKLayer[ newLayerID ].TileWidth = PKLayer[ SourceLayerID ].TileWidth
			PKLayer[ newLayerID ].TileHeight = PKLayer[ SourceLayerID ].TileHeight
			PKLayer[ newLayerID ].Hidden = PKLayer[ SourceLayerID ].Hidden
			PKLayer[ newLayerID ].XDisplay = PKLayer[ SourceLayerID ].XDisplay
			PKLayer[ newLayerID ].YDisplay = PKLayer[ SourceLayerID ].YDisplay
			PKLayer[ newLayerID ].XCycle = PKLayer[ SourceLayerID ].XCycle
			PKLayer[ newLayerID ].YCycle = PKLayer[ SourceLayerID ].YCycle
			PKLayer[ newLayerID ].XStart = PKLayer[ SourceLayerID ].XStart
			PKLayer[ newLayerID ].YStart = PKLayer[ SourceLayerID ].YStart
			PKLayer[ newLayerID ].XEnd = PKLayer[ SourceLayerID ].XEnd
			PKLayer[ newLayerID ].YEnd = PKLayer[ SourceLayerID ].YEnd
			PKLayer[ newLayerID ].XSpeed = PKLayer[ SourceLayerID ].XSpeed
			PKLayer[ newLayerID ].YSpeed = PKLayer[ SourceLayerID ].YSpeed
			PKLayer[ newLayerID ].CameraLOCK = PKLayer[ SourceLayerID ].CameraLOCK
		Endif
	Endif
EndFunction newLayerID

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerExists( LayerID As Integer )
	isExist As Integer : isExist = FALSE
	if LayerID > -1 and LayerID < ( PKLayer.length + 1 )
		if PKLayer[ LayerID ].MemblockID > -1
			isExist = TRUE
		Endif
	Endif
EndFunction isExist

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerTile( LayerID As Integer, X As Integer, Y As Integer, TileID As Integer )
	if PKLayer.Length = -1
		CastError( "PKSetLayerTile Error : No layer exists" )
	Else
		if PKGetLayerExists( LayerID ) = TRUE
			if X > -1 and Y > -1 and X < PKLayer[ LayerID ].Width and Y < PKLayer[ LayerId ].Height
				// As Layer memblocks are created using the same scheme than Images, we can directly use the same memblock method
				XTWriteMemblockPixel( PKLayer[ LayerID ].MemblockID, X, Y, TileID )
			Else
				CastError( "PKSetLayerTile : The current coordinates " + Str( X ) + "," + Str( Y ) + " are inccorect. Currently accepted values for this layer x=0->" + Str( PKLayer[ LayerID ].Width -1 ) + " , y=0->" + Str( PKLayer[ LayerID ].Height - 1 ) )
			Endif
		Else
			CastError( "PKSetLayerTile Error : The LayerID " + Str( LayerID ) + "is invalid. Currently accepted values 0-" + Str( PKLayer.length ) )
		Endif
	Endif
EndFunction

/* ************************************************************************
 * @Description : 
*/// Définit la zone d'affichage dans l'écran
Function PKSetLayerArea( LayerID As Integer, aLeft As Integer, aTop As Integer, aRight As Integer, aBottom As Integer )
	If PKGetLayerExists( LayerID ) = TRUE
		PKLayer[ LayerID ].XStart = aLeft : PKLayer[ LayerID ].YStart = aTop
		PKLayer[ LayerID ].XEnd = aRight : PKLayer[ LayerID ].YEnd = aBottom
	EndIf
 EndFunction

/* ************************************************************************
 * @Description : 
*/
// décrit à partir de quel endroit (dans le layer) le tracé sera rendu dans la zone (LayerArea)
Function PKSetLayerViewPosition( LayerID As Integer, XPos As Float, YPos As Float )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].XDisplay = XPos
		PKLayer[ LayerID ].YDisplay = YPos
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerViewPositionX( LayerID As Integer, XPos As Float )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].XDisplay = XPos
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerViewPositionY( LayerID As Integer, YPos As Float )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].YDisplay = YPos
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerUVMode( LayerID As Integer, XC As Integer, YC As Integer )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].XCycle = XC
		PKLayer[ LayerID ].YCycle = YC
	EndIf  
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerTilesSizes( LayerID As Integer, Width As Integer, Height As Integer )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].TileWIDTH = Width
		PKLayer[ LayerID ].TileHEIGHT = Height
	Else
		CastError( "PluginKIT : The specified Layer does not exists" )
	EndIf  
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKScrollLayer( LayerID As Integer, XScroll As Integer, YScroll As Integer )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].XDisplay = PKLayer[ LayerID ].XDisplay + XScroll
		PKLayer[ LayerID ].YDisplay = PKLayer[ LayerID ].YDisplay + YScroll
		LayerWIDTH As Integer : LayerWIDTH = PKLayer[ LayerID ].Width * PKLayer[ LayerID ].TileWIDTH
		LayerHEIGHT As Integer : LayerHEIGHT = PKLayer[ LayerID ].Height * PKLayer[ LayerID ].TileHEIGHT
		If PKLayer[ LayerID ].XDisplay < 0 - LayerWIDTH
			PKLayer[ LayerID ].XDisplay = PKLayer[ LayerID ].XDisplay + LayerWIDTH
		Else
			If PKLayer[ LayerID ].XDisplay > LayerWIDTH
				PKLayer[ LayerID ].XDisplay = PKLayer[ LayerID ].XDisplay - LayerWIDTH
			EndIf
		EndIf
		If PKLayer[ LayerID ].YDisplay < 0 - LayerHEIGHT
			PKLayer[ LayerID ].YDisplay = PKLayer[ LayerID ].YDisplay + LayerHEIGHT
		Else
			If PKLayer[ LayerID ].YDisplay > LayerHEIGHT
				PKLayer[ LayerID ].YDisplay = PKLayer[ LayerID ].YDisplay - LayerHEIGHT
			EndIf
		EndIf   
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKScrollLayerX( LayerID As Integer, XScroll As Integer )
	PKScrollLayer( LayerID, XScroll, 0 )
Endfunction

/* ************************************************************************
 * @Description : 
*/
Function PKScrollLayerY( LayerID As Integer, YScroll As Integer )
	PKScrollLayer( LayerID, 0, YScroll )
Endfunction

/* ************************************************************************
 * @Description : 
*/
Function PKTraceLayerEx( LayerID As Integer, X0 As Integer, Y0 As Integer, X1 As Integer, Y1 As Integer )
	if PKGetLayerExists( LayerID ) = 1
		if PKLayer[ LayerID ].Hidden = FALSE
			if PKSetup.rZoom = FALSE then internalAdaptDisplay( FALSE ) // If called Alone, then force refresh screen ratio.
			// if PKLayer[ LayerID ].Hidden = 1
			XDisplay As FLoat : XDisplay = PKLayer[ LayerID ].XDisplay
			YDisplay As Float : YDisplay = PKLayer[ LayerID ].YDisplay
			// Calibrate display
			If X0 = 0
				X0 = X0 - PKLayer[ LayerID ].TileWidth
				XDisplay = XDisplay - PKLayer[ LayerID ].TileWidth
			EndIf
			If Y0 = 0 
				Y0 = Y0 - PKLayer[ LayerID ].TileHeight
				YDisplay = YDisplay - PKLayer[ LayerID ].TileHeight
			EndIf
			If X1 = 0 Then X1 = PKSetup.vWidth   // getBitmapWidth() + ...
			If Y1 = 0 Then Y1 = PKSetup.vHeight // getBitmapHeight() + ...
			// Recalculate Scissor depending on true window size
			advSetScissor( X0, Y0, X1, Y1 )
			// Read screen sizes to calculate drawing area
			XCount As Integer : XCount = ( X1 - X0 ) / PKLayer[ LayerID ].TileWidth
			YCount As Integer : YCount = ( Y1 - Y0 ) / PKLayer[ LayerID ].TileHeight
			XStart As Integer : XStart = XDisplay / PKLayer[ LayerID ].TileWidth 
			YStart As Integer : YStart = YDisplay / PKLayer[ LayerID ].TileHeight
			XShift As Integer : XShift = XDisplay - ( XStart * PKLayer[ LayerID ].TileWidth )
			YShift As Integer : YShift = YDisplay - ( YStart * PKLayer[ LayerID ].TileHeight )
			XTile As Integer = 0 : YTile As Integer = 0
			XLoop As Integer = 0 : YLoop As Integer = 0
			TileID As Integer = 0
			YTile = YStart
			YLoop = - YShift + Y0
			Repeat
				XTile = XStart
				XLoop = - XShift + X0
				Repeat
					TileID = PKGetLayerTileID( LayerID, XTile, YTile )
					If TileID > -1
						PKPasteTile( TileID, XLoop, YLoop )
					EndIf
					XTile = Xtile + 1
					XLoop = XLoop + PKLayer[ LayerID ].TileWidth
				Until XLoop > X1
				YTile = YTile + 1 
				YLoop = YLoop + PKLayer[ LayerID ].TileHeight
			Until YLoop > Y1
			PKDisplayLayerLights( LayerID, X0, Y0, X1, Y1, XDisplay, YDisplay )
			internalPKDrawLayerParticles( LayerID, X0, Y0, X1, Y1, XDisplay, YDisplay )
			internalPKDrawLayerBobs( LayerID, X0, Y0, X1, Y1, XDisplay, YDisplay )
			Render2DFront()
			advSetScissor( 0, 0, 0, 0 )
		Endif
	Else
		CastError( "2DPKv2_Layers/PKTraceLayerex : The Specified layer does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKTraceLayer( LayerID As Integer )
	if PKGetLayerExists( LayerID ) = TRUE
		PKTraceLayerEx( LayerID, PKLayer[ LayerID ].XStart, PKLayer[ LayerID ].YStart, PKLayer[ LayerID ].XEnd, PKLayer[ LayerID ].YEnd )
	Else
		CastError( "2DPKv2_Layers/PKTraceLayer : The Specified layer does not exist" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKTraceAllLayers()
	// Tracé des Layers
	StandAlone As Integer : StandAlone = FALSE
	if PKLayer.length > -1
		// Detect if call is behind the 2DPKv2_Core.PKFullUpdate( withSynchro ) or not
		if PKSetup.rZoom = FALSE
			StandAlone = TRUE
			internalAdaptDisplay( FALSE )
		Endif
		// Recalcul des zooms.
		LayerID As Integer = 0
		For LayerID = 0 to PKLayer.length Step 1
			PKTraceLayer( LayerID )
		Next LayerID
		// if not called from 2DPKv2_Core.PKFullUpdate( withSynchro ), then we clear the checker flag.
		if StandAlone = TRUE
			PKSetup.rZoom = FALSE
			StandAlone = FALSE
			advSetScissor( 0, 0, 0, 0 )
		Endif
	Endif
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerVisible( LayerID As Integer, VisibleMODE As Integer )
	If PKGetLayerExists( LayerID ) = TRUE
		If VisibleMODE < 0 Or VisibleMODE > 1
			CastError( "2DPlugKIT Error : Layer visibility flag value is invalid (Allowed 0-1)" )
		Else
			PKLayer[ LayerID ].Hidden = 1 - VisibleMODE
		EndIf
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKisLayerVisible( LayerID As Integer )
	Retour As Integer
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = 1 - PKLayer[ LayerID ].Hidden
	Else
		Retour = 0
	Endif
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerWidth( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].Width
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerHeight( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].Height
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerTileWidth( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].TileWidth
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerTileHeight( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].TileHeight
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerXCycling( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].XCycle
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerYCycling( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].YCycle
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerXScroll( LayerID As Integer )
	Retour As Float = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].XDisplay
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerYScroll( LayerID As Integer )
	Retour As Float = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerID ].YDisplay
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerTileID( LayerID As Integer, X As Integer, Y As Integer )
	TileID As Integer = 0
	Count As Integer = 0
	if PKGetLayerExists( LayerID ) = TRUE
		// Checking des limites sur X.
		If X >= PKLayer[ LayerID ].Width Or X < 0
			If PKLayer[ LayerID ].XCycle = 1      
				Count = X / PKLayer[ LayerID ].Width
				If X < 0 : Count = Count - 1 : EndIf
				X = X - ( PKLayer[ LayerID ].Width * Count )
			Else
				X = - 1
			EndIf
		EndIf
		// Checking des limites sur Y.
		If Y >= PKLayer[ LayerID ].Height Or Y < 0
			If PKLayer[ LayerID ].YCycle = 1
				Count = Y / PKLayer[ LayerID ].Height
				If Y < 0 : Count = Count - 1 : EndIf
				Y = Y - ( PKLayer[ LayerID ].Height * Count )
			Else
				Y = - 1
			EndIf
		EndIf
		If X > -1 And Y > -1
			// Layers memblocks are organized like images ones, so we can use the same method.
			TileID = XTReadMemblockPixel( PKLayer[ LayerID ].MemblockID, X, Y )
			if TileID > 32766 then TileID = -1
		Else
			TileID = -1
			If PKSetup.outZoneGivesError = 1
				CastError( "Coordinates for Layer #" + Str( LayerID ) + " are out of bounds" )
			Endif
		EndIf
	Else
		CastError( "Layer #" + str( LayerID ) + " Does not exist" )
	EndIf
EndFunction TileID

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerTileIDFromCoordinates( LayerID As Integer, X As Float, Y As Float )
//	XTile As Integer : XTile = ( X / PKLayer[ LayerID ].TileWIDTH ) - 0.5
//	YTile As Integer : YTile = ( Y / PKLayer[ LayerID ].TileHEIGHT ) - 0.5
	XTile As Integer : XTile = ( Trunc( X / PKLayer[ LayerID ].TileWIDTH ) ) // - 0.5
	YTile As Integer : YTile = ( Trunc( Y / PKLayer[ LayerID ].TileHEIGHT ) ) // - 0.5
	TileID As Integer : TileID = PKGetLayerTileID( LayerID, XTile, YTile )
EndFunction TileID

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerTileIDFromCoordinates( LayerID As Integer, X As Float, Y As Float, TileID As Integer )
	XTile As Integer : XTile = ( Trunc( X / PKLayer[ LayerID ].TileWIDTH ) ) // - 0.5
	YTile As Integer : YTile = ( Trunc( Y / PKLayer[ LayerID ].TileHEIGHT ) ) // - 0.5
    PKSetLayerTile( LayerID, XTile, YTile, TileID )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerScrollMode( LayerID As Integer, ScrollMODE As Integer )
	If PKGetLayerExists( LayerID ) = TRUE
		PKLayer[ LayerID ].ScrollMODE = ScrollMODE
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerScrollSpeedXY( LayerID As Integer, XSCR As Float, YSCR As Float )
	If PKGetLayerExists( LayerID ) = TRUE
		PKLayer[ LayerID ].XSpeed = XSCR
		PKLayer[ LayerID ].YSpeed = YSCR
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerScrollX( LayerID As Integer, XSCR As Float )
	If PKGetLayerExists( LayerID ) = TRUE
		PKLayer[ LayerID ].XSpeed = XSCR
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerScrollY( LayerID As Integer, YSCR As Float )
	If PKGetLayerExists( LayerID ) = TRUE
		PKLayer[ LayerID ].YSpeed = YSCR
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetGameLayer( LayerID As Integer )
	If PKGetLayerExists( LayerID ) = TRUE
		PKSetup.GameLayer = LayerID
	EndIf
 EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKGetGameLayer()
	Retour As Integer
	Retour = PKSetup.GameLayer
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerScrollMode( LayerID As Integer )
	Retour As Integer  = 0
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerID ].ScrollMODE
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerXSpeed( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerId ].XSpeed
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerYSpeed( LayerID As Integer )
	Retour As Integer = 0
	If PKGetLayerExists( LayerID ) = TRUE
		Retour = PKLayer[ LayerId ].YSpeed
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKSetGameLayerScroll( XPosF As Float, YPosF As Float )
	LLoop As Integer = 0
	If PKGetLayerExists( PKSetup.GameLayer ) = TRUE
		For LLoop = 0 To PKLayer.length
			If LLoop = PKSetup.GameLayer
				PKLayer[ LLoop ].XDisplay = XPosF
				PKLayer[ LLoop ].YDisplay = YPosF
			Else
				Select PKLayer[ LLoop ].ScrollMODE
					Case 1
						PKLayer[ LLoop ].XDisplay = XPosF * PKLayer[ LLoop ].XSpeed
						PKLayer[ LLoop ].YDisplay = YPosF * PKLayer[ LLoop ].YSpeed
					EndCase
					Case 2
						PKLayer[ LLoop ].XDisplay = XPosF
						PKLayer[ LLoop ].YDisplay = YPosF
					EndCase
					Case 3
						PKLayer[ LLoop ].XDisplay = 0.0
						PKLayer[ LLoop ].YDisplay = 0.0
					EndCase
				EndSelect         
			EndIf
		Next LLoop
	Else
		CastError( "PluginKIT Error : Game Layer is not set" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKWriteLAYERToFILE( ChannelID As Integer, LayerID As Integer )
	If PKGetLayerExists( LayerID ) = 1
		WriteString( ChannelID, "[2DPKLayer_v2]" )
		WriteInteger( ChannelID, LayerID )
		WriteString( ChannelID, PKLayer[ LayerID ].Name )
		WriteInteger( ChannelID, PKLayer[ LayerID ].Width )
		WriteInteger( ChannelID, PKLayer[ LayerID ].Height )
		WriteInteger( ChannelID, PKLayer[ LayerID ].TileWIDTH )
		WriteInteger( ChannelID, PKLayer[ LayerID ].TileHEIGHT )
		WriteInteger( ChannelID, PKLayer[ LayerID ].XCycle )
		WriteInteger( ChannelID, PKLayer[ LayerID ].YCycle )
		WriteInteger( ChannelID, PKLayer[ LayerID ].Hidden )
		WriteInteger( ChannelID, PKLayer[ LayerID ].XDisplay )
		WriteInteger( ChannelID, PKLayer[ LayerID ].YDisplay )
		WriteInteger( ChannelID, PKLayer[ LayerID ].XStart )
		WriteInteger( ChannelID, PKLayer[ LayerID ].YStart )
		WriteInteger( ChannelID, PKLayer[ LayerID ].XEnd )
		WriteInteger( ChannelID, PKLayer[ LayerID ].YEnd )
		WriteInteger( ChannelID, PKLayer[ LayerID ].ScrollMODE )
		WriteFloat( ChannelID, PKLayer[ LayerID ].XSpeed )
		WriteFloat( ChannelID, PKLayer[ LayerID ].YSpeed )
		WriteInteger( ChannelID, PKLayer[ LayerID ].CameraLOCK )
		WriteString( ChannelID, "[PKLayerData_v2]" )
		WriteInteger( ChannelID, PKLayer[ LayerID ].MemorySIZE )
		mLoop As Integer = 0
		For mLoop = 0 To PKLayer[ LayerID ].MemorySIZE Step 4
			WriteInteger( ChannelID, GetMemblockInt( PKLayer[ LayerID ].MemblockID, mLoop ) )
		Next mLoop
	EndIf
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKCreateLAYERFromFile( ChannelID As Integer )
	_HEADERS As String
	OldLayerID As Integer = 0
	LayerID As Integer = 0
	_HEADERS = ReadString( ChannelID )
	// First we must read the LayerID contained in the file ans see if we overwrite it or not with NewLayerID
	If _HEADERS = "[2DPKLayer_v2]"
		OldLayerID = ReadInteger( ChannelID ) // Read Original LayerID
		layerName As String = "" : LayerName = ReadString( ChannelID )
		layerWidth As Integer = 0 : LayerWidth = ReadInteger( ChannelID )
		layerHeight As Integer = 0 : layerHeight = ReadInteger( ChannelID )
		if LayerWidth > 0 and LayerHeight > 0 
			LayerID = PKCreateNewLayer( LayerName, LayerWidth, layerHeight )
			if ( LayerID > -1 )
				PKLayer[ LayerID ].TileWIDTH = ReadInteger( ChannelID )
				PKLayer[ LayerID ].TileHEIGHT = ReadInteger( ChannelID )
				PKLayer[ LayerID ].XCycle = ReadInteger( ChannelID )
				PKLayer[ LayerID ].YCycle = ReadInteger( ChannelID )
				PKLayer[ LayerID ].Hidden = ReadInteger( ChannelID )
				PKLayer[ LayerID ].XDisplay = ReadInteger( ChannelID )
				PKLayer[ LayerID ].YDisplay = ReadInteger( ChannelID )
				PKLayer[ LayerID ].XStart = ReadInteger( ChannelID )
				PKLayer[ LayerID ].YStart = ReadInteger( ChannelID )
				PKLayer[ LayerID ].XEnd = ReadInteger( ChannelID )
				PKLayer[ LayerID ].YEnd = ReadInteger( ChannelID )
				PKLayer[ LayerID ].ScrollMODE = ReadInteger( ChannelID )
				PKLayer[ LayerID ].XSpeed = ReadFloat( ChannelID )
				PKLayer[ LayerID ].YSpeed = ReadFloat( ChannelID )
				PKLayer[ LayerID ].CameraLOCK  = ReadInteger( ChannelID )
				_HEADERS = ReadString( ChannelID )
				If _HEADERS = "[PKLayerData_v2]"
					PKLayer[ LayerID ].MemorySIZE = ReadInteger( ChannelID )
					mbcSize As Integer : mbcSize = getFileSize( ChannelID ) - GetFilePos( ChannelID )
					if PKLayer[ LayerID ].MemorySIZE <= mbcSize // Because there can be several layers in the same file.
						PKLayer[ LayerID ].MemblockID = CreateMemblock( mbcSize )
						PKLayer[ LayerID ].MemorySIZE = mbcSize
						xMbcPos As Integer = 0
						// On lit le contenu du fichier jusqu'à atteindre la fin de ce dernier
						Repeat
							SetMemblockInt( PKLayer[ LayerID ].MemblockID, xMbcPos, ReadInteger( ChannelID ) )
							xMbcPos = xMbcPos + 4
						Until xMbcPos = PKLayer[ LayerID ].MemorySIZE
					Else
						PKDeleteLayer( LayerID )
						CastError( "PluginKIT Error : The opened file is corrupted" )
						LayerID = -1
					EndIf
				Else
					PKDeleteLayer( LayerID )
					CastError( "PluginKIT Error : The opened file does not contain PluginKIT v2 Layer Datas" )
					LayerID = -1
				EndIf
			Else
				CastError( "PluginKIT Error : Impossible to create the Layer" )
				LayerID = -1
			EndIf
		Else
			CastError( "PluginKIT Error : Layer sizes are incorrect" )
			LayerID = -1
		EndIf
	Else
		CastError( "PluginKIT Error : The opened file is not a PluginKIT V2 Layer File" )
		LayerID = -1
	Endif
EndFunction LayerID

/* ************************************************************************
 * @Description : 
*/
Function PKWriteAllLayersToFile( ChannelID2 As Integer )
	LayerID As Integer = 0
	WriteString( ChannelID2, "[PKAllLayers_v2]" )
	For LayerID = 0 To 15
		If PKGetLayerExists( LayerID ) = 1
		PKWriteLAYERToFILE( ChannelID2, LayerID )
		if LayerID < 15 Then WriteString( ChannelID2, "[PKAllLAyers_v2_NextOne]" )
		EndIf
	Next LayerID
	WriteString( ChannelID2, "[PKAllLayers_v2_END]" )
 EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKCreateAllLayersFromFile( ChannelID2 As Integer )
	LayerCount As Integer = 0
	_HEADERS As String
	_HEADERS = ReadString( ChannelID2 )
	if _HEADERS = "[PKAllLayers_v2]"
		repeat
			LayerCount = PKCreateLAYERFromFile( ChannelID2 )
			_HEADERS = ReadString( ChannelID2 )
		until _HEADERS = "[PKAllLayers_v2_END"
	Else
		CastError( "PluginKIT Error : The opened file is not a PluginKIT V2 Multi-Layers File" )
		LayerCount = -1
	Endif
EndFunction LayerCount

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerCameraMODE( LayerID As Integer )
	Retour As Integer 
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerID ].CameraLOCK
	Else
		Retour = 0
	EndIf
EndFunction Retour
 
/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerCameraMODE( LayerID As Integer, CameraMODE As Integer )
	If PKGetLayerExists( LayerID ) = 1
		PKLayer[ LayerID ].CameraLOCK = CameraMODE
	EndIf
EndFunction
 
/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaLEFT( LayerID As Integer )
	Retour As Integer 
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerID ].XStart
	Else
		Retour = 0
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaRIGHT( LayerID As Integer )
	Retour As Integer 
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerID ].XEnd
	Else
		Retour = 0
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaTop( LayerID As Integer )
	Retour As Integer 
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerID ].YStart
	Else
		Retour = 0
	EndIf
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaBOTTOM( LayerID As Integer )
	Retour As Integer 
	If PKGetLayerExists( LayerID ) = 1
		Retour = PKLayer[ LayerID ].YEnd
	Else
		Retour = 0
	EndIf
EndFunction Retour

//
//**************************************************************************************************************
//
function PKGetLayerMaskPixel( LayerID As Integer, XPos As Integer, YPos As Integer )
	MASKPixel As Integer = 0
	XTile As Integer : YTile As Integer
	TileID As Integer = -1
	If PKGetLayerExists( LayerID ) = TRUE
		If XPos > -1 and XPos < ( PKLayer[ LayerID ].Width * PKLayer[ LayerID ].TileWidth )
			XTile = XPos / PKLayer[ LayerID ].TileWIDTH
		Else
			XTile = -1
		EndIf
		If YPos > -1 and YPos < ( PKLayer[ LayerID ].Height * PKLayer[ LayerID ].TileHeight )
			YTile = YPos / PKLayer[ LayerID ].TileHEIGHT 
		Else
			YTile = -1
		EndIf
		if YTile > -1 and XTile > -1
			TileID = PKGetLayerTileID( LayerID, XTile, YTile )
		Endif
		// DebugMessage( "Tile Sizes : " + Str( Layers[ LayerID ].TileWIDTH ) + ", " + Str( Layers[ LayerID ].TileHEIGHT ) + " ) " )
		If TileID > -1
			if PKTile[ TileID ].maskLoaded = TRUE
				XPosIn As Integer 
				XPosIn = XPos - ( XTile * PKLayer[ LayerID ].TileWIDTH )
				YPosIn As Integer
				YPosIn = YPos - ( YTile * PKLayer[ LayerID ].TileHEIGHT )
				// DebugMessage( "Get Tiles " + Str( TileID ) + " Mask at tile coordinate " + Str( XPosIn ) + "," + Str( YPosIn ) )
				MASKPixel = PKGetTileMaskPixel( TileID, XPosIn, YPosIn )
			Else
				MASKPixel = 0
			Endif
		Else
			MASKPixel = 0
		EndIf
	Else
		CastError( "PKGetLayerMaskPixel Error : The requested Layer does not exists" )
	EndIf
Endfunction MASKPixel

//
//**************************************************************************************************************
//
function PKGetLayerNMapPixel( LayerID As Integer, XPos As Integer, YPos As Integer )
	NMapPixel As Integer = 0
	XTile As Integer : YTile As Integer
	TileID As Integer = -1
	If PKGetLayerExists( LayerID ) = TRUE
		If XPos > -1 and XPos < ( PKLayer[ LayerID ].Width * PKLayer[ LayerID ].TileWidth )
			XTile = XPos / PKLayer[ LayerID ].TileWIDTH
		Else
			XTile = -1
		EndIf
		If YPos > -1 and YPos < ( PKLayer[ LayerID ].Height * PKLayer[ LayerID ].TileHeight )
			YTile = YPos / PKLayer[ LayerID ].TileHEIGHT 
		Else
			YTile = -1
		EndIf
		if YTile > -1 and XTile > -1
			TileID = PKGetLayerTileID( LayerID, XTile, YTile )
		Endif
		// DebugMessage( "Tile Sizes : " + Str( Layers[ LayerID ].TileWIDTH ) + ", " + Str( Layers[ LayerID ].TileHEIGHT ) + " ) " )
		If TileID > -1
			if PKTile[ TileID ].nmapLoaded = TRUE
				XPosIn As Integer 
				XPosIn = XPos - ( XTile * PKLayer[ LayerID ].TileWIDTH )
				YPosIn As Integer
				YPosIn = YPos - ( YTile * PKLayer[ LayerID ].TileHEIGHT )
				// DebugMessage( "Get Tiles " + Str( TileID ) + " Mask at tile coordinate " + Str( XPosIn ) + "," + Str( YPosIn ) )
				NMapPixel = PKGetTileNMapPixel( TileID, XPosIn, YPosIn )
			Else
				NMapPixel = dbRGBAex( 127, 127, 255, 255 )
			Endif
		Else
			NMapPixel = 0
		EndIf
	Else
		CastError( "PKGetLayerMaskPixel Error : The requested Layer does not exists" )
	EndIf

Endfunction NMapPixel


//                                                                     ***********************************
// ************************************************************************ Layers methods by NAME
//                                                                     ***********************************

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerExistsByName( LayerName As String )
	isExist As Integer : isExist = FALSE
	if PKLayer.length > -1
		lLoop As Integer = 0
		repeat
			if PKLayer[ lLoop ].Name = LayerName then isExist = TRUE
			inc lLoop, 1
		until lLoop < ( PKLayer.length - 1 ) or isExist = TRUE
	Endif
EndFunction isExist

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerIDByName( LayerName As String )
	layerID As Integer = -1
	if PKLayer.length > -1
		lLoop As Integer = 0
		repeat
			if PKLayer[ lLoop ].Name = LayerName then layerID = lLoop
			inc lLoop, 1
		until lLoop > ( PKLayer.length - 1 ) or layerID > -1
	Endif
EndFunction layerID

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerTileByName( LayerName As String, X As Integer, Y As Integer, TileID As Integer )
	PKSetLayerTile( PKgetLayerIDByName( LayerName ), X, Y, TileID )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerAreaByName( LayerName As String, aLeft As Integer, aTop As Integer, aRight As Integer, aBottom As Integer )
	PKSetLayerArea( PKgetLayerIDByName( LayerName ), aLeft, aTop, aRight, aBottom )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerViewPositionByName( LayerName As String, XPos As float, YPos As Float )
	PKSetLayerViewPosition( PKgetLayerIDByName( LayerName ), XPos, YPos )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerViewPositionXByName( LayerName As String, XPos As Float )
	PKSetLayerViewPositionX( PKgetLayerIDByName( LayerName ), XPos )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerViewPositionYByName( LayerName As String, YPos As Float )
	PKSetLayerViewPositionY( PKgetLayerIDByName( LayerName ), YPos )
EndFunction
 
/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerUVModeByName( LayerName As String, XC As Integer, YC As Integer )
	PKSetLayerUVMode( PKgetLayerIDByName( LayerName ), XC, YC )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerTilesSizesByName( LayerName As String, Width As Integer, Height As Integer )
	PKSetLayerTilesSizes( PKgetLayerIDByName( LayerName ), Width, Height )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKScrollLayerByName( LayerName As String, XScroll As Integer, YScroll As Integer )
	PKScrollLayer( PKgetLayerIDByName( LayerName ), XScroll, YScroll )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKScrollLayerXByName( LayerName As String, XScroll As Integer )
	PKScrollLayer( PKgetLayerIDByName( LayerName ), XScroll, 0 )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKScrollLayerYByName( LayerName As String, YScroll As Integer )
	PKScrollLayer( PKgetLayerIDByName( LayerName ), 0, YScroll )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKTraceLayerByNameEx( LayerName As String, X0 As Integer, Y0 As Integer, X1 As Integer, Y1 As Integer )
	PKTraceLayerEx( PKgetLayerIDByName( LayerName ), X0, Y0, X1, Y1 )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKTraceLayerByName( LayerName As String )
	PKTraceLayer( PKgetLayerIDByName( LayerName ) )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerVisibleByName( LayerName As String, VisibleMODE As Integer )
	PKSetLayerVisible( PKgetLayerIDByName( LayerName ), VisibleMODE )
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function PKisLayerVisibleByName( LayerName As String )
	Retour As Integer
	Retour = PKisLayerVisible( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerWidthByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerWidth( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerHeightByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerHeight( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerTileWidthByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerTileWidth( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerTileHeightByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerTileHeight( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerXCyclingByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerXCycling( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerYCyclingByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerYCycling( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerXScrollByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerXScroll( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerYScrollByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerYScroll( PKgetLayerIDByName( LayerName ) ) 
EndFunction Retour

/* ************************************************************************
 * @Description : 
 */
Function PKGetLayerTileIDByName( LayerName As String, X As Integer, Y As Integer )
	Retour As Integer
	Retour = PKGetLayerTileID( PKgetLayerIDByName( LayerName ), X, Y )
EndFunction Retour

/* ************************************************************************
 * @Description : Get the tile value at x,y of the specified layer
 */
Function PKGetLayerTileIDFromCoordinatesByName( LayerName As String, X As Float, Y As Float )
	TileID As Integer
	TileID = PKGetLayerTileIDFromCoordinates( PKgetLayerIDByName( LayerName ), X, Y )
EndFunction TileID

/* ************************************************************************
 * @Description : Set the tile at x,y of the specified layer
 */
Function PKSetLayerTileIDFromCoordinatesByName( LayerName As String, X As Float, Y As Float, TileID As Integer )
	PKSetLayerTileIDFromCoordinates( PKgetLayerIDByName( LayerName ), X, Y, TileID )
EndFunction

/* ************************************************************************
 * @Description : Defint the default scrolling mode for the specified Layer
 */
Function PKSetLayerScrollModeByName( LayerName As String, ScrollMODE As Integer )
	PKSetLayerScrollMode( PKgetLayerIDByName( LayerName ), ScrollMODE  )
EndFunction

/* ************************************************************************
 * @Description : Define the default X and Y scrolling for the specified Layer
 */
Function PKSetLayerScrollSpeedXYByName( LayerName As String, XSCR As Float, YSCR As Float )
	PKSetLayerScrollSpeedXY( PKgetLayerIDByName( LayerName ), XSCR, YSCR )
EndFunction

/* ************************************************************************
 * @Description : Scroll a Layer on X
 */
Function PKSetLayerScrollXByName( LayerName As String, XSCR As Float )
	PKSetLayerScrollX( PKgetLayerIDByName( LayerName ), XSCR )
EndFunction

/* ************************************************************************
 * @Description : Scroll a Layer on Y
 */
Function PKSetLayerScrollYByName( LayerName As String, YSCR As Float )
	PKSetLayerScrollY( PKgetLayerIDByName( LayerName ), YSCR )
EndFunction

/* ************************************************************************
 * @Description : Makes a layer become the default Game Layer
 */
Function PKSetGameLayerByName( LayerName As String )
	PKSetGameLayer( PKgetLayerIDByName( LayerName ) )
 EndFunction

/* ************************************************************************
 * @Description : Get the name of the Layer that is defined as the current Game Layer
 */
Function PKGetGameLayerName()
	Retour As String = ""
	If PKGetLayerExists( PKSetup.GameLayer ) = TRUE
		Retour = PKLayer[ PKSetup.GameLayer ].Name
	Endif
EndFunction Retour

/* ************************************************************************
 * @Description : Return the current scrolling mode for the specified layer
 */
Function PKGetLayerScrollModeByName( LayerName As String )
	Retour As Integer  = 0
	Retour = PKGetLayerScrollMode( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : Return the default layer X Speed for scrollings
 */
Function PKGetLayerXSpeedByName( LayerName As String )
	Retour As Integer  = 0
	Retour = PKGetLayerXSpeed( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : Return the default layer Y Speed for scrollings
 */
Function PKGetLayerYSpeedByName( LayerName As String )
	Retour As Integer  = 0
	Retour = PKGetLayerYSpeed( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : Clone an existing layer
 */
Function PKCloneLayerByName( LayerName As String )
	Retour As String = ""
	newLayerID As Integer = -1
	newLayerID = PKCloneLayer( PKgetLayerIDByName( LayerName ) )
EndFunction PKLayer[ newLayerID ].Name

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerCameraMODEByName( LayerName As String )
	Retour As Integer 
	Retour = PKGetLayerCameraMODE( PKgetLayerIDByName( LayerName ) )
EndFunction Retour
 
/* ************************************************************************
 * @Description : 
*/
Function PKSetLayerCameraMODEByName( LayerName As String, CameraMODE As Integer )
	PKSetLayerCameraMODE( PKgetLayerIDByName( LayerName ), CameraMODE )
EndFunction
 
/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaLEFTByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerAreaLEFT( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaRIGHTByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerAreaRIGHT( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaTOPByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerAreaTOP( PKgetLayerIDByName( LayerName ) )
EndFunction Retour

/* ************************************************************************
 * @Description : 
*/
Function PKGetLayerAreaBOTTOMByName( LayerName As String )
	Retour As Integer
	Retour = PKGetLayerAreaBOTTOM( PKgetLayerIDByName( LayerName ) )
EndFunction Retour


/* ************************************************************************
 * @Description : 
*/
function internalPKDrawLayerParticles( LayerID As Integer, XS As Integer, YS As Integer, XE As Integer, YE As Integer, XDisplay As Integer, YDisplay As Integer )
	//  Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
	DisplayWIDTH As Integer : DisplayWIDTH = XE - XS
	DisplayHEIGHT As Integer : DisplayHEIGHT = YE - YS
	//  Calcul des 4 extrémités pour l'affichage des lumières.
	if PKLayer[ LayerID ].PKParticles.length > -1
		pLoop As Integer
		for pLoop = 0 to PKLayer[ LayerID ].PKParticles.length Step 1
			particleID As Integer : particleID = PKLayer[ LayerID ].PKParticles[ pLoop ]
			if PKGetParticleExists( particleID ) = TRUE
				If PKParticle[ particleID ].XMax > XDisplay And PKParticle[ particleID ].XMin < XDisplay + DisplayWIDTH
					If PKParticle[ particleID ].YMax > YDisplay And PKParticle[ particleID ].YMin < YDisplay + DisplayHEIGHT
						XSHIFT As Integer : XSHIFT = XS - XDisplay
						YSHIFT As Integer : YSHIFT = YS - YDisplay
						PKUpdateParticle( particleID, XSHIFT, YSHIFT )
					Endif
				Endif
			Endif
		next pLoop
	Endif
 Endfunction
