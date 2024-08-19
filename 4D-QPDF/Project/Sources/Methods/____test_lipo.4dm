//%attributes = {"invisible":true}


var $lipo : cs:C1710.lipo

var $intel; $arm; $folder; $lib; $bin : 4D:C1709.Folder
var $file; $ub : 4D:C1709.File

var $helper_folder : 4D:C1709.Folder

$helper_folder:=environ.helpers_folder


$lipo:=cs:C1710.lipo.new()

//$lib:=Folder("/RESOURCES/qpdf/mac/ub/lib")

$lib:=$helper_folder.folder("qpdf/mac/ub/lib")

//$intel:=Folder("/RESOURCES/qpdf/mac/intel/lib")
//$arm:=Folder("/RESOURCES/qpdf/mac/arm/lib")

$intel:=$helper_folder.folder("qpdf/mac/intel/lib")
$arm:=$helper_folder.folder("qpdf/mac/arm/lib")


For each ($file; $intel.files())
	
	$lipo.intel:=$file
	
	If ($lipo.intel_ready)
		
		$file:=$arm.file($file.fullName)
		$lipo.arm:=$file
		
		If ($lipo.create($lib))
			
			$ub:=$lipo.ub
			
		End if 
		
	End if 
	
End for each 

//$bin:=Folder("/RESOURCES/qpdf/mac/ub/bin")

//$intel:=Folder("/RESOURCES/qpdf/mac/intel/bin")
//$arm:=Folder("/RESOURCES/qpdf/mac/arm/bin")

$bin:=$helper_folder.folder("qpdf/mac/ub/bin")

$intel:=$helper_folder.folder("qpdf/mac/intel/bin")
$arm:=$helper_folder.folder("qpdf/mac/arm/bin")

For each ($file; $intel.files())
	
	$lipo.intel:=$file
	
	If ($lipo.intel_ready)
		
		$file:=$arm.file($file.fullName)
		$lipo.arm:=$file
		
		If ($lipo.create($bin))
			
			$ub:=$lipo.ub
			
		End if 
		
	End if 
	
End for each 