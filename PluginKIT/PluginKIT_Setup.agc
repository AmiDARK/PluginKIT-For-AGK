//
// ***********************************************
// *                                             *
// * PluginKIT Include File : SYSTEM DEFINITIONS *
// *                                             *
// ***********************************************
// Start Date : 2019.04.23 22:45
// Description : Default PluginKIT Ver 2.0 System informations
// Author : Frédéric Cordier

//
// *********************                                                                                                                           *************
// *
// ********************************************************************************************************************************* PluginKIT - MagicMenu Setup
// *
// *************                                                                                                                           *********************
//

Type AGKInfos_Type
	InstallPath As String
	gSpawnExe As String
	CompilerExe As String
EndType
Global AGKInfos As AGKInfos_Type
AGKInfos.InstallPath = "C:\Program Files (x86)\TheGameCreators\AGK2"
AGKInfos.gSpawnExe = "\Tier 1\Editor\bin\gspawn-win32-helper.exe"
AGKInfos.CompilerExe = "\Tier 1\Compiler\AGKCompiler.exe"


// The main Menu source
Type PKMainMenu_Type
	isActive As Integer                         // = TRUE when at least 1 element is set
	AutoHideBar As Integer                      // = TRUE the bar is shown only when mouse pointer is over it
	areGfxThumbVisible As Integer               // = TRUE will allow the display of MenuOption/gfxThumbs when defined.
	areShortCutsVisible As Integer              // = TRUE will allow the display of shortcuts text at the end of the menu
    MenuID As Integer[]                         // Should contain the IDs to link to all PKMenu(s) available in the menubar
    intID As Integer                            // Unique ID with auto-increment to makes all menus, submenus and items owning unique ID
    overlapedID As Integer                      // Which menu/subMenu or MenuOption is currently overlaped.
    intTextOutput As Integer                    // The text interface with CreateText()
    useTheme As String
EndType
Global PKMainMenu As PKMainMenu_Type
PKMainMenu.intID = -1                               // The latest ID created.
PKMainMenu.isActive = FALSE                         // = TRUE will display menu. 
PKMainMenu.intTextOutput = -1                       // Not Defined
PKMainMenu.useTheme = "none"

// All the menus available in the main menu
Type PKMenu_Type
	Menu_Name As String                         // The name of the menu to display
	gfxThumb As Integer                         // Menu graphic
	MenuContent As Integer[]                    // The list of options attached to this menu.
	MenuContentType As Integer[]                // Define is the content is an option or a submenu.
	pixelWidth As Integer                       // The Width in pixel required to display this menu. It is calculated from the longest menu option text pixel length
EndType
Global PKMenu As PKMenu_Type[]

// Internally used from PKMenu                     In order from left to right : gfxThumb | MOption_Name ( PKShortCur[ MOShortCutID ].MoShortCutSTR ) 
Type MenuOption_Type
	MOption_Name As String                      // The name displayed in the menu option
	MOptionID As Integer                        // The ID returned when user click on this Menu Option .
	isActive As Integer                         // Is = FALSE, option is displayed but click on it will return -1
	gfxThumb As Integer                         // A graphic used to be displayed at the left of the menu option
	MOShortCutID As Integer                     // The ID of the MOShortCuts list element to use there
EndType
Global PKMenuOptions As MenuOption_Type[]       // To allow the creation of the option lists for menus.

// Used in // To optimise the use of MenuOption/MOShortCutsSTR(VAL). Used by keyboard detection system
Type MOShortCuts_Type
    MenuOptionID As Integer[]                   // Should contain the IDs to link to all menus available in the menubar
	MOShortCutSTR As String                     // The Shortcut available to run this Menu Option from keyboard
	MOShortCutVAL As Integer                    // The Key combination value to run this menu option from keybaord
EndType
Global PKShortCut As MOShortCuts_Type[]
