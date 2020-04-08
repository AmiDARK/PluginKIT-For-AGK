//
// ******************************************************
// *                                                    *
// * eXtends Ver 2.0 Include File : 3D Particles System *
// *                                                    *
// ******************************************************
// Start Date : 2019.05.16 22:56
// Description : These methods will add support for custom
//               particles system with specific presets
//
// Author : Frédéric Cordier
//

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTCreateNewXParticle( ParticleName As String, ParticleCount As Integer , ParticleImage As Integer , ParticleSize As Float )
	If ParticleCount > 8 And ParticleSize > 0.0
		newParticle As Particle_Type
		newParticle.Name = ParticleName
		newParticle.Exist = 1
		newParticle.mType = 0
		newParticle.Count = ParticleCount
		newParticle.Size =	ParticleSize
		If GetImageExists( ParticleImage ) <> 0
			newParticle.LoadedImage = ParticleImage
		Else
			newParticle.LoadedImage = 0
		Endif
		//
		XLoop As Integer
		For XLoop = 1 To ParticleCount
			New3DObject As ParticleObject_Type
			New3DObject.Number = CreateObjectPlane( ParticleSize, ParticleSize )
			SetObjectCollisionMode( New3DObject.Number, 0 )
			If New3DObject.Number > 0
				If GetImageExists( newParticle.LoadedImage )
					SetObjectImage( New3DObject.Number , newParticle.LoadedImage , 0 )
				EndIf
				New3DObject.XPos = 0
				New3DObject.YPos = 0
				New3DObject.ZPos = 0
				XTAddObjectToBillboard3D( New3DObject.Number )
			EndIf
			newParticle.ParticleObject.insert( new3DObject )
		Next XLoop
		XParticle.insert( newParticle )
	EndIf
Endfunction XParticle.length
/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSet2DParticleImage( ParticleName As String, ParticleImage As Integer )
	pID As Integer : pID = XTGetXParticleIDByName( ParticleName )
	if pID > -1
		if getImageExists( ParticleImage ) = TRUE
			// Update the particle data
			XParticle[ pID ].LoadedImage = ParticleImage
			// Update all the 3D objects used to create the particle.
			pLoop As Integer
			for pLoop = 0 to XParticle[ pID ].ParticleObject.length
				SetObjectImage( XParticle[ pID ].ParticleObject[ pLoop ].Number, ParticleImage, 0 )
			Next pLoop
		Else
			Message( "XTSet2DParticleImage Error : The request Image index number '" + Str( ParticleImage ) + "' does not exists or is invalid." )
		Endif
	Else
		Message( "XTSet2DParticleImage Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleIDByName( ParticleName As String )
	particleID As Integer = -1
	if XParticle.length > -1
		xpLoop As Integer = 0
		Repeat
			if XParticle[ xpLoop ].Name = ParticleName then particleID = xpLoop
			Inc xpLoop, 1
		Until xpLoop > XParticle.length or particleID > -1
	Endif
EndFunction particleID

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleExists( ParticleName As String )
	isExist As Integer : isExist = ( XTGetXParticleIDByName( ParticleName ) > -1 )
EndFunction isExist

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleVisibility( ParticleName As String, isVisible As Integer )
	pID As Integer : pID = XTGetXParticleIDByName( ParticleName )
	if ( pID > -1 )
		if isVisible = FALSE or isVisible = TRUE
			if XParticle[ pID ].ParticleObject.length > -1
				// Now we set all the objects of the XParticle visible or hidden
				xpLoop As Integer = 0
				For xpLoop = 0 to XParticle[ pID ].ParticleObject.length
					SetObjectvisible( XParticle[ pID ].ParticleObject[ xpLoop ].Number, isVisible )
				Next xpLoop
			Endif
			XParticle[ pID ].isVisible = isVisible
		Else
			Message( "XTSetXParticleVisibility Error : isVisible only allow 0-1 values (hidden-visible)" )
		Endif
	Else
		Message( "XTSetXParticleVisibility Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction

Function XTShowXParticle( ParticleName As String )
	XTSetXParticleVisibility( ParticleName, TRUE )
EndFunction

Function XTHideXParticle( ParticleName As String )
	XTSetXParticleVisibility( ParticleName, FALSE )
EndFunction

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTDeleteXParticle( ParticleName As String )
	pID As Integer : pID = XTGetXParticleIDByName( ParticleName )
	if ( pID > -1 )
		if XParticle[ pID ].ParticleObject.length > -1
			// Firstly we remove all the 3D Objects used by the XParticle object
			xpLoop As Integer = 0
			For xpLoop = XParticle[ pID ].ParticleObject.length to 0 step -1
				DeleteObject( XParticle[ pID ].ParticleObject[ xpLoop ].Number )
				XParticle[ pId ].ParticleObject.remove( xpLoop )
			Next xpLoop
			// Si l'image a été spécialement chargée pour la XParticle, on la supprime.
			if XParticle[ pID ].LoadedImage < 0
				DeleteImage( 0 - XParticle[ pID ].LoadedImage )
			Endif
			// Secondly, we remove the XParticle Object from the list
			XParticle.remove( pID )
		Endif
	Else
		Message( "XTDeleteXParticle Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction
	

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTDeleteAllXParticle()
	if XParticle.length > -1
		xpLoop As Integer
		for xpLoop = XParticle.length to 0 step -1
			XParticle.remove( xpLoop )
		Next xpLoop
	Endif
EndFunction


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticlePosition( ParticleName As String, xPos As Float, yPos As Float, zPos As Float )
	pID As Integer : pID = XTGetXParticleIDByName( ParticleName )
	if ( pID > -1 )
		// Calculate coordinates to move all the particles objects
		// xShift As Float : yShift As Float : zShift As Float
		// xShift = xPos - XParticle[ pID ].XEmitter
		// yShift = yPos - XParticle[ pID ].YEmitter
		// zShift = zPos - XParticle[ pID ].ZEmitter
		// 2. We update the position of the current XParticle emitter
		XParticle[ pID ].XEmitter = xPos
		XParticle[ pID ].YEmitter = yPos
		XParticle[ pID ].ZEmitter = zPos
		// 3. We update all the current XParticle boundaries
		If XParticle[ pID ].XSize > 0 And XParticle[ pID ].YSize > 0 And XParticle[ pID ].ZSize > 0
			XSize As Integer : YSize As Integer : ZSize As Integer
			XSize = XParticle[ pID ].XSize
			YSize = XParticle[ pID ].YSize
			ZSize = XParticle[ pID ].ZSize
			XParticle[ pID ].XMin = XParticle[ pID ].XEmitter - ( Xsize / 2 )
			XParticle[ pID ].XMax = XParticle[ pID ].XEmitter + ( Xsize / 2 )
			XParticle[ pID ].YMin = XParticle[ pID ].YEmitter - ( Ysize / 2 )
			XParticle[ pID ].YMax = XParticle[ pID ].YEmitter + ( Ysize / 2 )
			XParticle[ pID ].ZMin = XParticle[ pID ].ZEmitter - ( Zsize / 2 )
			XParticle[ pID ].ZMax = XParticle[ pID ].ZEmitter + ( Zsize / 2 )
		 EndIf
	Else
		Message( "XTSetXParticlePosition Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
 Function XTSetXParticleEmitter( ParticleName As String, XSize AS INTEGER , YSize AS INTEGER , ZSize AS INTEGER )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].XSize = XSize
		XParticle[ ParticleID ].YSize = YSize
		XParticle[ ParticleID ].ZSize = ZSize
		XParticle[ ParticleID ].XMin = XParticle[ ParticleID ].XEmitter - ( Xsize / 2 )
		XParticle[ ParticleID ].XMax = XParticle[ ParticleID ].XEmitter + ( Xsize / 2 )
		XParticle[ ParticleID ].YMin = XParticle[ ParticleID ].YEmitter - ( Ysize / 2 )
		XParticle[ ParticleID ].YMax = XParticle[ ParticleID ].YEmitter + ( Ysize / 2 )
		XParticle[ ParticleID ].ZMin = XParticle[ ParticleID ].ZEmitter - ( Zsize / 2 )
		XParticle[ ParticleID ].ZMax = XParticle[ ParticleID ].ZEmitter + ( Zsize / 2 )
	Else
		Message( "XTSetXParticleEmitter Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticlePath( ParticleName As String, XMove AS INTEGER , YMove AS INTEGER , ZMove AS INTEGER )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].XMove = XMove
		XParticle[ ParticleID ].YMove = YMove
		XParticle[ ParticleID ].ZMove = ZMove
	Else
		Message( "XTSetXParticlePath Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 
/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleAsPrimitive( ParticleName As String )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].mType = 0
	Else
		Message( "XTSetXParticleAsPrimitive Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTLoadXParticleImage( ParticleName As String, Source AS STRING )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		// Si aucune image n'est utilisée pour la flamme, on utilise celle contenue dans la DLL.
		If XParticle[ ParticleID ].LoadedImage = 0
			// Memb AS INTEGER : Memb = CreateMemblockFromFile( Source )
			// If Memb > 0
			Img As Integer : Img = LoadImage( Source, 1 )
			XParticle[ ParticleID ].loadedImage = 0 - Img
			XParticle[ ParticleID ].UseInternal = 1
			XLoop As Integer
			If GetImageExists( Img ) = 1
				For XLoop = 1 To XParticle[ ParticleID ].Count
					SetObjectImage( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , Img, 0 )
				Next XLoop
			EndIf
		Endif
	Else
		Message( "XTLoadXParticleImage Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleAsFlame( ParticleName As String )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].mType = 1
		XTLoadXParticleImage( ParticleName, FLAMEPARTICLES )
		XLoop As Integer
		XRand As Integer : ZRand As Integer
		For XLoop = 1 To XParticle[ ParticleID ].Count
			FLAMESTEP AS FLOAT : FLAMESTEP = 200.0 / XParticle[ ParticleID ].Count
			// We Apply object properties to all entities to make a true flame
			SetObjectTransparency( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 2 )
			SetObjectLightMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number ,0 )
			SetObjectFogMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectDepthWrite( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 )
			XTSetBillboard3DYRotation( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, TRUE )
			// We position the flames for default settings.
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = FLAMESTEP * XLoop
			XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
			ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].XMin + XRand + ( XParticle[ ParticleID ].Size / 2 )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration * 0.1
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ZMin + ZRand + ( XParticle[ ParticleID ].Size / 2 )
		Next XLoop				
		XParticle[ ParticleID ].XMove = 0.0
		XParticle[ ParticleID ].YMove = 0.25
		XParticle[ ParticleID ].ZMove = 0.0
		XParticle[ ParticleID ].Duration = XParticle[ ParticleID ].YSize
	Else
		Message( "XTSetXParticleAsFlame Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 
/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleAsSmoke( ParticleName As String )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].mType = 2
		XTLoadXParticleImage( ParticleName, FLAMEPARTICLES )
		XLoop As Integer
		XRand As Integer : ZRand As Integer
		For XLoop = 1 To XParticle[ ParticleID ].Count
			SMOKESTEP AS FLOAT : SMOKESTEP = 200.0 / XParticle[ ParticleID ].Count
			SetObjectBlendModes( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 2, 10 ) // Was DBGhostObjectOn1()
			SetObjectTransparency( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 0 )
			SetObjectLightMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectFogMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectDepthWrite( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 ) // DBDisableObjectZWrite()
			XTSetBillboard3DYRotation( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, TRUE )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = SMOKESTEP * XLoop
			XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
			ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].XMin + XRand + ( XParticle[ ParticleID ].Size / 2 )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration * 0.1
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ZMin + ZRand + ( XParticle[ ParticleID ].Size / 2 )
		Next XLoop
		XParticle[ ParticleID ].XMove = 0.0
		XParticle[ ParticleID ].YMove = 0.025
		XParticle[ ParticleID ].ZMove = 0.0
		XParticle[ ParticleID ].Duration = XParticle[ ParticleID ].YSize
	Else
		Message( "XTSetXParticleAsSmoke Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleAsRain( ParticleName As String )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].mType = 3
		XTLoadXParticleImage( ParticleName, RAINPARTICLES )
		XLoop As Integer
		XRand As Integer : ZRand As Integer : YRand As Integer
		For XLoop = 1 To XParticle[ ParticleID ].Count
			SetObjectTransparency( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 2 )
			SetObjectLightMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number ,1 )
			SetObjectFogMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectDepthWrite( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 )
			SetObjectColor( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 128, 128, 128, 255 )
			XTSetBillboard3DYRotation( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, FALSE )
			XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
			YRand = Random( 0, XParticle[ ParticleID ].YSize - XParticle[ ParticleID ].Size )
			ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + XRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMin + YRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + ZRand
		Next XLoop
		XParticle[ ParticleID ].XMove = 0.0
		XParticle[ ParticleID ].YMove = 0.5
		XParticle[ ParticleID ].ZMove = 0.0
		XParticle[ ParticleID ].Duration = 0.0
	Else
		Message( "XTSetXParticleAsRain Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleAsSnow( ParticleName As String )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].mType = 4
		XTLoadXParticleImage( ParticleName, SNOWPARTICLES )
		XLoop As Integer
		XRand As Integer : ZRand As Integer : YRand As Integer
		For XLoop = 1 To XParticle[ ParticleID ].Count
			SetObjectTransparency( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 2 )
			SetObjectLightMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number ,0 )
			SetObjectFogMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectDepthWrite( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 )
			XTSetBillboard3DYRotation( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, TRUE )
			XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
			YRand = Random( 0, XParticle[ ParticleID ].YSize - XParticle[ ParticleID ].Size )
			ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + XRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMin + YRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + ZRand
		Next XLoop
		XParticle[ ParticleID ].XMove = 0.0
		XParticle[ ParticleID ].YMove = 0.0625
		XParticle[ ParticleID ].ZMove = 0.0
		XParticle[ ParticleID ].Duration = 0.0
	Else
		Message( "XTSetXParticleAsSnow Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTSetXParticleAsSparkle( ParticleName As String )
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		XParticle[ ParticleID ].mType = 5
		XTLoadXParticleImage( ParticleName, SPARKLEPARTICLES )
		XLoop As Integer
		XRand As Integer : ZRand As Integer : YRand As Integer
		For XLoop = 1 To XParticle[ ParticleID ].Count
			SetObjectTransparency( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 2 )
			SetObjectLightMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectFogMode( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 1 )
			SetObjectDepthWrite( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 )
			SetObjectColor( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 128, 128, 128, 128 )
			XTSetBillboard3DYRotation( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, TRUE )
			XRand = Random2( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
			YRand = Random2( 0, XParticle[ ParticleID ].YSize - XParticle[ ParticleID ].Size )
			ZRand = Random2( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + XRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMin + YRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + ZRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = Random( 0, 200.0 ) + 50.0
		Next XLoop
		XParticle[ ParticleID ].XMove = 0.0
		XParticle[ ParticleID ].YMove = 0.0
		XParticle[ ParticleID ].ZMove = 0.0
		XParticle[ ParticleID ].Duration = 250.0
	Else
		Message( "XTSetXParticleAsSparkle Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	EndIf
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleXPath( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].XMove 
	Else
		Message( "XTGetXParticleXPath Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleYPath( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].YMove 
	Else
		Message( "XTGetXParticleYPath Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleZPath( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].ZMove 
	Else
		Message( "XTGetXParticleZPath Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleXRange( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].XSize
	Else
		Message( "XTGetXParticleXRange Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleYRange( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].YSize
	Else
		Message( "XTGetXParticleYRange Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour
 
 /* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleZRange( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].ZSize
	Else
		Message( "XTGetXParticleZRange Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour
 
/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleXPosition( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].XEmitter
	Else
		Message( "XTGetXParticleXPosition Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleYPosition( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].YEmitter
	Else
		Message( "XTGetXParticleYPosition Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleZPosition( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].ZEmitter
	Else
		Message( "XTGetXParticleZPosition Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleCount( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].Count
	Else
		Message( "XTGetXParticleCount Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleType( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].mType
	Else
		Message( "XTGetXParticleType Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleSize( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].Size
	Else
		Message( "XTGetXParticleSize Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTGetXParticleDuration( ParticleName As String )
	Retour As Float = 0
	ParticleID As Integer : ParticleID = XTGetXParticleIDByName( ParticleName )
	If ParticleID > -1
		Retour = XParticle[ ParticleID ].Duration
	Else
		Message( "XTGetXParticleDuration Error : The request particle name '" + ParticleName + "' was not found in the existing particle list" )
	Endif
EndFunction Retour


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function XTUpdateXParticles()
	XTSystem.ActualTime = Timer()
	TimeChange AS FLOAT
	TimeChange = ( XTSystem.ActualTime - XTSystem.OldTime ) * 1000.0
	If TimeChange > 60 : TimeChange = 60 : EndIf
	XTSystem.TimeFactor = TimeChange / 2.0
	XTSystem.OldTime = XTSystem.ActualTime
	if XParticle.Length > -1
		ParticleID As Integer = 0
		For ParticleID = 0 To XParticle.length
			If XParticle[ ParticleID ].isVisible = 1
				Select XParticle[ ParticleID ].mType
					Case 0 : Internal_UpdateXParticleAsDefault( ParticleID ) : EndCase
					Case 1 : Internal_UpdateXParticleAsFlames( ParticleID ) : EndCase
					Case 2 : Internal_UpdateXParticleAsSmoke( ParticleID ) : EndCase
					Case 3 : Internal_UpdateXParticleAsRain( ParticleID ) : EndCase
					Case 4 : Internal_UpdateXParticleAsSnow( ParticleID ) : EndCase
					Case 5 : Internal_UpdateXParticleAsSparkles( ParticleID ) : EndCase
				EndSelect
			EndIf
		Next ParticleID
	Endif
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_UpdateXParticleAsDefault( ParticleID As Integer )
	XLoop As Integer
	For XLoop = 0 To XParticle[ ParticleID ].Count
		// We move the particle component to its next position.
		XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos + XParticle[ ParticleID ].XMove
		XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos + XParticle[ ParticleID ].YMove
		XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos + XParticle[ ParticleID ].ZMove
		// Checking for X limits
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos < XParticle[ ParticleID ].XMin
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].XMax
		EndIf
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos > XParticle[ ParticleID ].XMax
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].XMin
		EndIf
		// Checking for Y limits
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos < XParticle[ ParticleID ].YMin
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos = XParticle[ ParticleID ].YMax
		EndIf
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos > XParticle[ ParticleID ].YMax
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos = XParticle[ ParticleID ].YMin
		EndIf
		// Checking for Z limits
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos < XParticle[ ParticleID ].ZMin
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ZMax
		EndIf
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos > XParticle[ ParticleID ].ZMax
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ZMin
		EndIf
		// We finalize the object position changes.
		SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos )
	Next XLoop
EndFunction 


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_UpdateXParticleAsFlames( ParticleID As Integer )
	XLoop As Integer = 0: NextFlame As Integer = 0
	Mult As Float = 0.0
	Red As Float : Green As Float : Blue As Float
	XRand As Integer : ZRand As Integer
	For XLoop = 0 To XParticle[ ParticleID ].Count
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Number > 0
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration > 0
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration - ( 0.5 * XTSystem.TimeFactor )
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration < 0 : XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = 0 : EndIf
				Red = 255.0
				Green = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration * 1.28 
				Blue = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration * 0.64
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration < 200
					Mult = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration / XParticle[ ParticleID ].YSize
					If Mult < 0.0 : Mult = 0 : EndIf
					// DBSetEmissiveMaterial( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , DBRgb( Red * Mult , Green * Mult , Blue * Mult ) ) // Vérifier si ColorEmissive is ok
					SetObjectColor( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, Red * Mult, Green * Mult, Blue * Mult, 255 )
					// SetObjectColorEmissive( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, Red / 4, Green /4, Blue /4 ,  )
				Else
					Mult = Abs( 250 - XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration )
					If Mult < 0.0 : Mult = 0 : EndIf
					// DBSetEmissiveMaterial( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , DBRgb( 255 * Mult , 255 * Mult , 255 * Mult ) ) // Vérifier si ColorEmissive is ok
					SetObjectColor( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , 255 * Mult , 255 * Mult , 255 * Mult, 255 ) 
					// SetObjectColorEmissive( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , Mult , Mult , Mult ) 
				EndIf
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos + ( XParticle[ ParticleID ].XMove * XTSystem.TimeFactor )
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos + ( XParticle[ ParticleID ].ZMove * XTSystem.TimeFactor )
				XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos + ( XParticle[ ParticleID ].YMove * XTSystem.TimeFactor )
				SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos )
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration <= 0
					SetObjectvisible( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 )
					If NextFlame = 0 : NextFlame = XLoop : EndIf
				EndIf
			Else
				If NextFlame = 0 : NextFlame = XLoop : EndIf
			EndIf
		EndIf
	Next XLoop 
	If NextFlame > 0
		XParticle[ ParticleID ].ParticleObject[ NextFlame ].Duration = XParticle[ ParticleID ].Duration
		XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
		ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
		XParticle[ ParticleID ].ParticleObject[ NextFlame ].Xpos = XParticle[ ParticleID ].XMin + XRand + ( XParticle[ ParticleID ].Size / 2 )
		XParticle[ ParticleID ].ParticleObject[ NextFlame ].Ypos = XParticle[ ParticleID ].YMin - 8
		XParticle[ ParticleID ].ParticleObject[ NextFlame ].Zpos = XParticle[ ParticleID ].ZMin + ZRand + ( XParticle[ ParticleID ].Size / 2 )
		SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ NextFlame ].Number , XParticle[ ParticleID ].ParticleObject[ NextFlame ].Xpos , XParticle[ ParticleID ].ParticleObject[ NextFlame ].Ypos , XParticle[ ParticleID ].ParticleObject[ NextFlame ].Zpos )
		SetObjectVisible( XParticle[ ParticleID ].ParticleObject[ NextFlame ].Number, 1 )
		NextFlame = 0
	EndIf
 EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_UpdateXParticleAsSmoke( ParticleID As Integer )
	XLoop As Integer = 0: NextSmoke As Integer = 0
	Mult As Float = 0.0 : Value As Integer
	XRand As Integer : ZRand As Integer
	For XLoop = 0 To XParticle[ ParticleID ].Count
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Number > 0
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration > 0
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration - ( 0.05 * XTSystem.TimeFactor )
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration < 0 : XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = 0 : EndIf
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration < 200
					// DBFadeObject( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , Int( XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration ) )                  // ***********************
				Else
					Value = Abs( 200 - XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration ) : Value = ( 50 - Value ) * 2.0
					// DBFadeObject( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , Value )                                                                 // ***********************
				EndIf
				XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos + ( XParticle[ ParticleID ].YMove * XTSystem.TimeFactor )
				SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos )
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration <= 0 
					SetObjectVisible( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, 0 )
					If NextSmoke = 0 : NextSmoke = XLoop : EndIf
				EndIf
			Else
				If NextSmoke = 0 : NextSmoke = XLoop : EndIf
			EndIf
		EndIf
	Next XLoop						 
	If NextSmoke > 0
		XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Duration = XParticle[ ParticleID ].Duration
		XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
		ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
		XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Xpos = XParticle[ ParticleID ].XMin + XRand + ( XParticle[ ParticleID ].Size / 2 )
		XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Ypos = XParticle[ ParticleID ].YMin - 8
		XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Zpos = XParticle[ ParticleID ].ZMin + ZRand + ( XParticle[ ParticleID ].Size / 2 )
		SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Number , XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Xpos , XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Ypos , XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Zpos )
		SetObjectVisible( XParticle[ ParticleID ].ParticleObject[ NextSmoke ].Number, 1 )
		NextSmoke = 0
	EndIf
 EndFunction 


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_UpdateXParticleAsSnow( ParticleID As Integer )
	XLoop As Integer = 0
	XRand As Integer : ZRand As Integer
	For XLoop = 0 To XParticle[ ParticleID ].Count
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Number > 0
			XShift AS FLOAT : XShift = XTSystem.TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
			ZShift AS FLOAT : ZShift = XTSystem.TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos + XShift
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos + ZShift 
			XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos - ( XParticle[ ParticleID ].YMove * XTSystem.TimeFactor )
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos < XParticle[ ParticleID ].XMin
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].XMax - 4
			Else
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos > XParticle[ ParticleID ].XMax
					XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].Xmin + 4
				EndIf
			EndIf
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos < XParticle[ ParticleID ].YMin
				XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMax
				XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
				ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
				XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + Xrand
				XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + Zrand
			Else
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos > XParticle[ ParticleID ].YMax
					XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMax
					XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
					ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
					XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + Xrand
					XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + Zrand
				EndIf
			EndIf
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos < XParticle[ ParticleID ].ZMin
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ZMax - 4
			Else
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos > XParticle[ ParticleID ].ZMax
					XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].Zmin + 4
				EndIf
			EndIf
			SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos )
		EndIf
	Next XLoop
EndFunction 

/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_UpdateXParticleAsRain( ParticleID As Integer )
	XLoop As Integer = 0
	XRand As Integer : ZRand As Integer
	For XLoop = 0 To XParticle[ ParticleID ].Count
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Number > 0
//			XShift AS FLOAT = XTSystem.TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
//			ZShift AS FLOAT = XTSystem.TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
//			XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos + XShift
//			XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos + ZShift 
			XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos - ( XParticle[ ParticleID ].YMove * XTSystem.TimeFactor )
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos < XParticle[ ParticleID ].XMin
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].XMax - 4
			Else
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos > XParticle[ ParticleID ].XMax
					XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos = XParticle[ ParticleID ].Xmin + 4
				EndIf
			EndIf
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos < XParticle[ ParticleID ].YMin
				XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMax
				XRand = Random( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
				ZRand = Random( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
				XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + Xrand
				XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + Zrand
			EndIf
			If XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos < XParticle[ ParticleID ].ZMin
				XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].ZMax - 4
			Else
				If XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos > XParticle[ ParticleID ].ZMax
					XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos = XParticle[ ParticleID ].Zmin + 4
				EndIf
			EndIf
			SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos )
		EndIf
	Next XLoop
EndFunction 


/* ************************************************************************
 * @Description :
 *
 * @Param :
 * @Param :
 * @Param :
 *
 * @Return :
 *
 * @Author :
*/
Function Internal_UpdateXParticleAsSparkles( ParticleID As Integer )
	XLoop As Integer = 0 : ParticlePhase As Float : Percent As Float
	XRand As Integer : ZRand As Integer : YRand As Integer
	For XLoop = 0 To XParticle[ ParticleID ].Count
		XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration - XTSystem.TimeFactor
		If XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration < 0
			// On recrée la particule dans l'espace prévu pour.
			XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration = XParticle[ ParticleID ].Duration
			XRand = Random2( 0, XParticle[ ParticleID ].XSize - XParticle[ ParticleID ].Size )
			YRand = Random2( 0, XParticle[ ParticleID ].YSize - XParticle[ ParticleID ].Size )
			ZRand = Random2( 0, XParticle[ ParticleID ].ZSize - XParticle[ ParticleID ].Size )
			XParticle[ ParticleID ].ParticleObject[ XLoop ].XPos = XParticle[ ParticleID ].XMin + XRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].YPos = XParticle[ ParticleID ].YMin + YRand
			XParticle[ ParticleID ].ParticleObject[ XLoop ].ZPos = XParticle[ ParticleID ].ZMin + ZRand		 
		Else
			// On met à jour les Sparkles ...
			ParticlePhase = ( XParticle[ ParticleID ].ParticleObject[ XLoop ].Duration / XParticle[ ParticleID ].Duration ) * 100.0
			If ParticlePhase < 75.0
				// Phase 2 - Descendante
				Percent = ( ParticlePhase * 4.0 ) / 3.0
			Else
				// Phase 1 - Ascendante
				Percent = ( 25.0 - Abs( 75 - ParticlePhase ) ) * 4.0
			EndIf
			SetObjectColor( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number, Percent * 3.0, Percent * 3.0, Percent * 3.0, Percent * 3.0 )
			SetObjectPosition( XParticle[ ParticleID ].ParticleObject[ XLoop ].Number , XParticle[ ParticleID ].ParticleObject[ XLoop ].Xpos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Ypos , XParticle[ ParticleID ].ParticleObject[ XLoop ].Zpos )
		EndIf
	Next XLoop
EndFunction
