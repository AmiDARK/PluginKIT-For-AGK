

Function PKForceVirtualLightRefresh()
	PKSetup.VLRefreshForce = TRUE
EndFunction

//
//**************************************************************************************************************
//
Function PKAddVirtual2DLight( Name As String, XPos As Integer, YPos As Integer, RGBAColor As Integer, Rayon As Float, Intensite As Integer, LayerID As Integer, CastNMAP As Integer, CastSHADOWS As Integer, CastBRIGHT As Integer )
	// 1. We create the object to receive the LightsData
	newVirtualLight As P2DLights_Type
	// 1. Check important values
	If Rayon < 8 : Rayon = 8 : EndIf
	ImageWIDTH As Integer : ImageWIDTH = Rayon * 2
	Red As Integer : Red = dbRGBAr( RGBAColor )
	Green As Integer : Green = dbRGBAg( RGBAColor )
	Blue As Integer : Blue = dbRGBAb( RGBAColor )

	// 2. We setup the new Virtual Light datas
	newVirtualLight.Name = Name
	newVirtualLight.XPos = XPos
	newVirtualLight.YPos = YPos
	newVirtualLight.Rouge = Red
	newVirtualLight.Vert = Green
	newVirtualLight.Bleu = Blue
	newVirtualLight.Range = Rayon
	newVirtualLight.Intensite = Intensite
//	newVirtualLight.Active = 1
	newVirtualLight.Mode = CastNMAP + ( CastSHADOWS * 2 ) + ( CastBRIGHT * 4 )
	newVirtualLight.PlayMODE = 0
	newVirtualLight.ImgWIDTH = ImageWIDTH
	newVirtualLight.LayerID = 0
	newVirtualLight.CastNMAP = CastNMAP
	newVirtualLight.CastSHADOWS = CastSHADOWS
	newVirtualLight.CastBRIGHT = CastBRIGHT
	newVirtualLight.LayerID = -1 // Default value before setting it.
	// Message( "Default Create = " + Hex( Red ) + ", " + Hex( Green ) + ", " + Hex( Blue ) + " RGBColor = " + Hex( RGBAColor ) )
	// 3. We add the virtual light to the system [List]
	P2DLights.insert( newVirtualLight )
	// 4. We attach it to the chosen Layer
	PKAttachVirtual2DLightToLayer( P2DLights.length, LayerID )
	// 5. We update the light effect.
	PKUpdateVirtual2DLight( P2DLights.length )
EndFunction P2DLights.length

//
//**************************************************************************************************************
//
Function PKDeleteVirtual2DLight( LightID As Integer )
	// 1. Check if the requiested Virtual 2D Light exists (or not)
	If PKgetVirtual2DLightExists( LightID ) = 1
		// 2. Detach the Virtual Light from its layer
		if P2DLights[ LightID ].LayerID > -1
			PKADetachVirtual2DLightFromLayer( LightID ) // On détache la lumière d'un éventuel layer au cas ou ...
		Endif
		// 3. If an Image (Halo) was loaded we delete it
		If P2DLights[ LightID ].ImageLOADED > 0
			DeleteImage( P2DLights[ LightID ].ImageLOADED )
		EndIf
		// 4. And finally, we remove the Virtual Light from the List
		P2DLights.remove( LightID )
	EndIf
 EndFunction

//
//**************************************************************************************************************
//
Function PKgetVirtual2DLightExists( LightID As Integer )
	isExists As Integer = 0
	if LightID > -1 and LightID < P2DLights.length + 1
		isExists = 1
	Endif
EndFunction isExists

//
//**************************************************************************************************************
//
Function PKAttachVirtual2DLightToLayer( LightID As Integer, LayerID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		If PKGetLayerExists( LayerID ) = TRUE
			// If the light was previously attached to a Layer, we remove it from the existing layer
			if P2DLights[ LightID ].LayerID > -1
				inPos As Integer = -1  								// create var for ID
				inPos = PKLayer[ P2DLights[ LightID ].LayerID ].PKLights.find( LightID )  // Try to find the vLight in the PKLayer vLights list
				if inPos > -1 then PKLayer[ P2DLights[ LightID ].LayerID ].PKLights.remove( inPos ) // if Found -> Remove it from the list.
			Endif
			// Then we add it to the new chosen layer.
			PKLayer[ LayerID ].PKLights.insert( LightID ) // Insert the virtual Light in the Layer vLights datas
			P2DLights[ LightID ].LayerID = LayerID
		Else
			Message( "PKAttachVirtual2DLightToLayer Error : Requested Layer does not exists" )
		Endif
	Else
		Message( "PKAttachVirtual2DLightToLayer Error : Requested Light does not exists" )
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKADetachVirtual2DLightFromLayer( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		LayerID As Integer : LayerID = P2DLights[ LightID ].LayerID
		if PKGetLayerExists( LayerID ) = 1
			inPos As Integer = -1  								// create var for ID
			inPos = PKLayer[ LayerID ].PKLights.find( LightID )  // Try to find the vLight in the PKLayer vLights list
			if inPos > -1 then PKLayer[ LayerID ].PKLights.remove( inPos ) // if Found -> Remove it from the list.
		Endif
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightAsStaticLight( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].PlayMODE = 0
	EndIf
EndFunction
 
//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightAsFlameLight( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].PlayMODE = 1
	EndIf
EndFunction
 
//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightAsPulseLight( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].PlayMODE = 2
	EndIf
EndFunction
 
//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightAsFlashLight( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].PlayMODE = 3
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightPosition( LightID As Integer, XPos As Integer, YPos As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].XPos = XPos
		P2DLights[ LightID ].YPos = YPos
		If P2DLights[ LightID ].CastSHADOWS = 1 Or P2DLights[ LightID ].CastNMAP = 1
			PKUpdateVirtual2DLight( LightID )
		EndIf
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightColor( LightID As Integer, Red As Integer, Green As Integer, Blue As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].Rouge = Red
		P2DLights[ LightID ].Vert = Green
		P2DLights[ LightID ].Bleu = Blue
		If P2DLights[ LightID ].CastSHADOWS = 1 Or P2DLights[ LightID ].CastNMAP = 1
			PKUpdateVirtual2DLight( LightID )
		EndIf
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightRange( LightID As Integer, Rayon As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].Range = Rayon
		PKUpdateVirtual2DLight( LightID )
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetVirtual2DLightIntensity( LightID As Integer, Intensite As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].Intensite = Intensite
		PKUpdateVirtual2DLight( LightID )
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKHideVirtual2DLight( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].Hide = 1
	EndIf
EndFunction
 
//
//**************************************************************************************************************
//
Function PKShowVirtual2DLight( LightID As Integer )
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		P2DLights[ LightID ].Hide = 0
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKGetVirtual2DLightLayer( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour = P2DLights[ LightID ].LayerID
	Else
		Retour = 0
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKIsVirtual2DLightHidden( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour = P2DLights[ LightID ].Hide
	Else
		Retour = 0
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetVirtual2DLightRGBR( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour = P2DLights[ LightID ].Rouge
	Else
		Retour = 0
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetVirtual2DLightRGBG( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour = P2DLights[ LightID ].Vert
	Else
		Retour = 0
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetVirtual2DLightRGBB( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour= P2DLights[ LightID ].Bleu
	Else
		Retour = 0
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetVLightPositionX( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour = P2DLights[ LightID ].XPos
	Else
		Retour = 0
	EndIf
EndFunction Retour
//
//**************************************************************************************************************
//
Function PKGetVLightPositionY( LightID As Integer )
	Retour As Integer = -1
	If PKgetVirtual2DLightExists( LightID ) = TRUE
		Retour = P2DLights[ LightID ].YPos
	Else
		Retour = 0
	EndIf
EndFunction Retour

//
//**************************************************************************************************************
//
Function PKUpdateVirtual2DLight( LightID As Integer )

	FinalImage As Integer
	LightMapFileName As String
	LightMapFileName = "raw:" + GetReadPath() + "media/pklightmaps/" + PKLayer[ P2DLights[ LightID ].LayerID ].Name + "_" + P2DLights[ LightID ].Name + "_lightMapping.dat"
	UseImageFile As Integer : UseImageFile = FALSE
	
	fileID As Integer
	if GetFileExists( LightMapFileName ) = TRUE
		fileID = OpenToRead( LightMapFileName )
			newLight As P2DLights_Type
			newLight = loadLightFromFile( fileID )
			UseImageFile = CompareLights( P2DLights[ LightID ], newLight )
		CloseFile( fileID ) : FileID = -1
	Endif

	if UseImageFile = TRUE
		FinalImage = LoadImage( "pklightmaps/" + PKLayer[ P2DLights[ LightID ].LayerID ].Name + "_" + P2DLights[ LightID ].Name + "_lightMapping.png" )
	Else
		// 1. Create variables
		LightXPos As Integer = 0 : LightYPos As Integer = 0
		LightRange As Float = 0 : LightWIDTH As Integer = 0 : LightXYShift As Integer = 0
		LightLayerID As Integer = 0
		ShadowMAPMBC As Integer = 0 : LightMAPMBC As Integer = 0 : LightColorMAPMBC As Integer = 0
		IMGMBC As Integer = 0
		XLoop As Integer = 0 : YLoop As Integer = 0 : ZLoop As Integer = 0
		PixelX As Integer = 0 : PixelY As Integer = 0
		TileX As Integer = 0 : TileY As Integer = 0
		TileXPixel As Integer = 0 : TileYPixel As Integer = 0
		Pixel As Integer = 0
		// 5. Render
		Percent As Float = 0.0 : Dist As Float = 0.0 : NexPCT As Float = 0.0 
		XDist As Float = 0.0 : YDist As Float = 0.0
		// XPCT As Float = 0.0 : YPCT As Float = 0.0
		NewRED As Integer = 0 : NewGREEN As Integer = 0 : NewBLUE As Integer = 0
		cRed As Integer : cRed = P2DLights[ LightID ].Rouge
		cGreen As Integer : cGreen = P2DLights[ LightID ].Vert
		cBlue As Integer : cBlue = P2DLights[ LightID ].Bleu
		// Message( "Default = " + Hex( cRed ) + ", " + Hex( cGreen ) + ", " + Hex( cBlue ) )
		Intensite As Integer : Intensite = P2DLights[ LightID ].Intensite
		SHADOW As Integer = 0 : MaskPIX As Integer = 0
		XAdd As Float = 0.0 : YAdd As Float = 0.0
		XPosS As Float = 0.0 : YPosS As Float = 0.0
		// 5.2 Normal mapping
		CPixel As Integer = 0 : NMapPIXEL As Integer = 0
		XPosN As Float = 0.0 : YPosN As Float = 0.0 : ZPosN As Float = 0.0
		U0 As Integer = 0
		AlfaL As Float = 0.0 : AlfaN As Float = 0.0 
		DiffANGLE As Float = 0.0 : Multiplier As Float = 0.0
		sourcePixel As Integer = 0
		TileID As Integer = 0
		TileSHIFT As Integer = 0

		// 2. Get information concerning Virtual Light && its parent layer
		LightXPos = P2DLights[ LightID ].XPos
		LightYPos = P2DLights[ LightID ].YPos
		LightRange = P2DLights[ LightID ].Range
		LightWIDTH = LightRange * 2                 // Dimension de l'image  de la lumière virtuelle
		LightXYShift = LightWIDTH / 2
		LightLayerID = P2DLights[ LightID ].LayerID

		// 3.1. We create the memblock that will receive the final Image data
		IMGMBC = XTCreateImageMemblock( LightWIDTH, LightWIDTH, 32 )
		// // 3.2. If Shadow Casting is asked, then we have to create its memblock
		if P2DLights[ LightID ].CastSHADOWS = TRUE then ShadowMAPMBC = XTCreateImageMemblock( LightWIDTH, LightWIDTH, 8 )
		// 3.3. If normal mapping is asked, then we have to create its memblock
		if P2DLights[ LightID ].CastNMAP = TRUE then LightMAPMBC = XTCreateImageMemblock( LightWIDTH, LightWIDTH, 32 )

		// Image de la tile en cours d'utilisation pour en récupérer les couleurs.
		TrueColorIMG As Integer = -1
		TrueColorIMGid As Integer = -1

		LightColorMAPMBC = XTCreateImageMemblock( LightWIDTH, LightWIDTH, 32 )
	
		// 4 Mise en place des données de "Shadow Casting" et de "Normal Mapping"
		If ( P2DLights[ LightID ].CastSHADOWS || P2DLights[ LightID ].CastNMAP ) = TRUE
			for YLoop = 0 to LightWIDTH -1
				PixelY = ( LightYPos + YLoop ) - LightXYShift              // Coordonnée sur Y des pixels du LayerID
				TileY = PixelY / PKLayer[ LightLayerID ].TileHEIGHT
				TileYPixel = PixelY - ( TileY * PKLayer[ LightLayerID ].TileHEIGHT )
				For XLoop = 0 to LightWIDTH -1
					PixelX = ( LightXPos + XLoop ) - LightXYShift         // Coordonnée sur X des pixels du LayerID
					TileX = PixelX / PKLayer[ LightLayerID ].TileWIDTH
					TileXPixel = PixelX - ( TileX * PKLayer[ LightLayerID ].TileWIDTH )

					// Récupération de l'ID De la tile à checker...
					TileID = PKGetLayerTileID( LightLayerID, TileX, TileY )   // On récupère le numéro de tile présent sous le pixel.
					If TileID > -1 // and TileX > -1 and TileY > -1 // and TileX < ( PKLayer[ LightLayerID ].Width * PKLayer[ LightLayerID ].TileWidth ) and TileY < ( PKLayer[ LightLayerID ].Height * PKLayer[ LightLayerID ].TileHeight )

						// 4.1.0 On récupère le color mapping
						if ( TrueColorIMGid <> TileID )
							if GetMemblockExists( TrueColorIMG ) = TRUE then DeleteMemblock( TrueColorIMG )
							TrueColorIMG = CreateMemblockFromImage( PKTile[ TileID ].ImageID )
							TrueColorIMGid = TileID
						Endif
					
						if TileXPixel > -1 and TileXPixel < PKTile[ TileID ].Width and TileYPixel > -1 and TileYPixel < PKTile[ TileID ].Height
							Pixel = XTReadMemblockPixel( TrueColorIMG, TileXPixel, TileYPixel )
						Else
							Pixel = dbRGBAex( 0,0,0,255 )
						Endif
						XTWriteMemblockPixel( LightColorMAPMBC, XLoop, YLoop, Pixel )

						// 4.1.1 SI le "Shadow Casting" est demandé on récupère les pixels
						if P2DLights[ LightID ].CastSHADOWS = TRUE
							// Pixel = PKGetLayerMaskPixel( LightLayerID, PixelX, PixelY )
							Pixel = PKGetTileMaskPixel( TileID, TileXPixel, TileYPixel )
							// if Pixel = 0 then Pixel = 0xFF000000
							XTWriteMemblockPixel( ShadowMAPMBC, XLoop, YLoop, Pixel )
							// Message( "Pixel At " + Str( PixelX ) + "," + Str( PixelY ) + " = " + Str( Pixel ) )
	//					Else
	//						Pixel = 0
	//						XTWriteMemblockPixel( ShadowMAPMBC, XLoop, YLoop, Pixel )
						Endif

						// 4.1.2 Si le "Normal Mapping" est demandé on récupère les pixels
						If P2DLights[ LightID ].CastNMAP = TRUE
							// Pixel = PKGetLayerNMapPixel( LightLayerID, PixelX, PixelY )
							Pixel = PKGetTileNMapPixel( TileID, TileXPixel, TileYPixel )
							XTWriteMemblockPixel( LightMAPMBC, XLoop, YLoop, Pixel )					
	//					Else
	//						Pixel = dbRGBAex( 127, 127, 255, 255 )
						Endif

					// Si la TileID = 0, pas de tile, rendu vide
					Else
						// Si la Tile = 0 Le color mapping est noir
						XTWriteMemblockPixel( LightColorMAPMBC, XLoop, YLoop, dbRGBAex( 0, 0, 0, 0 ) ) 
						// 
						if P2DLights[ LightID ].CastSHADOWS = TRUE
							XTWriteMemblockPixel( ShadowMAPMBC, XLoop, YLoop, 0 )
						Endif
						// Normal mapping en couleur par défaut si tileID = 0
						If P2DLights[ LightID ].CastNMAP = TRUE
							XTWriteMemblockPixel( LightMAPMBC, XLoop, YLoop, dbRGBAex( 127, 127, 255, 255 ) )
						Endif
					Endif 
				Next XLoop
			Next YLoop
		Endif
	//	dbClearAllImagesData() // 2019.12.15 Enhancement with dbGetImageData(...) To clear all images data used for MaskImageID & NMapImageID
		if getMemblockExists( TrueColorIMG ) = TRUE Then DeleteMemblock( TrueColorIMG )
		TrueColorIMGid = -1

		// 5. Tracé de la lumière dans le bloc mémoire
		Percent = 100.0 / LightRange
		NewPCT As Float = 0.0
		Alfa As Integer = 0
		SHADOW = FALSE
		For YLoop = 0 to LightWIDTH - 1
			For XLoop = 0 to LightWIDTH  - 1
				CPixel = XTReadMemblockPixel( LightColorMAPMBC, XLoop, YLoop )
				Dist = GetDotsDistance2D( XLoop, YLoop, LightRange, LightRange )
				NewPCT = ( 100.0 - ( Dist * Percent ) ) / 100.0
				XDist = LightRange - XLoop
				YDist = LightRange - YLoop
				if NewPCT > 0
					NewRED = dbRGBAr( CPixel ) + ( cRed * NewPCT )
					NewGREEN = dbRGBAg( CPixel ) + ( cGreen * NewPCT )
					NewBLUE = dbRGBAb( CPixel ) + ( cBlue * NewPCT )
					if P2DLights[ LightID ].CastBRIGHT = TRUE
						Alfa = NewPCT * Intensite * 2.55
					Else
						Alfa = ( dbRGBAa( CPixel ) * NewPCT * Intensite ) / 64
					Endif
					// 
					If P2DLights[ LightID ].CastSHADOWS = TRUE
						SHADOW = FALSE
						If abs( XDist ) > Abs( YDist )
							// Tracé par X plus long que Y
							YAdd = YDist / Abs( XDist )
							For ZLoop = 1 to Abs( XDist ) - 1
								XPosS = LightRANGE - ( ZLoop * Sign( XDist ) ) : YPosS = LightRANGE - ( ZLoop * YAdd )
								MaskPIX = XTReadMemblockPixel( ShadowMAPMBC, XPosS, YPosS )
								if MaskPIX > 0
									SHADOW = TRUE
									XTWriteMemblockPixel( ShadowMAPMBC, XPosS, YPosS, 255 )
								Endif
							Next ZLoop
						Else
							XAdd = XDist / Abs( YDist )
							For ZLoop = 1 to Abs( YDist ) - 1
								YPosS = LightRANGE - ( ZLoop * Sign( YDist ) ) : XPosS = LightRANGE - ( ZLoop * XAdd )
								MaskPIX = XTReadMemblockPixel( ShadowMAPMBC, XPosS, YPosS )
								If MaskPIX > 0
									SHADOW = TRUE
									XTWriteMemblockPixel( ShadowMAPMBC, XPosS, YPosS, 255 )
								Endif
							Next ZLoop
						Endif
						/* 2020.04.22 HOT Fix to remove small artefacts in shadows places of a virtual Light */
						If SHADOW = TRUE
							NewRED = 0
							NewGREEN = 0
							NewBLUE = 0
							Alfa = 0
						Endif
					Endif

					// 5.2 On ajoute les valeurs RGB en utilisant le Normal Mapping si disponible
					If P2DLights[ LightID ].CastNMAP = TRUE
						if SHADOW = FALSE
							CPixel = XTReadMemblockPixel( LightColorMAPMBC, XLoop, YLoop )
							NMapPIXEL = XTReadMemblockPixel( LightMAPMBC, XLoop, YLoop )
							ZPosN = ( dbRGBAb( NMapPIXEL ) / 255.0 )
							XPosN = ( 1.0 - ( dbRGBAr( NMapPIXEL ) / 127.5 ) ) * ZPosN
							YPosN = ( 1.0 - ( dbRGBAg( NMapPIXEL ) / 127.5 ) ) * ZPosN
							If CPixel <> 0 And NMapPixel <> 0 And ( NMapPixel && 0xFFFFFF00 ) <> 0x7F7FFF00
								// On calcule l'angle du point projeté de la lumière
								If ( 0-XLoop ) < 0 Then U0 = 0 Else U0 = 1
								AlfaL = Rad2Deg( 2 * Deg2Rad( ATan( YLoop / XLoop ) ) + ( 3.1415 * U0 * ( YLoop / Abs( YLoop ) ) ) )
								// On calcule l'angle du point de la texture de normal mapping avec le rouge et le vert.
								If ( 0-XPosN ) < 0 Then U0 = 0 Else U0 = 1
								AlfaN = Rad2Deg( 2 * Deg2Rad( ATan( YPosN / XPosN ) ) + ( 3.1415 * U0 * ( YPosN / Abs( YPosN ) ) ) )
								// On calcule la différence d'angle en conservant le signe pour l'oriengation
								DiffANGLE = AlfaL - AlfaN
								If DiffANGLE < -180.0 : DiffANGLE = DiffANGLE + 360.0 : EndIf
								if DiffANGLE > 180.0 : DiffANGLE = DiffANGLE - 360.0 : EndIf
								MultiPlier = 2.0 - Abs( DiffANGLE / 90.0 )
	//							NewRED = NewRED + ( dbRGBAr( CPixel ) * Multiplier )
	//							NewGREEN = NewGREEN + ( dbRGBAg( CPixel ) * Multiplier )
	//							NewBLUE = NewBLUE + ( dbRGBAb( CPixel ) * Multiplier )
								NewRED = NewRED  * Multiplier
								NewGREEN = NewGREEN * Multiplier
								NewBLUE = NewBLUE * Multiplier
							Endif
						else
							NewRED = NewRED + dbRGBAr( CPixel )
							NewGREEN = NewGREEN + dbRGBAg( CPixel )
							NewBLUE = NewBLUE + dbRGBAb( CPixel )
							// Alfa = 0
						Endif
					Endif

					If NewRED > 255 Then NewRED = 255
					If NewGREEN > 255 Then NewGREEN = 255
					If NewBLUE > 255 Then NewBLUE = 255
					If NewRED < 0 Then NewRED = 0
					If NewGREEN < 0 Then NewGREEN = 0
					If NewBLUE < 0 Then NewBLUE = 0
					If NewRED || NewGREEN || NewBLUE = 0 Then Alfa = 0
					If Alfa > 255  Then Alfa = 255
					If Alfa < 0  Then Alfa = 0
				
					final As Integer : final = dbRGBAex( NewRED, NewGREEN, NewBLUE, Alfa )
					// Message( "Hex Final = " + Hex( final ) )
					XTWriteMemblockPixel( IMGMBC, XLoop, YLoop, final )

				Endif

			Next XLoop
		Next YLoop
	
		// 9.1.1 Sauvegarde de l'image du Shadow Casting
	/*	if GetMemblockExists( ShadowMAPMBC ) = TRUE 
			ShadowMapImage As Integer : ShadowMapImage = XTCreateImageFromMemblock( ShadowMAPMBC )
			SaveImage( ShadowMapImage, P2DLights[ LightID ].Name + "_shadowmapcasting.png" )
		Endif */

		// 9.1.2 Sauvegarde de l'image du Normal Mapping
	/*	if getMemblockExists( LightMAPMBC) = TRUE
			NormalMapImage As Integer : NormalMapImage = CreateImageFromMemblock( LightMAPMBC )
			SaveImage( NormalMapImage, P2DLights[ LightID ].Name + "_normalmapping.png" )
		Endif */
	
		// 9.1.3 Sauvegarde de l'image de Color Mapping
	/*	if GetMemblockExists( LightColorMAPMBC ) = TRUE
			ColorMapImage As Integer : ColorMapImage = CreateImageFromMemblock( LightColorMAPMBC )
			SaveImage( ColorMapImage, P2DLights[ LightID ].Name + "_colormapping.png" )
		Endif */
	
		// 9.1.4 Final color Image
		if GetMemblockExists( IMGMBC ) = TRUE
			FinalImage = CreateImageFromMemblock( IMGMBC )
			SaveImage( FinalImage, "raw:" + PKSetup.OutputPATH + "media/pklightmaps/" + PKLayer[ P2DLights[ LightID ].LayerID ].Name + "_" + P2DLights[ LightID ].Name + "_lightMapping.png" )
		Endif

		// Save the image informations data there.
		fileID = OpenToWrite( "raw:" + PKSetup.OutputPATH + "media/pklightmaps/" + PKLayer[ P2DLights[ LightID ].LayerID ].Name + "_" + P2DLights[ LightID ].Name + "_lightMapping.dat" )
			saveLightToFile( fileID, LightID )
		CloseFile( fileID ) : FileID = -1

	Endif
		
    // 6. Si on utilise le plugin M2E D3D.DLL, on update pour créer le sprite.
    if P2DLights[ LightID ].DBSprite = 0
		P2DLights[ LightID ].DBSprite = CreateSprite( FinalImage )
	Else
		SetSpriteImage( P2DLights[ LightID ].DBSprite, FinalImage )
	Endif
	SetSpriteVisible( P2DLights[ LightID ].DBSprite, FALSE )
    // SetSpriteVisible( P2DLights[ LightID ].DBSprite, FALSE )
EndFunction

/* ************************************************************************
 * @Description : 
*/
function PKDisplayLayerLights( LayerID As Integer, XS As Integer, YS As Integer, XE As Integer, YE As Integer, xDisp As Integer, yDisp As Integer )
	if PKLayer[ LayerID ].PKLights.length > -1
		//  Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
		DisplayWIDTH As Integer : DisplayWIDTH = XE - XS 
		DisplayHEIGHT As Integer : DisplayHEIGHT = YE - YS
		//  Calcul des 4 extrémités pour l'affichage des lumières.
		DispLEFT As Integer : DispLEFT = PKLayer[ LayerID ].XDisplay
		DispTOP As Integer : DispTOP = PKLayer[ LayerID ].YDisplay
		DispRIGHT As Integer : DispRIGHT = PKLayer[ LayerID ].XDisplay + DisplayWIDTH
		DispBOTTOM As Integer : DispBOTTOM = PKLayer[ LayerID ].YDisplay + DisplayHEIGHT
		//  Maintenant, on lit les lumières présentes dans le layer et on les affiche si cela est nécessaire.
		lLoop As Integer

		for lLoop = 0 to PKLayer[ LayerID ].PKLights.length Step 1
			DisplayLIGHT As Integer : DisplayLIGHT = PKLayer[ LayerID ].PKLights[ lLoop ]
			//  On n'affiche la lumière que si elle est à la fois active et non cachée.
			if PKgetVirtual2DLightExists( DisplayLIGHT ) = TRUE
				If P2DLights[ DisplayLIGHT ].Hide = FALSE
					LightRAY As Integer : LightRAY = P2DLights[ DisplayLIGHT ].ImgWIDTH / 2.0
					XPos As Integer = 0 : YPos As Integer = 0
					LXPos As Integer : LXPos = P2DLights[ DisplayLIGHT ].XPos
					LYPos As Integer : LYPos = P2DLights[ DisplayLIGHT ].YPos

					If LXpos + LightRAY > DispLEFT And LXpos - LightRAY < DispRIGHT
						If LYPos + LightRAY > DispTOP And LYPos - LightRAY < DispBOTTOM
							XPos = ( LXPos - PKLayer[ LayerID ].XDisplay ) // + XS
							YPos = ( LYPos - PKLayer[ LayerID ].YDisplay ) // + YS
							
							SprColor As Integer : SprColor = 128 // P2DLights[ DisplayLIGHT ].Intensite * 50
							// SetSpriteColor( P2DLights[ DisplayLIGHT ].DBSprite, 128, P2DLights[ DisplayLight ].Rouge, P2DLights[ DisplayLight ].Vert, P2DLights[ DisplayLight ].Bleu )
							SetSpriteColorAlpha( P2DLights[ DisplayLIGHT ].DBSprite, P2DLights[ DisplayLIGHT ].Intensite * 2.55 )
							SetSpriteVisible( P2DLights[ DisplayLight ].DBSprite, TRUE )
							SetSpriteTransparency( P2DLights[ DisplayLight ].DBSprite,1 )
							SetSpritePosition( P2DLights[ DisplayLIGHT ].DBSprite, XPos-LightRAY, YPos-LightRAY )
							DrawSprite( P2DLights[ DisplayLIGHT ].DBSprite )
							SetSpriteVisible( P2DLights[ DisplayLight ].DBSprite, FALSE )
							// dbPrint( "Update v2DLight #" + Str( lLoop ) + " At : " + Str( XPos ) + ", " + Str( YPos ) )
							P2DLights[ DisplayLIGHT ].XDisplayPOS = XPos
							P2DLights[ DisplayLIGHT ].YDisplayPOS = YPos

						EndIf
					EndIf
				EndIf
			EndIf
		Next lLoop
	Endif
 Endfunction

function internalPKUpdateLightsEffects()
	OldTIMER As Integer : OldTimer = PKSetup.PreviousTimer 
	Delay As Float : Delay = ( PKSetup.NewTimer / 30.0 )
	Count As Integer = 0
	inCyclePos As Integer
	If Delay > 100.0
		Count = Trunc( Delay / 100.0 )
		InCyclePos = Delay - ( Count * 100 )
		Delay = Delay - ( Count * 100 )
	EndIf
	XLoop As Integer
	For XLoop = 0 To P2DLights.length Step 1
		//  0 = Statique, 1 = Torche, 2 = Pulse, 3 = Défectueuse
		Intensity As Float
		Select P2DLights[ XLoop ].PlayMODE
			// Flame
			Case 1:
				inCyclePos = inCyclePos * 2
				if inCyclePos > 100 Then inCyclePos = inCyclePos - 100
				Intensity = ( inCyclePos / 2 ) + 75
				If Intensity > 100 : Intensity = 200 - Intensity : EndIf
				P2DLights[ XLoop ].Intensite = Intensity
			EndCase
			// Pulse
			Case 2:
				Intensity = Delay * 2
				If Intensity > 100 : Intensity = 200 - Intensity : EndIf
				P2DLights[ XLoop ].Intensite = Intensity        
			EndCase
			// Flash
			Case 3:
				Intensity = Random( 0, 100 )
				P2DLights[ XLoop ].Intensite = Intensity
				P2DLights[ XLoop ].CyclePOS = Random( 0, 4 )
			EndCase
		EndSelect
	Next XLoop
Endfunction


Function loadLightFromFile( ChannelID As Integer )
	HEADER As String
	newLight As P2DLights_Type
	HEADER = ReadString( ChannelID )
	if ( HEADER = "P2DLight" )
		newLight.Name = ReadString( ChannelID )
		newLight.PlayMODE = ReadInteger( ChannelID )
		newLight.XPos = ReadInteger( ChannelID )
		newLight.YPos = ReadInteger( ChannelID )
		newLight.Rouge = ReadInteger( ChannelID )
		newLight.Vert = ReadInteger( ChannelID )
		newLight.Bleu = ReadInteger( ChannelID )
		newLight.Intensite = ReadInteger( ChannelID )
		newLight.Range = ReadInteger( ChannelID )
		newLight.Mode = ReadInteger( ChannelID )
		newLight.CastSHADOWS = ReadInteger( ChannelID )
		newLight.CastNMAP = ReadInteger( ChannelID )
		newLight.CastBRIGHT = ReadInteger( ChannelID )
		HEADER = ReadString( ChannelID ) // Read the 'P2DLight_End' footer
	Endif
EndFunction newLight
	

Function saveLightToFile( ChannelID As Integer, currentLight As Integer )
	WriteString( ChannelID, "P2DLight" )
	WriteString( ChannelID, P2DLights[ currentLight].Name )
	WriteInteger( ChannelID, P2DLights[ currentLight].PlayMODE )
	WriteInteger( ChannelID, P2DLights[ currentLight].XPos )
	WriteInteger( ChannelID, P2DLights[ currentLight].YPos )
	WriteInteger( ChannelID, P2DLights[ currentLight].Rouge )
	WriteInteger( ChannelID, P2DLights[ currentLight].Vert )
	WriteInteger( ChannelID, P2DLights[ currentLight].Bleu )
	WriteInteger( ChannelID, P2DLights[ currentLight].Intensite )
	WriteInteger( ChannelID, P2DLights[ currentLight].Range )
	WriteInteger( ChannelID, P2DLights[ currentLight].Mode )
	WriteInteger( ChannelID, P2DLights[ currentLight].CastSHADOWS )
	WriteInteger( ChannelID, P2DLights[ currentLight].CastNMAP )
	WriteInteger( ChannelID, P2DLights[ currentLight].CastBRIGHT )
	WriteString( ChannelID, "P2DLight_End" )
EndFunction

Function CompareLights( Light1 As P2DLights_Type, Light2 As P2DLights_Type )
	Result As Integer
	Result = FALSE
	if Light1.Name = Light2.Name and Light1.PlayMODE = Light2.PlayMODE
		If Light1.XPos = Light2.Xpos and Light1.YPos = Light2.YPos
			If Light1.Rouge = Light2.Rouge and Light1.Vert = Light2.Vert
				If Light1.Bleu = Light2.Bleu and Light1.Intensite = Light2.Intensite
					If Light1.Range = Light2.Range and Light1.CastSHADOWS = Light2.CastSHADOWS
						if Light1.CastNMAP = Light2.CastNMAP and Light1.CastBRIGHT = Light2.CastBRIGHT
							Result = TRUE
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif

EndFunction result
