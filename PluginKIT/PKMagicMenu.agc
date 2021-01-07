



Function PKAddNewMenu( menuName As String )
	MenuID As Integer = -1
	newMenu as PKMenu_Type
	newMenu.Menu_Name = menuName
	newMenu.gfxThumb = -1
	newMenu.pixelWidth = internalPKMenuGetTextWidth( menuName )
	PKMenu.insert( newMenu )
	PKMainMenu.intID = PKMainMenu.intID + 1
	MenuID = PKMainMenu.intID
	PKMainMenu.isActive = TRUE
EndFunction MenuID




Function internalPKMenuGetTextWidth( textToWrite As String )
	feedBack As Integer = -1
	if PKMainMenu.intTextOutput = -1
		PKMainMenu.intTextOutput = CreateText( textToWrite )
		SetTextSize( PKMainMenu.intTextOutput, 8 )
	Else
		SetTextString( PKMainMenu.intTextOutput, textToWrite )
	Endif
	feedBack = GetTextTotalWidth( PKMainMenu.intTextOutput )
EndFunction feedBack




Function refreshMenu()
	if PKMainMenu.isActive = TRUE
		If PKMainMenu.MenuID.length > -1
			if PKMainMenu.useTheme = "none"

			Else
			Endif
		Endif
	Endif
EndFunction
