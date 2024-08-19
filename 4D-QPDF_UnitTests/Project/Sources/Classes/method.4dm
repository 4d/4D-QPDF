

property _path : Text

//https://doc.4d.com/4Dv20R4/4D/20-R4/Commandes-du-theme-Acces-objets-developpement.300-6656406.fe.html

Class constructor($path : Text)
	
	This:C1470._path:=$path
	
	
	//mark:-
	
	
Function get is_method : Boolean
	If (This:C1470.exists)
		return This:C1470._path#"[@"
	End if 
	
	
Function get is_database_method : Boolean
	If (This:C1470.exists)
		return This:C1470._path="[databaseMethod]/@"
	End if 
	
	
Function get is_project_form_method : Boolean
	If (This:C1470.exists)
		return This:C1470._path="[projectForm]/@"
	End if 
	
	
Function get is_table_form_method : Boolean
	If (This:C1470.exists)
		return This:C1470._path="[tableForm]/@"
	End if 
	
	
Function get is_trigger : Boolean
	If (This:C1470.exists)
		return This:C1470._path="[trigger]/@"
	End if 
	
	
	//mark:-
	
	
Function get name : Text
	
	var $_ : Collection
	$_:=Split string:C1554(This:C1470._path; "/"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	return $_[$_.length-1]  //This._path
	
	
Function get exists : Boolean
	
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path all objects:K72:16; $_path)
	
	return Find in array:C230($_path; This:C1470._path)>0
	
	
	
Function get invisible : Boolean
	var $attributs : Object
	
	$attributs:=This:C1470.attributs()
	If ($attributs.exists)
		return $attributs.invisible
	End if 
	
	
	
Function get server : Boolean
	var $attributs : Object
	
	$attributs:=This:C1470.attributs()
	If ($attributs.exists)
		return $attributs.executedOnServer
	End if 
	
	
	
Function get shared : Boolean
	var $attributs : Object
	
	$attributs:=This:C1470.attributs()
	If ($attributs.exists)
		return $attributs.shared
	End if 
	
	
	
Function get adaptative : Boolean
	var $attributs : Object
	If (This:C1470.exists)
		METHOD GET ATTRIBUTES:C1334(This:C1470._path; $attributs)
		return Bool:C1537($attributs.preemptive="indifferent")
	End if 
	
	
	
Function get cooperative : Boolean
	var $attributs : Object
	If (This:C1470.exists)
		METHOD GET ATTRIBUTES:C1334(This:C1470._path; $attributs)
		return Bool:C1537($attributs.preemptive="incapable")
	End if 
	
	
	
Function get preemptive : Boolean
	var $attributs : Object
	If (This:C1470.exists)
		METHOD GET ATTRIBUTES:C1334(This:C1470._path; $attributs)
		return Bool:C1537($attributs.preemptive="capable")
	End if 
	
	
Function get comments : Text
	var $comments : Text
	
	If (This:C1470.exists)
		METHOD GET COMMENTS:C1189(This:C1470._path; $comments)
		return $comments
	End if 
	
	
	//mark:-
	
	
Function attributs : Object
	var $attributs : Object
	
	If (This:C1470.exists)
		METHOD GET ATTRIBUTES:C1334(This:C1470._path; $attributs)
		$attributs.exists:=True:C214
	Else 
		$attributs:={exists: False:C215}
	End if 
	
	return $attributs
	
	
Function code : Text
	var $code : Text
	
	If (This:C1470.exists)
		METHOD GET CODE:C1190(This:C1470._path; $code)
	End if 
	
	return $code
	
	
Function tokens : Text
	var $code : Text
	
	If (This:C1470.exists)
		METHOD GET CODE:C1190(This:C1470._path; $code; Code with tokens:K72:18)
	End if 
	
	return $code