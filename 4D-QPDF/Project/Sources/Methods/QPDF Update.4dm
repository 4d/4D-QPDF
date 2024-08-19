//%attributes = {}

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : QPDF Update
   ID[360A6C94CFBB48E887BFE1BF48308094]
   Created : 08-04-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/


//MARK:- Variables 

var $qpdf : cs:C1710.qpdf
var $brew : cs:C1710.brew
var $otool : cs:C1710.otool
var $name_tool : cs:C1710.install_name_tool
var $http : cs:C1710.http_request

var $file; $bin : 4D:C1709.File
var $folder; $temporary; $win_folder; $helpers_folder; $bin_folder; $lib_folder : 4D:C1709.Folder
var $zip : 4D:C1709.ZipArchive

var $relative_path; $system_path; $full_name; $res_name : Text
var $dependency; $result : Object
var $_; $_otool; $_list : Collection
var $exit : Boolean


Case of 
		
	: (arch.is_rosetta)
		
		ALERT:C41("\"QPDF Update\" cannot be run on Rosetta!")
		
	: (Is macOS:C1572)
		
/*
	
This code sets up instances of QPDF and Brew, 
checks if QPDF is ready, and updates it if necessary. 
If QPDF is not ready, it checks if Brew is installed. 
If Brew is installed, it updates Brew. 
If Brew is not installed, it installs it. 
Then, regardless of the Brew status, 
it checks if Brew is installed again and if so, installs QPDF.
	
*/
		
		//MARK:- Brew and QPDF Installation
		
		MESSAGE:C88("Homebrew & QPDF downloading...")
		SET WINDOW TITLE:C213("4D QPDF update...")
		
		// Create a new Brew instance
		$brew:=cs:C1710.brew.new()
		
		// Check if Brew is installed
		If ($brew.installed)
			
			// If Brew is installed but QPDF is not ready, update Brew
			
			MESSAGE:C88("Update Brew...")
			$brew.update()
			
		Else 
			
			// If Brew is not installed, install it
			MESSAGE:C88("Install Brew...")
			$brew.install()
			
		End if 
		
		If ($brew.installed)
			
			// Create a new QPDF instance
			$qpdf:=cs:C1710.qpdf.new()
			
			// Check if QPDF is ready on system
			If ($qpdf.system_ready)
				
				// If QPDF is ready, update it
				MESSAGE:C88("Update QPDF...")
				$qpdf.update()
				
			Else 
				
				// If QPDF is not ready
				
				MESSAGE:C88("Install QPDF...")
				$qpdf.install()
				
			End if 
			
			
/*
	
This code segment checks if QPDF is ready, 
performs various operations related to managing its dependencies and installation, 
including handling library paths, copying files, and retrieving resources from the internet. 
Additionally, it includes handling for both Mac and Windows platforms.
	
*/
			
			// Retrieve QPDF binary package from Brew
			$bin:=$brew.package_bin("qpdf")
			
			If (($bin#Null:C1517) && $bin.exists)
				
				//MARK:- RE-MAPPING QPDF DEPENDENCIES
				
				MESSAGE:C88("Build mac parts...")
				
				// Obtain component folder path
				$helpers_folder:=$qpdf.component_folder
				
				// Define bin and lib folders within the resource folder
				$bin_folder:=$helpers_folder.folder("bin")
				$lib_folder:=$helpers_folder.folder("lib")
				
				// Create a new Otool instance
				$otool:=cs:C1710.otool.new()
				
				// Get library information using Otool
				$_:=$otool.L($bin.path)
				$_otool:=$_.copy()
				
				// Repeat until all library paths are resolved
				Repeat 
					
					$exit:=True:C214
					
					// Loop through each dependency to resolve paths
					For each ($dependency; $_)
						
						// Check if the dependency path is valid
						If ($dependency.valid=Null:C1517)
							
							// Get the absolute system path of the dependency
							$system_path:=to.absolute_path($dependency.path)
							
							// If the system path has not been queried before
							If ($_.query(" system_path = :1 "; $system_path).length=0)
								
								// Set the system path for the dependency
								$dependency.system_path:=$system_path
								
								// Check if the file exists
								$file:=File:C1566($system_path)
								$dependency.valid:=$file.exists
								
								// If the file exists
								If ($file.exists)
									
									// Mark the iteration to continue
									$exit:=False:C215
									
									// Get library information using Otool
									$_list:=$otool.L($dependency.system_path)
									$_:=$_.combine($_list)
									
									// Copy the file to the lib folder
									$file.copyTo($lib_folder; fk overwrite:K87:5)
									$dependency.local_file:=$lib_folder.file($file.fullName)
									$dependency.local_path:=$dependency.local_file.path
									
									// Handle alias files
									If ($dependency.file.isAlias)
										
										// Create an alias for the file in the lib folder
										$dependency.alias:=$dependency.local_file.createAlias($lib_folder; $dependency.file.fullName; fk alias link:K87:3)
									Else 
										//nothing to do
									End if 
									
								Else 
									//nothing to do
								End if 
								
							Else 
								//nothing to do
							End if 
							
						Else 
							//nothing to do
						End if 
						
					End for each 
					
				Until ($exit)
				
				// Copy valid libraries to lib folder
				$_list:=$_.copy()
				$_:=$_.query(" valid = :1 "; True:C214)
				$bin.copyTo($bin_folder; fk overwrite:K87:5)
				$bin:=$bin_folder.file($bin.name)
				
				
				// Define relative path for library dependencies
				$relative_path:="../lib/"
				
				
				// Create a new InstallNameTool instance
				$name_tool:=cs:C1710.install_name_tool.new()
				
				
				// Loop through each file in bin folder to manage library dependencies
				For each ($file; $bin_folder.files())
					$_otool:=$otool.L($file.path)
					
					For each ($dependency; $_otool)
						Case of 
								
							: ($dependency.otool_result="@rpath/@")
								
								If ($dependency.file.isAlias)
									
									$full_name:=$dependency.file.original.fullName
									
								Else 
									
									$full_name:=$dependency.file.fullName
									
								End if 
								
								
								// Change library paths using InstallNameTool
								$name_tool.change($dependency.otool_result; "@executable_path/"+$relative_path+$full_name; $file.path)
								
							Else 
								//nothing to do
						End case 
					End for each 
					
				End for each 
				
				// Get Brew package folder
				$folder:=$brew.package_folder()
				
				// Loop through each file in lib folder to manage Brew library dependencies
				For each ($file; $lib_folder.files())
					
					// Get library information using Otool
					$_otool:=$otool.L($file.path)
					
					// Loop through each dependency in the Otool result
					For each ($dependency; $_otool)
						
						Case of 
								// Check if the dependency path needs to be changed
							: ($dependency.otool_result=($folder.path+"@"))
								// Determine the full name of the dependency
								
								If ($dependency.file.isAlias)
									
									$full_name:=$dependency.file.original.fullName
									
								Else 
									
									$full_name:=$dependency.file.fullName
									
								End if 
								
								
								// Change library paths using InstallNameTool
								$name_tool.change($dependency.otool_result; "@executable_path/"+$relative_path+$full_name; $file.path)
								
							Else 
								//nothing to do
						End case 
						
					End for each 
					
				End for each 
				
				
				var $config : Object
				
				$config:=$qpdf._config.read_template()
				
				//$config.os_version:=Get system info.osVersion
				$config.arch:=($config.arch=Null:C1517) ? {} : $config.arch
				$config.arch[arch.name]:=Get system info:C1571.osVersion
				
				$qpdf._config.update_template($config)
				
				MESSAGE:C88("Build universal binary...")
				build_ub
				
				
				
				//mark:- INSTALL WINDOWS 64-BITS VERSION
				
				MESSAGE:C88("Download Windows part...")
				
				// Create a new HTTP request for QPDF
				$http:=cs:C1710.http_request.new($qpdf.origin())
				
				
				// Modify the resource name to match the Windows archive
				$res_name:=Split string:C1554($http.res_name; ".tar")[0]
				$http.res_name:=$res_name+"-msvc64.zip"
				
				
				// Retrieve and extract the Windows archive
				$result:=$http.get()
				
				If ($result.success)
					
					$temporary:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)
					
					$file:=$temporary.file($http.res_name)
					
					$file.create()
					$file.setContent($result.answer)
					
					$zip:=ZIP Read archive:C1637($file)
					
					// Copy Windows binaries to the appropriate folder
					//$win_folder:=Folder("/RESOURCES/qpdf/win/")
					$win_folder:=environ.helpers_folder.folder("qpdf/win/")
					If ($win_folder.exists)
						$win_folder.delete(Delete with contents:K24:24)
					Else 
						// nothing to do
					End if 
					
					$win_folder:=$zip.root.folders().first().folder("bin").copyTo($win_folder)
					
					If ($win_folder.exists)
						ALERT:C41("QPDF installation done !")
					Else 
						ASSERT:C1129(False:C215; "Unable to copy the QPDF Windows archive to resources folder.")
					End if 
					
				Else 
					
					// HTTP error
					ASSERT:C1129(False:C215; "Unable to download the QPDF Windows archive from Git. \r https://github.com/qpdf/qpdf/releases/ ")
					
				End if 
				
			Else 
				
				// Installation error
				ASSERT:C1129(False:C215; "Unable to install the QPDF Mac archive from HomeBrew.")
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; "Unable to install HomeBrew.")
		End if 
		
	Else 
		
		ALERT:C41("4D-QPDF must be installed or updated from both ARM and INTEL Macs!")
		
End case 