Class extends _method_attributs

property _path : Text

Class constructor($path : Text; $attributs : Object)
	
	
	Super:C1705(($attributs=Null:C1517) ? {} : $attributs)
	
	
	This:C1470._path:=$path
	
	
	
Function get name : Text
	var $_ : Collection
	$_:=Split string:C1554(This:C1470._path; "/")
	return Split string:C1554($_[$_.length-1]; ".4DM"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)[0]  //This._name
	
	
	
	
	
	
	
	