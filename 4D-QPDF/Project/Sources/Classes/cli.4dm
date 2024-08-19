
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : cli
   ID[AA96C646C8A1423DABB01E1s5BDAA3BF9]
   Created : 03-12-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/


property ____ : Object

Class constructor($path : Text)
	
	
	
	// Initialize cache object
	
	This:C1470.____:={}  //{options: {}; file: Null; errors: []}
	
	// Define default options for cache
	This:C1470.____.options:={\
		timeout: Null:C1517; \
		dataType: "text"; \
		encoding: "UTF-8"; \
		variables: Null:C1517; \
		hideWindow: True:C214; \
		currentDirectory: to.absolute_folder(Folder:C1567(fk database folder:K87:14))\
		}
	
	// Set file path in cache options
	This:C1470.____.file:=(Count parameters:C259=0) ? Null:C1517 : File:C1566(to.posix($path))
	
	// Initialize errors array in cache
	This:C1470.____.errors:=[]
	
	
	
	// Getter function to access the cache object
Function get _cache : Object
	return This:C1470.____
	
	
	// Function to reset cache errors
Function _reset()
	This:C1470._cache.errors:=[]
	
	
	// Getter function to access the file path
Function get _path : Text
	return This:C1470.installed ? This:C1470._cache.file.path : ""
	
	
	
	//mark:-
	
	
	// Getter function to access the data type in cache options
Function get dataType : Text
	If (This:C1470._cache.options#Null:C1517)
		return This:C1470._cache.options.dataType
	End if 
	
	
	// Setter function to set the data type in cache options
Function set dataType($type : Text)
	This:C1470._cache.options.dataType:=$type
	
	
	// Getter function to check if the extension is installed
Function get installed : Boolean
	
	Case of 
		: (This:C1470._cache.file=Null:C1517)
		: (OB Instance of:C1731(This:C1470._cache.file; 4D:C1709.File))
			return This:C1470._cache.file.exists
	End case 
	
	
	// Getter function to access the timeout in cache options
Function get timeout : Variant
	return This:C1470._cache.options.timeout
	
	
	// Setter function to set the timeout in cache options
Function set timeout($timeout : Variant)
	This:C1470._cache.options.timeout:=$timeout
	
	
	// Getter function to access the hideWindow option in cache options
Function get hideWindow : Boolean
	return This:C1470._cache.options.hideWindow
	
	
	// Setter function to set the hideWindow option in cache options
Function set hideWindow($hide : Boolean)
	This:C1470._cache.options.hideWindow:=$hide
	
	
	// Getter function to access the current directory in cache options
Function get currentDirectory : 4D:C1709.Folder
	return This:C1470._cache.options.currentDirectory
	
	
	// Setter function to set the current directory in cache options
Function set currentDirectory($path : Variant)
	
	var $type : Integer
	
	$type:=Value type:C1509($path)
	
	Case of 
			
		: (($type=Is object:K8:27) && (OB Instance of:C1731($path; 4D:C1709.Folder)) && ($path.exists))
			
			This:C1470._cache.options.currentDirectory:=$path
			
			
		: ($type=Is text:K8:3) && (Test path name:C476($path)=Is a folder:K24:2)
			This:C1470._pdf_file:=Folder:C1567(to.posix($path))
			
			
		: ($type=Is text:K8:3) && (Test path name:C476($path)=Is a document:K24:1)
			This:C1470._pdf_file:=File:C1566(to.posix($path)).parent
			
			
			
		: (($type=Is object:K8:27) && (OB Instance of:C1731($path; 4D:C1709.File)) && ($path.exists))  // . misc
			
			This:C1470._cache.options.currentDirectory:=$path.parent
			
	End case 
	
	
	// Getter function to access the resolved path
Function get path : Text
	return This:C1470._path
	
	
	// Getter function to check if a command is set
Function get is_cmd : Boolean
	return (Value type:C1509(This:C1470._cache.cmd)=Is text:K8:3)
	
	
	// Getter function to access the command
Function get cmd : Text
	If (This:C1470.is_cmd)
		return This:C1470._cache.cmd
	End if 
	
	
	// Setter function to set the command
Function set cmd($cmd : Variant)
	Case of 
		: (Value type:C1509($cmd)=Is text:K8:3)
			This:C1470._cache.cmd:=$cmd
			
		: (Value type:C1509($cmd)=Is null:K8:31)
			OB REMOVE:C1226(This:C1470._cache; "cmd")
			
	End case 
	
	
	// Getter function to access the variables in cache options
Function get variables : Object
	return (This:C1470._cache.options.variables=Null:C1517) ? {} : This:C1470._cache.options.variables
	
	
	// Setter function to set the variables in cache options
Function set variables($vars : Object)
	This:C1470._cache.options.variables:=$vars
	
	
	//mark:-
	
	
	// Function to disable timeout
Function no_time_out
	This:C1470.timeout:=Null:C1517
	
	
	// Function to execute a command
Function execute($command : Text) : Object
	
	var $worker : 4D:C1709.SystemWorker
	var $c : Object
	var $key : Text
	
	// Check if extension is installed or if a command is set
	If (This:C1470.installed || This:C1470.is_cmd)
		
		// Initialize system worker based on whether a command is set or not
		If (This:C1470.is_cmd)
			$worker:=4D:C1709.SystemWorker.new(This:C1470._cache.cmd+" "+$command; This:C1470._cache.options)
		Else 
			$worker:=4D:C1709.SystemWorker.new(This:C1470._path+" "+$command; This:C1470._cache.options)
		End if 
		
		// Wait for system worker to complete execution based on timeout option
		Case of 
			: (This:C1470._cache.options.timeout=Null:C1517) || (This:C1470._cache.options.timeout<=0)
				
				$worker.wait()
				
			Else 
				$worker.wait(This:C1470._cache.options.timeout)
				
		End case 
		
		
		// Initialize result object
		$c:={}
		// Iterate over worker keys and store in result object
		For each ($key; $worker)
			$c[$key]:=$worker[$key]
		End for each 
		
		// Check if exit code is non-zero and store errors
		If (Num:C11($worker.exitCode)#0)
			
			This:C1470._cache.errors.push($c)
			
		End if 
		
		// If data type is text, convert response to collection
		If ($worker.dataType="text")
			
			$c.rows:=to.collection($c.response)
			
		End if 
		
		// Convert response errors to collection
		$c.errors:=to.collection($c.responseError)
		
	Else 
		
		// If extension is not installed or no command is set, return error code
		$c:={errorCode: -43}
		
	End if 
	
	return $c
	
	
	