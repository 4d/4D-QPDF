
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : config
   ID[8B058302BDF14094B75787FBA5CF110C]
   Created : 03-05-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/



property _name : Text

Class constructor($name : Text)
	
	
	var $file; $host_file; $system_file : 4D:C1709.File
	
	
	// If name parameter is not provided
	If (Count parameters:C259<1)
		
		// Get host structure file and extract its name
		$file:=File:C1566(Structure file:C489(*); fk platform path:K87:2)
		
		$name:=$file.name
		
	End if 
	
	// Set _name property
	This:C1470._name:=$name
	
	// Initialize local host configuration file
	$host_file:=This:C1470._host_config_file(True:C214)
	
	// If host configuration file does not exist, create it
	If ($host_file.exists)
	Else 
		
		// Get component configuration file
		$file:=This:C1470._component_config_file()
		
		// Copy component configuration file to local host configuration folder
		$host_file:=$file.copyTo(This:C1470._host_config_folder(); This:C1470._name+".json")
		
	End if 
	
	// Initialize system component configuration file
	$system_file:=This:C1470._system_config_file(True:C214)
	
	// If system component configuration file does not exist, create it
	If ($system_file.exists)
	Else 
		
		// Get component configuration file
		$file:=This:C1470._component_config_file()
		
		// Copy component configuration file to system component configuration folder
		$system_file:=$file.copyTo(This:C1470._system_config_folder(); This:C1470._name+".json")
		
	End if 
	
	
	
	//mark:-
	
	
	// Function to read template
Function read_template : Object
	var $json : Text
	
	// Read content of component configuration file
	$json:=This:C1470._component_config_file().getText()
	// Parse JSON content
	return JSON Parse:C1218($json)
	
	
	// Function to update template
Function update_template($config : Object; $compact : Boolean)
	var $json : Text
	
	Case of 
			
		: (Count parameters:C259<1)
			ASSERT:C1129(False:C215; Current method path:C1201+" : Missing paramater...")
			
		Else 
			
			If (Structure file:C489#Structure file:C489(*))  //Is compiled mode(*))
				// coulnot update template if host database is compiled 
				// may be will dammage the signature
				ASSERT:C1129(False:C215; "Couln't update template in component mode !\r Run component in standalone mode.")
				
			Else 
				// Convert configuration object to JSON
				If ($compact)
					$json:=JSON Stringify:C1217($config)
				Else 
					$json:=JSON Stringify:C1217($config; *)
				End if 
				// Set JSON content to component configuration file
				This:C1470._component_config_file().setText($json)
			End if 
	End case 
	
	// Function to read host configuration
Function read : Object
	var $json : Text
	
	$json:=This:C1470._host_config_file().getText()
	
	return JSON Parse:C1218($json)
	
	
	// Function to write host configuration
Function write($config : Object; $compact : Boolean)
	var $json : Text
	
	// Convert configuration object to JSON
	If ($compact)
		$json:=JSON Stringify:C1217($config)
	Else 
		$json:=JSON Stringify:C1217($config; *)
	End if 
	
	// Set JSON content to host configuration file
	This:C1470._host_config_file().setText($json)
	
	
	// Getter function to access the path of host configuration file
Function get path : Text
	return This:C1470._host_config_file().path
	
	
	// Getter function to access the platform path of host configuration file
Function get platformPath : Text
	return This:C1470._host_config_file().platformPath
	
	//mark:- system
	
	
	// Function to read system configuration
Function read_system : Object
	var $json : Text
	
	$json:=This:C1470._system_config_file().getText()
	
	return JSON Parse:C1218($json)
	
	
	// Function to write system configuration
Function write_system($config : Object; $compact : Boolean)
	var $json : Text
	
	If ($compact)
		$json:=JSON Stringify:C1217($config)
	Else 
		
		$json:=JSON Stringify:C1217($config; *)
	End if 
	This:C1470._system_config_file().setText($json)
	
	
	// Getter function to access the path of system configuration file
Function get system_path : Text
	return This:C1470._system_config_file().path
	
	
	
	//mark:- COMPONENT DEFAULT CONFIG
	
	
	// Function to get the component configuration file
Function _component_config_file($test_file : Boolean) : 4D:C1709.File
	var $file : 4D:C1709.File
	$file:=This:C1470._component_config_folder().file(This:C1470._name+".json")
	
	If ($file.exists)
	Else 
		$file:=This:C1470._component_config_folder().file("config.json")
		If ($file.exists)
		Else 
			If ($test_file)
			Else 
				If ($file.create())
					$file.setText("{}")
				Else 
					
				End if 
			End if 
		End if 
	End if 
	
	return File:C1566($file.platformPath; fk platform path:K87:2)
	
	
	// Function to get the component configuration folder
Function _component_config_folder : 4D:C1709.Folder
	
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567("/RESOURCES/"+This:C1470._name)
	
	If ($folder.exists)
	Else 
		If ($folder.create())
		Else 
			
		End if 
	End if 
	
	return Folder:C1567($folder.platformPath; fk platform path:K87:2)
	
	
	
	//mark:- HOST LOCAL CONFIG
	
	// Function to get the host configuration file
Function _host_config_file($test_file : Boolean) : 4D:C1709.File
	var $file : 4D:C1709.File
	
	$file:=This:C1470._host_config_folder().file(This:C1470._name+".json")
	
	If ($file.exists)
	Else 
		
		If ($test_file)
		Else 
			If ($file.create())
				$file.setText("{}")
			End if 
		End if 
	End if 
	
	return File:C1566($file.platformPath; fk platform path:K87:2)
	
	
	// Function to get the host configuration folder
Function _host_config_folder : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470._host_user_preferences_folder().folder("configs")
	
	If ($folder.exists)
	Else 
		$folder.create()
	End if 
	
	return Folder:C1567($folder.platformPath; fk platform path:K87:2)
	
	
	// Function to get the host user preferences folder
Function _host_user_preferences_folder : 4D:C1709.Folder
	var $name : Text
	var $result : Boolean
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	
	$file:=File:C1566(Structure file:C489(*); fk platform path:K87:2)
	$name:=$file.name
	
	$folder:=Folder:C1567(fk user preferences folder:K87:10).folder($name)
	
	If ($folder.exists)
		
	Else 
		
		$result:=$folder.create()
		
	End if 
	
	return Folder:C1567($folder.platformPath; fk platform path:K87:2)
	
	
	
	//MARK:- SYSTEM CONFIG
	
	
	// Function to get the system configuration file
Function _system_config_text() : Text
	var $file : 4D:C1709.File
	$file:=This:C1470._system_config_file(True:C214)
	If ($file.exists)
		return $file.getText()
	End if 
	
	
	// Function to get the JSON content of system configuration
Function _system_config_json() : Text
	
	var $json : Text
	$json:=This:C1470._system_config_text()
	
	$json:=Replace string:C233($json; "\n"; "")
	
	Case of 
		: (Match regex:C1019("(?m-si)^\\{.*\\}$"; $json; 1))  //object
			return $json
		: (Match regex:C1019("(?m-si)^\\[.*\\]$"; $json; 1))  //collection
			return $json
	End case 
	
	
	// Function to parse system configuration content as an object
Function _system_config_object() : Object
	var $json : Text
	
	$json:=This:C1470._system_config_json()
	
	If (Match regex:C1019("(?m-si)^\\{.*\\}$"; $json; 1))
		return JSON Parse:C1218($json)
	End if 
	
	
	// Function to parse system configuration content as a collection
Function _system_config_collection() : Collection
	var $json : Text
	
	$json:=This:C1470._system_config_json()
	
	If (Match regex:C1019("(?m-si)^\\[.*\\]$"; $json; 1))
		return JSON Parse:C1218($json)
	End if 
	
	
	// Function to get the system configuration file
Function _system_config_file($test_file : Boolean) : 4D:C1709.File
	var $file : 4D:C1709.File
	
	$file:=This:C1470._system_config_folder().file(This:C1470._name+".json")
	
	If ($file.exists)
	Else 
		
		If ($test_file)
		Else 
			If ($file.create())
				$file.setText("{}")
			End if 
		End if 
	End if 
	
	return File:C1566($file.platformPath; fk platform path:K87:2)
	
	
	
	// Function to get the system configuration folder
Function _system_config_folder : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470._system_user_preferences_folder().folder("configs")
	
	If ($folder.exists)
	Else 
		$folder.create()
	End if 
	
	return Folder:C1567($folder.platformPath; fk platform path:K87:2)
	
	
	
	// Function to get the system user preferences folder
Function _system_user_preferences_folder : 4D:C1709.Folder
	var $name : Text
	var $result : Boolean
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	
	$file:=File:C1566(Structure file:C489; fk platform path:K87:2)
	$name:=$file.name
	
	$folder:=Folder:C1567(fk user preferences folder:K87:10).folder($name)
	
	If ($folder.exists)
		
	Else 
		$result:=$folder.create()
		
	End if 
	
	return Folder:C1567($folder.platformPath; fk platform path:K87:2)
	
	
	