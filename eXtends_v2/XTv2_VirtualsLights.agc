//
// **********************************************************
// *                                                        *
// * eXtends Ver 2.0 Include File : Virtuals Lights Methods *
// *                                                        *
// **********************************************************
// Start Date : 2019.12.13 22:52
// Description : These methods will add virtuals lights system
//
// Author : Frédéric Cordier
//

// **************************************************************
Function XYSetVisibilityDistance( Distance As Float )
	VisibilityDistance = Distance
EndFunction

// **************************************************************
Function XTGetVisibilityDistance()
 EndFunction VisibilityDistance

// **************************************************************
Function XTSetDisplayCamera( CameraNumber As Integer )
	If CameraNumber > 0
		VisibilityCam = CameraNumber
	EndIf
EndFunction

// **************************************************************
Function XTGetDisplayCamera()
EndFunction VisibilityCam

// **************************************************************
Function XTAddVirtualLight( Name As String, XPos As Float, YPos As Float, ZPos As Float, Rayon As Float, Red As Integer, Green As Integer, Blue As Integer, lightType As Integer )
	virtualLight As VLightsStruct_Type
	virtualLight.Name = Name
	virtualLight.XPos = XPos
	virtualLight.YPos = YPos
	virtualLight.ZPos = ZPos
	virtualLight.Range = Rayon
	virtualLight.Red = Red
	virtualLight.Green = Green
	virtualLight.Blue = Blue
	virtualLight.lightType = lightType
	virtualLight.Active = 1
	VLights.insert( virtualLight )
EndFunction VLights.length

// **************************************************************
function XTgetVirtualLightExists( lightID As Integer )
	isExist As Integer = 0
	if lightID > -1 and lightID < VLights.length then isExist = 1
EndFunction isExist

// **************************************************************
Function XTDeleteVirtualLight( lightID As Integer )
	if XTgetVirtualLightExists( lightID ) = 1
		VLights.remove( lightID )
	Else
		Message( "PluginKIT XT : Requested virtual light does not exist" )
	Endif
EndFunction

// **************************************************************
Function XTSetVirtualLightPosition( lightID As Integer, XPos As Float, YPos As Float, ZPos As Float )
	If XTgetVirtualLightExists( lightID ) = 1
		VLights[ lightID ].XPos = XPos
		VLights[ lightID ].YPos = YPos
		VLights[ lightID ].ZPos = ZPos
	Else
		Message( "PluginKIT XT : Requested virtual light does not exist" )
	EndIf
EndFunction

// **************************************************************
Function XTSetVirtualLightRange( lightID As Integer, Rayon As Float )
	If XTgetVirtualLightExists( lightID ) = 1
		VLights[ lightID ].Range = Rayon
	Else
		Message( "PluginKIT XT : Requested virtual light does not exist" )
	EndIf
EndFunction

// **************************************************************
Function XTSetVirtualLightColor( lightID As Integer, Red As Integer, Green As Integer, Blue As Integer )
	If XTgetVirtualLightExists( lightID ) = 1
		VLights[ lightID ].Red = Red
		VLights[ lightID ].Green = Green
		VLights[ lightID ].Blue = Blue
	Else
		Message( "PluginKIT XT : Requested virtual light does not exist" )
	EndIf
EndFunction
// **************************************************************
Function XTSetVirtualLightHalo( lightID As Integer, HaloImage As Integer )
	If XTgetVirtualLightExists( lightID ) = 1
		If HaloImage > 0
			If GetImageExists( HaloImage ) = 1
				VLights[ lightID ].Halo = HaloImage
			Else
				Message( "PluginKIT XT : The specified Halo image ID does not exists" )
				VLights[ lightID ].Halo = 0
			EndIf
		Else
			Message( "PluginKIT XT : The specified Halo image ID is invalid" )
			VLights[ lightID ].Halo = 0
		EndIf
	Else
		Message( "PluginKIT XT : Requested virtual light does not exist" )
	EndIf
EndFunction

// **************************************************************
Function XTRemoveVirtualLightHalo( lightID As Integer )
	If XTgetVirtualLightExists( lightID ) = 1
		VLights[ lightID ].Halo = 0
	Else
		Message( "PluginKIT XT : Requested virtual light does not exist" )
	EndIf
EndFunction
	
