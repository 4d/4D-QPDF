
singleton Class constructor
	
	var $_ : Collection
	var $name : Text
	var $index : Integer
	
	var $folder; $component; $project_folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	
	
	ARRAY TEXT:C222($_components; 0)
	
	COMPONENT LIST:C1001($_components)
	
	$_:=cs:C1710.to.me.collection(->$_components)
	
	
	This:C1470._components:={}  // list has object
	This:C1470._all_components:=[]
	
	//mark:-
	
	//https://developer.4d.com/docs/fr/Concepts/paths
	
	//mark:- load project components
	$project_folder:=This:C1470.folder_project()
	
	This:C1470._project_component:=[]
	
	For each ($folder; $project_folder.folders())
		$index:=$_.indexOf($folder.name)
		If ($index>=0)
			$name:=$_[$index]
			This:C1470._components[$name]:=cs:C1710.component.new($folder.original)
			This:C1470._project_component.push(This:C1470._components[$name])
			This:C1470._all_components.push(This:C1470._components[$name])
		End if 
	End for each 
	
	
	For each ($file; $project_folder.files())
		$index:=$_.indexOf($file.original.name)
		If ($index>=0)
			$name:=$_[$index]
			This:C1470._components[$name]:=cs:C1710.component.new($file.original.parent.parent)  // remonter au .4dbase
			This:C1470._project_component.push(This:C1470._components[$name])
			This:C1470._all_components.push(This:C1470._components[$name])
		End if 
		
	End for each 
	
	//For each ($name; $_)
	//$component:=$folder.folder($name+".4dbase")
	//If ($component.exists)
	//This._components[$name]:=cs.component.new($component)
	//This._project_component.push(This._components[$name])
	//This._all_components.push(This._components[$name])
	//End if 
	//End for each 
	
	
	//mark:- load application components
	$folder:=This:C1470.folder_application()
	
	This:C1470._application_component:=[]
	
	For each ($name; $_)
		$component:=$folder.folder($name+".4dbase")
		If ($component.exists)
			This:C1470._components[$name]:=cs:C1710.component.new($component)
			This:C1470._application_component.push(This:C1470._components[$name])
			This:C1470._all_components.push(This:C1470._components[$name])
		End if 
	End for each 
	
	
	//mark:- load standard components
	$folder:=This:C1470.folder_application_user()
	
	This:C1470._std_component:=[]
	
	For each ($name; $_)
		$component:=$folder.folder($name+".4dbase")
		If ($component.exists)
			This:C1470._components[$name]:=cs:C1710.component.new($component)
			This:C1470._std_component.push(This:C1470._components[$name])
			This:C1470._all_components.push(This:C1470._components[$name])
		End if 
	End for each 
	
	
	//mark:- load internal components
	$folder:=This:C1470.folder_application_internal()
	
	This:C1470._internal_component:=[]
	
	//var $component_folder : 4D.Folder
	
	//For each ($component_folder; $folder.folders())
	
	//If ($component_folder.extension=".4dbase")
	
	//This._components[$name]:=cs.component.new($component)
	//This._internal_component.push(This._components[$name])
	//This._all_components.push(This._components[$name])
	
	//End if 
	//End for each 
	
	
	For each ($name; $_)
		$component:=$folder.folder($name+".4dbase")
		If ($component.exists)
			This:C1470._components[$name]:=cs:C1710.component.new($component)
			This:C1470._internal_component.push(This:C1470._components[$name])
			This:C1470._all_components.push(This:C1470._components[$name])
		End if 
	End for each 
	
	
	
	
	
	
	
	
	
Function names : Collection
	return OB Keys:C1719(This:C1470._components).sort()
	
	
Function query($name : Text) : Collection
	
	return This:C1470._all_components.query(" name = :1 "; $name)
	
	
	
	//mark:- components folders location
	
Function folder_project : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(fk resources folder:K87:11; *)
	
	$folder:=to.absolute_folder($folder).parent.folder("Components")
	
	return $folder
	
	
	
	
Function folder_application : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	$folder:=to.absolute_folder($folder).folder("Contents/Components")
	
	return $folder
	
	
	
	
Function folder_application_internal : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	$folder:=to.absolute_folder($folder).folder("Contents/Resources/Internal Components")
	
	return $folder
	
	
	
	
Function folder_application_user : 4D:C1709.Folder
	var $folder : 4D:C1709.Folder
	
	$folder:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	$folder:=to.absolute_folder($folder).folder("Contents/Resources/Internal User Components")
	
	return $folder
	
	
	
	
	