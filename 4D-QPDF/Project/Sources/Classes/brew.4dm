
/*  ----------------------------------------------------
Project: 4D-QPDF
Project class : brew
ID[8E711854926A4BF09BDAD0C60385CA59]
Created : 03-04-2024 by Dominique Delahaye
Commented by: chatGPT 3.5
----------------------------------------------------
*/

/*
https://github.com/homebrew/install#uninstall-homebrew


Error: Your Command Line Tools are too outdated.
Update them from Software Update in System Settings.

If that doesn't show you any updates, run:
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install


xcode-select -p


*/


Class extends cli



Class constructor
	
	var $zsh : cs:C1710.zsh
	var $path : Text
	var $cache : Object
	
	
	$zsh:=cs:C1710.zsh.new()
	
	Case of 
		: (arch.is_mac_arm)
			
			$zsh.add_path("/opt/homebrew/bin/")
			$path:=$zsh.which("brew")
			
		: (arch.is_mac_intel)
			
			$zsh.add_path("/usr/local/bin/")
			$path:=$zsh.which("brew")
			
		: (arch.is_microsoft)
			
			
	End case 
	
	
	Super:C1705($path)
	
	
	$cache:=This:C1470._cache
	$cache.os_path:=$path
	$cache.zsh:=$zsh
	
	This:C1470._module:={}
	
	$cache.config:=cs:C1710.config.new(current class name)
	
	This:C1470._load_config()
	
	This:C1470._reset()
	
	
	//mark:-
	
	
	// Function to read configuration
Function _read_config : Object
	
	var $config : Object
	
	$config:=This:C1470._cache.config.read()
	
	$config.module:=($config.module=Null:C1517) ? {} : $config.module
	
	return $config
	
	
	// Function to write configuration
Function _write_config($config : Object)
	
	$config.module:=($config.module=Null:C1517) ? {} : $config.module
	This:C1470._cache.config.write($config)
	
	
	// Function to load configuration
Function _load_config
	
	var $key : Text
	var $config : Object
	
	$config:=This:C1470._read_config()
	
	For each ($key; $config)
		
		Case of 
				
			: ($key="_@")  // ignore property begin with "_"
				
			: (This:C1470["_"+$key]=Null:C1517)  // if property is not defined in this
				
			Else 
				//todo: type checking
				This:C1470["_"+$key]:=$config[$key]
		End case 
		
	End for each 
	
	
	//mark:-
	
	
	// Function to reset
Function _reset()
	
	var $cache : Object
	
	Super:C1706._reset()
	
	$cache:=This:C1470._cache
	$cache.version:=""
	
	$cache._attachements:=[]
	
	
	// Getter function for version
Function get version : Text
	
	var $cache : Object
	var $result : 4D:C1709.SystemWorker
	var $_ : Collection
	
	$cache:=This:C1470._cache
	
	If ($cache.version="")
		
		$result:=This:C1470.execute("--version")
		If ($result.exitCode=0)
			
			$_:=to.collection($result.response)
			
			$_:=Split string:C1554($_[0]; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			$cache.version:=($_.length>0) ? $_[$_.length-1] : ""
			
		End if 
		
	End if 
	
	return $cache.version
	
	
	//mark:-
	
	
	// Function to get package folder
Function package_folder($package : Text) : 4D:C1709.Folder
	var $w : 4D:C1709.SystemWorker
	var $path : Text
	
	If (Count parameters:C259>0)
		$w:=This:C1470.execute("--prefix "+$package)
	Else 
		$w:=This:C1470.execute("--prefix ")
	End if 
	
	$path:=to.text($w.response)
	
	return Folder:C1567(to.absolute_path($path))
	
	
	// Function to get package binary file
Function package_bin($package : Text) : 4D:C1709.File
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470.package_folder($package)
	If ($folder.exists)
		
		$folder:=$folder.folder("bin")
		If ($folder.exists)
			
			$file:=$folder.file($package)
			
		End if 
		
	End if 
	
	return $file
	
	
	// Function to install package
Function install_package($package : Text) : Boolean
	
	var $w : 4D:C1709.SystemWorker
	var $index : Integer
	var $path : Text
	var $success : Boolean
	var $_ : Collection
	var $config : Object
	
	This:C1470.no_time_out()
	
	$w:=This:C1470.execute("install "+$package)
	
	This:C1470._install:=$w  // passer par un collector
	
	$index:=$w.rows.indexOf("🍺@")
	If ($index>=0)
		
		$_:=$w.rows.filter(Formula:C1597($1.value="🍺@"))
		
		$path:=$_[$_.length-1]  //$w.rows[$index]
		
		$_:=Split string:C1554($path; "🍺"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
		$_:=Split string:C1554($_[0]; ":"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
		$path:=$_[0]
		This:C1470.install_package_path:=to.absolute_path($path)
		
		$success:=Folder:C1567(This:C1470.install_package_path).exists
		
		If ($success)
			
			$config:=This:C1470._read_config()
			
			$config.module[$package]:={folder: This:C1470.install_package_path}
			
			This:C1470._write_config($config)
			
			This:C1470._load_config()
			
		End if 
		
	End if 
	
	return $success
	
	
	// Function to update package
Function update_package($package : Text) : Boolean
	
	var $w : 4D:C1709.SystemWorker
	
	$w:=This:C1470.execute("upgrade "+$package)
	
	return Bool:C1537($w.exitCode=0)
	
	
	// Function to uninstall package
Function uninstall_package($package : Text) : Boolean
	
	var $w : 4D:C1709.SystemWorker
	
	$w:=This:C1470.execute("uninstall "+$package)
	
	return Bool:C1537($w.responseError="")
	
	
	// Function to get package info
Function package_infos($package : Text) : Object
	
	var $_ : Collection
	
	$_:=This:C1470.packages()
	
	$_:=$_.query(" name=:1 "; $package)
	
	return $_.length<1 ? {} : $_[0]
	
	
	// Function to check if package is installed
Function package_installed($package : Text) : Boolean
	
	var $_ : Collection
	
	$_:=This:C1470.packages()
	
	$_:=$_.query(" name=:1 "; $package)
	
	return $_.length>0
	
	
	//mark:-
	
	// Function to get installed packages
Function packages : Collection
	
	var $w : 4D:C1709.SystemWorker
	var $_ : Collection
	var $saveTimeOut : Variant
	
	$saveTimeOut:=This:C1470.timeout
	
	This:C1470.no_time_out()
	
	$w:=This:C1470.execute(" info  --installed --json")
	
	If ($w.exitCode=0)
		$_:=JSON Parse:C1218($w.response)
	Else 
		$_:=[]
	End if 
	
	This:C1470.timeout:=$saveTimeOut
	
	return $_
	
	
	// Function to list packages
Function list : Collection
	
	var $w : 4D:C1709.SystemWorker
	var $saveTimeOut : Variant
	
	$saveTimeOut:=This:C1470.timeout
	
	$w:=This:C1470.execute("list")
	
	This:C1470.timeout:=$saveTimeOut
	
	return $w.rows=Null:C1517 ? [] : $w.rows
	
	
	// Function to run doctor command
Function doctor : 4D:C1709.SystemWorker
	
	var $w : 4D:C1709.SystemWorker
	var $saveTimeOut : Variant
	
	$saveTimeOut:=This:C1470.timeout
	
	This:C1470.no_time_out()
	
	$w:=This:C1470.execute("doctor")
	
	This:C1470.timeout:=$saveTimeOut
	
	return $w
	
	
	// Function to update brew
Function update : Boolean
	
	var $w : 4D:C1709.SystemWorker
	var $saveTimeOut : Variant
	var $uptodate; $exit : Boolean
	
	$saveTimeOut:=This:C1470.timeout
	
	This:C1470.no_time_out()
	
	Repeat 
		
		$w:=This:C1470.execute("update")
		
		Case of 
			: (Value type:C1509($w.rows)#Is collection:K8:32)
				$exit:=True:C214
			: ($w.rows.length<1)
				$exit:=True:C214
			Else 
				
				$uptodate:=$w.rows.indexOf("Already up-to-date.")>=0
				
		End case 
		
	Until ($uptodate || $exit)
	
	This:C1470.timeout:=$saveTimeOut
	
	return $uptodate
	
	
	// Function to install brew
Function install : Boolean
	
	var $w; $todo : 4D:C1709.SystemWorker
	var $i; $j : Integer
	var $_; $_to_do : Collection
	var $zsh : cs:C1710.zsh
	var $success : Boolean
	var $action; $path : Text
	
	$zsh:=cs:C1710.zsh.new()
	
/*
https://brew.sh/fr/
	
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	
*/
	
	$w:=$zsh.sudo("/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""; "4D need to install Homebrew...")
	If ($w.exitCode=0)
		
		$_:=Split string:C1554($w.response; "==>"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
		For ($i; 0; $_.length-1)
			
			$action:=to.text($_[$i])
			
			Case of 
					
				: ($action="Installation @")
					$success:=True:C214
					
				: ($action="Next steps:@")
					$_to_do:=Split string:C1554($action; "-"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
					$_to_do:=Split string:C1554($_to_do[1]; "    "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
					For ($j; 1; $_to_do.length-1)
						
						$todo:=$zsh.execute($_to_do[$j])
						
					End for 
					
			End case 
			
		End for 
		
		Case of 
				
			: (arch.is_mac_arm)
				
				$zsh.add_path("/opt/homebrew/bin/")
				$path:=$zsh.which("brew")
				This:C1470._cache.file:=File:C1566($path)
				
			: (arch.is_mac_intel)
				
				$zsh.add_path("/usr/local/bin/")
				$path:=$zsh.which("brew")
				This:C1470._cache.file:=File:C1566($path)
				
			: (arch.is_microsoft)
				
		End case 
		
	End if 
	
	return $success
	
	
	// Function to uninstall brew
Function uninstall : Boolean
	
	var $zsh : cs:C1710.zsh
	var $w : 4D:C1709.SystemWorker
	
	$zsh:=cs:C1710.zsh.new()
	
/*
	
https://github.com/homebrew/install#uninstall-homebrew
	
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	
	
/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\"
	
*/
/*
	
WARNING WILL UNINSTALL BREW AND ALL PACKAGES INSTALLED WITH BREW LIKE POWERSHELL , OPENSSL ...
	
*/
	
	$w:=$zsh.sudo("/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""; "4D need to uninstall Homebrew (warning ! )...")
	
	
	return ($w.exitCode=0)