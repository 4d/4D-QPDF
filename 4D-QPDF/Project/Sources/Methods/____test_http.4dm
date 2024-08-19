//%attributes = {"invisible":true}

var $http : cs:C1710.http_request
var $result : Object
var $temporary : 4D:C1709.Folder
var $file : 4D:C1709.File


$http:=cs:C1710.http_request.new("https://github.com/qpdf/qpdf/releases/latest")


$result:=$http.get()

If ($http.success)
	
	$temporary:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)
	
	$file:=$temporary.file("answer.html")
	
	
	$file.create()
	$file.setContent($result.answer)
	
	show_on_disk($file)
	
End if 



