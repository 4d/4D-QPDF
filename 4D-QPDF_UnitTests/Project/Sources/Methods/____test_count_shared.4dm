//%attributes = {"invisible":true}
#DECLARE($component : cs:C1710.component) : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $name; $status : Text
var $failed:=False:C215
var $_method : Collection

$name:="Count shared methods"

$ms:=Milliseconds:C459


$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)



$_method:=$component.shared_methods()

If ($_method.length=1)
	
	$_tu.push("method: shared == 1."+"\t OK")
Else 
	
	$failed:=True:C214
	$_tu.push("method shared == "+String:C10($_method.length)+"."+"\t  KO")
End if 


$ms:=Abs:C99(Milliseconds:C459-$ms)

$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu