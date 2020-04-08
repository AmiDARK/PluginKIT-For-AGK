//
// *****************************************************
// *                                                   *
// * eXtends Ver 2.0 Include File : 2D Prticles System *
// *                                                   *
// *****************************************************
// Start Date : 2020.03.26 23.51
// Description : A total rewriting of the 2DPluginKIT
//               2D Particles System
// Author : Frédéric Cordier
//

// ParticleID = PKAddParticles( ParticleCount, ParticleImage, ParticleSize )
// ParticleID = PKAddParticlesEx( ParticleCount, ParticleImage, ParticleSize, ParticleType )
// ParticleID = PKAddParticlesEx2( ParticleCount, ParticleImage, ParticleSize, ParticleType, xPos, yPos, Width, Height )
// PKUpdateParticles()
// PKAttachParticleToLayer( ParticleID, LayerID )
// PKDetachParticleFromLayer( ParticleID )
// PKSetParticleImage( ParticleID, ImageID )
// PKSetParticlePosition( ParticleID , XPos , YPos )
// PKSetParticleEmitterRange( ParticleID, XSize, YSize )
// PKSetParticlePath( ParticleID, XMove, YMove )
// TRUE/FALSE = PKGetParticleExists( ParticleID )
// 
// ParticleID = PKGetParticleIDByName( ParticleName )
// ParticleID = PKAddParticleByName( ParticleName, ParticleCount , ParticleImage , ParticleSize )
// ParticleID = PKAddParticleByNameEx( ParticleName, ParticleCount , ParticleImage , ParticleSize, ParticleType )
// ParticleID = PKAddParticleByNameEx2( ParticleName, ParticleCount , ParticleImage, ParticleSize, ParticleType, xPos, yPos, Width, Height )
// PKUpdateParticleByName( ParticleName, XADD, YADD )
// PKAttachParticleToLayerByName( ParticleName, LayerName )
// PKDetachParticleFromLayer( ParticleName )
// PKSetParticleImageByName( ParticleName, ImageID )
// PKSetParticlePositionByName( ParticleName, XPos, YPos )
// PKSetParticleEmitterRangeByName( ParticleName, XSize, YSize )
// PKSetParticlePathByName( ParticleName, XMove, YMove )
// TRUE/FALSE PKGetParticleExistsByName( ParticleName )

//
//**************************************************************************************************************
//
Function PKAddParticle( ParticleCount As Integer , ParticleImage As Integer , ParticleSize As Float )
	ParticleID As Integer
	ParticleID = PKAddParticleEx( ParticleCount, ParticleImage, ParticleSize, PKParticleType.Initial )
EndFunction ParticleID


Function PKAddParticleEx( ParticleCount As Integer , ParticleImage As Integer , ParticleSize As Float, ParticleType As Integer )
	ParticleID As Integer
	ParticleID = PKAddParticleEx2( ParticleCount, ParticleImage, ParticleSize, ParticleType, -1, -1, -1, -1 )
EndFunction ParticleID
//
//**************************************************************************************************************
//
Function PKAddParticleEx2( ParticleCount As Integer , ParticleImage As Integer, ParticleSize As Float, ParticleType As Integer, xPos As Integer, yPos As Integer, Width As integer, Height As Integer )
	if ParticleCount < 1 then ParticleCount = PKSetup.defElementsAmount
	newParticle As PKParticle_Type
	newParticle.mType = ParticleType
	newParticle.Count = ParticleCount
	newParticle.pSize = ParticleSize
	// Setup default parameter for other properties
	if xPos > -1 then newParticle.XEmitter = xPos Else newParticle.XEmitter = 0.0
	if yPos > -1 Then newParticle.YEmitter = yPos Else newParticle.YEmitter = 0.0
	newParticle.SpriteID = -1
	if Width > -1 then newParticle.XSize = Width Else newParticle.XSize = 40
	if Height > -1 then newParticle.YSize = Height Else newParticle.YSize = 200
	newParticle.XMove = 0.0
	newParticle.YMove = 0.0
	newParticle.XMin = newParticle.XEmitter - round( newParticle.XSize / 2 )
	newParticle.XMax = newParticle.XEmitter + round( newParticle.XSize / 2 )
	newParticle.YMin = newParticle.YEmitter - round( newParticle.YSize / 2 )
	newParticle.YMax = newParticle.YEmitter + round( newParticle.YSize / 2 )
	newParticle.Duration = 0
	newParticle.Hide = 0
	newParticle.LayerID = -1
	newParticle.OldTime = 0
	newParticle.ActualTime = 0
	newParticle.TimeChange = 0
	newParticle.TimeFactor = 0.0
	// On ajoute les informations qui serviront à positionner les éléments de la particule dans l'écran.
	newParticleObject As PKParticleObject_Type
	newParticleObject.xPos = 0.0
	newParticleObject.yPos = 0.0
	newParticleObject.Duration = 0.0
	XLoop As Integer
	For XLoop = 1 To ParticleCount
		newParticle.pElement.insert( newParticleObject )
	Next XLoop
	//
	PKParticle.insert( newParticle )
	ParticleID As Integer
	ParticleID = PKParticle.length
	// On définit l'image de la particule
	If ParticleImage > -1
		If GetImageExists( ParticleImage ) = 1
			PKParticle[ ParticleID ].ImageID = ParticleImage
			PKSetParticleImage( ParticleID, ParticleImage )
		Else
			PKParticle[ ParticleID ].ImageID = 0
		EndIf
	Else
		XRand As Integer : YRand As Integer
		Select ParticleType
			// ********************************* Particules de type : Par défaut / Initial / Standard
			Case PKParticleType.Initial
				PKParticle[ ParticleID ].ImageID = -1
			EndCase
			// ********************************* Particules de type : FLAMES / FLAMMES
			Case PKParticleType.Flames
				if PKParticlesTextures.pkFlames = -1
					PKParticlesTextures.pkFlames = LoadImage( iPKFlame )
				Endif
				PKParticlesTextures.pkFlamesCount = PKParticlesTextures.pkFlamesCount + 1 // Incrémente le compteur de particles de type flammes
				PKSetParticleImage( ParticleID, PKParticlesTextures.pkFlames )			
				For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
					FLAMESTEP As Float : FLAMESTEP = 200.0 / PKParticle[ ParticleID ].Count
					// We position the flames for default settings.
					PKParticle[ ParticleID ].pElement[ XLoop ].Duration = FLAMESTEP * XLoop
					RandomNumber As Integer : RandomNumber = PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize
					XRand = Random( 0, RandomNumber )
					PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].XMax - XRand - ( PKParticle[ ParticleID ].pSize / 2 )
					PKParticle[ ParticleID ].pElement[ XLoop ].Ypos = PKParticle[ ParticleID ].YMax - ( PKParticle[ ParticleID ].pElement[ XLoop ].Duration * 0.1 )
				Next XLoop        
				PKParticle[ ParticleID ].XMove = 0.0
				PKParticle[ ParticleID ].YMove = -0.25
				PKParticle[ ParticleID ].Duration = PKParticle[ ParticleID ].YSize
			EndCase
			// ********************************* Particules de type : SMOKE / FUMEE
			Case PKParticleType.Smoke
				if PKParticlesTextures.pkFlames = -1
					PKParticlesTextures.pkFlames = LoadImage( iPKFlame )
				Endif
				PKSetParticleImage( ParticleID, PKParticlesTextures.pkFlames )
				PKParticlesTextures.pkFlamesCount = PKParticlesTextures.pkFlamesCount + 1 // Incrémente le compteur de particles de type flammes
				For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
					SMOKESTEP As Float : SMOKESTEP = 200.0 / PKParticle[ ParticleID ].Count
					// We position the flames for default settings.
					PKParticle[ ParticleID ].pElement[ XLoop ].Duration = SMOKESTEP * XLoop
					RandomNumber = PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize
					PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].XMax - XRand - ( PKParticle[ ParticleID ].pSize / 2 )
					PKParticle[ ParticleID ].pElement[ XLoop ].Ypos = PKParticle[ ParticleID ].pElement[ XLoop ].Duration * 0.1
				Next XLoop        
				PKParticle[ ParticleID ].XMove = 0.0
				PKParticle[ ParticleID ].YMove = -0.025
				PKParticle[ ParticleID ].Duration = PKParticle[ ParticleID ].YSize
			EndCase
			// ********************************* Particules de type : SNOW / NEIGE
			Case PKParticleType.Snow
				if PKParticlesTextures.pkSnow = -1
					PKParticlesTextures.pkSnow = LoadImage( iPKSnow )
				Endif
				PKSetParticleImage( ParticleID, PKParticlesTextures.pkSnow )
				PKParticlesTextures.pkSnowCount = PKParticlesTextures.pkSnowCount + 1 // Incrémente le compteur de particles de type flammes
				For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
					// We position the Snow for default settings.
					XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
					YRand = Random( 0, PKParticle[ ParticleID ].YSize - PKParticle[ ParticleID ].pSize )
					PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + XRand
					PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMin + YRand
				Next XLoop        
				PKParticle[ ParticleID ].XMove = 0.0
				PKParticle[ ParticleID ].YMove = -0.0625
				PKParticle[ ParticleID ].Duration = 0.0
			EndCase
			// ********************************* Particules de type : RAIN / PLUIE
			Case PKParticleType.Rain
				if PKParticlesTextures.pkRain = -1
					PKParticlesTextures.pkRain = LoadImage( iPKRain )
				Endif
				PKSetParticleImage( ParticleID, PKParticlesTextures.pkRain )
				PKParticlesTextures.pkRainCount = PKParticlesTextures.pkRainCount + 1 // Incrémente le compteur de particles de type flammes
				For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
					// We position the Snow for default settings.
					XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
					YRand = Random( 0, PKParticle[ ParticleID ].YSize - PKParticle[ ParticleID ].pSize )
					PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + XRand
					PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMin + YRand
				Next XLoop        
				PKParticle[ ParticleID ].XMove = 0.0
				PKParticle[ ParticleID ].YMove = -1.5
				PKParticle[ ParticleID ].Duration = 0.0
			EndCase
			// ********************************* Particules de type : SPARKLES / ECLATS
			Case PKParticleType.Sparkles
				if PKParticlesTextures.pkSparkles = -1
					PKParticlesTextures.pkSparkles = LoadImage( iPKSparkle )
				Endif
				PKSetParticleImage( ParticleID, PKParticlesTextures.pkSparkles )
				PKParticlesTextures.pkSparklesCount = PKParticlesTextures.pkSparklesCount + 1 // Incrémente le compteur de particles de type flammes
				For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
					// We position the Snow for default settings.
					XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
					YRand = Random( 0, PKParticle[ ParticleID ].YSize - PKParticle[ ParticleID ].pSize )
					PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + XRand
					PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMin + YRand
					PKParticle[ ParticleID ].pElement[ XLoop ].Duration = Random( 0, 200.0 ) + 50.0
				Next XLoop        
				PKParticle[ ParticleID ].XMove = 0.0
				PKParticle[ ParticleID ].YMove = 0.0
				PKParticle[ ParticleID ].Duration = 250.0
			EndCase
			// ********************************* Particules de type : RAINDROP / ECLAT DE GOUTTES DE PLUIE
			Case PKParticleType.RainDrop
				if PKParticlesTextures.pkRainDrop = -1
					PKParticlesTextures.pkRainDrop = LoadImage( iPKRainDrop )
				Endif
				PKSetParticleImage( ParticleID, PKParticlesTextures.pkRainDrop )
				PKParticlesTextures.pkRainDropCount = PKParticlesTextures.pkRainDropCount + 1 // Incrémente le compteur de particles de type flammes
				PKParticle[ ParticleID ].XMove = 0.0
				PKParticle[ ParticleID ].YMove = 0.0
				PKParticle[ ParticleID ].Duration = 200.0
				For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
					// We position the Snow for default settings.
					XRand = Random( 0, Abs( PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize ) )
					PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + XRand
					PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMax - PKParticle[ ParticleID ].pSize
					Ratio As Float : Ratio = Random( 1.0, 100.0 ) / 100.0
					PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].Duration * Ratio
				Next XLoop        
			EndCase
		EndSelect
	EndIf
EndFunction ParticleID

Function PKUpdateParticle( ParticleID As Integer, XADD As Integer, YADD As Integer )
	XLoop As Integer
	XRand As Integer : YRand As Integer
	ParticlePhase As Float
	If PKGetParticleExists( ParticleID ) = TRUE
		PKParticle[ ParticleID ].TimeChange = ( PKSetup.NewTimer - PKSetup.PreviousTimer )
		If PKParticle[ ParticleID ].TimeChange > 60 Then PKParticle[ ParticleID ].TimeChange = 60
		PKParticle[ ParticleID ].TimeFactor = PKParticle[ ParticleID ].TimeChange / 2.0
		If PKParticle[ ParticleID ].Hide = FALSE
			SetSpriteVisible( PKParticle[ ParticleID ].SpriteID, TRUE )
			Select PKParticle[ ParticleID ].mType
				// ***************************** Update Particles Type : DEFAULT / PAR DEFAUT
				Case PKParticleType.Initial
					eXPos As Integer : eYPos As Integer : eDuration As Integer : eReset As Integer
					for XLoop = 0 to PKParticle[ ParticleID ].pElement.length
						eReset = FALSE
						eXPos = PKParticle[ ParticleID ].pElement[ XLoop ].XPos
						eYPos = PKParticle[ ParticleID ].pElement[ XLoop ].YPos
						eDuration = PKParticle[ ParticleID ].pElement[ XLoop ].Duration
						if PKParticle[ ParticleID ].Duration > -1
							// Particle's life and death
							eDuration = eDuration - PKParticle[ ParticleID ].TimeFactor
							if eDuration < 0 Then eReset = TRUE
							// Particles out of limits
						Endif
						// Checking movements limits
						eXPos = eXpos + ( PKParticle[ ParticleID ].xMove * PKParticle[ ParticleID ].TimeFactor )
						eYPos = eYPos + ( PKParticle[ ParticleID ].yMove * PKParticle[ ParticleID ].TimeFactor )
						if eXPos < PKParticle[ ParticleID ].XMin then eReset = TRUE
						if eXPos > PKParticle[ ParticleID ].XMax then eReset = TRUE
						if eYPos < PKParticle[ ParticleID ].YMin then eReset = TRUE
						if eYPos > PKParticle[ ParticleID ].YMax then eReset = TRUE
						// Reset particle if required
						if eReset = TRUE 
							eDuration = PKParticle[ ParticleID ].Duration
							XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
							YRand = Random( 0, PKParticle[ ParticleID ].YSize - PKParticle[ ParticleID ].pSize )
							eXPos = PKParticle[ ParticleID ].XMin + XRand
							eYPos = PKParticle[ ParticleID ].YMin + YRand
						Endif
						// Update final values for the particle element
						PKParticle[ ParticleID ].pElement[ XLoop ].XPos = eXPos
						PKParticle[ ParticleID ].pElement[ XLoop ].YPos = eYPos
						PKParticle[ ParticleID ].pElement[ XLoop ].Duration = eDuration
					Next XLoop
				EndCase
				// ***************************** Update Particles Type : FLAMES / FLAMMES
				Case PKParticleType.Flames
					Mult As Float = 1.0
					For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
						If PKParticle[ ParticleID ].pElement[ XLoop ].Duration > 0
							PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].pElement[ XLoop ].Duration - ( 0.5 * PKParticle[ ParticleID ].TimeFactor )
							If PKParticle[ ParticleID ].pElement[ XLoop ].Duration < 0 : PKParticle[ ParticleID ].pElement[ XLoop ].Duration = 0 : EndIf
							Red As Float = 255.0
							Green As Float : Green = PKParticle[ ParticleID ].pElement[ XLoop ].Duration * 1.28
							Blue As Float : Blue = PKParticle[ ParticleID ].pElement[ XLoop ].Duration * 0.64
							If PKParticle[ ParticleID ].pElement[ XLoop ].Duration < 200
								Mult = ( PKParticle[ ParticleID ].pElement[ XLoop ].Duration / PKParticle[ ParticleID ].YSize )
								If Mult < 0.0 : Mult = 0 : EndIf
								Red = Red * Mult : If Red > 255.0 : Red = 255.0 : EndIf
								Green = Green * Mult : If Green > 255.0 : Green = 255.0 : EndIf
								Blue = Blue * Mult : If Blue > 255.0 : Blue = 255.0 : EndIf
								Alfa As Integer : Alfa = ( Red + Green + Blue ) / 3
								SetSpriteColor( PKParticle[ ParticleID ].SpriteID, Red, Green, Blue, Alfa )
								// SetSpriteColorAlpha( PKParticle[ ParticleID ].SpriteID, Alfa )
							Else
								Mult = Abs( 200 - PKParticle[ ParticleID ].pElement[ XLoop ].Duration )
								If Mult < 0.0 : Mult = 0 : EndIf
								If Mult > 1.0 : Mult = 1.0 : EndIf
								// SetSpriteColor( PKParticle[ ParticleID ].SpriteID , 255 * Mult , 255 * Mult , 255 * Mult )
								SetSpriteColor( PKParticle[ ParticleID ].SpriteID , 255 * Mult , 255 * Mult , 255 * Mult, 255 * Mult ) // Original is without Alpha.
							EndIf
							PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + (PKParticle[ ParticleID ].XMove * PKParticle[ ParticleID ].TimeFactor )
							PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].pElement[ XLoop ].YPos + ( PKParticle[ ParticleID ].YMove * PKParticle[ ParticleID ].TimeFactor / 1.5 )
							SetSpritePosition( PKParticle[ ParticleID ].SpriteID , PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XADD , PKParticle[ ParticleID ].pElement[ XLoop ].Ypos + YADD )
							DrawSprite( PKParticle[ ParticleID ].SpriteID)
						Else
							PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].Duration
							XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
							PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].XMax - XRand - ( PKParticle[ ParticleID ].pSize / 2 )
							PKParticle[ ParticleID ].pElement[ XLoop ].Ypos = PKParticle[ ParticleID ].YMax - 8
						EndIf
					Next XLoop 
				EndCase
				// ***************************** Update Particles Type : SMOKE / FUMEE
				Case PKParticleType.Smoke
					For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
						If PKParticle[ ParticleID ].pElement[ XLoop ].Duration > 0
							PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].pElement[ XLoop ].Duration - ( 0.05 * PKParticle[ ParticleID ].TimeFactor )
							If PKParticle[ ParticleID ].pElement[ XLoop ].Duration < 0 : PKParticle[ ParticleID ].pElement[ XLoop ].Duration = 0 : EndIf
							If PKParticle[ ParticleID ].pElement[ XLoop ].Duration < 200
								SetSpriteColorAlpha( PKParticle[ ParticleID ].SpriteID, Round( PKParticle[ ParticleID ].pElement[ XLoop ].Duration ) / 4 )
							Else
								Value As Integer : Value = Abs( 200 - PKParticle[ ParticleID ].pElement[ XLoop ].Duration )
								Value = ( 50 - Value ) // * 2.0
								SetSpriteColorAlpha( PKParticle[ ParticleID ].SpriteID, Value )
							EndIf
							PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].pElement[ XLoop ].YPos + ( PKParticle[ ParticleID ].YMove * PKParticle[ ParticleID ].TimeFactor )
							SetSpritePosition( PKParticle[ ParticleID ].SpriteID , PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XADD , PKParticle[ ParticleID ].pElement[ XLoop ].Ypos + YADD )
							DrawSprite( PKParticle[ ParticleID ].SpriteID)
							If PKParticle[ ParticleID ].pElement[ XLoop ].Duration <= 0 
								PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].Duration
								XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
								PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].XMax - XRand - ( PKParticle[ ParticleID ].pSize / 2 )
								PKParticle[ ParticleID ].pElement[ XLoop ].Ypos = PKParticle[ ParticleID ].YMax - 8
							EndIf
						EndIf
					Next XLoop             
				EndCase
				// ***************************** Update Particles Type : SNOW / NEIGE
				Case PKParticleType.Snow
					For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
						XShift As Float : XShift = PKParticle[ ParticleID ].TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
						PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XShift
						PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].pElement[ XLoop ].YPos - ( PKParticle[ ParticleID ].YMove * PKParticle[ ParticleID ].TimeFactor )
						If PKParticle[ ParticleID ].pElement[ XLoop ].Xpos < PKParticle[ ParticleID ].XMin
							PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].XMax - 4
						Else
							If PKParticle[ ParticleID ].pElement[ XLoop ].Xpos > PKParticle[ ParticleID ].XMax
								PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].Xmin + 4
							EndIf
						EndIf
						If PKParticle[ ParticleID ].pElement[ XLoop ].YPos > PKParticle[ ParticleID ].YMax
							PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMin
							XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
							PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + Xrand
						Else
							If PKParticle[ ParticleID ].pElement[ XLoop ].YPos > PKParticle[ ParticleID ].YMax
								PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMax
								XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
								PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + Xrand
							EndIf
						EndIf
						SetSpritePosition( PKParticle[ ParticleID ].SpriteID , PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XADD , PKParticle[ ParticleID ].pElement[ XLoop ].Ypos + YADD )
						DrawSprite( PKParticle[ ParticleID ].SpriteID)
					Next XLoop
				EndCase
				// ***************************** Update Particles Type : RAIN / PLUIE
				Case PKParticleType.Rain
					For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
						PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].pElement[ XLoop ].YPos - ( PKParticle[ ParticleID ].YMove * PKParticle[ ParticleID ].TimeFactor )
						If PKParticle[ ParticleID ].pElement[ XLoop ].Xpos < PKParticle[ ParticleID ].XMin
							PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].XMax - 4
						Else
							If PKParticle[ ParticleID ].pElement[ XLoop ].Xpos > PKParticle[ ParticleID ].XMax
								PKParticle[ ParticleID ].pElement[ XLoop ].Xpos = PKParticle[ ParticleID ].Xmin + 4
							EndIf
						EndIf
						If PKParticle[ ParticleID ].pElement[ XLoop ].YPos > PKParticle[ ParticleID ].YMax
							PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMin - Random( 0, 32 )
							XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
							PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + Xrand
						EndIf
						SetSpritePosition( PKParticle[ ParticleID ].SpriteID , PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XADD , PKParticle[ ParticleID ].pElement[ XLoop ].Ypos + YADD )
						DrawSprite( PKParticle[ ParticleID ].SpriteID)
					Next XLoop
				EndCase
				// ***************************** Update Particles Type : SPARKLES / ETINCELLES
				Case PKParticleType.Sparkles
					Percent As Float
					For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
						PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].pElement[ XLoop ].Duration - PKParticle[ ParticleID ].TimeFactor
						If PKParticle[ ParticleID ].pElement[ XLoop ].Duration < 0
							// On recrée la particule dans l'espace prévu pour.
							PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].Duration
							XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
							YRand = Random( 0, PKParticle[ ParticleID ].YSize - PKParticle[ ParticleID ].pSize )
							PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + XRand
							PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMin + YRand
						Else
							// On met à jour les Sparkles ...
							ParticlePhase = ( PKParticle[ ParticleID ].pElement[ XLoop ].Duration / PKParticle[ ParticleID ].Duration ) * 100.0 
							If ParticlePhase < 75.0
								// Phase 2 - Descendante
								Percent = ( ParticlePhase * 4.0 ) / 3.0
							Else
								// Phase 1 - Ascendante
								Percent = ( 25.0 - Abs( 75 - ParticlePhase ) ) * 4.0
							EndIf
							SetSpriteColor( PKParticle[ ParticleID ].SpriteID, Percent * 2.5, Percent * 2.5, Percent * 2.5, Percent * 2.5 )
							SetSpriteColorAlpha( PKParticle[ ParticleID ].SpriteID, Percent * 2.5 )
							SetSpritePosition( PKParticle[ ParticleID ].SpriteID , PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XADD , PKParticle[ ParticleID ].pElement[ XLoop ].Ypos + YADD )
							DrawSprite( PKParticle[ ParticleID ].SpriteID)
						EndIf
					Next XLoop
				EndCase
				// ***************************** Update Particles Type : RAINDROP / ECLATS DE GOUTTES PLUIE
				Case PKParticleType.RainDrop
					For XLoop = 0 To PKParticle[ ParticleID ].pElement.length
						PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].pElement[ XLoop ].Duration - PKParticle[ ParticleID ].TimeFactor 
						if PKParticle[ ParticleID ].pElement[ XLoop ].Duration < 0
							PKParticle[ ParticleID ].pElement[ XLoop ].Duration = PKParticle[ ParticleID ].Duration 
							XRand = Random( 0, PKParticle[ ParticleID ].XSize - PKParticle[ ParticleID ].pSize )
							PKParticle[ ParticleID ].pElement[ XLoop ].XPos = PKParticle[ ParticleID ].XMin + XRand
							PKParticle[ ParticleID ].pElement[ XLoop ].YPos = PKParticle[ ParticleID ].YMax + PKParticle[ ParticleID ].pSize
						Endif
						ParticlePhase = ( PKParticle[ ParticleID ].pElement[ XLoop ].Duration / PKParticle[ ParticleID ].Duration ) * 100.0
						Percent = ( ParticlePhase * 4.0 ) / 3.0
						SetSpriteColor( PKParticle[ ParticleID ].SpriteID, Percent, Percent, Percent, Percent )
						SetSpritePosition( PKParticle[ ParticleID ].SpriteID , PKParticle[ ParticleID ].pElement[ XLoop ].Xpos + XADD , PKParticle[ ParticleID ].pElement[ XLoop ].Ypos + YADD )
						DrawSprite( PKParticle[ ParticleID ].SpriteID)
					Next XLoop
				EndCase
			EndSelect
			SetSpriteVisible( PKParticle[ ParticleID ].SpriteID, FALSE )
		EndIf
	Endif
 EndFunction


Function PKUpdateParticles()
	if PKParticle.length > -1
		pLoop As Integer
		for pLoop = 0 to PKParticle.length Step 1
			PKUpdateParticle( pLoop, 0, 0 )
		next pLoop
	Endif
EndFunction

Function PKAttachParticleToLayer( ParticleID As Integer, LayerID As Integer )
	if PKGetParticleExists( ParticleID ) = True
		if PKGetLayerExists( LayerID ) = True
			if PKParticle[ ParticleID ].LayerID > -1 then PKDetachParticleFromLayer( ParticleID )
			PKParticle[ ParticleID ].LayerID = LayerID
			PKLayer[ LayerID ].PKParticles.insert( ParticleID )
		Else
			Message( "PKAttachParticleToLayer Error : The requeted Layer does not exists" )
		Endif	
	Else
		Message( "PKAttachParticleToLayer Error : The requested particle does not exists" )
	Endif
	
EndFunction

Function PKDetachParticleFromLayer( ParticleID As Integer )
	if PKGetParticleExists( ParticleID ) = TRUE
		LayerID As Integer
		LayerID = PKParticle[ ParticleID ].LayerID
		PKParticle[ ParticleID ].LayerID = -1           // Remove the layer from the particle list
		if PKGetLayerExists( LayerID ) = TRUE
			ParticlePosInLayerList As Integer
			ParticlePosInLayerList = PKLayer[ LayerID ].PKParticles.find( ParticleID )
			if ParticlePosInLayerList > -1
				PKLayer[ LayerID ].PKParticles.remove( ParticlePosInLayerList ) // Remove the particle from the layer's linked particles list
			Else
				Message( "PKDetachParticleFromLayer Error : The requested particle was not found in the layer's particles list" )
			Endif
		Else
			Message( "PKDetachParticleFromLayer Error : The layer linked with the particle does not exists" )
		Endif
	Else
		Message( "PKDetachParticleFromLayer Error : The requested particle does not exists" )
	Endif
EndFunction

Function PKSetParticleImage( ParticleID As Integer, ImageID As Integer )
	// Mode SPRITES DarkBASIC Professional par défaut.
	If GetImageExists( ImageID ) = TRUE
		If PKGetParticleExists( ParticleID ) = TRUE
			// On crée ou mets à jour le sprite avec la nouvelle image.
			If PKParticle[ ParticleID ].SpriteID < 0
				PKParticle[ ParticleID ].SpriteID = CreateSprite( ImageID )
			Else
				SetSpriteImage( PKParticle[ ParticleID ].SpriteID, ImageID )
			EndIf
			SetSpriteSize( PKParticle[ ParticleID ].SpriteID, PKParticle[ ParticleID ].pSize , PKParticle[ ParticleID ].pSize )
			SetSpriteTransparency( PKParticle[ ParticleID ].SpriteID, 2 )
			// SetSpriteVisible( PKParticle[ ParticleID ].SpriteID, FALSE )
			PKParticle[ ParticleID ].ImageID = ImageID
		Else
			Message( "PKSetParticleImage Error : The requested particle does not exists" )
		Endif
	Else
		Message( "PKSetParticleImage Error : The requested Image does not exists" )
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticlePosition( ParticleID As Integer , XPos As Integer , YPos As Integer )
	if PKGetParticleExists( ParticleID ) = true
		PKParticle[ ParticleID ].XEmitter = XPos
		PKParticle[ ParticleID ].YEmitter = YPos
		If PKParticle[ ParticleID ].XSize > 0 And PKParticle[ ParticleID ].YSize > 0
			XSize As Integer : XSize = PKParticle[ ParticleID ].XSize
			YSize As Integer : YSize = PKParticle[ ParticleID ].YSize
			PKParticle[ ParticleID ].XMin = PKParticle[ ParticleID ].XEmitter - ( Xsize / 2 )
			PKParticle[ ParticleID ].XMax = PKParticle[ ParticleID ].XEmitter + ( Xsize / 2 )
			PKParticle[ ParticleID ].YMin = PKParticle[ ParticleID ].YEmitter - ( Ysize / 2 )
			PKParticle[ ParticleID ].YMax = PKParticle[ ParticleID ].YEmitter + ( Ysize / 2 )
		EndIf
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticleEmitterRange( ParticleID As Integer, XSize As Integer, YSize As Integer )
	if PKGetParticleExists( ParticleID ) = true
		PKParticle[ ParticleID ].XSize = XSize
		PKParticle[ ParticleID ].YSize = YSize
		PKParticle[ ParticleID ].XMin = PKParticle[ ParticleID ].XEmitter - round( Xsize / 2 )
		PKParticle[ ParticleID ].XMax = PKParticle[ ParticleID ].XEmitter + round( Xsize / 2 )
		PKParticle[ ParticleID ].YMin = PKParticle[ ParticleID ].YEmitter - round( Ysize / 2 )
		PKParticle[ ParticleID ].YMax = PKParticle[ ParticleID ].YEmitter + round( Ysize / 2 )
	EndIf
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticlePath( ParticleID As Integer, XMove As Float, YMove As Float )
	if PKGetParticleExists( ParticleID ) = true
		PKParticle[ ParticleID ].XMove = XMove
		PKParticle[ ParticleID ].YMove = YMove
	EndIf
EndFunction



//
//**************************************************************************************************************
//
Function PKGetParticleExists( ParticleID As Integer )
	isExist As Integer : isExist = FALSE
	if ParticleID > -1 and ParticleID < ( PKParticle.length +1 )
		isExist = TRUE
	Endif
EndFunction isExist



Function PKGetParticleIDByName( ParticleName As String )
	ParticleID As Integer = -1
	if PKParticle.length > -1
		pLoop As Integer
		For pLoop = 0 to PKParticle.length Step 1
			if PKParticle[ pLoop ].Name = ParticleName
				ParticleID = pLoop
				Exit
			Endif
		Next pLoop
	Endif
	if ParticleID = -1
		Message( "The requested particle cannot be found with the provided name" )
	Endif

EndFunction ParticleID

//
//**************************************************************************************************************
//
Function PKAddParticleByName( ParticleName As String, ParticleCount As Integer , ParticleImage As Integer , ParticleSize As Float )
	ParticleID As Integer
	ParticleID = PKAddParticleEx( ParticleCount, ParticleImage, ParticleSize, PKParticleType.Initial )
	PKParticle[ ParticleID ].Name = ParticleName
EndFunction ParticleID

//
//**************************************************************************************************************
//
Function PKAddParticleByNameEx( ParticleName As String, ParticleCount As Integer , ParticleImage As Integer , ParticleSize As Float, ParticleType As Integer )
	ParticleID As Integer
	ParticleID = PKAddParticleEx2( ParticleCount, ParticleImage, ParticleSize, ParticleType, -1, -1, -1, -1 )
	PKParticle[ ParticleID ].Name = ParticleName
EndFunction ParticleID

//
//**************************************************************************************************************
//
Function PKAddParticleByNameEx2( ParticleName As String, ParticleCount As Integer , ParticleImage As Integer, ParticleSize As Float, ParticleType As Integer, xPos As Integer, yPos As Integer, Width As integer, Height As Integer )
	ParticleID As Integer
	ParticleID = PKAddParticleEx2( ParticleCount, ParticleImage, ParticleSize, ParticleType, xPos, yPos, Width, Height )
	PKParticle[ ParticleID ].Name = ParticleName
EndFunction ParticleID

//
//**************************************************************************************************************
//
Function PKUpdateParticleByName( ParticleName As String, XADD As Integer, YADD As Integer )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	PKUpdateParticle( ParticleID, XADD, YADD )
 EndFunction

//
//**************************************************************************************************************
//
Function PKAttachParticleToLayerByName( ParticleName As String, LayerName As String )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	LayerID As Integer
	LayerID = PKGetLayerIDByName( LayerName )
	PKAttachParticleToLayer( ParticleID, LayerID )
EndFunction

//
//**************************************************************************************************************
//
Function PKDetachParticleFromLayerByName( ParticleName As String )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	PKDetachParticleFromLayer( ParticleID )
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticleImageByName( ParticleName As String, ImageID As Integer )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	PKSetParticleImage( ParticleID, ImageID )
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticlePositionByName( ParticleName As String, XPos As Integer, YPos As Integer )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	PKSetParticlePosition( ParticleID, XPos, YPos )
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticleEmitterRangeByName( ParticleName As String, XSize As Integer, YSize As Integer )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	PKSetParticleEmitterRange( ParticleID, XSize, YSize )
EndFunction

//
//**************************************************************************************************************
//
Function PKSetParticlePathByName( ParticleName As String, XMove As Float, YMove As Float )
	ParticleID As Integer
	ParticleID = PKGetParticleIDByName( ParticleName )
	PKSetParticlePath( ParticleID, XMove, YMove )
EndFunction

//
//**************************************************************************************************************
//
Function PKGetParticleExistsByName( ParticleName As String )
	isExist As Integer = 0
	if PKParticle.length > -1
		pLoop As Integer
		For pLoop = 0 to PKParticle.length Step 1
			if PKParticle[ pLoop ].Name = ParticleName
				isExist = TRUE
				Exit
			Endif
		Next pLoop
	Endif
EndFunction isExist




