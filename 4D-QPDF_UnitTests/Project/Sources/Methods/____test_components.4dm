//%attributes = {}


var $comp_manager : cs:C1710.components
var $my_component : cs:C1710.component

var $o : Object

var $map; $method : Variant

If (is.singleton(cs:C1710.components))
	
	$comp_manager:=cs:C1710.components["me"]
Else 
	
	$comp_manager:=cs:C1710.components.new()
End if 



$my_component:=$comp_manager.query("4D-QPDF").first()

//$map:=$my_component.map()
//If ($map.success)

//$map:=$map.to_object()

//End if 

var $result:=cs:C1710.result.new()
var $value : cs:C1710.value
var $hidden : Boolean


var $_methods; $_shared; $_visible : Collection

//$result:=$my_component.methods_attributes()

If ($my_component#Null:C1517)  //$result.is_file)
	
	$_methods:=$my_component.methods()
	
	
	$_methods:=$my_component.find_method("QPDF Check environment")
	
	If ($_methods.length=1)
		
		$method:=$_methods[0]
		
		
	Else 
		
	End if 
	
	$_shared:=$my_component.shared_methods()
	
	$_visible:=$my_component.visible_methods()
	
	
	
	
	$method:=$my_component.find_method("show_on_disk").first()
	
	
	$hidden:=$method.attributes.invisible
	
	
	$o:=$result.to_object()
	
	
	$method:=$o.methods["QPDF Check environment"]
	If ($method.attributes#Null:C1517)
		
	End if 
	
	$method:=$o.methods["QPDF Update"]
	If ($method.attributes#Null:C1517)
		
		
		
		
	End if 
	
	$method:=$o.methods["QPDF Use component"]
	If ($method.attributes#Null:C1517)
		
	End if 
	
	$method:=$o.methods["QPDF Use system"]
	If ($method.attributes#Null:C1517)
		
	End if 
	
	$method:=$o.methods["PDF Get attachments"]
	If ($method.attributes#Null:C1517)
		
	End if 
	
	
	
	
	
	
End if 




