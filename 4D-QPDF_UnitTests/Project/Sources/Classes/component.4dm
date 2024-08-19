
property _component : 4D:C1709.Folder
property _classes : Object
property _databasemethod : Object
property _method_attributes : 4D:C1709.File
property _methods : Collection
property _is_compiled : Boolean

Class constructor($component : 4D:C1709.Folder)
	
	var $o; $toc : Object
	var $_ : Collection
	var $method : Object
	var $4DZ : 4D:C1709.File
	var $zip : 4D:C1709.ZipArchive
	var $map : Object
	
	This:C1470._component:=$component
	
	
	$4DZ:=This:C1470._component.files().query(" name = :1 AND extension = :2 "; This:C1470._component.name; ".4DZ").first()
	
	This:C1470._is_compiled:=$4DZ#Null:C1517
	
	If ($4DZ#Null:C1517)
		
		$zip:=ZIP Read archive:C1637($4DZ)
		
		$map:=cs:C1710.to.me.object($zip.root.folder("Project/DerivedData/CompiledCode").file("map.json"))
		
		
		This:C1470._classes:=cs:C1710.to.me.object($zip.root.folder("Project/DerivedData/CompiledCode").file("classes.json"))
		
		This:C1470._databasemethod:={}
		
		
		This:C1470._method_attributes:=$zip.root.folder("Project/DerivedData").file("methodAttributes.json")
		This:C1470._methods:=[]  //
		
		$toc:=cs:C1710.to.me.object(This:C1470._method_attributes).methods
		
		
		For each ($o; $map.map)
			
			$_:=Split string:C1554($o.path; "/")
			
			Case of 
				: ($_[0]="Trash")  // skip deleted element
					
					
					
					
				: ($_[1]="Methods")
					
					$method:=$toc[Path to object:C1547($_[2]).name]
					$method:=cs:C1710._method.new($o.path; $method.attributes)
					
					This:C1470._methods.push($method)
					
					
					
				: ($_[1]="Classes")
					
				: ($_[1]="DatabaseMethods")
					
					
				Else 
					
					
			End case 
			
			
		End for each 
		
	Else 
		
		//todo: wok with interpreted components...
		
	End if 
	
	
Function get is_compiled : Boolean
	return This:C1470._is_compiled
	
	
	
Function show
	
	show_on_disk(This:C1470._component)
	
	
Function get name : Text
	
	return This:C1470._component.name
	
	
	
Function method_names : Collection
	
	return This:C1470._methods.sort()
	
	
Function find_method($name) : Collection
	
	return This:C1470._methods.query(" name=:1 "; $name)
	
Function shared_methods() : Collection
	
	return This:C1470._methods.query(" shared=:1 "; True:C214)
	
	
Function visible_methods() : Collection
	
	return This:C1470._methods.query(" visible=:1 "; True:C214)
	
	
Function methods($name) : Collection
	
	return This:C1470._methods
	
	
	
	
	