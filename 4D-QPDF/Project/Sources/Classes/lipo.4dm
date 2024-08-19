/*  ----------------------------------------------------
   Project: 
   Class : lipo
   ID[476F269E30FB41589FD3A9433524A2A0]
   Created : 08-04-2024 by Dominique Delahaye
   Documented by: 
   Commented by: 
   Origin : man lipo
   ----------------------------------------------------
*/


/*

COMMANDS
       -archs Display only the architecture names present in a single input
              file. Each architecture name is a single word, making this
              option suitable for shell scripting. Unknown architectures will
              be represented by "unknown" along with the numeric CPU type and
              CPU subtype values as a single word.

       -create
              Create one universal output file from one or more input files.
              When input files specified on the command-line, all of the
              architectures in each file will be copied into the output file,
              whereas when input files are included using the global -arch
              option, only the specified architecture will be copied from that
              input file.  This command requires the -output option.

       -detailed_info
              Display a detailed list of the architecture types in the input
              universal file (all the the information in the universal header,
              for each architecture in the file).

       -extract arch_type [-extract arch_type...]
              Take one universal input file and copy the arch_type from that
              universal file into a universal output file containing only that
              architecture. This command requires the -output option.

       -extract_family arch_type [-extract_family arch_type...]
              Take one universal input file and copy all of the arch_types for
              the family that arch_type is in from that universal file into an
              output file containing only those architectures.  The file will
              be thin if only one architecture is found or universal
              otherwise. This command requires the -output option.

       -info  Display a brief description of each input file along with the
              names of each architecture type in that input file.

       -remove arch_type [-remove arch_type ...]
              Take one universal input file and remove the arch_type from that
              universal file, placing the result in the output file. This
              command requires the -output option.

       -replace arch_type file_name [-replace arch_type file_name...]
              Take one universal input file; in the output file, replace the
              arch_type contents of the input file with the contents of the
              specified file_name.  This command requires the -output option.

       -thin arch_type
              Take one input file and create a thin output file with the
              specified arch_type.  This command requires the -output option.

       -verify_arch arch_type ...
              Take one input file and verify the specified arch_types are
              present in the file.  If so then exit with a status of 0 else
              exit with a status of 1. Because more than one arch_type can be
              verified at once, all of the input files must appear before the
              -verify_arch flag on the command-line.

*/


/*

OPTIONS
       -arch arch_type input_file
              Tells lipo that input_file contains the specified architecture
              type.  The -arch arch_type specification is unnecessary if
              input_file is an object file, a universal file, or some other
              file whose architecture(s) lipo can figure out.

       -hideARM64
              When creating a universal binary including both 32-bit and
              64-bit ARM files, this option will ask lipo to add the 64-bit
              files at the end and not include them in the count of
              architectures present in the file. The files must be executable
              files (Mach-O filetype MH_EXECUTE). This option has no effect if
              neither 32-bit ARM nor 64-bit ARM files are present, and no
              other files may be hidden in this way. This option only works
              with the -create, -remove, and -replace, commands, and is only
              intended for tools and workflows testing a workaround on older
              systems.

       -output output_file
              Commands that create new files write to the output file
              specified by the -output flag. This option is required for the
              -create, -extract, -extract_family, -remove, -replace, and -thin
              commands.

       -segalign arch_type value
              Set the segment alignment of the specified arch_type when
              creating a universal file containing that architecture.  value
              is a hexadecimal number that must be an integral power of 2.
              This is only needed when lipo can't figure out the alignment of
              an input file (currently not an object file), or when it guesses
              at the alignment too conservatively.  The default for files
              unknown to lipo is 0 (2^0, or an alignment of one byte), and the
              default alignment for archives is 4 (2^2, or 4-byte alignment).

*/


Class extends cli

property _intel : 4D:C1709.File
property _arm : 4D:C1709.File
property _ub : 4D:C1709.File

Class constructor
	
	Super:C1705("/usr/bin/lipo")
	This:C1470._intel:=Null:C1517
	This:C1470._arm:=Null:C1517
	
	
	//mark:-
	
	
Function get intel_ready : Boolean
	return (This:C1470._intel#Null:C1517) && OB Instance of:C1731(This:C1470._intel; 4D:C1709.File)
	
	
Function get intel : 4D:C1709.File
	return This:C1470._intel
	
	
Function set intel($file : 4D:C1709.File)
	This:C1470._intel:=Null:C1517
	Case of 
		: (($file=Null:C1517) || Not:C34(OB Instance of:C1731($file; 4D:C1709.File)))
			
			//: ($file.isAlias)
		: ($file.exists)
			
			This:C1470._intel:=$file
	End case 
	
	
	//mark:-
	
	
Function get arm_ready : Boolean
	return (This:C1470._arm#Null:C1517) && OB Instance of:C1731(This:C1470._arm; 4D:C1709.File)
	
	
Function get arm : 4D:C1709.File
	return This:C1470._arm
	
	
Function set arm($file : 4D:C1709.File)
	This:C1470._arm:=Null:C1517
	Case of 
		: (($file=Null:C1517) || Not:C34(OB Instance of:C1731($file; 4D:C1709.File)))
			
			//: ($file.isAlias)
		: ($file.exists)
			
			This:C1470._arm:=$file
	End case 
	
	//mark:-
	
	
Function get ub_ready : Boolean
	return (This:C1470._ub#Null:C1517) && OB Instance of:C1731(This:C1470._ub; 4D:C1709.File) && (This:C1470._ub.exists)
	
	
Function get ub : 4D:C1709.File
	return This:C1470._ub
	
	
Function set ub($file : 4D:C1709.File)
	This:C1470._ub:=Null:C1517
	Case of 
		: (($file=Null:C1517) || Not:C34(OB Instance of:C1731($file; 4D:C1709.File)))
			
		: ($file.isAlias)
		: ($file.exists)
			
			This:C1470._ub:=$file
	End case 
	
	
	//mark:-
	
	
Function create($folder : 4D:C1709.Folder; $full_name : Text) : Boolean
	
/*
	
lipo -create  -output $root_path/lib/libcrypto.3.dylib $root_path/arm/lib/libcrypto.3.dylib $root_path/intel/lib/libcrypto.3.dylib
*/
	
	var $worker : 4D:C1709.SystemWorker
	var $ub_path; $intel_path; $arm_path : Text
	var $ub_file : 4D:C1709.File
	If (This:C1470.arm_ready && This:C1470.intel_ready)
		
		If ($folder.exists)
		Else 
			$folder.create()
		End if 
		
		$full_name:=($full_name#"") ? $full_name : This:C1470._intel.fullName
		$ub_path:=to.absolute_path(File:C1566($folder.platformPath+$full_name; fk platform path:K87:2).path)
		$intel_path:=to.absolute_file(This:C1470._intel).original.path
		
		$arm_path:=to.absolute_file(This:C1470._arm).original.path
		
		
		$ub_file:=File:C1566($ub_path)
		If ($ub_file.exists)
			$ub_file.delete()
		End if 
		
		
		This:C1470.dataType:="text"
		This:C1470.no_time_out()
		
		$worker:=This:C1470.execute(" -create -output \""+$ub_path+"\" \""+$intel_path+"\" \""+$arm_path+"\"")
		
		This:C1470._ub:=$ub_file
		
		
		If (This:C1470._intel.isAlias)
			This:C1470._ub.createAlias($folder; This:C1470._intel.name)
			
		End if 
		
		return $ub_file.exists
		
	End if 
	
	
Function remove($arch : Text) : Boolean
	var $worker : 4D:C1709.SystemWorker
	var $ub_path; $output_path : Text
	var $output_file : 4D:C1709.File
	
	If (This:C1470.ub_ready)
		
		Case of 
				
			: (($arch="arm") || ($arch="x86_64"))
				$arch:="arm64"
				$output_file:=This:C1470._intel
				
				
			: (($arch="intel") || ($arch="x86_64"))
				$arch:="x86_64"
				$output_file:=This:C1470._arm
				
		End case 
		
		If ($output_file.exists)
			$output_file.delete()
		End if 
		
		$output_path:=to.absolute_file($output_file).path
		
		$ub_path:=to.absolute_file(This:C1470._ub).path
		
		$worker:=This:C1470.execute(" -remove "+$arch+" -output \""+$output_path+"\" \""+$ub_path+"\"")
		
		Case of 
				
			: ($arch="arm64")
				This:C1470._intel:=$output_file
				
			: ($arch="x86_64")
				This:C1470._arm:=$output_file
				
		End case 
		
		return $output_file.exists
		
	End if 