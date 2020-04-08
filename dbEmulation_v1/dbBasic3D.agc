
/* ************************************************************************
 * @Description : Try to emulate the DarkBASIC Professionals "Fade Object" command
 *
 * @Param : ObjectID = the index number of the 3D object on which the fade effect will be achieved
 *
 * @Author : Frédéric Cordier
*/
Function dbFadeObject( ObjectID As Integer, FadeValue As Integer )
	SetObjectColor( ObjectID, FadeValue, FadeValue, FadeValue, 255 )
EndFunction


/* ************************************************************************
 * @Description : Try to emulate parts of the DarkBASIC Professionals "Set Object" command
 *
 * @Param : ObjectID = the index number of the 3D object on which the fade effect will be achieved
 * @Param : WireFrame = TRUE to display the model as wireframe (not available)
 * @Param : TranspMode = use SetObjectTransparency to set transparency mode
 * @Param : Culling = 0 for all faces, 1 only front faces, 2 = only back faces
 * @Param : Filter = TRUE to set filtering textures (not available)
 * @Param : LightSensor = TRUE to makes object sensible to lights
 * @Param : FogSensor = TRUE to makes object sensible to fog
 * @Param : AmbientSensor = TRUE to makes object sensible to the ambient light 0 (not available)
 *
 * @Author : Frédéric Cordier
*/
Function dbSetObject4( ObjectID As Integer, Wire As Integer, TranspMode As Integer, Culling As Integer, Filter As Integer, LightSensor As Integer, FogSensor As Integer, AmbientSensor As Integer )
	if ( GetObjectExists( ObjectID ) = 1 )
		
		SetObjectTransparency( ObjectID, TranspMode ) // -> SetObjectBlendMode()
		SetObjectCullMode( ObjectID, Culling )
		// SetObjectFilter( ObjectID, Filter ) does not exists
		SetObjectLightMode( ObjectID, LightSensor )
		SetObjectFogMode( ObjectID, FogSensor )
		// SetObjectAmbient( ObjectID, AmbientSensor ) does not exist
	Endif
EndFunction

/* ************************************************************************
 * @Description : Emulate the DarkBASIC Professional command "Disable Object ZWrite" using SetObjectDepthWrite
 *
 * @Param : ObjectID = the index number of the 3D object on which the fade effect will be achieved
 *
 * @Author : Frédéric Cordier
*/
Function dbDisableObjectZWrite( ObjectID As Integer )
	SetObjectDepthWrite( ObjectID, 0 )
EndFunction

/* ************************************************************************
 * @Description : Try to emulate the DarkBASIC Professional command "Ghost Object On"
 *
 * @Param : ObjectID = the index number of the 3D object on which the fade effect will be achieved
 *
 * @Author : Frédéric Cordier
*/
Function DBGhostObjectOn( ObjectID )
	SetObjectTransparency( ObjectID, 3 )
	SetObjectBlendModes( ObjectID, 2, 3 )
	SetObjectalpha( ObjectID, 128 )
EndFunction

/* ************************************************************************
 * @Description : Try to emulate the DarkBASIC Professional command "Ghost Object Off"
 *
 * @Param : ObjectID = the index number of the 3D object on which the fade effect will be achieved
 *
 * @Author : Frédéric Cordier
*/
Function DBGhostObjectOff( ObjectID )
	SetObjectTransparency( ObjectID, 0 )
	SetObjectalpha( ObjectID, 255 )
EndFunction
