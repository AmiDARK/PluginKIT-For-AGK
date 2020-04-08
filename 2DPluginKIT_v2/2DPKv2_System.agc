//
// ***********************************************
// *                                             *
// * 2DPlugKIT Include File : SYSTEM METHODS     *
// *                                             *
// ***********************************************
// Start Date : 2020.03.24
// Description : Default 2DPluginKIT Ver 2.1 System Methods
// Author : Frédéric Cordier

// PKSetDefaultTileSizes( NewDefTileWidth, NewDefTileHeight )
// PKSetDefaultTileWidth( NewDefTileWidth )
// PKSetDefaultTileHeight( NewDefTileHeight )
// PKSetDefaultTileTransparency( TransparencyMode )
// DefTileWidth = PKGetDefaultTileWidth()
// DefTileHeight = PKGetDefaultTileHeight()
// TransparencyMode = PKGetDefaultTileTransparency()
// PKSetDebugMODE( TRUE/FALSE )
// TRUE/FALSE = PKGetDebugMODE()

//**************************************************************************************************************
//
Function PKSetDefaultTileSizes( DefaultWIDTH As Integer, DefaultHEIGHT As Integer )
	If DefaultWIDTH > 7 And DefaultWIDTH < 257
		If DefaultHEIGHT > 7 And DefaultHEIGHT < 257
			PKSetup.TileDefWidth = DefaultWIDTH
			PKSetup.TileDefHeight = DefaultHEIGHT
		Else
			Message( "2PKv2_System.PKSetDefaultTileSizes Error : Choosen default tile height is incorrect" )
		EndIf
	Else
		Message( "2PKv2_System.PKSetDefaultTileSizes Error : Choosen default tile width is incorrect" )
	EndIf
EndFunction

// **************************************************************************************************************
//
Function PKSetDefaultTileWidth( DefaultWIDTH As Integer )
	If DefaultWIDTH > 7 And DefaultWIDTH < 257
		PKSetup.TileDefWidth = DefaultWIDTH
	Else
		Message( "2PKv2_System.PKSetDefaultTileWidth Error : Choosen default tile width is incorrect" )
	EndIf
EndFunction
//

// **************************************************************************************************************
//
Function PKSetDefaultTileHeight( DefaultHEIGHT As Integer )
	If DefaultHEIGHT > 7 And DefaultHEIGHT < 257
		PKSetup.TileDefHeight = DefaultHEIGHT
	Else
		Message( "2PKv2_System.PKSetDefaultTileHeight Error : Choosen default tile height is incorrect" )
	EndIf
EndFunction

//**************************************************************************************************************
//
Function PKSetDefaultTileTransparency( DefaultTRANSPARENCY As Integer )
	If DefaultTRANSPARENCY = FALSE Or DefaultTRANSPARENCY = TRUE
		PKSetup.TileDefTransp = DefaultTRANSPARENCY
	Else
		Message( "2PKv2_System.PKSetDefaultTileTransparency Error : Choosen default tile transparency is incorrect" )
	EndIf
EndFunction

//**************************************************************************************************************
//
Function PKGetDefaultTileWidth()
	Retour As Integer 
	Retour = PKSetup.TileDefWidth
EndFunction Retour
//

//**************************************************************************************************************
//
Function PKGetDefaultTileHeight()
	Retour As Integer
	Retour = PKSetup.TileDefHeight
EndFunction Retour
//

//**************************************************************************************************************
//
Function PKGetDefaultTileTransparency()
	Retour As Integer
	Retour = PKSetup.TileDefTransp
EndFunction Retour

//**************************************************************************************************************
//
Function PKSetDebugMODE( ModeL As Integer )
	PKSetup.DebugMode = ModeL
EndFunction

//**************************************************************************************************************
//
Function PKGetDebugMODE()
	ModeL As Integer
	ModeL = PKSetup.DebugMode
EndFunction ModeL
