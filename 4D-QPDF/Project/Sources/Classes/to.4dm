
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : to
   ID[163E35D0B3C542A3ACEE4E4F82DA30E1]
   Created : 03-04-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/


singleton Class constructor
	
	
	
	//mark:-
	
	
	
	// Convert file path to absolute path using platform-specific format
Function absolute_file($file : 4D:C1709.File) : 4D:C1709.File
	return File:C1566($file.platformPath; fk platform path:K87:2)
	
	
	
	// Convert folder path to absolute path using platform-specific format
Function absolute_folder($folder : 4D:C1709.Folder) : 4D:C1709.Folder
	return Folder:C1567($folder.platformPath; fk platform path:K87:2)
	
	
	
Function absolute_path($path : Text) : Text
	var $o : Object
	
	// Check and adjust path format if necessary
	If (Position:C15(Folder separator:K24:12; $path; *)>0)
		$path:=Convert path system to POSIX:C1106($path)
	End if 
	
	If (Test path name:C476(Convert path POSIX to system:C1107($path))=Is a folder:K24:2)
		// Ensure path ends with "/"
		$path:=$path="@/" ? $path : $path+"/"
	End if 
	
	// Determine object type (file or folder) from path
	$o:=Path to object:C1547($path; Path is POSIX:K24:26)
	
	If ($o.isFolder)
		$o:=Folder:C1567($path)
	Else 
		$o:=File:C1566($path)
	End if 
	
	// Resolve alias to original path if applicable
	$o:=$o.isAlias ? $o.original : $o
	
	// Return the absolute path
	return $o.path
	
	
	
Function posix($path : Variant) : Text
	var $type : Integer
	
	$type:=Value type:C1509($path)
	
	Case of 
		: ($type=Is text:K8:3)
			// Convert path to POSIX format
			If (Position:C15(Folder separator:K24:12; $path)>0)
				$path:=Convert path system to POSIX:C1106($path)
			End if 
			
			return $path
			
			
		: ($type#Is object:K8:27)
			// Error handling for invalid value types
			ASSERT:C1129(False:C215; "error to_posix :value could be a path or 4D.Folder or 4D.File or null for home directory")
			
		: ($path=Null:C1517)
			// Return home directory path if input is null
			return Folder:C1567(fk home folder:K87:24).path
			
		: (OB Instance of:C1731($path; 4D:C1709.Folder))
			// Return folder path
			return $path.path
			
		: (OB Instance of:C1731($path; 4D:C1709.File))
			// Return file path
			return $path.path
			
		Else 
			
			// Error handling for invalid value types
			ASSERT:C1129(False:C215; "error to.posix: value could be a path or 4D.Folder or 4D.File or null for home directory")
			
	End case 
	
	
	
	// Resolve the path relative to the base folder and return the corresponding object
Function resolve_path($path : Variant; $baseFolder : 4D:C1709.Folder) : Object
	
	var $absolutePath : Text
	var $absoluteFolder; $app; $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	var $path_root; $base_root : Text
	var $_path; $_base; $_volume : Collection
	
	Case of 
			
		: ((Value type:C1509($path)=Is object:K8:27) && (OB Instance of:C1731($path; 4D:C1709.File) || OB Instance of:C1731($path; 4D:C1709.Folder)))  // $path is a File or a Folder
			// Return input path if it's already a file or folder object
			return $path
			
		: (Value type:C1509($path)=Is text:K8:3)  // $path is a text
			// Resolve text path
			
			// Set base folder as the starting point
			$absoluteFolder:=$baseFolder
			
			Case of 
					
				: ($path="./@")
					// Resolve relative path inside base folder
					$path:=Substring:C12($path; 3)
					$absolutePath:=$absoluteFolder.path+$path
					
				: ($path="../@")
					// Resolve relative path outside base folder
					While ($path="../@")
						$absoluteFolder:=$absoluteFolder.parent
						$path:=Substring:C12($path; 4)
					End while 
					$absolutePath:=$absoluteFolder.path+$path
					
				Else 
					
					// Resolve absolute or custom file system path
					Case of 
							
						: ($path="/4DCOMPONENTS/@")
							// Resolve path within Components folder
							$app:=(Is macOS:C1572) ? Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents/Components") : File:C1566(Application file:C491; fk platform path:K87:2).parent.folder("Components")
							$absolutePath:=$app.path+Substring:C12($path; 15)
							
						: (($path="") | ($path="/"))
							// Return base folder path if path is empty or "/"
							$absolutePath:=$baseFolder.path
							
						Else 
							
							// Resolve absolute path or base folder subpath
							
							Case of 
									
								: (Folder:C1567($path; *).exists)
									// Resolve folder path
									$absolutePath:=Folder:C1567(Folder:C1567($path; *).platformPath; fk platform path:K87:2).path
									
									
								: (File:C1566($path; *).exists)
									// Resolve file path
									$absolutePath:=File:C1566(File:C1566($path; *).platformPath; fk platform path:K87:2).path
									
								Else 
									// Resolve other cases
									
									// Split paths into segments
									$_base:=($baseFolder=Null:C1517) ? [] : Split string:C1554($baseFolder.path; "/"; sk ignore empty strings:K86:1)
									$_path:=Split string:C1554($path; "/"; sk ignore empty strings:K86:1)
									
									// Get root volumes of base folder and input path
									$base_root:=Split string:C1554($baseFolder.platformPath; Folder separator:K24:12)[0]
									$path_root:=Split string:C1554(Folder:C1567($path; fk posix path:K87:1).platformPath; Folder separator:K24:12)[0]
									
									If ($path_root=$base_root)
										
										// Paths are on the same root volume
										
										If ($_base[0]=$_path[0])
											// Paths share the same root
											$absolutePath:=$path
										Else 
											// Absolute path
											$absolutePath:=$absoluteFolder.path+$path
										End if 
										
									Else 
										
										// Paths are on different volumes
										
										// Check if path volume exists
										$_volume:=Get system info:C1571.volumes.query(" name = :1 "; $path_root)
										If ($_volume.length>0)
											// Path volume exists
											$absolutePath:=$path
										Else 
											// Use absolute folder path
											$absolutePath:=$absoluteFolder.path+$path  // stranger thing
										End if 
										
									End if 
									
									// Remove double slashes from path
									$absolutePath:=Replace string:C233($absolutePath; "//"; "/")
									
							End case 
							
					End case 
					
			End case 
			
			// Create folder or file object from resolved path
			$folder:=Folder:C1567($absolutePath; *)
			If ($absolutePath="@/")
				// If path is root, return folder object
			Else 
				// If path is not root, attempt to create file object
				$file:=File:C1566($absolutePath; *)  // generate a -1 error if path is a folder
				
			End if 
			
			Case of 
					
				: ($folder.isPackage)
					// Return package folder object
					return Folder:C1567($folder.platformPath; fk platform path:K87:2)
					
				: (Bool:C1537($file.isFile))
					// Return file object if path is a file
					return File:C1566($file.platformPath; fk platform path:K87:2)
					
				Else 
					// Return folder object for all other cases
					return Folder:C1567($folder.platformPath; fk platform path:K87:2)
					
			End case 
			
		Else 
			// Return null for invalid input type
			return Null:C1517
			
	End case 
	
	
	
	
	//mark:-
	//todo: @executable_path, @loader_path, @rpath
	// https://wincent.com/wiki/@executable_path,_@load_path_and_@rpath
	
	
	
	
	//mark:-
	
Function json($something : Variant; $beautify : Boolean) : Text
	
	$beautify:=Count parameters:C259<2 ? False:C215 : $beautify
	
	Case of 
			
		: (Value type:C1509($something)=Is object:K8:27)
			
			If ($beautify)
				
				return JSON Stringify:C1217($something; *)
				
			Else 
				
				return JSON Stringify:C1217($something)
				
			End if 
			
			
		: (Value type:C1509($something)=Is collection:K8:32)
			
			If ($beautify)
				
				return JSON Stringify:C1217($something; *)
				
			Else 
				
				return JSON Stringify:C1217($something)
				
			End if 
			
	End case 
	
	
	
Function text($something : Variant) : Text
	
	var $type : Integer
	
	// Determine the type of input
	$type:=Value type:C1509($something)
	
	Case of 
			
		: ($type=Is text:K8:3)
			// If input is already text, return it after removing line breaks
			
			Case of 
					
				: (Position:C15("\r\n"; $something; *)>0)
					
					return Replace string:C233($something; "\r\n"; "")
					
					
				: (Position:C15("\n"; $something; *)>0)
					
					return Replace string:C233($something; "\n"; "")
					
				: (Position:C15("\r"; $something; *)>0)
					
					return Replace string:C233($something; "\r"; "")
					
				Else 
					
					return $something
					
			End case 
			
			
		Else 
			
			// todo: For other data types, implement as needed (not implemented in this snippet)
			
			
			
	End case 
	
	
	
Function collection($something : Variant; $options : Integer; $separator : Text) : Collection
	
	var $_ : Collection
	var $type : Integer
	
	// Set default options if not provided
	If (Count parameters:C259<2)
		$options:=sk ignore empty strings:K86:1+sk trim spaces:K86:2
	End if 
	
	// Determine the type of input
	$type:=Value type:C1509($something)
	
	$_:=[]  // default
	
	Case of 
		: ($type=Is text:K8:3)
			// If input is text, split it into a collection based on the separator
			
			Case of 
					
				: (is.json_collection($something))
					
					$_:=JSON Parse:C1218($something)
					
				: (Count parameters:C259>2) & (Length:C16($separator)>0)
					
					$_:=Split string:C1554($something; $separator; $options)
					
				: (Position:C15("\r\n"; $something; *)>0)
					
					$_:=Split string:C1554($something; "\r\n"; $options)
					
					
				: (Position:C15("\n"; $something; *)>0)
					
					$_:=Split string:C1554($something; "\n"; $options)
					
				: (Position:C15("\r"; $something; *)>0)
					
					$_:=Split string:C1554($something; "\r"; $options)
					
					
			End case 
			
		Else 
			
			//todo: For other data types, implement as needed (not implemented in this snippet)
			
			
	End case 
	
	
	return $_