//
// ******************************************************
// *                                                    *
// * eXtends Ver 2.0 Include File : Restore Data System *
// *                                                    *
// ******************************************************
// Start Date : 2019.04.23 22:48
// Description : This system emulates old basic "Restore LABEL" and "Read DATA"
//               Using disk file that contain Data ??, ??, ... 
// Author : Frédéric Cordier
//

// This method will open a file that contains data lines in the old BASIC Languages style
// And extract them one by one to put them in an array that can be read at any time

// Restore( FileNameToRestore As String )
// String = Read()
// String = ReadS()
// Integer = ReadI()
// Float = ReadF()

/* ************************************************************************
 * @Description : Cette méthode extrait toutes les données Data d'un fichier de données Data
 *
 * @Param : FileNameToRestore = Le nom du fichier (sans l'extension .txt) dont on va extraire les data
 *
 * @Return : AmountOfDataRead = La quantité de datas lues dans le fichier de données Data
 *
 * @Author : Frédéric Cordier
*/
Function Restore( FileNameToRestore As String )
	AmountOfDataRead As Integer = 0                          // Variable donnant la quantité de data lus
	if ( FileNameToRestore = XTRestoreFile )
		XTRestoreItem = 0
		AmountOfDataRead = XTRestoreArray.length
	Else
		// Variables are setup here because we setup them only if needed.
		FileID As Integer = -1                                   // Invalid value
		inText As String = "" : inData As String = ""            // Reset inText and inData contents as void
		input As String = ""                                     // variable to receive chat by char from the inText data
		dLoop As Integer = 0                                     // Main data read loop variable
		newArray As String[]                                     // Array to receive datas
		If getFileExists( FileNameToRestore + ".txt" ) = 1
			FileID = OpenToRead( FileNameToRestore + ".txt" )
			inText = ReadString( FileID ) // Read the whole content of the Txt file.
			for dLoop = 1 to len( inText )
				input = mid( inText, dLoop, 1 )
				If input = "D" or input = "a" or input = "t" or input = " " or asc( input ) = 10 
					// Do Nothing in all these cases
				Else
					// If we reach the end of a data (delimited with comma or end of line)
					If input = "," or asc( input ) = 13
						if len( inData ) > 0 then newArray.insert( inData )
						inData = ""
						AmountOfDataRead = AmountOfDataRead + 1
					// We are reading data from the inText content
					Else
						inData = inData + input
					Endif
				Endif
			next dLoop
			// Once the job is finished we close file and set global Restore/Read variables
			CloseFile( FileID )
			XTRestoreArray = newArray
			XTRestoreItem = 0
			XTRestoreFile = FileNameToRestore
		Else
			Message ( "eXtends Ver 2.0 Error : File " + FileNameToRestore + " does not exist." )
		Endif
	Endif
EndFunction AmountOfDataRead

/* ************************************************************************
 * @Description : Lit la prochaine donnée Data sous le format Texte
 *
 * @Return : ItemToRead = Donnée lue et rendue au format texte
 *
 * @Author : Frédéric Cordier
*/
Function Read()
	ItemToRead As String
	ItemToRead = ReadS()
EndFunction ItemToRead

/* ************************************************************************
 * @Description : Lit la prochaine donnée Data sous le format Texte
 *
 * @Return : ItemToRead = Donnée lue et rendue au format texte
 *
 * @Author : Frédéric Cordier
*/
Function ReadS()
	ItemToRead As String
	if XTRestoreItem <= XTRestoreArray.length
		ItemToRead = XTRestoreArray[ XTRestoreItem ]
		XTRestoreItem = XTRestoreItem + 1
	Else
		Message( "eXtends Ver 2.0 Error : No more data to read from " + XTRestoreFile + ".txt file." )
	Endif
EndFunction ItemToRead

/* ************************************************************************
 * @Description : Lit la prochaine donnée Data sous le format Integer
 *
 * @Return : ItemToRead = Donnée lue et rendue au format Integer
 *
 * @Author : Frédéric Cordier
*/
Function ReadI()
	ItemToRead As Integer
	if XTRestoreItem <= XTRestoreArray.length
		ItemToRead = Val( XTRestoreArray[ XTRestoreItem ] )
		XTRestoreItem = XTRestoreItem + 1
	Else
		Message( "eXtends Ver 2.0 Error : No more data to read from " + XTRestoreFile + ".txt file." )
	Endif
EndFunction ItemToRead

// This method will read a data as Float from RESTORE data
/* ************************************************************************
 * @Description : Lit la prochaine donnée Data sous le format Nombre Flottant
 *
 * @Return : ItemToRead = Donnée lue et rendue au format Nombre Flottant
 *
 * @Author : Frédéric Cordier
*/
Function ReadF()
	ItemToRead As Float
	if XTRestoreItem <= XTRestoreArray.length
		ItemToRead = ValFloat( XTRestoreArray[ XTRestoreItem ] )
		XTRestoreItem = XTRestoreItem + 1
	Else
		Message( "eXtends Ver 2.0 Error : No more data to read from " + XTRestoreFile + ".txt file." )
	Endif
EndFunction ItemToRead
