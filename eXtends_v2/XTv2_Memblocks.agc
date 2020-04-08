//
// *********************************************************
// *                                                       *
// * eXtends Ver 2.0 Include File : Memblock Extra Methods *
// *                                                       *
// *********************************************************
// Start Date : 2019.04.23 23:10
// Description : These methods will add extra functionalities
//               to Memblock support
// Author : Frédéric Cordier
//
// XTCloneMemblock( MemblockSource As Integer )
// XTCreateImageMemblock( MWidth As Integer, MHeight As Integer, MDepth As Integer )
// XTWriteMemblockPixel( MemblockID As Integer, XPos As Integer, YPos As Integer, Pixel As Integer )
// XTReadMemblockPixel( MemblockID As Integer, XPos As Integer, YPos As Integer )
// XTCopyImageMemblock( SourceMBC As Integer, X As Integer, Y As Integer, Width As Integer, Height As Integer, TargetMBC As Integer, X2 As Integer, Y2 As Integer )
// XTStretchImageMemblock( SourceMBC, TargetMBC )
// XTImageMemblockBox( Memblok As Integer, XPos As Integer, YPos As Integer, XRight As Integer, YDown As Integer, RGBColor As Integer, Mode As Integer )
// XTImageMemblockCube( SourceMBC As Integer, XPos As Integer, YPos As Integer, XYSize As Integer, RGBColor As Integer, Mode As Integer )
// XTImageMemblockCircle( SourceMBC As Integer, XPos As Integer, YPos As Integer, Radius As Integer, RGBColor As Integer, Mode As Integer )
// XTCopyMemblockContent( SourceMBC As Integer, SourceStart As Integer, TargetMBC As Integer, TargetStart As Integer, BytesPerCycle As Integer, ReadSkip As Integer, WriteSkip As Integer, Iterations As Integer )
// XTCreateMeshMemblock( TriangleCount As Integer )
// XTSetMemblockVector( sourceMBC As Integer, Vector_Num As Integer, X1 As Float, Y1 As Float, Z1 As Float, Xn As Float, Yn As Float, Zn As Float, RGBColor As Integer, TU As Float, TV As Float )
// XTSetMemblockQuadVertex( sourceMBC As Integer, Tile As Integer, X1 As Float, Y1 As Float, Z1 As Float, X2 As Float, Y2 As Float, Z2 As Float, X3 As Float, Y3 As Float, Z3 As Float, X4 As Float, Y4 As Float, Z4 As Float )

/* ************************************************************************
 * @Description : Crée un nouveau bloc mémoire, réplique exacte du contenu du bloc source
 *
 * @Param : MemblockSource = Le bloc mémoire dont on veut réaliser une copier
 *
 * @Return : Target = Le nouveau bloc mémoire créé
 *
 * @Author : Frédéric Cordier
*/
Function XTCloneMemblock( MemblockSource As Integer )
	Target As Integer = 0 : NULL As Integer = 0
	If GetMemblockExists( MemblockSource ) = 1
		Size As Integer : Size = GetMemblockSize( MemblockSource )
		Target = CreateMemblock( Size )
		CopyMemblock( MemblockSource, Target, 0, 0, Size )
	EndIf
EndFunction Target

/* ************************************************************************
 * @Description : Créé un bloc mémoire formaté pour contenir des données d'images
 *
 * @Param : MWidth = La largeur en pixels d'une image que pourrait créer ce bloc mémoire
 * @Param : MHeight = La hauteur en pixels d'une image que pourrait créer ce bloc mémoire
 * @Param : MDepth = La profondeur (8, 16, 32 bits) de l'image que pourrait créer ce bloc mémoire
 *
 * @Return : MNumber = La bloc mémoire créé
 *
 * @Author : Frédéric Cordier
*/
Function XTCreateImageMemblock( MWidth As Integer, MHeight As Integer, MDepth As Integer )
	MNumber As Integer = 0 
	If MWidth > 0 And MHeight > 0
		FSize As Integer : FSize = 12 + ( MWidth * MHeight * ( MDepth / 8 ) )
		MNumber = CreateMemblock( FSize )
		SetMemblockInt( MNumber, 0, MWidth )
		SetMemblockInt( MNumber, 4, MHeight )
		SetMemblockInt( MNumber, 8, MDepth )
	EndIf
 EndFunction MNumber
 
/* ************************************************************************
 * @Description : Ecrit un pixel dans un bloc mémoire formaté pour contenir des données d'images
 *
 * @Param : MemblockID = La bloc mémoire dans lequel le pixel sera dessiné
 * @Param : XPos = La coordonnée d'abscisse (sur X) du pixel à écrire
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du pixel à écrire
 * @Param : Pixel = Le pixel au format RGBQ à écrire dans le bloc mémoire
 *
 * @Author : Frédéric Cordier
*/
Function XTWriteMemblockPixel( MemblockID As Integer, XPos As Integer, YPos As Integer, Pixel As Integer )
	If ( getMemblockExists( MemblockID ) = TRUE )
		//                  mbcPos = (            ImageWidthInPixels                * YPos ) + XPos ) * (            PixelLength              )
		mWidth As Integer : mWidth = XTGetMemblockImageWidth( MemblockID )
		mHeight As Integer : mHeight = XTGetMemblockImageHeight( MemblockID )
		mDepth As Integer : mDepth = XTGetMemblockImageDepth( MemblockID )
		mbcPos As Integer : mbcPos = 12 + ( ( mWidth * YPos ) + XPos ) * ( mDepth / 8 )
//		mbcPos As Integer : mbcPos = 12 + ( ( XTGetMemblockImageWidth( MemblockID ) * YPos ) + XPos ) * ( XTGetMemblockImageDepth( MemblockID ) / 8 )
		if XPos > -1 and XPos < mWidth and YPos > -1 and YPos < mHeight
			Select( getMemblockInt( MemblockID, 8 ) / 8 )
				Case 1
					Pixel = rangeByte( Pixel )
					SetMemblockByte( MemblockID, mbcPos, Pixel )
				EndCase
				Case 2
					Pixel = PKReverse16( Pixel )
					SetMemblockShort( MemblockID, mbcPos, Pixel && 65535 )
				EndCase
				Case 4
					cRed As Integer : cGreen As Integer : cBlue As Integer : cAlpha As Integer
					cRed = dbRGBAr( Pixel )
					cGreen = dbRGBAg( Pixel )
					cBlue = dbRGBAb( Pixel )
					cAlpha = dbRGBAa( Pixel )
					SetMemblockByte( MemblockID, mbcPos, cRed )
					SetMemblockByte( MemblockID, mbcPos+1, cGreen )
					SetMemblockByte( MemblockID, mbcPos+2, cBlue )
					SetMemblockByte( MemblockID, mbcPos+3, cAlpha )
				EndCase
			EndSelect
		Else
			Message( "eXtends Ver 2.0 Error : WriteMemblockPixel - Coordinates " + Str( XPos ) + ", " + Str( YPos ) + " ( = offset " + Str( mbcPos ) + " ) are out of memblock " + Str( MemblockID ) + " sizes ( " + Str( GetMemblockInt( MemblockID, 0 ) ) + ", " + Str( GetMemblockInt( MemblockID, 4 ) ) + " ) " )
		Endif
	Else
		Message( "eXtends Ver 2.0 Error : WriteMemblockPixel - Memblock " + Str( MemblockID ) + " does not exists" )
	Endif
EndFunction

/* ************************************************************************
 * @Description : Lit un pixel depuis un bloc mémoire formaté pour contenir des données d'images
 *
 * @Param : MemblockID = La bloc mémoire dans lequel le pixel sera lu
 * @Param : XPos = La coordonnée d'abscisse (sur X) du pixel à lire
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du pixel à lire
 *
 * @Return : Pixel = Le pixel au format RGBA à lire du bloc mémoire
 *
 * @Author : Frédéric Cordier
*/
Function XTReadMemblockPixel( MemblockID As Integer, XPos As Integer, YPos As Integer )
	Pixel As Integer = 0
	If ( getMemblockExists( MemblockID ) = TRUE )
		//                  mbcPos = (          ImageWidthInPixels                  * YPos ) + XPos ) * (            PixelLength              )
		mWidth As Integer : mWidth = XTGetMemblockImageWidth( MemblockID )
		mHeight As Integer : mHeight = XTGetMemblockImageHeight( MemblockID )
		mDepth As Integer : mDepth = XTGetMemblockImageDepth( MemblockID )
		mbcPos As Integer : mbcPos = 12 + ( ( mWidth * YPos ) + XPos ) * ( mDepth / 8 )
		if XPos > -1 and XPos < mWidth and YPos > -1 and YPos < mHeight
			Select( mDepth )
				Case 8
					Pixel = getMemblockByte( MemblockID, mbcPos )
					Pixel = rangeByte( Pixel )
				EndCase
				Case 16
					Pixel = getMemblockShort( MemblockID, mbcPos ) && 65535
					Pixel = PKReverse16( Pixel )
				EndCase
				Case 32
					cRed As Integer : cGreen As Integer : cBlue As Integer : cAlpha As Integer
					cRed = rangeByte( getMemblockbyte( MemblockID, mbcPos ) )
					cGreen = rangeByte( getMemblockbyte( MemblockID, mbcPos+1 ) )
					cBlue = rangeByte( getMemblockByte( MemblockID, mbcPos+2 ) )
					cALpha = rangeByte( getMemblockByte( MemblockID, mbcPos+3 ) )
					Pixel = dbrgbaex( cRed, cGreen, cBlue, cAlpha )
				EndCase
			EndSelect
		Else
			Message( "eXtends Ver 2.0 Error : ReadMemblockPixel - Coordinates " + Str( XPos ) + ", " + Str( YPos ) + " are out of memblock " + Str( MemblockID ) + " sizes ( " + Str( GetMemblockInt( MemblockID, 0 ) ) + ", " + Str( GetMemblockInt( MemblockID, 4 ) ) + " ) " )
		Endif
	Else
		Message( "eXtends Ver 2.0 Error : ReadMemblockPixel - Memblock " + Str( MemblockID ) + " does not exists" )
	Endif
EndFunction Pixel


Function XTGetMemblockImageWidth( MemblockID )
	rData As Integer = -1
	If ( getMemblockExists( MemblockID ) = TRUE )
		rData = getMemblockInt( MemblockID, 0 )
	Else
		Message( "eXtends Ver 2.0 Error : XTGetMemblockImageWidth - Memblock " + Str( MemblockID ) + " does not exists" )
	Endif
EndFunction rData

Function XTGetMemblockImageHeight( MemblockID )
	rData As Integer = -1
	If ( getMemblockExists( MemblockID ) = TRUE )
		rData = getMemblockInt( MemblockID, 4 )
	Else
		Message( "eXtends Ver 2.0 Error : XTGetMemblockImageHeight - Memblock " + Str( MemblockID ) + " does not exists" )
	Endif
EndFunction rData

Function XTGetMemblockImageDepth( MemblockID )
	rData As Integer = -1
	If ( getMemblockExists( MemblockID ) = TRUE )
		rData = getMemblockInt( MemblockID, 8 )
	Else
		Message( "eXtends Ver 2.0 Error : XTGetMemblockImageDepth - Memblock " + Str( MemblockID ) + " does not exists" )
	Endif
EndFunction rData


/* ************************************************************************
 * @Description : Copie un morceau d'image d'un bloc mémoire contenant des données d'image, dans un autre bloc mémoire contenant des données d'images
 *
 * @Param : SourceMBC = Bloc mémoire source contenant des données d'image
 * @Param : X = La coordonnée d'abscisse (sur X) du coin supérieur gauche du début de capture dans le bloc source
 * @Param : Y = La coordonnée d'ordonnée (sur Y) du coin supérieur gauche du début de capture dans le bloc source
 * @Param : Width = La largeur en pixels de la zone de capture dans le bloc mémoire source
 * @Param : Height = La heuteur en pixels de la zone de capture dans le bloc mémoire source
 * @Param: TargetMBC = Bloc mémoire cible contenant des données d'image
 * @Param : X2 = La coordonnée d'abscisse (sur X) du coin supérieur gauche du début d'écriture dans le bloc cible
 * @Param : Y2 = La coordonnée d'ordonnée (sur Y) du coin supérieur gauche du début d'écriture dans le bloc cible
 *
 * @Author : Frédéric Cordier
*/
Function XTCopyImageMemblock( SourceMBC As Integer, X As Integer, Y As Integer, Width As Integer, Height As Integer, TargetMBC As Integer, X2 As Integer, Y2 As Integer )
	If SourceMBC > 0 And TargetMBC > 0
		If GetMemblockExists( SourceMBC ) = 1 And GetMemblockExists( TargetMBC ) = 1
			// Data are created here because we create them only if everything is ok
			Reduce As Integer = 0
			XSize1 As Integer = 0 : YSize1 As Integer = 0 : Depth1 As Integer = 0
			XSize2 As Integer = 0 : YSize2 As Integer = 0 : Depth2 As Integer = 0
			BytesPerCycle As Integer = 0 
			ReadSkip As Integer = 0 : WriteSkip As Integer = 0
			SourcePTR As Integer = 0 : TargetPTR As Integer = 0
			// 
			XSize1 = GetMemblockInt( SourceMBC, 0 )
			YSize1 = GetMemblockInt( SourceMBC, 4 )
			Depth1 = GetMemblockInt( SourceMBC, 8 )
			XSize2 = GetMemblockInt( TargetMBC, 0 )
			YSize2 = GetMemblockInt( TargetMBC, 4 )
			Depth2 = GetMemblockInt( TargetMBC, 8 )
			If Width <= XSize1 And Width <= XSize2
				If Height <= YSize1 And Height <= YSize2
					// On checke si la zone à copier déborde du cadre ... Si c'est le cas, on réduit.
					If X < 0 : Width = Width + X : X = 0 : EndIf // Si X < 0 On réduit la 
					If Y < 0 : Height = Height + Y : Y = 0 : EndIf
					If X + Width > XSize1
						Reduce = ( X + Width ) - XSize1
						Width = Width - Reduce
					EndIf
					If Y + Height > YSize1
						Reduce = ( Y + Height ) - YSize1
						Height = Height - Reduce
					EndIf
					// On checke si la zone copiée sortira du cadre cible ... Si c'est le cas, on réduit.
					If X2 < 0 : X = X + X2 : Width = Width + X2 : X2 = 0 : EndIf
					If Y2 < 0 : Y = Y + Y2 : Height = Height + Y2 : Y2 = 0 : EndIf
					If X2 + Width > XSize2
						Reduce = ( X2 + Width ) - XSize2
						Width = Width - Reduce
					EndIf
					If Y2 + Height > YSize2
						Reduce = ( Y2 + Height ) - YSize2
						Height = Height - Reduce
					EndIf
					// On vérifie qu'après tout les checking, il reste un morceau de bloc à copier...
					If Width > 0 And Height > 0
						// On défini les variables nécessaires à la copie du bloc final nécessaire.
						BytesPerCycle = Width * 4              // Nombre d'octets à copier par lignes.
						ReadSkip = ( XSize1 - Width ) * 4      // Nombre d'octets à skipper par lignes.
						WriteSkip = ( XSize2 - Width ) * 4   // Nombre d'octets à skipper par lignes.
						SourcePTR = ( X * 4 ) + ( Y * XSize1 * 4 ) + 12
						TargetPTR = ( X2 * 4 ) + ( Y2 * XSize2 * 4 ) + 12
						XTCopyMemblockContent( SourceMBC, SourcePTR, TargetMBC, TargetPTR, BytesPerCycle, ReadSkip, WriteSkip, Height ) 
					EndIf
				EndIf
			EndIf
		Else
			Message( "eXtends Ver 2.0 Error :  XTCopyImageMemblock - One of the requested memblocks does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTCopyImageMemblock - Invalid memblocks numbers detected" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Redimensionne une image contenue dans un bloc mémoire, aux dimensions des données d'images d'un autre bloc mémoire
 *
 * @Param : SourceMBC = Bloc mémoire source contenant des données d'image
 * @Param : TargetMBC = Bloc mémoire cible contenant des données d'image
 *
 * @Author : Frédéric Cordier
*/
Function XTStretchImageMemblock( SourceMBC, TargetMBC )
	YLoop As Integer = 0 : XLoop As Integer = 0
	RGBColor As Integer = 0
	If SourceMBC > 0 And TargetMBC > 0
		If getMemblockExists( SourceMBC ) = 1 And getMemblockExists( TargetMBC ) = 1
			XSize1 As Integer = 0 : YSize1 As Integer = 0 : Depth1 As Integer = 0
			XSize2 As Integer = 0 : YSize2 As Integer = 0 : Depth2 As Integer = 0
			XScaling As Float = 0.0 : YScaling As Float = 0.0
			XSize1 = GetMemblockInt( SourceMBC, 0 )
			YSize1 = GetMemblockInt( SourceMBC, 4 )
			Depth1 = GetMemblockInt( SourceMBC, 8 )
			XSize2 = GetMemblockInt( TargetMBC, 0 )
			YSize2 = GetMemblockInt( TargetMBC, 4 )
			Depth2 = GetMemblockInt( TargetMBC, 8 )
			XScaling = XSize1 / XSize2
			YScaling = YSize1 / YSize2      
			For YLoop = 0 To YSize2 -1
				For XLoop = 0 To XSize2 -1
					RGBColor = XTReadMemblockPixel( SourceMBC, XLoop * XScaling, YLoop * YScaling )
					XTWriteMemblockPixel( TargetMBC, XLoop, YLoop, RGBColor )
				Next XLoop
			Next YLoop
		Else
			Message( "eXtends Ver 2.0 Error :  XTStretchImageMemblock - One of the requested memblocks does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTStretchImageMemblock - Invalid memblocks numbers detected" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Trace une boite (vide ou pleine) dans un bloc mémoire contenant des données d'image
 *
 * @Param : Memblock = Bloc mémoire contenant des données d'images
 * @Param : XPos = La coordonnée d'abscisse (sur X) du coin supérieur gauche du début de tracé dans le bloc
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du coin supérieur gauche du début de tracé dans le bloc
 * @Param : XPos = La coordonnée d'abscisse (sur X) du coin inférieur droit de la fin du tracé dans le bloc
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du coin inférieur droit de la fin du tracé dans le bloc
 * @Param : RGBColor = Couleur des pixels au format ARGB à utiliser pour tracer la boite
 * @Param : Mode = Mode de tracé de la boite : 0 = Vide, 1 = pleine
 *
 * @Author : Frédéric Cordier
*/
Function XTImageMemblockBox( Memblok As Integer, XPos As Integer, YPos As Integer, XRight As Integer, YDown As Integer, RGBColor As Integer, Mode As Integer )
	XLoop As Integer = 0 : YLoop As Integer = 0
	If Memblok > 0
		If getMemblockExists( Memblok ) = 1
			Select Mode
				Case 0
					For XLoop = Xpos To XRight
						XTWriteMemblockPixel( Memblok, XLoop, YPos, RGBColor )  // Top Line
						XTWriteMemblockPixel( Memblok, XLoop, YDown, RGBColor ) // Bottom Line
					Next XLoop
					For YLoop = YPos To YDown
						XTWriteMemblockPixel( Memblok, XPos, YLoop, RGBColor )   // Left Line
						XTWriteMemblockPixel( Memblok, XRight, YLoop, RGBColor ) // Right Line
					Next YLoop
				EndCase
				Case 1
					For XLoop = XPos To XRight
						For YLoop = YPos To YDown
							XTWriteMemblockPixel( Memblok, XLoop, YLoop, RGBColor )
						Next YLoop
					Next XLoop
				EndCase
			EndSelect
		Else
			Message( "eXtends Ver 2.0 Error :  XTBoxImageMemblock - One of the requested memblocks does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTBoxImageMemblock - Invalid memblocks numbers detected" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Trace un cube (vide ou plein) dans un bloc mémoire contenant des données d'image
 *
 * @Param : SourceMBC = Bloc mémoire contenant des données d'images
 * @Param : XPos = La coordonnée d'abscisse (sur X) du coin supérieur gauche du début de tracé dans le bloc
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du coin supérieur gauche du début de tracé dans le bloc
 * @Param : XYSize = Hauteur et largeur du cube à tracer dans le bloc
 * @Param : RGBColor = Couleur des pixels au format ARGB à utiliser pour tracer le cube
 * @Param : Mode = Mode de tracé du cube : 0 = Vide, 1 = pleine
 *
 * @Author : Frédéric Cordier
*/
Function XTImageMemblockCube( SourceMBC As Integer, XPos As Integer, YPos As Integer, XYSize As Integer, RGBColor As Integer, Mode As Integer )
	XYLoop As Integer = 0 : XLoop As Integer = 0 : YLoop As Integer = 0
	If SourceMBC > 0
		If getMemblockExists( SourceMBC ) = 1
			if XYSize < 1 or XYSize > GetMemblockInt( SourceMBC, 0 ) or XYSize > getMemblockInt( SourceMBC, 4 )
				If XYSize > 1
					Select Mode
						Case 0
							For XYLoop = XPos To XPos + XYSize - 1
								XTWriteMemblockPixel( SourceMBC, XYLoop, YPos, RGBColor ) // Top Line
								XTWriteMemblockPixel( SourceMBC, XPos, XYLoop, RGBColor ) // Left Line
								XTWriteMemblockPixel( SourceMBC, XYLoop, YPos + XYSize -1, RGBColor ) // Bottom Line
								XTWriteMemblockPixel( SourceMBC, XPos + XYSize -1, XYLoop, RGBColor ) // Right Line
							Next XYLoop
						EndCase
						Case 1
							For XLoop = XPos To XPos + XYSize -1
								For YLoop = YPos To YPos + XYSize -1
									XTWriteMemblockPixel( SourceMBC, XLoop, YLoop, RGBColor )
								Next YLoop
							Next XLoop
						EndCase
					EndSelect
				Else
					If XYSize = 1
						XTWriteMemblockPixel( SourceMBC, XPos, YPos, RGBColor )
					EndIf
				Endif
			Else
				Message( "eXtends Ver 2.0 Error :  XTImageMemblockCube - Requested Size " + Str( XYSize ) + "is out of Image Memblock allowed Sizes range" )
			EndIf
		Else
			Message( "eXtends Ver 2.0 Error :  XTImageMemblockCube - One of the requested memblocks does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTImageMemblockCube - Invalid memblocks numbers detected" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Trace un cercle (vide ou plein) dans un bloc mémoire contenant des données d'image
 *
 * @Param : SourceMBC = Bloc mémoire contenant des données d'images
 * @Param : XPos = La coordonnée d'abscisse (sur X) du centre du cercle tracé dans le bloc mémoire
 * @Param : YPos = La coordonnée d'ordonnée (sur Y) du centre du cercle tracé dans le bloc mémoire
 * @Param : Radius = Le rayon du cercle à tracer dans le bloc mémoire
 * @Param : RGBColor = Couleur des pixels au format ARGB à utiliser pour tracer le cube
 * @Param : Mode = Mode de tracé du cube : 0 = Vide, 1 = pleine
 *
 * @Author : Frédéric Cordier
*/
Function XTImageMemblockCircle( SourceMBC As Integer, XPos As Integer, YPos As Integer, Radius As Integer, RGBColor As Integer, Mode As Integer )
	Angle As Integer = 0
	XIn As Integer = 0 : YIn As Integer = 0
	Size As Float = 0.0
	AngleF As Float = 0.0
	If SourceMBC > 0
		If getMemblockExists( SourceMBC ) = 1
			If Radius > 0
				Select Mode
					Case 0
						For Angle = 0 To 360 Step 1
							XIn = Xpos + ( Cos( Angle ) * ( Radius / 2.0 ) )
							YIn = YPos + ( Sin( Angle ) * ( Radius / 2.0 ) )
							XTWriteMemblockPixel( SourceMBC, XIn, YIn, RGBColor )
						Next Angle
					EndCase
					Case 1
						Size = Radius
						Repeat
							AngleF = 0.0
							Repeat
								XIn = XPos + ( Cos( AngleF ) * ( Size / 2.0 ) )
								YIn = YPos + ( Sin( AngleF ) * ( Size / 2.0 ) )
								XTWriteMemblockPixel( SourceMBC, XIn, YIn, RGBColor )
								AngleF = AngleF + 0.5
							Until AngleF > 360.0
							Size = Size - 0.5
						Until Size = 0
						XTWriteMemblockPixel( SourceMBC, XPos, YPos, RGBColor )
					EndCase
				EndSelect
			EndIf
		Else
			Message( "eXtends Ver 2.0 Error :  XTImageMemblockCube - One of the requested memblocks does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTImageMemblockCube - Invalid memblocks numbers detected" )
	EndIf
 EndFunction

/* ************************************************************************
 * @Description : Copie des données présentes dans un bloc mémoire, vers un autre bloc mémoire
 *
 * @Param : SourceMBC = Bloc mémoire source (Lecture)
 * @Param : SourceStart = Offset de départ (depuis le début du bloc mémoire) de la copie dans le bloc mémoire source
 * @Param : TargetMBC = Blos mémoire cible (Ecriture)
 * @Param : TargetStart = Offset de départ (depuis le début du bloc mémoire) de la copie dans le bloc mémoire cible
 * @Param : BytesPerCucle = Nombre d'octets à copier par bloc de copies
 * @Param : ReadSkip = Nombre d'octets à sauter dans le bloc mémoire source entre deux blocs de copies
 * @Param : WriteSkip = Nombre d'octets à sauter dans le bloc mémoire cible entre deux blocs de copies
 * @Param : Iterations = Nombre de blocs de copies (lignes) à exécuter
 *
 * @Author : Frédéric Cordier
*/
Function XTCopyMemblockContent( SourceMBC As Integer, SourceStart As Integer, TargetMBC As Integer, TargetStart As Integer, BytesPerCycle As Integer, ReadSkip As Integer, WriteSkip As Integer, Iterations As Integer )
	copyMode As Integer = 0
	iLoop As Integer = 0 : bpcLoop As Integer = 0              // Iteractions & BytesPerCycle loops.
	readData As Integer = 0
	SourcePos As Integer : SourcePos = SourceStart
	TargetPos As Integer : TargetPos = TargetStart
	If SourceMBC > 0 And TargetMBC > 0
		If GetMemblockExists( SourceMBC ) = 1 And GetMemblockExists( TargetMBC ) = 1
		// Check for the best copy method Integer, Word or Byte
		if ( BytesPerCycle && 0xFFFFFFFC ) = BytesPerCycle
			copyMode = 4
		ElseIf ( BytesPerCycle && 0xFFFFFFFE ) = BytesPerCycle
			copyMode = 2
		Else
			copyMode = 1
		Endif
		for iLoop = 0 to Iterations -1 step 1
			For bpcLoop = 0 to BytesPerCycle -1 Step copyMode
				Select copyMode
					Case 1
						readData = getMemblockByte( SourceMBC, SourcePos )
						setMemblockByte( TargetMBC, TargetPos, readData )
					EndCase
					Case 1
						readData = getMemblockShort( SourceMBC, SourcePos )
						setMemblockShort( TargetMBC, TargetPos, readData )
					EndCase
					Case 4
						readData = getMemblockInt( SourceMBC, SourcePos )
						setMemblockInt( TargetMBC, TargetPos, readData )
					EndCase
				EndSelect
				SourcePos = SourcePos + copyMode
				TargetPos = TargetPos + copyMode
			Next bpcLoop
			SourcePos = SourcePos + ReadSkip
			TargetPos = TargetPos + WriteSkip
		Next iLoop
		Else
			Message( "eXtends Ver 2.0 Error :  XTCopyImageMemblock - One of the requested memblocks does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTCopyImageMemblock - Invalid memblocks numbers detected" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Créé un bloc mémoire prévu pour contenir des données de Meshs
 *
 * @Param : TriangleCount = Nombre de triangles (vecteurs) que le bloc mémoire peut contenir
 *
 * @Return : MemblockNumber = Index du bloc mémoire créé
 *
 * @Author : Frédéric Cordier
*/
Function XTCreateMeshMemblock( TriangleCount As Integer )
	Size As Integer
	MemblockNumber As Integer 
	Size = ( ( 36 * 3 ) * TriangleCount ) + 16
	MemblockNumber = CreateMemblock( Size )
	// Définition du format FVF
	SetMemblockInt( MemblockNumber , 0 , 338 )
	// Définition de la longueur d'un Vertex
	SetMemblockInt( MemblockNumber , 4 , 36 )
	// Combien de sommets ( = Vertex = Vertices ) sont présents ?
	SetMemblockInt( MemblockNumber , 8 , TriangleCount )
EndFunction MemblockNumber

/* ************************************************************************
 * @Description : Définit un vertex dans un bloc mémoire formatté pour contenir des données de Meshs
 *
 * @Param : sourceMBC = Bloc mémoire dans lequel les modifications vont être apportées
 * @Param : Vector_Num = Numéro d'index du vertex à modifier dans le bloc mémoire
 * @Param : X1 = Nouvelle coordonnée sur X du vertex
 * @Param : Y1 = Nouvelle coordonnée sur Y du vertex
 * @Param : Z1 = Nouvelle coordonnée sur Z du vertex
 * @Param : Xn = Nouvelle valeur de normale sur X du vertex
 * @Param : Yn = Nouvelle valeur de normale sur Y du vertex
 * @Param : Zn = Nouvelle valeur de normale sur Z du vertex
 * @Param : RGBColor = Couleur du vertex au format ARGB à utiliser
 * @Param : TU = Coordonnée de textura sur X au niveau du vertex
 * @Param : TV = Coordonnée de textura sur X au niveau du vertex
 *
 * @Author : Frédéric Cordier
*/
Function XTSetMemblockVector( sourceMBC As Integer, Vector_Num As Integer, X1 As Float, Y1 As Float, Z1 As Float, Xn As Float, Yn As Float, Zn As Float, RGBColor As Integer, TU As Float, TV As Float )
	If sourceMBC > 0
		If GetMemblockExists( sourceMBC ) = 1
			InPos As Integer
			InPos = 12 + ( Vector_Num * 36 )
			if ( inPos + 36 ) <= getMemblockSize( sourceMBC )  
				SetMemblockFloat( sourceMBC, InPos, X1 )
				SetMemblockFloat( sourceMBC, InPos + 4, Y1 )
				SetMemblockFloat( sourceMBC, InPos + 8, Z1 )
				SetMemblockFloat( sourceMBC, InPos + 12, Xn )
				SetMemblockFloat( sourceMBC, InPos + 16, Yn )
				SetMemblockFloat( sourceMBC, InPos + 20, Zn )
				SetMemblockFloat( sourceMBC, InPos + 24, RGBColor )
				SetMemblockFloat( sourceMBC, InPos + 28, TU )
				SetMemblockFloat( sourceMBC, InPos + 32, TV )
			Else
				Message( "eXtends Ver 2.0 Error :  XTSetMemblockVector - The requested vector is out of memblock range/size" )
			Endif
		Else
			Message( "eXtends Ver 2.0 Error :  XTSetMemblockVector - The requested memblock does not exist" )
		EndIf
	Else
		Message( "eXtends Ver 2.0 Error :  XTSetMemblockVector - Invalid memblock number detected" )
	EndIf
EndFunction

/* ************************************************************************
 * @Description : Définit un Quad (4 points, 4 côtés) dans un bloc mémoire formatté pour contenir des données de Meshs
 *
 * @Param : sourceMBC = Bloc mémoire dans lequel les modifications vont être apportées
 * @Param : Vector_Num = Numéro d'index du vecteur à modifier dans le bloc mémoire
 * @Param : X1 = Nouvelle coordonnée sur X du vertex 1 du Quad
 * @Param : Y1 = Nouvelle coordonnée sur Y du vertex 1 du Quad
 * @Param : Z1 = Nouvelle coordonnée sur Z du vertex 1 du Quad
 * @Param : X2 = Nouvelle coordonnée sur X du vertex 2 du Quad
 * @Param : Y2 = Nouvelle coordonnée sur Y du vertex 2 du Quad
 * @Param : Z2 = Nouvelle coordonnée sur Z du vertex 2 du Quad
 * @Param : X3 = Nouvelle coordonnée sur X du vertex 3 du Quad
 * @Param : Y3 = Nouvelle coordonnée sur Y du vertex 3 du Quad
 * @Param : Z3 = Nouvelle coordonnée sur Z du vertex 3 du Quad
 * @Param : X4 = Nouvelle coordonnée sur X du vertex 4 du Quad
 * @Param : Y4 = Nouvelle coordonnée sur Y du vertex 4 du Quad
 * @Param : Z4 = Nouvelle coordonnée sur Z du vertex 4 du Quad
 *
 * @Author : Frédéric Cordier
*/
Function XTSetMemblockQuadVertex( sourceMBC As Integer, Tile As Integer, X1 As Float, Y1 As Float, Z1 As Float, X2 As Float, Y2 As Float, Z2 As Float, X3 As Float, Y3 As Float, Z3 As Float, X4 As Float, Y4 As Float, Z4 As Float )
	Vector_Number As Integer
	_Nk As Integer
	Vector_Number = Tile * 6
	_Nk = ( 255+65536 ) + (255*256 ) + 255
	XTSetMemblockVector( sourceMBC, Vector_Number + 0, X3, Y3, Z3, 0.000 , 1.000 , 0.000 , _Nk , 0.000 , 1.000 )
	XTSetMemblockVector( sourceMBC, Vector_Number + 1, X2, Y2, Y2, 0.000 , 1.000 , 0.000 , _Nk , 1.000 , 0.000 )
	XTSetMemblockVector( sourceMBC, Vector_Number + 2, X4, Y4, Y4, 0.000 , 1.000 , 0.000 , _Nk , 1.000 , 1.000 )
	XTSetMemblockVector( sourceMBC, Vector_Number + 3, X3, Y3, Y3, 0.000 , 1.000 , 0.000 , _Nk , 0.000 , 1.000 )
	XTSetMemblockVector( sourceMBC, Vector_Number + 4, X1, Y1, Y1, 0.000 , 1.000 , 0.000 , _Nk , 0.000 , 0.000 )
	XTSetMemblockVector( sourceMBC, Vector_Number + 5, X2, Y2, Y2, 0.000 , 1.000 , 0.000 , _Nk , 1.000 , 0.000 )
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
Function XTGetImageMemblockWidth( sourceMBC As Integer )
	outputData As Integer = -1
	if getMemblockExists( sourceMBC ) = TRUE
		outputData = GetMemblockInt( SourceMBC, 0 )
	Else
		Message( "XTGetImageMemblockWidth Error : The memblock '" + Str( sourceMBC ) + "' is invalid or memblock does not exists." )
	Endif
EndFunction outputData

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
Function XTGetImageMemblockHeight( sourceMBC As Integer )
	outputData As Integer = -1
	if getMemblockExists( sourceMBC ) = TRUE
		outputData = GetMemblockInt( SourceMBC, 4 )
	Else
		Message( "XTGetImageMemblockHeight Error : The memblock '" + Str( sourceMBC ) + "' is invalid or memblock does not exists." )
	Endif
EndFunction outputData

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
Function XTGetImageMemblockDepth( sourceMBC As Integer )
	outputData As Integer = -1
	if getMemblockExists( sourceMBC ) = TRUE
		outputData = GetMemblockInt( SourceMBC, 8 )
	Else
		Message( "XTGetImageMemblockDepth Error : The memblock '" + Str( sourceMBC ) + "' is invalid or memblock does not exists." )
	Endif
EndFunction outputData
