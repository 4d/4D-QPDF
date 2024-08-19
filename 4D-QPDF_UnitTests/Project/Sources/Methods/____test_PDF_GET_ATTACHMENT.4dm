//%attributes = {"invisible":true}
#DECLARE($component : cs:C1710.component) : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $status; $name : Text
var $failed:=False:C215


$name:="PDF Get attachments"

$ms:=Milliseconds:C459


$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)

/*

check method "PDF Get attachments"

should be shared
should be invisible

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

If ($method.invisible)
	$_tu.push("method: invisible."+"\t OK")
Else 
	$failed:=True:C214
	$_tu.push("method is visible."+"\t  KO")
	
	//throw({errCode: -1; message: "\"PDF Get attachments\" method is visible!"; componentSignature: "4D-QPDF UNIT TEST"; deferred: False})
	
End if 

If ($method.shared)
	$_tu.push("method: shared."+"\t OK")
Else 
	$failed:=True:C214
	$_tu.push("method is not shared."+"\t  KO")
	
	//throw({errCode: -1; message: "\"PDF Get attachments\" method is not shared!"; componentSignature: "4D-QPDF UNIT TEST"; deferred: False})
	
End if 




//mark:-
$ms:=Abs:C99(Milliseconds:C459-$ms)

$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu