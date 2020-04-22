



Function PKGetQuantity( STRI As String, CHAR As String )
  Retour As Integer
  If Len( STRI ) = 0
    Retour = 0
   Else
    Retour = 0 : InPOS As Integer = 1
    Repeat
      If Mid( STRI, InPOS, 1 ) = CHAR : Retour = Retour + 1 : EndIf
      InPOS = InPOS + 1
     Until InPOS > Len( STRI )
   EndIf
 EndFunction Retour

Function PKFullUpdate( WithSync As Integer )
	PKSetup.PreviousTimer = PKSetup.NewTimer
	PKSetup.NewTimer = Timer() * 1000
	PKSetup.rZoom = TRUE
	internalAdaptDisplay( TRUE )
	if XParticle.length > -1 Then XTUpdateXParticles()
	if RTSSystem.Initialized = TRUE then XTRTSUpdate()
	if PKAnimations.length > -1 then PKUpdateAnimations() // Update the player animation
	if P2DLights.length > -1 Then internalPKUpdateLightsEffects()
	If PKLayer.length > -1 Then PKTraceAllLayers()   // Draw all layers
	dbRefresh()          // Call other refresh (dbPrint)
	PKSetup.rZoom = FALSE
	if WithSync = TRUE then Sync()

EndFunction

Function DebugMessage( MessageToOutput As String )
	if PKSetup.DebugMode = TRUE
		Message( MessageToOutput )
	Endif
EndFunction

Function DebugText( MessageToOutput As String )
	dbPrint( "dbg:" + MessageToOutput ) 
EndFunction

Function CastError( MessageToOutput As String )
	Message( MessageToOutput )
	End
EndFunction

Function PKSetVirtualResolution( Width As Integer, Height As Integer )
	SetVirtualResolution( Width, Height )
	PKSetup.VWidth = Width
	PKSetup.VHeight = Height
	xZoom As Float : yZoom As Float
	xZoom = PKSetup.WWidth / PKSetup.VWidth
	yZoom = PKSetup.WHeight / PKSetup.VHeight
	if xZoom > yZoom then xZoom = yZoom
	PKSetup.zFactor = xZoom

EndFunction

Function PKSetWindowSize( Width As Integer, Height As Integer, isFullScreen As Integer )
	SetWindowSize( Width, Height, isFullScreen )
	PKSetup.WWidth = Width
	PKSetup.WHeight = Height
EndFunction

/* ************************************************************************
 * @Description : 
*/
Function internalAdaptDisplay( withUpdateView As Integer )
	// Refresh display sizes and calculate best zoom factor to keep original virtual width aspect ratio.
	PKSetup.vWidth = getVirtualWidth()
	PKSetup.vHeight = getVirtualHeight()
	PKSetup.wWidth = GetWindowWidth()
	PKSetup.wHeight = getWindowHeight()
	xZoom As Float : yZoom As Float
	xZoom = PKSetup.WWidth / ( PKSetup.VWidth * 1.00 ) // To force floating point number calculations
	yZoom = PKSetup.WHeight / ( PKSetup.VHeight * 1.00 ) // to force floating point number calculation.
	if xZoom > yZoom then xZoom = yZoom
	PKSetup.zFactor = xZoom
	XShift2 As Float : XShift2 = ( PKSetup.WWidth - ( PKSetup.vWidth * PKSetup.zFactor ) ) / 1024
	YShift2 As Float : YShift2 = ( PKSetup.WHeight - ( PKSetup.vHeight * PKSetup.zFactor ) ) / 1024
	if withUpdateView = TRUE
		SetScissor( XShift2, YShift2, PKSetup.vWidth, PKSetup.vHeight )
		SetViewOffset( 0 - XShift2, 0 - YShift2 )
	Endif
EndFunction

Function advSetScissor( cLeft As Integer, cTop As Integer, cRight As Integer, cBottom As Integer )
	if cRight = 0 then cRight = PKSetup.vWidth
	if cBottom = 0 then cBottom = PKSetup.vHeight
	dispWidth As Integer : dispWidth = cRight - cLeft
	dispHeight As Integer : dispHeight = cBottom - cTop
	XShift2 As Float : XShift2 = ( PKSetup.WWidth - ( dispWidth * PKSetup.zFactor ) ) / 1024
	YShift2 As Float : YShift2 = ( PKSetup.WHeight - ( dispWidth * PKSetup.zFactor ) ) / 1024
	SetScissor( XShift2, YShift2, cRight, cBottom )
	SetViewOffset( 0 - XShift2, 0 - YShift2 )
EndFunction

