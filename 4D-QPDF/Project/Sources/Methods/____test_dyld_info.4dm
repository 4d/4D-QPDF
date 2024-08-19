//%attributes = {"invisible":true}

var $o : Object

var $lib; $bin : 4D:C1709.Folder
var $file : 4D:C1709.File

var $dylb : cs:C1710.dyld_info
var $helper_folder : 4D:C1709.Folder

$helper_folder:=environ.helpers_folder

$dylb:=cs:C1710.dyld_info.new()

$lib:=$helper_folder.folder("qpdf/mac/ub/lib")

For each ($file; $lib.files())
	//$file:=to.absolute_file($file)
	
	If ($dylb.validate($file.path))
		
		$o:=$dylb.platform($file.path)
		
	Else 
		
	End if 
	
	
End for each 


$bin:=$helper_folder.folder("qpdf/mac/ub/bin")

For each ($file; $bin.files())
	
	If ($dylb.validate($file.path))
		
		$o:=$dylb.platform($file.path)
		
		
	Else 
		
	End if 
	
End for each 

