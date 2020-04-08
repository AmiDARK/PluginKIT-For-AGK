//
// *****************************************************
// *                                                   *
// * eXtends Ver 2.0 Include File : HighScores methods *
// *                                                   *
// *****************************************************
// Start Date : 2019.05.28 23:32
// Description : This class will contain basic Highscores system
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
Function XT_AddNewHighScore( Score As Integer, Name As String, Level As Integer )
	lowerHighScore As Integer = -1
	lowerHighScore = internal_GetLowerHighScore()
	if lowerHighScore > -1 and lowerHighScore < Score
		newHighScore As HighScore_Type
		newHighScore.Score = Score
		newHighScore.Name = Name
		newHighScore.Level = Level
		HighScore.insert( newHighScore )
		HighScore.sort()
		if HighScore.length > 31 then HighScore.Remove( 32 )
	Endif
Endfunction

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
Function XTGetHighScoreCount()
EndFunction HighScore.length

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
Function XTGetHighScoreAtPosition( chosenPos As Integer )
	askedHighScore As HighScore_Type
	if chosenPos < HighScore.length +1
		askedHighScore.Score = HighScore[ chosenPos ].Score
		askedHighScore.Name = HighScore[ chosenPos ].Name
		askedHighScore.Level = HighScore[ chosenPos ].Level
	Else
		askedHighScore.Score = -1
		askedHighScore.Name = NULL
		askedHighScore.Level = -1
	Endif
EndFunction askedHighScore
		

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
Function XTGetHighScoreScoreAtPosition( chosenPos As Integer )
	dataToReturn As Integer = -1
	if chosenPos < HighScore.length +1
		dataToReturn = HighScore[ chosenPos ].Score
	Endif
EndFunction dataToReturn

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
Function XTGetHighScoreLevelAtPosition( chosenPos As Integer )
	dataToReturn As Integer = -1
	if chosenPos < HighScore.length +1
		dataToReturn = HighScore[ chosenPos ].Level
	Endif
EndFunction dataToReturn

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
Function XTGetHighScoreNameAtPosition( chosenPos As Integer )
	dataToReturn As String = ""
	if chosenPos < HighScore.length +1
		dataToReturn = HighScore[ chosenPos ].Name
	Endif
EndFunction dataToReturn

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
Function XTSaveHighScores( FileName As String )
	If Len( FileName ) > 0
		If HighScore.length > -1
			If FileName = "" then FileName = "highscores.dat"
			FileIO As Integer = -1
			FileIO = OpenToWrite( FileName )
				WriteString( FileIO, "AGK_eXtendedPack_highscores" )
				WriteInteger( FileIO, HighScore.length + 1 )
				XLoop As Integer = -1
				For XLoop = 1 To HighScore.length
					WriteInteger( FileIO, HighScore[ XLoop ].Score )
					WriteInteger( FileIO, HighScore[ XLoop ].Level )
					WriteString( FileIO, HighScore[ XLoop ].Name )
				Next XLoop
				WriteString( FileIO, "_EOF" )
			CloseFile( FileIO )
		EndIf
	EndIf
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
Function XTLoadHighScores( FileName As String )
	XTClearHighScores()
	If Len( FileName ) > 0
		If FileName = ""
			FileName = "highscores.dat"
		EndIf
		FileIO As Integer
		FileIO = OpenToRead( FileName )
			_HEADER As String
			_HEADER = ReadString( FileIO )
			If _HEADER = "AGK_eXtendedPack_highscores"
				ScoreAmount As Integer
				ScoreAmount = ReadInteger( FileIO )
				XLoop As Integer = -1
				For XLoop = 1 To ScoreAmount
					newHighScore As HighScore_Type
					newHighScore.Score = ReadInteger( FileIO )
					newHighScore.Level = ReadInteger( FileIO )
					newHighScore.Name = ReadString( FileIO )
					HighScore.insert( newHighScore )
				Next XLoop
			EndIf
		CloseFile( FileIO )
	EndIf
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
Function XTClearHighScores()
	if HighScore.Length > -1
		hsLoop As Integer = -1
		For hsLoop = HighScore.length to 0 step -1
			HighScore.remove( hsLoop )
		Next hsLoop
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
Function internal_GetLowerHighScore()
	lowerOne As Integer = -1
	if ( HighScore.length > -1 )
		hsLoop As Integer = -1
		for hsLoop = 0 to HighScore.length
			if lowerOne = -1
				lowerOne = HighScore[ hsLoop ].Score
			Else
				if HighScore[ hsLoop ].Score < lowerOne then lowerOne = HighScore[ hsLoop ].Score
			Endif
		Next hsLoop
	endif
EndFunction lowerOne
