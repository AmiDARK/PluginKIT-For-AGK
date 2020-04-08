
/* ************************************************************************
 * @Description : Renvoie l'index de la première occurence du texte à chercher dans un textxe
 *
 * @Param : MainText = Texte dans lequel la recherche va se réaliser
 * @Param : TextToFind = Le texte à trouver dans le texte source MainText.
 *
 * @Return : FinalPos = La position du texte trouvé, sinon -1
 *
 * @Author : Frédéric Cordier
*/
Function indexOf( MainText As String, TextToFind As String )
	FinalPos As Integer
	FinalPos = indexOf2( MainText, TextToFind, 1 )
EndFunction FinalPos

/* ************************************************************************
 * @Description : Renvoie l'index de la première occurence du texte à chercher dans un textxe à partir d'une position précise dans le texte
 *
 * @Param : MainText = Texte dans lequel la recherche va se réaliser
 * @Param : TextToFind = Le texte à trouver dans le texte source MainText.
 * @Param : From = La recherche débutera à partir de l'index de caractère From dans le texte source MainText.
 *
 * @Return : FinalPos = La position du texte trouvé, sinon -1
 *
 * @Author : Frédéric Cordier
*/
Function indexOf2( MainText As String, TextToFind As String, From As Integer )
	FinalPos As Integer = -1
	MainText = MainText + " "
	// From = From - 1
	ReadText As String = ""
	if Len( MainText ) > Len( TextToFind ) and Len( TextToFind ) > 0
		if From < ( Len( MainText ) - Len( TextToFind ) )
			Repeat
				ReadText = Mid( MainText, From, Len( TextToFind ) )
				If ( TextToFind = ReadText ) Then FinalPos = From
				Inc From, 1
			Until TextToFind = ReadText or From > ( Len( MainText ) - Len( TextToFind ) )

		// Else
		// 	If PKSetup.DebugMode = 1 Then Message( "XTv2_String.indexOf error : Cannot find a text with len=" + Str( Len( TextToFind ) ) + "when only " + Str( Len( MainText ) - Len( TextToFind ) ) + " remain available from choosen position" )
		Endif
	// Else
	// 	If PKSetup.DebugMode = 1 then Message( "XTv2_String.indexOf error : inputs are incorrect" )
	Endif
EndFunction FinalPos

/* ************************************************************************
 * @Description : Renvoie l'index de la première occurence du texte à chercher dans un textxe
 *
 * @Param : MainText = Texte dans lequel la recherche va se réaliser
 * @Param : TextToFind = Le texte à trouver dans le texte source MainText.
 *
 * @Return : FinalPos = La position du texte trouvé, sinon -1
 *
 * @Author : Frédéric Cordier
*/
Function lastIndexOf( MainText As String, TextToFind As String )
	FinalPos As Integer = -1
	From As Integer
	From = Len( MainText ) - Len( TextToFind )
	ReadText As String = ""
	if Len( MainText ) > Len( TextToFind ) and Len( TextToFind ) > 0
		if From < ( Len( MainText ) - Len( TextToFind ) )
			Repeat
				ReadText = Mid( MainText, From, Len( TextToFind ) )
				If ( TextToFind = ReadText ) Then FinalPos = From
				Dec From, 1
			Until TextToFind = ReadText or From < 1
		// Else
		// 	If PKSetup.DebugMode = 1 Then Message( "XTv2_String.indexOf error : Cannot find a text with len=" + Str( Len( TextToFind ) ) + "when only " + Str( Len( MainText ) - Len( TextToFind ) ) + " remain available from choosen position" )
		Endif
	// Else
	// 	If PKSetup.DebugMode = 1 then Message( "XTv2_String.indexOf error : inputs are incorrect" )
	Endif
EndFunction FinalPos

/* ************************************************************************
 * @Description : Return TRUE if the String 'Eval' contains the string 'toFind', otherwise FALSE
 *
 * @Param : Eval = The string within which we will try to find the 'toFind" string
 * @Param : toFind = the string to find inside the String 'Eval'
 *
 * @Return : result = TRUE if the String 'Eval' contains the string 'toFind', otherwise FALSE
 *
 * @Author : Frédéric Cordier
*/
Function Contains( Eval As String, toFind As String )
	iLoop As Integer = 0
	result As Integer = 0
	If len( Eval ) > len( toFind )
		for iLoop = 1 to Len( Eval ) - Len( toFind )
			if mid( Eval, iLoop, 1 ) = mid( toFind, 1, 1 )
				Temp as String
				Temp = mid( Eval, iLoop, len( toFind ) )
				if Temp = toFind
					result = 1
					exit // to quit For/Next looping
				Endif
			Endif
		Next iLoop
	Endif
EndFunction result

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
Function Replace( OriginalString As String, TextToReplace As String, Replacement As String )
	output As String = ""
	index As Integer = -1 : index = IndexOf( OriginalString, TextToReplace )
	if index > -1
		// 1er cas le texte à remplacer est au tout début
		if index = 1 
			output = Replacement + Right( OriginalString, Len( OriginalString ) - ( Len( TextToReplace ) + 1 ))
		Else
			// 2ème cas, le texte à remplacer est à la fin 
			if index = len( OriginalString ) - ( len( TextToReplace ) + 1 )
				output = Left( OriginalString, len( OriginalString ) - Len( TextToReplace ) ) + Replacement
			Else
				// 3ème (et dernier) cas, le texte à remplacer est n'importe où ailleurs
				output = Left( OriginalString, index -1 ) + Replacement + Right( OriginalString, len( OriginalString ) - ( ( index - 1 ) + len( TextToReplace ) ) )
			Endif
		Endif
	Endif
EndFunction output

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
Function ReplaceAll( OriginalString As String, TextToReplace As String, Replacement As String )
	Found As Integer = 0
	Output As String
	Repeat
		Output = Replace( OriginalString, TextToReplace, Replacement )
		If Output = OriginalString Then Found = TRUE
		OriginalString = Output
	Until( Found = TRUE )
EndFunction Output
