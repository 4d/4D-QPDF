//%attributes = {"invisible":true}
#DECLARE() : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $name; $status : Text
var $failed:=False:C215
var $folder : 4D:C1709.Folder

$name:="Count shared methods"

$ms:=Milliseconds:C459


$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)



$folder:=Folder:C1567(fk resources folder:K87:11).folder("qpdf-test-files")

$folder:=Folder:C1567($folder.platformPath; fk platform path:K87:2)



If ($folder.exists)
	
	$_tu.push("method: test folders."+"\t OK")
Else 
	
	$failed:=True:C214
	$_tu.push("method test folders."+"\t  KO")
End if 


$ms:=Abs:C99(Milliseconds:C459-$ms)

$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu