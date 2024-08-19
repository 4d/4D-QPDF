//%attributes = {}


var $codes : cs:C1710.codes
var $_ : Collection
var $_classes; $_user_classes; $_methods : Collection

var $method : cs:C1710.method
var $name : Text

var $folders : Object

$folders:=JSON Parse:C1218(Folder:C1567("/PACKAGE/Project/Sources").file("folders.json").getText())



$codes:=cs:C1710.codes.new()

$_:=$codes.folders()


$_classes:=$codes.classes()
$_user_classes:=$codes.user_classes()
$_methods:=$codes.methods()


var $attributs : Object

For each ($name; $_methods)
	
	$method:=$codes.method($name)
	
	$attributs:=$method.attributs()
	
	
End for each 