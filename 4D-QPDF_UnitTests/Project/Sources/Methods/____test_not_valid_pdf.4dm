//%attributes = {"invisible":true}
#DECLARE() : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $name; $status : Text
var $failed:=False:C215
var $_ : Collection
var $file : 4D:C1709.File

$name:="Count shared methods"

$ms:=Milliseconds:C459


$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)



$file:=Folder:C1567(fk resources folder:K87:11).folder("qpdf-test-files").file("NotAPdf.png")

Try
	$failed:=True:C214
	
	$_:=PDF Get attachments($file)
	
	
	
	
Catch
	$failed:=False:C215
	$_tu.push("method: catched."+"\t OK")
	
End try


$ms:=Abs:C99(Milliseconds:C459-$ms)

If ($failed)
	
	$_tu.push("method: not catched."+"\t KO")
End if 


$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu