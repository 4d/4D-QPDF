/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : xcode_select
   ID[B1363B647D3C4430A98D26570BB1ED25]
   Created : 03-12-2024 by Dominique Delahaye
   Commented by: 
   ----------------------------------------------------
*/


Class extends cli



Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:="xcode-select"
	
	
	
Function get path : Text
	var $cache : Object
	var $execute : Object
	
	$cache:=This:C1470._cache
	
	
	If (String:C10($cache.os_path)="")
		
		$execute:=This:C1470.execute(" -p")
		
		If ($execute.rows.length>0)
			
			$cache.os_path:=$execute.rows[0]
			
		End if 
		
	End if 
	
	
	return $cache.os_path
	
	
Function get version : Text
	var $cache : Object
	var $_ : Collection
	var $execute : Object
	
	$cache:=This:C1470._cache
	
	
	If (String:C10($cache.version)="")
		
		$execute:=This:C1470.execute(" -v")
		
		If ($execute.rows.length>0)
			
			$cache.version:=$execute.rows[0]
			$_:=Split string:C1554($cache.version; " ")
			
			$_:=Split string:C1554($_[$_.length-1]; "."; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			$cache.version:=$_[0]
			
		End if 
		
	End if 
	
	
	return $cache.version
	
	
	
Function install()
	var $execute : Object
	
	$execute:=This:C1470.execute(" --install")
	
	
Function show()
	show_on_disk(This:C1470.path)
	