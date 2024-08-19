//%attributes = {"invisible":true}
#DECLARE() : Collection

var $_tu:=[]
var $method : cs:C1710._method
var $ms : Integer
var $name; $status : Text
var $failed:=False:C215
var $_ : Collection
var $file : 4D:C1709.File

$name:="PDF with warnings"

$ms:=Milliseconds:C459

$_tu.push(Current method path:C1201+" : "+Timestamp:C1445)

$file:=Folder:C1567(fk resources folder:K87:11).folder("qpdf-test-files").file("warning pdf.pdf")

Try
	
	$_:=PDF Get attachments($file)
	
	If ($_.length=0)
		
		$_tu.push("method: attachment count == 0."+"\t OK")
	Else 
		
		$failed:=True:C214
		$_tu.push("method attachment count == "+String:C10($_.length)+"."+"\t  KO")
	End if 
	
Catch
	
	$failed:=True:C214
	$_tu.push("method catched "+JSON Stringify:C1217(Last errors:C1799)+"."+"\t  KO")
	
End try

$ms:=Abs:C99(Milliseconds:C459-$ms)

$status:=($failed) ? "FAILED" : "success"

$_tu.push(""; "status: "+$status)

return $_tu