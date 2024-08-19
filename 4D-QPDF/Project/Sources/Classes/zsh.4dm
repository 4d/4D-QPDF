
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : zsh
   ID[6CEF98B7226140ACBCB27E2A2C2EB34E]
   Created : 03-04-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/



/*

This code defines a class in 4D (4D for iOS and macOS) that interacts with the command-line shell in macOS (likely Zsh based on the code) for various tasks. 
Let's break down the key functions and their purposes:

### Class Definition
- **Extends**: This class extends some other class, which is not visible in the provided code.
- **Property**: `_variables` is an object property that seems to hold environment variables.

### Class Constructor
- **Initialization**: Calls the superclass constructor (`Super()`) and sets the command (`This.cmd`) to `"xcode-select"`.
- **Working Directory**: Sets the `_working_directory` property to the user's home folder.

### Methods
1. **`get currentDirectory : 4D.Folder`**: Returns the current working directory.
2. **`set currentDirectory($path : Variant)`**: Sets the current working directory.
3. **`get timeout : Integer`**: Gets the timeout value.
4. **`set timeout($value : Integer)`**: Sets the timeout value.
5. **`get exitCode : Integer`**: Gets the exit code of the last executed command.
6. **`get response : Text`**: Gets the response of the last executed command.
7. **`get responseError : Text`**: Gets the error response of the last executed command.
8. **`get terminated : Boolean`**: Checks if the command execution is terminated.

9. **`add_path($location : Variant) : cs.zsh`**: Adds a path to the environment's `PATH`.
10. **`where($target) : Text`**: Searches for the location of a command.
11. **`which($target) : Text`**: Finds the location of a command.
12. **`echo($target) : Text`**: Executes the `echo` command.
13. **`find($target) : Collection`**: Finds files matching a pattern.
14. **`cat($target) : Collection`**: Reads a file and returns its content.
15. **`env : Object`**: Retrieves environment variables.
16. **`shell : Text`**: Retrieves the shell being used.
17. **`ls($path : Text) : Collection`**: Lists files in a directory.
18. **`whoami : Text`**: Returns the current user.
19. **`is_admin($user : Text) : Boolean`**: Checks if a user is an administrator.
20. **`is_admin_user : Boolean`**: Checks if the current user is an administrator.
21. **`sudo($cmd : Text; $title : Text) : 4D.SystemWorker`**: Executes a command with elevated privileges.
22. **`execute($cmd : Text) : 4D.SystemWorker`**: Executes a command.

These methods provide a comprehensive interface for executing shell commands and managing the environment in a macOS environment. 
They seem to be part of a larger framework for interacting with the command-line interface programmatically.

*/


property _variables : Object

Class constructor
	
	
	This:C1470._working_directory:=Folder:C1567(Folder:C1567(fk home folder:K87:24).platformPath; fk platform path:K87:2)
	This:C1470.env()
	
	
Function get currentDirectory : 4D:C1709.Folder
	return This:C1470._working_directory
	
	
Function set currentDirectory($path : Variant)
	
	var $type : Integer
	
	$type:=Value type:C1509($path)
	
	Case of 
		: ($type=Is text:K8:3)
			
			If (Position:C15(Folder separator:K24:12; $path)=0)
				$path:=Convert path POSIX to system:C1107($path)
			End if 
			
			Case of 
				: (Test path name:C476($path)=Is a folder:K24:2)
					This:C1470._working_directory:=Folder:C1567($path; fk platform path:K87:2)
					
				: (Test path name:C476($path)=Is a document:K24:1)
					This:C1470._working_directory:=File:C1566($path; fk platform path:K87:2).parent
				Else 
					
			End case 
			
		: ($type#Is object:K8:27) && ($type#Is null:K8:31)
			
			ASSERT:C1129(False:C215; "error zsh : setting current directory failed. Value could be a path or 4D.Folder or 4D.File or null for home directory")
			
		: ($path=Null:C1517)
			//This._working_directory:=Folder(Folder(fk home folder).platformPath; fk platform path)
			This:C1470._working_directory:=Null:C1517
			
		: (OB Instance of:C1731($path; 4D:C1709.Folder))
			This:C1470._working_directory:=$path
			
		: (OB Instance of:C1731($path; 4D:C1709.File))
			This:C1470._working_directory:=$path.parent
			
		Else 
			
			ASSERT:C1129(False:C215; "error zsh : setting current directory failed. Value could be a path or 4D.Folder or 4D.File or null for home directory")
			
	End case 
	
	
	
Function get timeout : Integer
	return This:C1470._timeout#Null:C1517 ? Num:C11(This:C1470._timeout) : -1
	
	
Function set timeout($value : Integer)
	
	This:C1470._timeout:=($value>0) ? $value : Null:C1517
	
	
Function get exitCode : Integer
	return This:C1470._exitCode
	
	
Function get response : Text
	return This:C1470._response
	
	
Function get responseError : Text
	return This:C1470._responseError
	
	
Function get terminated : Boolean
	return This:C1470._terminated
	
	
	
	//mark:-
	
Function _catch_execution($worker : 4D:C1709.SystemWorker)
	
	This:C1470._exitCode:=$worker.exitCode
	This:C1470._response:=$worker.response
	This:C1470._responseError:=$worker.responseError
	This:C1470._terminated:=$worker.terminated
	
	//mark:-
	
Function add_path($location : Variant) : cs:C1710.zsh
	var $_ : Collection
	var $path : Text
	
	If (This:C1470._variables.PATH=Null:C1517)
		$_:=[]
	Else 
		$_:=Split string:C1554(This:C1470._variables.PATH; ":")
	End if 
	$path:=to.posix($location)
	
	If (is.valid_path($path))
		
		If ($_.indexOf($path)<0)
			
			If ($path="@/")
				$path:=Substring:C12($path; 1; Length:C16($path)-1)
			End if 
			
			$_.push($path)
			
		End if 
		This:C1470._variables.PATH:=$_.join(":")
	End if 
	
	return This:C1470
	
	
Function where($target) : Text
	
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new("zsh")
	$worker.postMessage("where "+$target)
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)
	
	
Function which($target) : Text
	
	//todo: windows la commande est where
	var $worker : 4D:C1709.SystemWorker
	
	
	Case of 
		: (This:C1470.currentDirectory=Null:C1517)
			$worker:=4D:C1709.SystemWorker.new("zsh")
			
		: (This:C1470.currentDirectory.exists)
			$worker:=4D:C1709.SystemWorker.new("zsh"; {currentDirectory: This:C1470.currentDirectory; variables: This:C1470._variables})
		Else 
			$worker:=4D:C1709.SystemWorker.new("zsh")
	End case 
	$worker.postMessage("which "+$target)
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)
	
	
	
	
	
Function echo($target) : Text
	
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new("zsh")
	$worker.postMessage("echo "+$target)
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)
	
	
Function find($target) : Collection
	
	var $worker : 4D:C1709.SystemWorker
	var $options : Object
	$options:={}
	If (This:C1470.currentDirectory#Null:C1517)
		$options.currentDirectory:=This:C1470.currentDirectory
	End if 
	
	$worker:=4D:C1709.SystemWorker.new("zsh"; $options)
	$worker.postMessage("find . -name \""+$target+"\" 2>/dev/null")
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.collection($worker.response)
	
	
Function cat($target) : Collection
	
	var $worker : 4D:C1709.SystemWorker
	var $options : Object
	$options:={}
	If (This:C1470.currentDirectory#Null:C1517)
		$options.currentDirectory:=This:C1470.currentDirectory
	End if 
	
	$worker:=4D:C1709.SystemWorker.new("zsh"; $options)
	$worker.postMessage("cat \""+$target+"\" ")
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.collection($worker.response)
	
	
Function env : Object
	var $worker : 4D:C1709.SystemWorker
	var $options : Object
	var $_; $__ : Collection
	var $i : Integer
	
	$options:={}
	If (This:C1470.currentDirectory#Null:C1517)
		$options.currentDirectory:=This:C1470.currentDirectory
	End if 
	
	
	$worker:=4D:C1709.SystemWorker.new("zsh"; $options)
	$worker.postMessage("env")
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	$_:=to.collection($worker.response)
	
	
	
	This:C1470._variables:={}
	
	For ($i; 0; $_.length-1)
		$__:=Split string:C1554($_[$i]; "="; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
		
		This:C1470._variables[$__[0]]:=$__[1]
		
	End for 
	
	return This:C1470._variables
	
	
Function shell : Text
	var $worker : 4D:C1709.SystemWorker
	var $options : Object
	$options:={}
	If (This:C1470.currentDirectory#Null:C1517)
		$options.currentDirectory:=This:C1470.currentDirectory
	End if 
	
	
	$worker:=4D:C1709.SystemWorker.new("zsh"; $options)
	$worker.postMessage("echo $SHELL")
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)
	
	
Function ls($path : Text) : Collection
	var $worker : 4D:C1709.SystemWorker
	var $options : Object
	
	$options:={}
	If (This:C1470.currentDirectory#Null:C1517)
		$options.currentDirectory:=This:C1470.currentDirectory
	End if 
	
	
	$worker:=4D:C1709.SystemWorker.new("zsh"; $options)
	If (Count parameters:C259>0)
		$worker.postMessage("ls \""+$path+"\"")
	Else 
		$worker.postMessage("ls")
	End if 
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	
	return to.collection($worker.response)
	
	
Function whoami : Text
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new("zsh")
	$worker.postMessage("whoami")
	$worker.closeInput()
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)
	
	
Function is_admin($user : Text) : Boolean
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new("zsh")
	$worker.postMessage("dseditgroup -o checkmember -m "+$user+" admin")
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)="yes @"
	
	
Function is_admin_user : Boolean
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new("zsh")
	$worker.postMessage("dseditgroup -o checkmember admin")
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	return to.text($worker.response)="yes @"
	
	
Function sudo($cmd : Text; $title : Text) : 4D:C1709.SystemWorker
	var $worker : 4D:C1709.SystemWorker
	var $script : 4D:C1709.File
	var $variables : Object
	var $user : Text
	var $count : Integer
	
	//$script:=Folder(Folder("/RESOURCES/scripts").platformPath; fk platform path).file("sudo-askpass")
	$script:=environ.resources_folder.folder("scripts").file("sudo-askpass")
	
	$variables:=OB Copy:C1225(This:C1470._variables)
	
	If (This:C1470.is_admin_user())
		$user:=This:C1470.whoami()
	Else 
		
		Repeat 
			$user:=Request:C163("Enter an admin user login:")
			
			$count+=$count
		Until ($count>2) || This:C1470.is_admin($user)
		
	End if 
	
	
	
	$variables.SUDO_USER:=$user
	$variables.SUDO_ASKPASS_TITLE:=$title
	$variables.SUDO_ASKPASS_MESSAGE:="Please, input "+$variables.SUDO_USER+" password."
	$variables.SUDO_ASKPASS:=$script.path
	$variables.SUDO_COMMAND:=$cmd
	
	
	$worker:=4D:C1709.SystemWorker.new("zsh"; {variables: $variables})
	$worker.postMessage($cmd)
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	
	return $worker
	
	
	
	
Function execute($cmd : Text) : 4D:C1709.SystemWorker
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new("zsh")
	$worker.postMessage($cmd)
	$worker.closeInput()
	
	$worker.wait()
	
	This:C1470._catch_execution($worker)
	
/*
Warning: Running in non-interactive mode because `stdin` is not a TTY.
Need sudo access on macOS (e.g. the user 4d needs to be an Administrator)!
	
*/
	
	return $worker  //This.to_text($worker.response)