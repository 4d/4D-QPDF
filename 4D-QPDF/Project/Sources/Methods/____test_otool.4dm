//%attributes = {"invisible":true}

var $otool : cs:C1710.otool

$otool:=cs:C1710.otool.new()


var $qpdf : cs:C1710.qpdf

$qpdf:=cs:C1710.qpdf.new()

$qpdf.use_system:=True:C214


var $_ : Collection
var $component_folder; $lib_folder : 4D:C1709.Folder
var $path : Text
var $file : 4D:C1709.File


$_:=$otool.L($qpdf.path)

$component_folder:=$qpdf.component_folder

$lib_folder:=$component_folder.folder("lib")

If ($lib_folder.exists)
	
	For each ($file; $_)
		
		$file:=File:C1566($file.path)
		
		If ($file.isAlias)
			
			$file:=$file.original
			
		End if 
		
		If ($file.exists)
			$file.copyTo($lib_folder; fk overwrite:K87:5)
		Else 
			//ASSERT(False; "error : "+$file.path+" does not exist !")
		End if 
		
	End for each 
	
	
	SHOW ON DISK:C922($lib_folder.platformPath)
	
Else 
	
	ASSERT:C1129(False:C215; "error : "+$lib_folder.path+" does not exist !")
	
	
End if 



