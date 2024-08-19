/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : install_name_tool
   ID[62B518601C4943C88E23D9804012B079]
   Created : 03-12-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/


Class extends cli



Class constructor()
	
	// Assuming the path for install_name_tool is specified correctly
	Super:C1705("/usr/bin/install_name_tool")  // which // windows path
	
	
	
	// Change the library or framework install path in a Mach-O binary
Function change($oldPath : Text; $newpath : Text; $target : Text) : 4D:C1709.SystemWorker
	var $worker : 4D:C1709.SystemWorker
	
	This:C1470.dataType:="text"
	This:C1470.no_time_out()
	
	$worker:=This:C1470.execute(" -change "+$oldPath+" "+$newpath+" "+$target)
	
	return $worker
	
	
	
Function id($id : Text; $target : Text) : 4D:C1709.SystemWorker
	
	var $worker : 4D:C1709.SystemWorker
	
	This:C1470.dataType:="text"
	This:C1470.no_time_out()
	
	$worker:=This:C1470.execute(" -id \"@executable_path"+$id+"\"  \""+$target+"\"")
	
	return $worker
	
	
	//// Implementation goes here
	
	// Set the runtime search path in a Mach-O binary
	//Function rpath($oldPath : Text; $newpath : Text)
	//// Implementation goes here
	
	
	//Function add_rpath
	//// Implementation goes here
	
	
	//Function delete_rpath
	//// Implementation goes here
	
	
	
	