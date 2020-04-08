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
Function getDotDistance( XP1 As Float, YP1 As Float, ZP1 As Float, XC1 As Float, YC1 As Float, ZC1 As Float )
	Vect1 As Integer : Vect1 = CreateVector3( XP1, YP1, ZP1 )
	Vect2 As Integer : Vect2 = CreateVector3( XC1, YC1, ZC1 )
	Distance As Float : Distance = GetVector3Distance( Vect1, Vect2 )
	DeleteVector3( Vect1 )
	DeleteVector3( Vect2 )
EndFunction Distance

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
Function getObjectToCameraDistance( Obj As Integer, Cmr As Integer )
	distance As Float = -1.0
	if getObjectExists( Obj ) = TRUE
		distance = getDotDistance( getCameraX( Cmr ), getCameraY( Cmr ), getCameraZ( Cmr ), getObjectX( Obj ), getObjectY( Obj ), getObjectZ( Obj ) )
	Endif
EndFunction distance

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
Function getObjectsDistance( Obj1 As Integer, Obj2 As Integer )
	distance As Float = -1.0
	if getObjectExists( Obj1 ) = TRUE and getObjectExists( Obj2 ) = TRUE
		distance = getDotDistance( getObjectX( Obj1 ), getObjectY( Obj1 ), getObjectZ( Obj1 ), getObjectX( Obj2 ), getObjectY( Obj2 ), getObjectZ( Obj2 ) )
	Endif
EndFunction distance

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
Function getPointToObjectDistance( X As Float, Y As Float, Z As Float, Obj As Integer )
	distance As Float = -1.0
	if getObjectExists( Obj ) = TRUE
		distance = getDotDistance( X, Y, Z, getObjectX( Obj ), getObjectY( Obj ), getObjectZ( Obj ) )
	Endif
EndFunction distance
	

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
Function getPointToCameraDistance( X As Float, Y As Float, Z As Float, Cmr As Integer )
	distance As Float = -1.0
	distance = getDotDistance( X, Y, Z, getCameraX( Cmr ), getCameraY( Cmr ), getCameraZ( Cmr ) )
EndFunction distance
