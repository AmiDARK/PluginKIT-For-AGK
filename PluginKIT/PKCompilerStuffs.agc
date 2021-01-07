

Function callCompilerForFile( FilePath As String, FileToCompileAGC As String )
	CommandToExecute As String
	CommandToExecute = chr(34)+AGKInfos.InstallPath+AGKInfos.gSpawnExe+Chr(34)+" 8 9 z 4 6 "+Chr(34)+FilePath+Chr(34)+" y y - "+Chr(34)+AGKInfos.InstallPath+AGKInfos.CompilerExe+Chr(34)+" -agk "+chr(34)+FileToCompileAGC+Chr(34)+" -> " +chr(34)+FilePath+"\log.txt"+chr(34)

	dbPrint( CommandToExecute )
EndFunction	
	
