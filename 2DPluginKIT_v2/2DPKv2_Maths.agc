//
// ******************************************************
// *                                                    *
// * eXtends Ver 2.0 Include File : Mathematics methods *
// *                                                    *
// ******************************************************
// Start Date : 2019.04.23 23:15
// Description : This class will contain mathematics methods
// 
// Author : Frédéric Cordier
//
/* ************************************************************************
 * @Description : Renvoie le signe d'un nombre flottant
 *
 * @Param : Value = Le nombre flottant à analyser
 *
 * @Return : -1 si le signe es négatif, +1 si le signe est positif, 0 si le nombre flottant est égale à 0
 *
 * @Author : Frédéric Cordier
*/
Function Sign( Value As Float )
	Retour As Float : Retour = 0.0
	if Value < 0.0 then Retour = -1.0
	if Value > 0.0 then Retour = 1.0 
 EndFunction Retour

/* ************************************************************************
 * @Description : Transform a degree angle to radian one
 *
 * @Param : Angle = The degree angle value
 *
 * @Return : AngleFinal = The radian angle value
 *
 * @Author : Frédéric Cordier
*/
Function Deg2Rad( Angle As Float )
	AngleFinal As Float
	AngleFinal = ( Angle * 3.1415 ) / 180.0
EndFunction AngleFinal

/* ************************************************************************
 * @Description : ransform a radian angle to degree one
 *
 * @Param : Angle = The radian angle value
 *
 * @Return : AngleFinal = The degree angle value
 *
 * @Author : Frédéric Cordier
*/
Function Rad2Deg( Angle As Float )
	AngleFinal As Float
	AngleFinal = ( Angle * 180.0 ) / 3.1415
EndFunction AngleFinal

/* ************************************************************************
 * @Description : Calculate 3D Distance between 2 dots using x,y,z coordinates
 *
 * @Param : X1, Y1, Z1 = The 3D coordinates of the 1st 3D dot
 * @Param : X2, Y2, Z2 = The 3D coordinates of the 2nd 3D dot
 *
 * @Return : Distance = the distance between the two 3D dots
 *
 * @Author : Frédéric Cordier
*/
Function GetDotsDistance3D( X1 As Float, Y1 As Float, Z1 As Float, X2 As Float, Y2 As Float, Z2 As Float )
	XDist As Float : XDist = X1 - X2
	YDist As Float : YDist = Y1 - Y2
	ZDist As Float : ZDist = Z1 - Z2
	Dist As Float : Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) + ( ZDist*ZDist ) )
EndFunction Dist

/* ************************************************************************
 * @Description : Calculate 2D Distance between 2 dots using x,y coordinates
 *
 * @Param : X1, Y1 = The 2D coordinates of the 1st 2D dot
 * @Param : X2, Y2 = The 2D coordinates of the 2nd 2D dot
 *
 * @Return : Distance = the distance between the two 2D dots
 *
 * @Author : Frédéric Cordier
*/
Function GetDotsDistance2D( X1 As Float, Y1 As Float, X2 As Float, Y2 As Float )
	XDist As Float : XDist = X1 - X2 
	YDist As Float : YDist = Y1 - Y2 
	Dist As Float : Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) )
EndFunction Dist

/* ************************************************************************
 * @Description : Calculate the minimal distance between two sprites
 *
 * @Param : Sprite1 = The 1st sprite
 * @Param : Sprite2 = The 2nd sprite
 *
 * @Return : sDistance = The distance between the two sprites
 *
 * @Author : Frédéric Cordier
*/
Function getSpritesDistance( Sprite1 As Integer, Sprite2 As Integer )
	sDistance As Integer = -1
	if getSpriteExists( Sprite1 ) and getSpriteExists( Sprite2 )
		xp1 As Integer : xp1 = GetSpriteX( Sprite1 )
		yp1 As Integer : yp1 = GetSpriteY( Sprite1 )
		xsize1 As Integer : xsize1 = GetSpriteWidth( Sprite1 )
		ysize1 As Integer : ysize1 = GetSpriteHeight( Sprite1 )
		xp2 As Integer : xp2 = GetSpriteX( Sprite2 )
		yp2 As Integer : yp2 = GetSpriteY( Sprite2 ) 
		xsize2 As Integer : xsize2 = GetSpriteWidth( Sprite2 )
		ysize2 As Integer : ysize2 = GetSpriteHeight( Sprite2 )
		If xp1 < xp2
			xp1 = xp1 + xsize1 : If xp1 > xp2 : xp1 = xp2 : EndIf
		Else
			xp2 = xp2 + xsize2 : If xp2 > xp1 : xp2 = xp1 : EndIf
		EndIf
		If yp1 < yp2
			yp1 = yp1 + ysize1 : If yp1 > yp2 : yp1 = yp2 : EndIf
		Else
			yp2 = yp2 + ysize2 : If yp2 > yp1 : yp2 = yp1 : EndIf
		EndIf
		sDistance = getDotsDistance2D( xp1, yp1, xp2, yp2 )
	Endif
EndFunction sDistance


Function PKReverse32( Value As Integer )
	b1 As Integer : b2 As Integer : b3 As Integer : b4 As Integer
	b1 = ( Value && 0xFF000000 ) / 16777216
	b2 = ( Value && 0xFF0000 ) / 256
	b3 = ( Value && 0xFF00 ) * 256 
	b4 = ( Value && 0xFF ) * 16777216
	final As Integer
	final = b1 || b2 || b3 || b4
EndFunction final

Function PKReverse16( Value As Integer )
	b1 As Integer : b2 As Integer
	b1 = ( Value && 0xFF00 ) / 256 
	b2 = ( Value && 0xFF ) * 256
	final As Integer
	final = b1 || b2
EndFunction final
