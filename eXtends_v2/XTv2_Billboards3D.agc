//
// ********************************************************
// *                                                      *
// * eXtends Ver 2.0 Include File : Billboards 3D methods *
// *                                                      *
// ********************************************************
// Start Date : 2019.05.23 22:46
// Description : This class will contain basic Billboards 3D methods
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
Function XTAddObjectToBillboard3DEx( ObjectNumber As Integer, zRoll As Integer )
	if getObjectExists( ObjectNumber ) = TRUE and XTGetObjectInBillboard3DList( ObjectNumber ) = -1
		newBillboard As Billboard3D_Type
		newBillboard.ObjectID = ObjectNumber
		newBillboard.zRoll = zRoll
		Billboard3D.insert( newBillboard )
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
Function XTAddObjecttoBillboard3D( ObjectNumber As Integer )
	XTAddObjecttoBillboard3DEx( ObjectNumber, 0 )
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
Function XTGetObjectInBillboard3DList( ObjectNumber As Integer )
	inPos As Integer = -1
	if Billboard3D.length > -1
		bLoop As Integer = 0
		Repeat
			if Billboard3D[ bLoop ].ObjectID = ObjectNumber then inPos = bLoop
			Inc bLoop, 1
		Until bLoop > Billboard3D.Length or inPos > -1
	Endif
EndFunction inPos

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
Function XTRemoveObjectFromBillboard3DList( ObjectNumber As Integer )
	inPos As Integer = -1
	inPos = XTGetObjectInBillboard3DList( ObjectNumber )
	if inPos > -1 then Billboard3D.remove( inPos )
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
Function XTSetBillboard3DYRotation( ObjectNumber As Integer, zRoll As Integer )
	inPos As Integer = -1
	inPos = XTGetObjectInBillboard3DList( ObjectNumber )
	if inPos > -1 then Billboard3D[ inPos ].zRoll = zRoll // Reverse to DisableYRotationMode flag
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
Function XTEnableBillboard3DYRotation( ObjectNumber As Integer )
	XTSetBillboard3DYRotation( ObjectNumber, TRUE )
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
Function XTDisableBillboard3DYRotation( ObjectNumber As Integer )
	XTSetBillboard3DYRotation( ObjectNumber, FALSE )
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
Function XTUpdateAllBillboard3DObjects()
	if Billboard3D.length > -1
		xPos As Integer : xPos = GetCameraX( 1 )
		yPos As Integer : yPos = GetCameraY( 1 )
		zPos As Integer : zPos = GetCameraZ( 1 )
		xLoop As Integer
		for xLoop = 0 to Billboard3D.length
			SetObjectLookAt( Billboard3D[ xLoop ].ObjectID, xPos, yPos, zPos, Billboard3D[ xLoop ].zRoll )
		Next xLoop
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
Function XTClearBillboard3DList()
	if Billboard3D.length > -1
		bbLoop As Integer
		for bbLoop = Billboard3D.length to 0 step -1
			Billboard3D.remove( bbLoop )
		Next bbLoop
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
Function XTGetBillboardCount()
EndFunction Billboard3D.length
