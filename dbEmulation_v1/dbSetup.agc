//
// ******************************************************************************
// *                                                                            *
// * DarkBASIC Professional Emulation Ver &.0 Include File : SYSTEM DEFINITIONS *
// *                                                                            *
// ******************************************************************************
// Start Date : 2019.04.23 22:45
//
Global TRUE As Integer = 1
Global FALSE As Integer = 0
Global NULL As String = "" // "#*$%NULLSPECIAL%$*#"
Global NOTSET As Integer = -1
#Constant PI = 3.141592653589793

// ****************************************** Default eXtends Ver 2.0 DarkBASIC Professional emulation TextRender System
Type printSystem
	prtSetup as Integer              // System setup done (=1) or not (=0)
	xCursor As Integer               // The current yCursor position
	yCursor As Integer               // The current xCursor position
	rgbR as Integer                  // The current rgbR color valua
	rgbG as Integer                  // The current rgbG color value
	rgbB as Integer                  // The current rgbB color value
	rgbA as Integer                  // The current rgbA color value
	rgbBb as Integer                 // The current full rgbA+rgbR+rgbG+rgbB color value
	idFont As Integer                // The current font in fntSystem[] array
	fontName As String               // The current font name
	fontSize As Integer              // The current font size
	tBold As Integer                 // The current font bold mode (active=1)
	tItalic As Integer               // The current font italic mode (active=1)
	tTransparent As Integer          // The current font transparency mode (active=1
	prtStack as String[]             // The output list
	autoPurge as Integer             // To remove unused font when not used during 1 rendered frame
	prtText As Integer               // Text utilisé pour écrire
 EndType
Global prtSystem as printSystem
Global prtRender as printSystem

prtSystem.prtSetup = 0
prtSystem.xCursor = 0 : prtSystem.yCursor = 0
prtSystem.rgbR = 255 : prtSystem.rgbG = 255 : prtSystem.rgbB = 255 : prtSystem.rgbA = 255
prtSystem.idFont = 0 : prtSystem.fontName = "default" : prtSystem.fontsize = 32
prtSystem.tItalic = FALSE : prtSystem.tTransparent = FALSE : prtSystem.tBold = FALSE
prtSystem.autoPurge = FALSE : prtSystem.prtText = false

prtRender.prtSetup = 0
prtRender.xCursor = 0 : prtRender.yCursor = 0
prtRender.rgbR = 255 : prtRender.rgbG = 255 : prtRender.rgbB = 255 : prtRender.rgbA = 255
prtRender.idFont = 0 : prtRender.fontName = "default" : prtRender.fontsize = 16
prtRender.tItalic = FALSE : prtRender.tTransparent = FALSE : prtRender.tBold = FALSE
prtRender.autoPurge = FALSE : prtRender.prtText = false

type fontSystem
	fontName As String          // Font name
	used As Integer              // If font was used during render (for auto purge mode )
EndType
global fntSystem as fontSystem[]

// ********************************************************************************** dbImage Emulation
global dbImageSPR As Integer = -1

// ********************************************************************************** dbGetImageData Emulation
Type DBImageData_Type
	imageID As Integer
	MemblockID As Integer
	Width As Integer
	Height As Integer
	Depth As Integer
	isModified As Integer
EndType
Global DBimageData As DBImageData_Type[]

