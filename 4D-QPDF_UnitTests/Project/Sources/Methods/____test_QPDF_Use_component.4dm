//%attributes = {"invisible":true}
#DECLARE($component : cs:C1710.component) : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $name; $status : Text
var $failed:=False:C215

$name:="QPDF Use component"

$ms:=Milliseconds:C459


$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)

/*

check method "QPDF Use component"

should not be shared
should be visible

*/

$method:=$component.find_method($name).first()


$_tu.push("method: "+$name)
$name:="\""+$name+"\""

If ($method#Null:C1517)
	$_tu.push("method: exist."+"\t OK")
Else 
	$failed:=True:C214
	$_tu.push("method does not exist."+"\t  KO")
End if 

If ($method.visible)
	$_tu.push("method: visible."+"\t OK")
Else 
	$failed:=True:C214
	$_tu.push("method is invisible."+"\t  KO")
End if 

If (Not:C34($method.shared))  // not
	$_tu.push("method: not shared."+"\t OK")
Else 
	$failed:=True:C214
	$_tu.push("method is shared."+"\t  KO")
End if 

$ms:=Abs:C99(Milliseconds:C459-$ms)

$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu