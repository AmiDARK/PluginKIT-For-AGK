

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
Function XTSetMosaicZoomMode( Mode As Integer )
	dbMosaicZoomMode = Mode
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
Function XTGenerateMosaicImage( Source As Integer, SFactor As Integer, Rand As Integer )
	feedback As Integer
	feedback = Internal_ImageMosaic( Source, SFactor, Rand, 0 )
 EndFunction feedback

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
Function XTGenerateMosaicImageEx( Source As Integer, SFactor As Integer, Rand As Integer, Target As Integer )
	feedback As Integer
	feedback = Internal_ImageMosaic( Source, SFactor, Rand, Target )
 EndFunction feedback


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
Function Internal_ImageMosaic( SourceImage As Integer, Factor As Integer, RandMode As Integer, TargetImage As Integer )
	If GetImageExists( SourceImage ) = 1
		If dbMosaicZoomMode = 0
			// Prepare memblock and get image informations.
			_Memblock As Integer : _Memblock = CreateMemblockFromImage( SourceImage )
			XSize As Integer : XSize = GetMemblockInt( _Memblock, 0 )
			YSize As Integer : YSize = GetMemblockInt( _Memblock, 4 )
			Depth As Integer : Depth = GetMemblockInt( _Memblock, 8 )
			Mult As Integer
			Mult = Depth / 8
			Lengt As Integer : Lengt = GetMemblockSize( _Memblock )
			// Main Mosaic loop
			YPos As Integer = 0 : YPos2 As Integer
			XPos As Integer : XPos2 As Integer 
			_Rea2 As Integer : _Read As Integer
			_Pixel As Integer
			Ysb As Integer : Xsb As Integer

			Repeat
				XPos = 0
				Repeat
					// Find pixel to read
					_Read = 12 + ( XPos * Mult ) + ( YPos * XSize * Mult )
					If RandMode = 0
						_Rea2 = _Read
					Else
						XPos2 = XPos + Random( 0, Factor )
						YPos2 = Ypos + Random( 0, Factor )
						If XPos2 > XSize - 1
							XPos2 = XSize - 1
						EndIf
						If YPos2 > YSize - 1
							YPos2 = YSize - 1
						EndIf
						_Rea2 = 12 + ( XPos2 * Mult ) + ( YPos2 * XSize * Mult )
					EndIf
					// Read Source Pixel
					_Pixel = 0
					If Mult = 2
						_Pixel = GetMemblockShort( _Memblock, _Rea2 )
					Else
						If Mult = 4
							_Pixel = GetMemblockInt( _Memblock, _Rea2 )
						EndIf
					EndIf
					// Write target pixel.
					If Factor = 2
						If Mult = 2
							SetMemblockShort( _Memblock, _Read + Mult, _Pixel )
							SetMemblockShort( _Memblock, _Read + ( XSize * Mult ), _Pixel )
							SetMemblockShort( _Memblock, _Read + ( XSize * Mult ) + Mult, _Pixel )
						Else
							If Mult = 4
								SetMemblockInt( _Memblock, _Read + Mult, _Pixel )
								SetMemblockInt( _Memblock, _Read + ( XSize * Mult ), _Pixel )
								SetMemblockInt( _Memblock, _Read + ( XSize * Mult ) + Mult, _Pixel )
							EndIf
						EndIf
					Else
						If Factor > 2
							For Ysb = 0 To Factor - 1
								For Xsb = 0 To Factor - 1
									_Write As Integer
									_Write = _Read + ( Xsb * Mult ) + ( Ysb * XSize * Mult )
									If Mult = 2
										SetMemblockShort( _Memblock, _Write, _Pixel )
									Else
										If Mult = 4
											SetMemblockInt( _Memblock, _Write, _Pixel )
										EndIf
									EndIf
								Next Xsb
							Next Ysb
						EndIf
					EndIf
					XPos = XPos + Factor
				Until XPos >= ( XSize - Factor )
				YPos = YPos + Factor
			Until YPos >= ( YSize - Factor )
			// Create the brand new mosaiced image from the memblock.
			If TargetImage < 1
				TargetImage = CreateImageFromMemblock( _Memblock )
			Else
				if getImageExists( TargetImage ) = 1 then DeleteImage( TargetImage )
				CreateImageFromMemblock( TargetImage, _Memblock )
			EndIf
			DeleteMemblock( _Memblock )
		Else
			if TargetImage < 1
				TargetImage = CopyImage( SourceImage, 0, 0, GetImageWidth( SourceImage ), GetImageHeight( SourceImage ) )
			Else
				If GetImageExists( TargetImage ) = 1 Then DeleteImage( TargetImage )
				CopyImage( SourceImage, TargetImage, 0, 0, GetImageWidth( SourceImage ), GetImageHeight( SourceImage ) )
			Endif
			NewWidth As Integer : NewWidth = GetImageWidth( SourceImage ) / Factor
			NewHeight As Integer : NewHeight = GetImageHeight( SourceImage ) / Factor
			ResizeImage( TargetImage, NewWidth, NewHeight )
			SetImageMagFilter( TargetImage, 0 )
			SetImageMinFilter( TargetImage, 0 )
			ResizeImage( TargetImage, GetImageWidth( SourceImage ), GetImageHeight( SourceImage ) )
		Endif
	EndIf
EndFunction TargetImage

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
Function XTSetImageWobbleValues( Amplitude As Integer, Speed As Integer, _Step As Integer )
	If Amplitude < 1 : Amplitude = 1 : EndIf
	XWobble.Amplitude = Amplitude
	If Speed < 1 : Speed = 1 : EndIf
	XWobble.Speed = Speed
	If _Step < 1 : _Step = 1 : EndIf
	Xwobble.wStep = _Step
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
Function XTGenerateImageWobbleEx3( SourceImage As Integer, TargetImage As Integer, Amplitude As Integer, Speed As Integer, _Step As Integer )
	feedback As Integer
	XTSetImageWobbleValues( Amplitude, Speed, _Step )
	feedback = Internal_ImageWobble( SourceImage, TargetImage )
EndFunction feedback

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
Function XTGenerateImageWobbleEx2( SourceImage As Integer, Amplitude As Integer, Speed As Integer, _Step As Integer )
	feedback As Integer
	XTSetImageWobbleValues( Amplitude, Speed, _Step )
	feedback = Internal_ImageWobble( SourceImage, 0 )
EndFunction feedback


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
Function XTGenerateImageWobbleEx( SourceImage As Integer, TargetImage As Integer )
	feedback As Integer
	feedback = Internal_ImageWobble( SourceImage, TargetImage )
EndFunction feedback

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
Function XTGenerateImageWobble( SourceImage As Integer )
	feedback As Integer
	feedback = Internal_ImageWobble( SourceImage, 0 )
EndFunction feedback

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
Function Internal_ImageWobble( SourceImage As Integer, TargetImage As Integer )
	If GetImageExists( SourceImage ) = 1
		// Create Original image memblock.
		_Memblock1 As Integer
		_Memblock1 = CreateMemblockFromImage( SourceImage )
		_Length As Integer
		_Length = GetMemblockSize( _Memblock1 )
		// Create Target memblock.
		_Memblock2 As Integer
		_Memblock2 = CreateMemblock( _Length )
		XSize As Integer
		XSize = GetMemblockInt( _Memblock1, 0 )
		SetMemblockShort( _Memblock2, 0, XSize )
		YSize As Integer
		YSize = GetMemblockInt( _Memblock1, 4 )
		SetMemblockShort( _Memblock2, 4, YSize ) 
		Depth As Integer
		Depth = GetMemblockInt( _Memblock1, 8 )
		SetMemblockShort( _Memblock2, 8, Depth )
		XWobble.XSize = XSize
		XWobble.YSize = YSize
		_Len As Integer
		_Len = Depth / 8
		// Create the Wobble Effect now.
		_Amp As Integer
		_Speed As Integer
		_Step As Integer
		_Cos As Integer
		_Amp = XWobble.Amplitude
		_Speed = XWobble.Speed
		_Step = XWobble.wStep
		_Cos = XWobble.internal
		If _Amp < 1
			_Amp = 1
		EndIf
		If _Speed < 1
			_Speed = 1
		EndIf
		If _Step < 1
			_Step = 1
		EndIf
		If _Cos < 0 Or _cos > 359
			_cos = 0
		EndIf
		XWobble.internal = _Cos + _Step // We save the next image starting line. WrapValue

		Boucle As Integer
		YLineStart As Integer
		YDecalage As Integer
		XSizeFinal As Integer
		For Boucle = 0 To YSize - 1 step 1
			YLineStart = 12 + ( Boucle * XSize * _Len )
			YDecalage = Trunc( Cos( _Cos ) * _Amp ) // Removes Deg2Rad for _Cos
			XSizeFinal = XSize - Abs( YDecalage )
			_Cos = _Cos + _Speed // WrapValue
			If YDecalage = 0
				// Rem If shift value If 0 then we simply copy 1 line .
				CopyMemblock( _Memblock1, _Memblock2, YLineStart, YLineStart, XSize * _Len )
			Else
				// Rem If shift is positive then we copy the desired part shifted To right of target.
				If YDecalage > 0
					CopyMemblock( _Memblock1, _Memblock2, YLineStart, YLineStart + ( YDecalage * _Len ), XSizeFinal * _Len )
				Else
					If YDecalage < 0
						CopyMemblock( _Memblock1, _Memblock2, YLineStart - ( YDecalage* _Len ), YLineStart, XSizeFinal * _Len )
					EndIf
				EndIf
			EndIf
		Next Boucle
		// Create the brand new mosaiced image from the memblock.
		If TargetImage < 1
			TargetImage = CreateImageFromMemblock( _Memblock2 )
		Else
			if getImageExists( TargetImage ) = 1 then DeleteImage( TargetImage )
			CreateImageFromMemblock( TargetImage, _Memblock2 )
		EndIf
		DeleteMemblock( _Memblock2 )
		DeleteMemblock( _Memblock1 )
	Else
		TargetImage = 0
	EndIf
	// Return new image
 EndFunction TargetImage

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
Function XTGenerateDOT3Image( IMG_Source As Integer, Smooth As Integer, Steep As Integer )
	IMG_Target As Integer = 0
	If IMG_Source > 0
		If GetImageExists( IMG_Source ) = 1
			MBC_Source As Integer
			MBC_Source = CreateMemblockFromImage( IMG_Source )
			If MBC_Source > 0
				IMG_XSize As Integer
				IMG_XSIZE = GetMemblockInt( MBC_Source, 0 )
				IMG_YSize As Integer
				IMG_YSize = GetMemblockInt( MBC_Source, 4 )
				MBC_Target As Integer
				MBC_Target = XTCreateImageMemblock( IMG_XSize, IMG_YSize, 32 )
				xloop As Integer = 0
				yloop As Integer = 0
				iloop As Integer = 0
				tempx As Integer = 0 : tempy As Integer = 0
				xpi As Integer : xmi As Integer : ypi As Integer : ymi As Integer
				nx As Float : ny As Float : nz As Float
				factor As Float
				red As Integer : green As Integer : blue As Integer
				For xloop=0 To IMG_XSize -1
					For yloop=0 To IMG_YSize -1
						tempx = 0
						tempy = 0 
						For iloop=1 To smooth 
							xpi = xloop + iloop
							xmi = xloop - iloop
							ypi = yloop + iloop
							ymi = yloop - iloop 
							If xpi > IMG_XSize
								xpi = xpi - IMG_XSize
							EndIf
							If xmi < 1
								xmi = xmi + IMG_XSize
							EndIf
							If ypi > IMG_YSize
								ypi = ypi - IMG_YSize
							EndIf
							If ymi < 1
								ymi = ymi + IMG_YSize
							EndIf
							tempx = tempx + InternalDOT3GetHeightMap( MBC_Source , xpi , yloop ) - InternalDOT3GetHeightMap( MBC_Source , xmi , yloop )
							tempy = tempy + InternalDOT3GetHeightMap( MBC_Source , xloop , ypi ) - InternalDOT3GetHeightMap( MBC_Source , xloop , ymi )
						Next iloop 
						nx = -tempx
						ny = -tempy
						nz =( 1024.0 * ( smooth + 1 ) ) / steep 
						factor = 127.0 / Sqrt( ( nx * nx ) + ( ny * ny ) + ( nz * nz ) ) 
						red = 128 + (factor * nx)
						green = 128 + (factor * ny)
						blue = 128 + (factor * nz)
						XTWriteMemblockPixel( MBC_Target, xloop, yloop, dbrgb( red, green, blue ) )
					Next yloop 
				Next xloop 
				IMG_Target = CreateImageFromMemblock( MBC_Target )
				DeleteMemblock( MBC_Source )
				DeleteMemblock( MBC_Target )
			EndIf
		EndIf
	EndIf
EndFunction IMG_Target

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
Function InternalDOT3GetHeightMap( MBC, X, Y )
	Pixel0 As Integer
	Pixel0 = XTReadMemblockPixel( MBC, X, Y )
	HeightMap As Integer
	HeightMap = dbrgbR( Pixel0 ) + dbrgbG( Pixel0 ) + dbrgbB( Pixel0 )
 EndFunction HeightMap

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
Function XTGenerateGreyScaleImage( IMG_Source As Integer )
	IMG_Target As Integer = 0
	If IMG_Source > 0
		If GetImageExists( IMG_Source ) = 1
			// Create a memblock from image and use it to create the final image.
			MBC_Source As Integer
			IMG_XSize As Integer
			IMG_YSize As Integer
			MBC_Target As Integer
			MBC_Source = CreateMemblockFromImage( IMG_Source )
			IMG_XSize = GetMemblockInt( MBC_Source, 0 )
			IMG_YSize = GetMemblockInt( MBC_Source, 4 )
			MBC_Target = XTCreateImageMemblock( IMG_XSize, IMG_YSize, 32 )
			XLoop As Integer = 0 : YLoop As Integer = 0
			PixelC As Integer : Medium As Integer : PixelF As Integer
			For YLoop = 0 To IMG_YSize -1
				For XLoop = 0 To IMG_XSize -1
					PixelC = XTReadMemblockPixel( MBC_Source, XLoop, YLoop )
					Medium = ( dbrgbR( PixelC ) + dbrgbG( PixelC ) + dbrgbB( PixelC ) ) / 3
					PixelF = dbrgb( Medium, Medium, Medium )
					XTWriteMemblockPixel( MBC_Target, XLoop, YLoop, PixelF )
				Next XLoop
			Next YLoop
			IMG_Target = CreateImageFromMemblock( MBC_Target )
			DeleteMemblock( MBC_Source )
			DeleteMemblock( MBC_Target )
		EndIf
	EndIf
EndFunction IMG_Target
 

Function XTCreateImageFromMemblock( MemblockID As Integer )
	ImageID As Integer = -1
	if getMemblockExists( MemblockID ) = TRUE
		if XTGetMemblockImageDepth( MemblockID ) = 8
			newBloc As Integer = -1 : xPos As Integer = -1 : yPos As Integer = -1 : pixColor As Integer = -1
			newBloc = XTCreateImageMemblock( XTGetMemblockImageWidth( MemblockID ), XTGetMemblockImageHeight( MemblockID ), 32 )
			For yPos = 0 to XTGetMemblockImageHeight( MemblockID ) - 1 Step 1
				for xPos = 0 to XTGetMemblockImageWidth( MemblockID ) - 1 Step 1
					pixColor = XTReadMemblockPixel( MemblockID, xPos, yPos )
					pixColor = dbrgbaex( pixColor, pixColor, pixColor, 255 )
					XTWriteMemblockPixel( newBloc, xPos, yPos, pixColor )
				next XPos
			next yPos
			ImageID = CreateImageFromMemblock( newBloc )
			DeleteMemblock( newBloc )
		Else
			ImageID = CreateImageFromMemblock( MemblockID )
		Endif
		
	Else
		Message( "XTCreateImageFromMemblock Error : Requested Memblock does not exists" )
	Endif
EndFunction ImageID
