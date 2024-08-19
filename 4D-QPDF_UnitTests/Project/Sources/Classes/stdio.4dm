
property _namespace : Text

Class constructor($namespace : Text)
	
	
	This:C1470._namespace:=$namespace
	
	
	This:C1470._sw_options:={\
		timeout: Null:C1517; \
		dataType: "text"; \
		encoding: "UTF-8"; \
		variables: Null:C1517; \
		hideWindow: True:C214; \
		currentDirectory: to.absolute_folder(Folder:C1567("/PACKAGE"))\
		}
	
	//https://developer.4d.com/docs/fr/Concepts/paths
	
Function out($flow : Text) : 4D:C1709.File
	
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	var $content : Blob
	
	$folder:=Folder:C1567(Folder:C1567("/PACKAGE").platformPath; fk platform path:K87:2).parent
	
	$file:=$folder.file(This:C1470._namespace+".txt")
	
	If ($file.exists)
		$file.delete()
	End if 
	
	If ($file.create())
		
		TEXT TO BLOB:C554($flow; $content; UTF8 text without length:K22:17; *)
		
		$file.setContent($content)
		
	Else 
		
		ALERT:C41("Error : could not create file : "+$file.name+"!")
		
	End if 
	
	return $file
	
	
Function show($file : 4D:C1709.File) : 4D:C1709.File
	
	SHOW ON DISK:C922($file.platformPath)
	
	return $file
	
Function splash($file : 4D:C1709.File) : 4D:C1709.SystemWorker
	
	var $sw : 4D:C1709.SystemWorker
	
	If ($file.exists && ($file.size>0))
		
		If (Is macOS:C1572)
			$sw:=4D:C1709.SystemWorker.new("cat \""+$file.path+"\""; This:C1470._sw_options)
		Else 
			$sw:=4D:C1709.SystemWorker.new("type \""+$file.path+"\""; This:C1470._sw_options)
		End if 
		
	Else 
		
		ALERT:C41("Error: file not exist or empty : "+$file.name+"!")
		
		$sw:=4D:C1709.SystemWorker.new("echo \""+$file.path+"\""; This:C1470._sw_options)
		
	End if 
	
	return $sw
	
	
	
	
	
	
	