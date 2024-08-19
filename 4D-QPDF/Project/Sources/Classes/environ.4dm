/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : environ
   ID[62E60A1759634173B678BB08D8F4353B]
   Created : 22-07-2024 by Dominique Delahaye
   ----------------------------------------------------
*/


property _resources_folder : 4D:C1709.Folder
property _helpers_folder : 4D:C1709.Folder


singleton Class constructor
	
	
	
	//mark:-
	
Function get resources_folder : 4D:C1709.Folder
	
	If (This:C1470._resources_folder=Null:C1517)
		This:C1470._resources_folder:=Folder:C1567(Folder:C1567("/RESOURCES").platformPath; fk platform path:K87:2)
	End if 
	
	return This:C1470._resources_folder
	
	
	
Function get helpers_folder : 4D:C1709.Folder
	
	If (This:C1470._helpers_folder=Null:C1517)
		This:C1470._helpers_folder:=This:C1470.resources_folder.parent.folder("Helpers")
	End if 
	
	return This:C1470._helpers_folder
	
	