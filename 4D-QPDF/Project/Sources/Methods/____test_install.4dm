//%attributes = {"invisible":true,"preemptive":"capable"}



var $qpdf : cs:C1710.qpdf
var $brew : cs:C1710.brew

$brew:=cs:C1710.brew.new()

$qpdf:=cs:C1710.qpdf.new()

If ($qpdf.ready)
	
	$qpdf.update()
	
Else 
	
	If ($brew.installed)  //& False
		
		$brew.update()
		
	Else 
		
		$brew.install()
		
	End if 
	
	If ($brew.installed)
		$qpdf.install()
	End if 
	
End if 



If ($qpdf.ready)
	
	var $bin : 4D:C1709.File
	var $resource_folder; $bin_folder; $lib_folder : 4D:C1709.Folder
	var $path : Text
	var $_; $dependencies : Collection
	
	var $infos : Object
	
	
	$path:=$qpdf.path
	
	$resource_folder:=$qpdf.component_folder
	
	$bin_folder:=$resource_folder.folder("bin")
	$lib_folder:=$resource_folder.folder("lib")
	
	$bin:=$brew.package_bin("qpdf")
	
	$infos:=$qpdf.infos()  //dependencies[jpeg-turbo,openssl@3]
	
	$dependencies:=$qpdf.dependencies()
	
	
	
	//For each ($dependency; $infos.dependencies)
	//$dependencies[$dependency]:={bin: $brew.package_bin($dependency); infos: $brew.package_infos($dependency)}
	//End for each 
	
	
	
	var $otool : cs:C1710.otool
	
	var $name_tool : cs:C1710.install_name_tool
	
	var $relative_path : Text
	
	
	var $system_path : Text
	var $file : 4D:C1709.File
	var $exit : Boolean
	var $dep : Object
	var $_otool; $_list : Collection
	
	
	$otool:=cs:C1710.otool.new()
	
	$_:=$otool.L($bin.path)
	
	
	$_otool:=$_.copy()
	
	Repeat 
		
		$exit:=True:C214
		
		For each ($dep; $_)
			
			If ($dep.valid=Null:C1517)
				
				$system_path:=to.absolute_path($dep.path)
				
				If ($_.query(" system_path = :1 "; $system_path).length=0)
					
					$dep.system_path:=$system_path
					
					$file:=File:C1566($system_path)
					
					$dep.valid:=$file.exists
					
					If ($file.exists)
						
						$exit:=False:C215
						
						$_list:=$otool.L($dep.system_path)
						
						$_:=$_.combine($_list)
						$file.copyTo($lib_folder; fk overwrite:K87:5)
						
						$dep.local_file:=$lib_folder.file($file.fullName)
						
						$dep.local_path:=$dep.local_file.path
						
						If ($dep.file.isAlias)
							
							$dep.local_file.createAlias($lib_folder; $dep.file.fullName; fk alias link:K87:3)
							
						End if 
						
					End if 
					
				End if 
				
			End if 
			
		End for each 
		
	Until ($exit)
	
	$_list:=$_.copy()
	
	$_:=$_.query(" valid = :1 "; True:C214)
	
	
	$bin.copyTo($bin_folder; fk overwrite:K87:5)
	
	$bin:=$bin_folder.file($bin.name)
	
	//show_on_disk($bin)
	
	
	
	$relative_path:="../lib/"
	
	$name_tool:=cs:C1710.install_name_tool.new()
	
	
	
	
	var $_debug : Collection
	var $fullName : Text
	var $folder : 4D:C1709.Folder
	
	
	For each ($file; $bin_folder.files())
		$_otool:=$otool.L($file.path)
		
		For each ($dep; $_otool)
			Case of 
					
				: ($dep.otool_result="@rpath/@")
					
					If ($dep.file.isAlias)
						
						$fullName:=$dep.file.original.fullName
						
					Else 
						$fullName:=$dep.file.fullName
					End if 
					
					
					$name_tool.change($dep.otool_result; $relative_path+$fullName; $file.path)
					
					
					$_debug:=$otool.L($file.path)
					
			End case 
		End for each 
		
		
		
	End for each 
	
	$folder:=$brew.package_folder()
	
	For each ($file; $lib_folder.files())
		$_otool:=$otool.L($file.path)
		
		For each ($dep; $_otool)
			
			Case of 
					
				: ($dep.otool_result=($folder.path+"@"))
					
					If ($dep.file.isAlias)
						
						$fullName:=$dep.file.original.fullName
						
					Else 
						
						$fullName:=$dep.file.fullName
						
					End if 
					
					$name_tool.change($dep.otool_result; $relative_path+$fullName; $file.path)
					
					$_debug:=$otool.L($file.path)
					
			End case 
			
		End for each 
		
	End for each 
	
	
/*
- check dependencies in terminal -
	
export DYLD_PRINT_LIBRARIES=1                                                                     
./qpdf  
	
*/
	
	//mark:- WINDOWS
	
	// installation du windows 64 bits
	
	var $http : cs:C1710.http_request
	var $res_name : Text
	var $result : Object
	var $temporary; $winFolder : 4D:C1709.Folder
	//var $file : 4D.File
	var $zip : 4D:C1709.ZipArchive
	
	var $helper_folder : 4D:C1709.Folder
	
	$helper_folder:=environ.helpers_folder
	
	
	$http:=cs:C1710.http_request.new($qpdf.origin())
	
	$res_name:=Split string:C1554($http.res_name; ".tar")[0]
	
	$http.res_name:=$res_name+"-msvc64.zip"
	
	
	$result:=$http.get()
	
	If ($result.success)
		
		$temporary:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)
		
		$file:=$temporary.file($http.res_name)
		
		$file.create()
		$file.setContent($result.answer)
		
		//show_on_disk($file)
		
		
		$zip:=ZIP Read archive:C1637($file)
		
		
		$winFolder:=$helper_folder.folder("qpdf/win/")
		If ($winFolder.exists)
			$winFolder.delete(Delete with contents:K24:24)
		End if 
		
		$winFolder:=$zip.root.folders().first().folder("bin").copyTo($winFolder)
		
		//show_on_disk($winFolder)
	Else 
		
		// http error
		
		ASSERT:C1129(True:C214; "Could not download QPDDF Windows archive from git.")
		
	End if 
	
	
Else 
	
	// erreur d'installation
	ASSERT:C1129(True:C214; "Could not install QPDDF Mac archive from HomeBrew.")
	
	
End if 



