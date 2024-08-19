/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : otool
   ID[07B74FC7AC9A420FA3D620C9A0EC6326]
   Created : 03-12-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/

Class extends cli


Class constructor
	
	Super:C1705("/usr/bin/otool")
	
/*
Display the names and version numbers of the shared libraries
that the object file uses, as well as the shared library ID if
the file is a shared library.
*/
	
	
	// Function to retrieve dependencies of a given file
Function L($path : Text; $arch : Text) : Collection
	
	var $i : Integer
	var $_dependancie : Collection
	var $worker : 4D:C1709.SystemWorker
	var $rpath : 4D:C1709.Folder
	var $owner : 4D:C1709.File
	var $_ : Collection
	var $otool_result; $param : Text
	var $to : cs:C1710.to
	var $target : 4D:C1709.File
	
	$_dependancie:=[]
	
	// Set the data type and disable timeout for long-running commands
	This:C1470.dataType:="text"
	This:C1470.no_time_out()
	
	$param:=" -L "+(($arch="") ? "" : " -arch "+$arch)
	
	// Execute otool command to retrieve dependencies
	$worker:=This:C1470.execute(" -L \""+$path+"\"")
	
	If ($worker.rows#Null:C1517)
		
		$to:=to
		
		$owner:=File:C1566($path)
		
		For ($i; 1; $worker.rows.length-1)
			
			// Remove tab characters from the output
			$worker.rows[$i]:=Replace string:C233($worker.rows[$i]; "\t"; "")
			
			// Split the output to extract dependency information
			$_dependancie.push(Split string:C1554($worker.rows[$i]; "("; sk trim spaces:K86:2))
			
		End for 
		
		// Get the parent directory of the file and then its parent directory (assuming the file is located in a subdirectory of 'lib')
		$rpath:=File:C1566($path; fk posix path:K87:1).parent.parent
		
		// Append 'lib' to the parent directory path
		$rpath:=$rpath.folder("lib")
		
		For ($i; 0; $_dependancie.length-1)
			
			$otool_result:=$_dependancie[$i][0]
			Case of 
				: ($_dependancie[$i][0]="/@")  // absolute path
				: ($_dependancie[$i][0]="@rpath/@")
					
					$_:=Split string:C1554($_dependancie[$i][0]; "/"; sk trim spaces:K86:2)
					
					// Resolve the dependency path using the 'lib' directory
					$_dependancie[$i][0]:=$rpath.file($_[1]).path
					
					
				Else 
					
					//nothing to do
					
			End case 
			
			
			// Resolve the path to the dependency file
			$target:=$to.resolve_path($_dependancie[$i][0]; $owner.parent)
			
			// Store dependency information along with the resolved file path
			$_dependancie[$i]:={otool_result: $otool_result; owner: $owner; path: $target.path; file: $target}  // infos: $_dependancie[$i][1]; 
			
		End for 
		
	End if 
	
	return $_dependancie
	
	
	