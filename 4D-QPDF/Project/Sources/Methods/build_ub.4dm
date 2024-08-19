//%attributes = {"invisible":true}

var $i : Integer
var $name : Text

var $_intel; $_arm; $_intel_aliases; $_arm_aliases; $_indices : Collection

var $aliases : Object


var $lipo : cs:C1710.lipo
var $otool : cs:C1710.otool

var $intel; $arm; $folder; $lib; $bin : 4D:C1709.Folder
var $alias; $file; $ub : 4D:C1709.File
var $qpdf_intel; $qpdf_arm; $qpdf_ub : 4D:C1709.File
var $qpdf : cs:C1710.qpdf

var $helper_folder : 4D:C1709.Folder

$helper_folder:=environ.helpers_folder

//$qpdf_intel:=File("/RESOURCES/qpdf/mac/intel/bin/qpdf")
//$qpdf_arm:=File("/RESOURCES/qpdf/mac/arm/bin/qpdf")

$qpdf_intel:=$helper_folder.file("qpdf/mac/intel/bin/qpdf")
$qpdf_arm:=$helper_folder.file("qpdf/mac/arm/bin/qpdf")

If ($qpdf_intel.exists && $qpdf_arm.exists)
	
	
	//$folder:=Folder("/RESOURCES/qpdf/mac/ub")
	$folder:=$helper_folder.folder("qpdf/mac/ub")
	If ($folder.exists)
		$folder.delete(Delete with contents:K24:24)
	End if 
	
	$otool:=cs:C1710.otool.new()
	$lipo:=cs:C1710.lipo.new()
	
	//mark:- lib folder
	
	//$lib:=Folder("/RESOURCES/qpdf/mac/ub/lib")
	
	$lib:=$helper_folder.folder("qpdf/mac/ub/lib")
	
	//$intel:=Folder("/RESOURCES/qpdf/mac/intel/lib")
	//$arm:=Folder("/RESOURCES/qpdf/mac/arm/lib")
	
	$intel:=$helper_folder.folder("qpdf/mac/intel/lib")
	$arm:=$helper_folder.folder("qpdf/mac/arm/lib")
	
	
	$_intel:=$intel.files().copy().query(" hidden = :1 "; False:C215).orderBy(" name asc ")
	$_arm:=$arm.files().copy().query(" hidden = :1 "; False:C215).orderBy(" name asc ")
	
	
	
	For ($i; 0; $_intel.length-1)
		$_intel[$i]:=to.absolute_file($_intel[$i])
	End for 
	
	For ($i; 0; $_arm.length-1)
		$_arm[$i]:=to.absolute_file($_arm[$i])
	End for 
	
	
	$_intel_aliases:=$_intel.query(" isAlias = :1 "; True:C214).orderBy(" name asc ")
	$_arm_aliases:=$_arm.query(" isAlias = :1 "; True:C214).orderBy(" name asc ")
	
	$aliases:={}
	For each ($alias; $_intel_aliases)
		$aliases[$alias.name]:={intel: $alias}
	End for each 
	
	For each ($alias; $_arm_aliases)
		$aliases[$alias.name]:=($aliases[$alias.name]=Null:C1517) ? {} : $aliases[$alias.name]
		$aliases[$alias.name].arm:=$alias
	End for each 
	
	For each ($name; $aliases)
		
		Case of 
			: ($aliases[$name].intel=Null:C1517)
			: ($aliases[$name].arm=Null:C1517)
				
			Else 
				
				$_indices:=$_intel.indices(" path = :1"; $aliases[$name].intel.path)
				$_intel.remove($_indices[0]; 1)
				$_indices:=$_intel.indices(" path = :1"; $aliases[$name].intel.original.path)
				$_intel.remove($_indices[0]; 1)
				
				
				$_indices:=$_arm.indices(" path = :1"; $aliases[$name].arm.path)
				$_arm.remove($_indices[0]; 1)
				$_indices:=$_arm.indices(" path = :1"; $aliases[$name].arm.original.path)
				$_arm.remove($_indices[0]; 1)
				
				$lipo.intel:=$aliases[$name].intel.original
				$lipo.arm:=$aliases[$name].arm.original
				
				If ($lipo.create($lib; $name+$lipo.arm.extension))
					
					$ub:=$lipo.ub
					
					$aliases[$name].ub:=$ub
				End if 
				
		End case 
		
	End for each 
	
	For each ($name; $aliases)
		
		$aliases[$name].dependencies:={}
		
		$aliases[$name].dependencies.arm:=$otool.L($aliases[$name].ub.path; "arm64")
		$aliases[$name].dependencies.intel:=$otool.L($aliases[$name].ub.path; "x86_64")
	End for each 
	
	
	
	
	// need to check both os intalled version
	
	For each ($file; $_intel)
		
		$lipo.intel:=$file
		
		If ($lipo.intel_ready)
			
			$file:=$arm.file($file.fullName)
			$lipo.arm:=$file
			
			If ($lipo.create($lib))
				
				$ub:=$lipo.ub
				
			End if 
			
		End if 
		
	End for each 
	
	
	
	//mark:- bin folder
	
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
	
	
	// remove intel and arm part
	
	//$qpdf_ub:=File("/RESOURCES/qpdf/mac/ub/bin/qpdf")
	$qpdf_ub:=$helper_folder.file("qpdf/mac/ub/bin/qpdf")
	
	//$qpdf_ub:=to.absolute_file($qpdf_ub)
	
	If ($qpdf_ub.exists)
		
		$qpdf:=cs:C1710.qpdf.new()
		
		If ($qpdf.path=$qpdf_ub.path)  // sure we are usin the ub
			
			If ($qpdf.version#"")  // sure we can interract with ub
				
				//$intel:=Folder("/RESOURCES/qpdf/mac/intel")
				$intel:=$helper_folder.folder("qpdf/mac/intel")
				
				$intel.delete(Delete with contents:K24:24)
				
				//$arm:=Folder("/RESOURCES/qpdf/mac/arm")
				$arm:=$helper_folder.folder("qpdf/mac/arm")
				
				$arm.delete(Delete with contents:K24:24)
				
			End if 
			
		End if 
	End if 
	
End if 




