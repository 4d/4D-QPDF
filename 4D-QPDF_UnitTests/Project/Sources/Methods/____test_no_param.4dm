//%attributes = {"invisible":true}
#DECLARE() : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $name; $status : Text
var $failed:=False:C215
var $_ : Collection

$name:="Count shared methods"

$ms:=Milliseconds:C459


$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)



$_:=PDF Get attachments



If ($_.length=0)
	
	$_tu.push("method: length == 0."+"\t OK")
Else 
	
	$failed:=True:C214
	$_tu.push("method length == "+String:C10($_.length)+"."+"\t  KO")
End if 


$ms:=Abs:C99(Milliseconds:C459-$ms)

$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu