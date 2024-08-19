

property _folders_file : 4D:C1709.File

Class constructor
	
	This:C1470._folders_file:=Folder:C1567("/PACKAGE/Project/Sources").file("folders.json")
	This:C1470._folder_derived_data:=Folder:C1567("/PACKAGE/Project/DerivedData")
	This:C1470._folder_compiled_code:=Folder:C1567("/PACKAGE/Project/CompiledCode")
	
	This:C1470._map_json:=Folder:C1567("/PACKAGE/Project/CompiledCode").file("map.json")
	
	
	
Function classes : Collection
	var $_ : Collection
	
	$_:=[]
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path class:K72:19; $_path)
	ARRAY TO COLLECTION:C1563($_; $_path)
	
	return $_
	
	
Function user_classes : Collection
	var $_ : Collection
	
	$_:=This:C1470.classes()
	
	$_:=$_.filter(Formula:C1597($1.value="[class]/@"))
	
	$_:=$_.map(Formula:C1597($1.result:=Substring:C12($1.value; Position:C15("/"; $1.value; *)+1)))
	
	return $_
	
	
	
Function database : Collection
	var $_ : Collection
	
	$_:=[]
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path database method:K72:2; $_path)
	ARRAY TO COLLECTION:C1563($_; $_path)
	
	return $_.sort()
	
	
	
	
Function forms : Collection
	var $_ : Collection
	
	$_:=[]
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path project form:K72:3; $_path)
	ARRAY TO COLLECTION:C1563($_; $_path)
	
	return $_
	
	
	
Function methods : Collection
	var $_ : Collection
	
	$_:=[]
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path project method:K72:1; $_path)
	ARRAY TO COLLECTION:C1563($_; $_path)
	
	return $_.sort()
	
	
	
Function table_forms : Collection
	var $_ : Collection
	
	$_:=[]
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path table form:K72:5; $_path)
	ARRAY TO COLLECTION:C1563($_; $_path)
	
	return $_
	
	
	
Function triggers : Collection
	var $_ : Collection
	
	$_:=[]
	ARRAY TEXT:C222($_path; 0)
	METHOD GET PATHS:C1163(Path trigger:K72:4; $_path)
	ARRAY TO COLLECTION:C1563($_; $_path)
	
	return $_
	
	
	
Function method($name) : cs:C1710.method
	
	return cs:C1710.method.new($name)
	
	
	
Function folders : Collection
	var $_ : Collection
	var $content : Object
	
	$content:=JSON Parse:C1218(This:C1470._folders_file.getText())
	
	//$_:=[]
	//ARRAY TEXT($_folder; 0)
	//METHOD GET FOLDERS($_folder)
	//ARRAY TO COLLECTION($_; $_folder)
	
	$_:=OB Keys:C1719($content)  // remove trash ?? 
	
	
	return $_.sort()
	
	