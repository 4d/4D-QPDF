/*  ----------------------------------------------------
Project: 4D-QPDF
Project class : qpfd
ID[EEEB2F79AE0443CCBAD459A74D7237308]
Created : 03-04-2024 by Dominique Delahaye
Commented by: chatGPT 3.5
----------------------------------------------------
*/


/*

- Properties `_use_system`, `_custom_path`, and `_install_path` are used to store information about the system, custom path, and installation path of QPDF.
- `____` is a private property used as storage space for the cache.
- The class constructor initializes certain values and loads the configuration.
- The `_cache` function returns the cache object.
- The `_reset` function resets certain values in the cache.
- The `_load_config` function loads the configuration from a file.
- The `_read_config` function reads the configuration from a system file.
- The `_write_config` function writes the configuration to a system file.
- The `_show_config` function displays the configuration on disk.
- The `get component_qpdf_folder` function returns the folder for QPDF components.
- The `get component_folder` function returns the folder for platform-specific QPDF components.
- The `get path` function returns the path to the QPDF executable based on different conditions.
- The `set path` function sets the custom path for QPDF.
- The `get use_system` and `set use_system` functions access and modify the `_use_system` property.

- The `infos`, `dependencies`, and `origin` functions retrieve information about QPDF.
- The `get pdf_folder`, `get pdf_file`, `get has_file`, `get encrypted`, `get toc`, `list_attachments`, `attachments` functions perform various operations on PDF files.
- The `get exe`, `get ready`, `get version`, `install`, `update`, `uninstall` functions handle the installation, update, and uninstallation of QPDF.
*/





/*

https://qpdf.readthedocs.io/en/stable/cli.html#option-show-attachment

windows & linux releases: https://github.com/qpdf/qpdf/releases/
mac releases: https://formulae.brew.sh/formula/qpdf


*/




property _use_system : Boolean

property _custom_path : Text
property _install_path : Text





Class constructor
	
	var $cache : Object
	
	
	This:C1470[""]:={}  // init cache object
	
	$cache:=This:C1470._cache()
	
	// parametrable fields
	
	This:C1470._use_system:=False:C215
	
	This:C1470._custom_path:=""
	This:C1470._install_path:=""
	
	
	
	$cache.os_path:=""
	$cache.version:=""
	
	$cache.sw_options:={\
		timeout: 5; \
		dataType: "text"; \
		encoding: "UTF-8"; \
		variables: {}; \
		hideWindow: True:C214; \
		currentDirectory: Folder:C1567(fk database folder:K87:14)\
		}
	
	$cache.sw_result:={}
	
	This:C1470._reset()
	
	$cache.config:=cs:C1710.config.new(current class name)
	
	This:C1470._load_config()
	
	
Function _cache : Object
	
	return This:C1470[""]
	
	
	
Function _reset()
	var $cache : Object
	
	$cache:=This:C1470._cache()
	$cache.version:=""
	
	$cache._errors:=[]
	
	
	
	
	//mark:-
	
	
Function get _config : cs:C1710.config
	
	return This:C1470._cache().config
	
	
	
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
	
	
	
Function _read_config : Object
	
	return This:C1470._config.read_system()
	
	
	
Function _write_config($definition : Object)
	
	This:C1470._config.write_system($definition)
	
	
	
Function _show_config
	
	show_on_disk(This:C1470._config.system_path)
	
	
	
	//mark:-
	
	
	
	
Function get component_qpdf_folder : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	//$folder:=Folder("/RESOURCES/qpdf/")
	
	$folder:=environ.helpers_folder.folder("qpdf")
	
	If ($folder.exists)
	Else 
		$folder.create()
		// recuperer le fichier de config ?
	End if 
	
	return $folder
	
	
	
Function get component_folder : 4D:C1709.Folder
	var $cache : Object
	var $ok : Boolean
	//var $ub : 4D.Folder
	
	$cache:=This:C1470._cache()
	
	If ($cache.component_folder=Null:C1517)
		
		
		$cache.component_folder:=This:C1470.component_qpdf_folder
		
		
		If (Is macOS:C1572)
			$cache.component_folder:=$cache.component_folder.folder("mac")
		Else 
			
			$cache.component_folder:=$cache.component_folder.folder("win")
		End if 
		
		If ($cache.component_folder.exists)
			
		Else 
			$cache.component_folder.create()
		End if 
		
		
		
		//$ub_folder:=$cache.component_folder.folder("ub")  ///bin").file("qpdf")
		
		Case of 
				
				//: (Is macOS & $ub_folder.exists)
				//$cache.component_folder:=$ub_folder
				
			: (arch.is_mac_arm)
				$cache.component_folder:=$cache.component_folder.folder("arm")
				
			: (arch.is_mac_intel)
				$cache.component_folder:=$cache.component_folder.folder("intel")
				
				
			: (arch.is_microsoft)
				//$cache.component_folder:=Folder("/RESOURCES/qpdf/win/"; fk posix path)
				
				
		End case 
		
		
		If ($cache.component_folder.exists)
		Else 
			$ok:=$cache.component_folder.create()
			
			If (Is macOS:C1572)
				$ok:=$cache.component_folder.folder("bin").create()
				$ok:=$cache.component_folder.folder("lib").create()
				
			Else 
				
			End if 
			
		End if 
		
		$cache.component_folder:=Folder:C1567($cache.component_folder.platformPath; fk platform path:K87:2)  // convert to full path
		
	End if 
	
	return $cache.component_folder
	
	
	
	//mark:-
	
Function get system_path : Text
	
	var $zsh : cs:C1710.zsh
	var $path : Text
	
	var $cache : Object
	
	$cache:=This:C1470._cache()
	
	If (is.valid_path($cache.os_path))
		
	Else 
		
		$zsh:=cs:C1710.zsh.new()
		
		Case of 
				
			: (arch.is_mac_arm)
				$zsh.add_path("/opt/homebrew/bin/")
				
			: (arch.is_mac_intel)
				$zsh.add_path("/usr/local/bin/")
				
		End case 
		
		$path:=$zsh.which("qpdf")
		
		If (is.valid_path($path))
			$cache.os_path:=File:C1566($path; fk posix path:K87:1).original.path
		End if 
		
		
	End if 
	
	return $cache.os_path
	
	
Function get path : Text
	
	var $cache : Object
	var $path : Text
	var $brew : cs:C1710.brew
	var $zsh : cs:C1710.zsh
	var $bin : 4D:C1709.File
	var $helper_folder : 4D:C1709.Folder
	var $return_path : Text
	
	$cache:=This:C1470._cache()
	
	If (This:C1470.use_custom_path)
		$return_path:=This:C1470._custom_path
	Else 
		
		If (This:C1470.use_system)
			
			If ($cache.os_path="")
				
				If (Is macOS:C1572)
					
					
					// try to find with the system
					
					$zsh:=cs:C1710.zsh.new()
					
					If (String:C10(This:C1470._install_path)#"")
						$zsh.add_path(This:C1470._install_path+"bin/")
					End if 
					
					Case of 
							
						: (arch.is_mac_arm)
							$zsh.add_path("/opt/homebrew/bin/")
							
						: (arch.is_mac_intel)
							$zsh.add_path("/usr/local/bin/")
							
					End case 
					
					$path:=$zsh.which("qpdf")
					
					If (is.valid_path($path))
						
					Else 
						
						// try to find with brew
						
						$brew:=cs:C1710.brew.new()
						
						If ($brew.installed)
							
							$bin:=$brew.package_bin("qpdf")
							
							$path:=$bin.path
							
							
						Else 
							
							
							
						End if 
						
					End if 
					
					If (is.valid_path($path))
						
						$cache.os_path:=$path
						
					End if 
					
					
				Else 
					
					$helper_folder:=environ.helpers_folder
					
					//$bin:=Folder("/RESOURCES/qpdf/win/bin/").file("qpdf.exe")
					$bin:=$helper_folder.folder("qpdf/win/bin/").file("qpdf.exe")
					
					$cache.os_path:=to.absolute_path($bin.platformPath)
					
				End if 
				
			End if 
			
			$return_path:=$cache.os_path
			
		Else 
			
			If ($cache.local_path=Null:C1517) || ($cache.local_path="")
				
				$helper_folder:=environ.helpers_folder
				
				//Folder("/RESOURCES/qpdf/mac/ub/bin/").file("qpdf")
				
				$bin:=$helper_folder.folder("qpdf/mac/ub/bin/").file("qpdf")
				
				Case of 
						
					: (Is macOS:C1572 && $bin.exists)
						$cache.local_path:=$bin.path  //to.absolute_path($bin.platformPath)
						
					: (arch.is_mac_arm)
						$bin:=$helper_folder.folder("qpdf/mac/arm/bin/").file("qpdf")
						$cache.local_path:=$bin.path  ////to.absolute_path($bin.platformPath)
						
					: (arch.is_mac_intel)
						$bin:=$helper_folder.folder("qpdf/mac/intel/bin/").file("qpdf")
						$cache.local_path:=$bin.path  ////to.absolute_path($bin.platformPath)
						
					Else 
						
						
						$bin:=$helper_folder.folder("qpdf/win/bin/").file("qpdf.exe")
						
						$cache.local_path:=$bin.path  ////to.absolute_path($bin.platformPath)
						
				End case 
				
			End if 
			
			
			
			$return_path:=$cache.local_path
			
		End if 
		
		
	End if 
	$cache.current_path:=$return_path
	
	
	return $return_path
	
	
Function set path($path : Text)
	If (This:C1470._custom_path#$path)
		This:C1470._custom_path:=$path
		This:C1470._reset()
	End if 
	
	
Function get use_custom_path : Boolean
	return (This:C1470._custom_path="") ? False:C215 : File:C1566(This:C1470._custom_path).exists
	
Function get use_system : Boolean
	return (This:C1470.use_custom_path=False:C215) && This:C1470._use_system
	
	
	
Function set use_system($system : Boolean)
	If (This:C1470._use_system#$system)
		This:C1470._use_system:=$system
		
		This:C1470._reset()
	End if 
	
	
	
Function infos : Object
	
	var $cache : Object
	var $brew : cs:C1710.brew
	
	$cache:=This:C1470._cache()
	
	If ($cache.package_infos=Null:C1517)
		$brew:=cs:C1710.brew.new()
		$cache.package_infos:=$brew.package_infos("qpdf")
	End if 
	
	return $cache.package_infos
	
	
	
Function dependencies : Collection
	var $infos : Object
	var $dependency : Text
	var $dependencies : Collection
	var $brew : cs:C1710.brew
	
	$infos:=This:C1470.infos()
	$brew:=cs:C1710.brew.new()
	
	$dependencies:=[]
	
	If ($infos.dependencies#Null:C1517)
		For each ($dependency; $infos.dependencies)
			$dependencies.push({name: $dependency; bin: $brew.package_bin($dependency); infos: $brew.package_infos($dependency)})
		End for each 
	End if 
	
	return $dependencies
	
	
	
Function origin : Text
	var $infos : Object
	
	//https://github.com/qpdf/qpdf/releases/latest
	
	$infos:=This:C1470.infos()
	
	Case of 
			
		: ($infos.urls=Null:C1517)
			
		: ($infos.urls.stable=Null:C1517)
			
		: ($infos.urls.stable.url=Null:C1517)
			
		Else 
			
			return $infos.urls.stable.url
			
	End case 
	
	
	
	//mark:-
	
	
	
Function get pdf_folder : 4D:C1709.Folder
	
	Case of 
			
		: (This:C1470.pdf_file=Null:C1517)
			
		Else 
			
			return This:C1470.pdf_file.parent
	End case 
	
	
	
Function set pdf_file($file : Variant)
	
	
	This:C1470._reset()
	
	//todo: controler le type entrée text / object
	
	Case of 
			
		: (Value type:C1509($file)=Is text:K8:3)
			
			This:C1470._pdf_file:=File:C1566($file)
			
		: ((Value type:C1509($file)=Is object:K8:27) && (OB Instance of:C1731($file; 4D:C1709.File)))
			
			This:C1470._pdf_file:=File:C1566($file.platformPath; fk platform path:K87:2)
			
		Else 
			
	End case 
	
	
	
Function get has_file : Boolean
	
	return (This:C1470._pdf_file#Null:C1517) && (This:C1470._pdf_file.exists)
	
	
	
Function get pdf_file : 4D:C1709.File
	
	return This:C1470._pdf_file
	
	
	
Function get pdf_path : Text
	
	Case of 
		: (This:C1470.pdf_file=Null:C1517)
			
		Else 
			
			return to.absolute_file(This:C1470._pdf_file).path
			
	End case 
	
	
	
Function get encrypted : Boolean
	var $result : 4D:C1709.SystemWorker
	
	If (This:C1470.has_file)
		
		If (This:C1470.pdf_file.exists)
			
			$result:=This:C1470.execute(" --is-encrypted \""+This:C1470.pdf_path+"\"")
			
			
/*
0 the file is encrypted
			
1 not used
			
2 the file is not encrypted
*/
			
			If (Length:C16($result.responseError)=0)
				
				return $result.exitCode=0
				
			End if 
			
		End if 
		
	End if 
	
	
	
Function get toc->$toc : Object
	
	var $result : 4D:C1709.SystemWorker
	//var $path : Text
	
	$toc:={attachments: {}}
	
	
	$result:=This:C1470.execute(" --json  --no-warn \""+This:C1470.pdf_path+"\"")
	
	If ((Not:C34(Undefined:C82($result.exitCode))) && (Num:C11($result.exitCode)=0) || (Num:C11($result.exitCode)=3))
		
		
		Case of 
			: ($result.response=Null:C1517)
				
			: (is.json_object($result.response))  //object
				
				$toc:=JSON Parse:C1218($result.response)
				
			: (is.json_collection($result.response))  //collection
				
				$toc.attachments:=to.collection($result.response)
				
		End case 
		
		$toc.attachments:=$toc.attachments=Null:C1517 ? {} : $toc.attachments
		
		
	Else 
		
		//return $toc  // because throw exit function 
		throw:C1805({errCode: $result.exitCode; componentSignature: "QPDF-toc"; message: $result.responseError; deferred: True:C214})
		
	End if 
	
	
	
	
	
Function list_attachments : Collection
	
	var $result : 4D:C1709.SystemWorker
	var $_ : Collection
	
	$result:=This:C1470.execute(" --list-attachments \""+This:C1470.pdf_path+"\"")
	
	$_:=to.collection($result.response)
	
	return $_
	
	
	
Function attachments->$_attachments : Collection
	
	var $_; $_mime; $_checksum; $_create; $_update : Collection
	var $w : 4D:C1709.SystemWorker
	var $o; $toc : Object
	var $a : cs:C1710._qpdf_attachment
	var $name; $key : Text
	var $entry : Object
	
	$_attachments:=[]
	
	$toc:=This:C1470.toc.attachments
	
	For each ($name; $toc)
		$entry:=$toc[$name]
		
		$o:=Path to object:C1547($name)
		
		$a:=cs:C1710._qpdf_attachment.new()
		
		$a._name:=$o.name
		$a._extension:=$o.extension
		
		$_:=Split string:C1554($entry.preferredcontents; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		$_.remove($_.length-1)
		$key:=$_.join(",")
		
		
		$w:=This:C1470.show_object($key)
		
		$a._success:=$w.responseError=""
		
		$a._value:=4D:C1709.Blob.new($w.response)
		
		$_mime:=[]
		$_checksum:=[]
		$_create:=[]
		$_update:=[]
		
		For each ($name; $entry.streams)
			$_mime.push($entry.streams[$name].mimetype)
			
			Case of 
				: ($entry.streams[$name].checksum=Null:C1517)
					
				: ($entry.streams[$name].checksum="null")
				Else 
					$_checksum.push($entry.streams[$name].checksum)
			End case 
			
			Case of 
				: ($entry.streams[$name].creationdate=Null:C1517)
					
				: ($entry.streams[$name].creationdate="null")
				Else 
					$_create.push($entry.streams[$name].creationdate)
			End case 
			
			
			Case of 
				: ($entry.streams[$name].modificationdate=Null:C1517)
					
				: ($entry.streams[$name].modificationdate="null")
				Else 
					$_update.push($entry.streams[$name].modificationdate)
			End case 
			
		End for each 
		
		$_mime:=$_mime.distinct()
		$_checksum:=$_checksum.distinct()
		$_create:=$_create.distinct()
		$_update:=$_update.distinct()
		
		If ($_mime.length>0)
			$a._type:=$_mime[0]
		Else 
			$a._type:=""
		End if 
		
		If ($_checksum.length>0)
			$a._checksum:=$_checksum[0]
		End if 
		
		If ($_create.length>0)
			$a._creationDate:=$_create[0]
		End if 
		
		If ($_update.length>0)
			$a._modificationDate:=$_update[0]
		End if 
		
		$_attachments.push($a.to_object)
		
	End for each 
	
	
	
	
	//mark:-
	
	
	
Function get exe : 4D:C1709.File
	
	If (This:C1470.ready)
		return File:C1566(String:C10(This:C1470.path); fk posix path:K87:1)
	End if 
	
	
	
Function get system_ready : Boolean
	
	var $path : Text
	
	$path:=This:C1470.system_path
	If (is.valid_path($path))
		return File:C1566($path; fk posix path:K87:1).exists
	End if 
	
	
	
Function get ready : Boolean
	If (This:C1470.path#"")
		return File:C1566(This:C1470.path; fk posix path:K87:1).exists
	End if 
	
	
	
Function get version : Text
	
	var $cache : Object
	
	$cache:=This:C1470._cache()
	
	If ($cache.version="")
		var $result : 4D:C1709.SystemWorker
		var $_ : Collection
		
		$result:=This:C1470.execute("--version")
		
		If ($result.exitCode=0)
			
			$_:=to.collection($result.response)
			
			$_:=Split string:C1554($_[0]; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			$cache.version:=($_.length>0) ? $_[$_.length-1] : ""
			
		End if 
		
	End if 
	
	return $cache.version
	
	
	
Function install() : Boolean
	var $brew : cs:C1710.brew
	var $success : Boolean
	var $config : Object
	
	If (Is macOS:C1572)
		
		$brew:=cs:C1710.brew.new()
		
		If ($brew.installed)
			
			If ($brew.package_installed("qpdf"))
				
				$success:=$brew.update_package("qpdf")
				
			Else 
				
				$success:=$brew.install_package("qpdf")
				
				If ($success)
					
					$config:=This:C1470._read_config()
					
					$config.install_path:=$brew.install_package_path
					
					This:C1470._write_config($config)
					
					This:C1470._load_config()
					
					//show_on_disk(This._config.path)
					
					//show_on_disk($brew.install_package_path)
					
				End if 
				
			End if 
			
			
			return $success
		End if 
		
	End if 
	
	
	
Function update() : Boolean
	var $brew : cs:C1710.brew
	var $success : Boolean
	
	If (Is macOS:C1572)
		
		$brew:=cs:C1710.brew.new()
		
		If ($brew.installed)
			
			$success:=$brew.update_package("qpdf")
			
			return $success
			
		End if 
		
	End if 
	
	
	
Function uninstall() : Boolean
	var $brew : cs:C1710.brew
	var $success : Boolean
	var $config : Object
	
	If (Is macOS:C1572)
		
		$brew:=cs:C1710.brew.new()
		
		If ($brew.installed)
			
			$success:=$brew.uninstall_package("qpdf")
			
			If ($success)
				
				$config:=This:C1470._read_config()
				
				$config.install_path:=""
				
				This:C1470._write_config($config)
				
				This:C1470._load_config()
				
			End if 
			
			return $success
			
		End if 
		
	End if 
	
	
Function show()
	
	show_on_disk(This:C1470.path)
	
	
	
	//mark:-
	
	
	
Function show_object($ref : Text) : 4D:C1709.SystemWorker
	
	var $result : 4D:C1709.SystemWorker
	var $save_datatype : Text
	var $cache : Object
	
	If (Bool:C1537(This:C1470.pdf_file.exists))
		$cache:=This:C1470._cache()
		
		$save_datatype:=$cache.sw_options.dataType
		$cache.sw_options.dataType:="blob"
		
		$result:=This:C1470.execute(" --show-object="+$ref+" --filtered-stream-data \""+This:C1470.pdf_path+"\" ")
		
		Case of 
				
			: ($result.exitCode=0)
				
			: ($result.exitCode=3)
				
			Else 
				
				throw:C1805({errCode: $result.exitCode; componentSignature: "QPDF-read-attachment"; message: $result.responseError; deferred: True:C214})
				
		End case 
		
		$cache.sw_options.dataType:=$save_datatype
		
	End if 
	
	return $result
	
	
	
	//mark:-
	
	
	
Function execute($command : Text) : Object
	
	var $worker : 4D:C1709.SystemWorker
	var $c : Object
	var $path; $key : Text
	var $cache : Object
	
	If (This:C1470.ready)
		
		$cache:=This:C1470._cache()
		$cache.sw_options.currentDirectory:=File:C1566($cache.current_path).parent
		
		$path:=Replace string:C233(This:C1470.path; " "; "\\ "; Length:C16(This:C1470.path))  // escape white spaces
		
		$worker:=4D:C1709.SystemWorker.new($path+" "+$command; $cache.sw_options)
		
		$worker.wait()
		
		$cache.sw_result:={}
		For each ($key; $worker)
			
			$cache.sw_result[$key]:=$worker[$key]
			
		End for each 
		
		$cache.sw_result.exitCode:=($worker.exitCode=Null:C1517) ? (($worker.terminated) ? 0 : 1) : $worker.exitCode
		
		//https://qpdf.readthedocs.io/en/stable/cli.html#exit-status
		
/*
Exit Codes
		
0 no errors or warnings were found
		
1 not used
		
2 errors were found; the file was not processed
		
3 warnings were found without errors
		
*/
		
		If (Num:C11($worker.exitCode)=2)
			
			$c:={}
			For each ($key; $worker)
				$c[$key]:=$worker[$key]
			End for each 
			$cache._errors.push($c)
			
		End if 
		
	End if 
	
	return $cache.sw_result
	
	
	