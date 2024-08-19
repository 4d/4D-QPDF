
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : arch
   ID[0B59F92734B44EB49109BEFA7FA2C768]
   Created : 03-04-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/

property _arch : Object
property _macRosetta : Boolean

singleton Class constructor
	
	var $arch : Text
	var $_ : Collection
	var $sys : 4D:C1709.SystemWorker
	var $to : cs:C1710.to
	
	
	
	// Determine system architecture based on operating system
	
	
	Case of 
			
		: (Is macOS:C1572)
			
			$to:=to  //cs.tos.me
			
			// Initialize system worker for macOS
			$sys:=4D:C1709.SystemWorker.new("zsh")
			// Execute command to retrieve system information
			$sys.postMessage("uname -a")
			$sys.closeInput()
			// Wait for system worker to complete execution
			$sys.wait()
			
			// Convert system response to a collection of tokens
			$_:=$to.collection($to.text($sys.response); sk ignore empty strings:K86:1+sk trim spaces:K86:2; " ")
			
			This:C1470._macRosetta:=Get system info:C1571.macRosetta
			
			
			
		: (Is Windows:C1573)
			// Handle Windows operating system (not implemented in this snippet)
			This:C1470._macRosetta:=False:C215
			
		Else 
			// Handle other operating systems (not implemented in this snippet)
			This:C1470._macRosetta:=False:C215
			
	End case 
	
	// Extract system architecture from the collected tokens
	$arch:=$_.length>0 ? $_[$_.length-1] : ""
	
	// Store architecture information in instance variable
	This:C1470._arch:={}
	This:C1470._arch.arm:=Is macOS:C1572 && ($arch="arm64")
	This:C1470._arch.intel:=Is macOS:C1572 && ($arch="x86_64")
	
	
	// Getter function for architecture name
Function get name : Text
	
	If (This:C1470._arch.name=Null:C1517)
		
		Case of 
			: (Is Windows:C1573)
				This:C1470._arch.name:="Microsoft Windows"
				
				
			: (This:C1470._macRosetta)
				This:C1470._arch.name:="Rosetta"
				
				
			: (This:C1470._arch.arm)
				This:C1470._arch.name:="arm"
				
				
			: (This:C1470._arch.intel)
				This:C1470._arch.name:="intel"
				
		End case 
		
	End if 
	
	return This:C1470._arch.name
	
	
	
	// Getter function to check if the system is running Rosetta
Function get is_rosetta : Boolean
	return This:C1470._macRosetta
	
	
	
	// Getter function to check if the system is running on macOS ARM architecture
Function get is_mac_arm : Boolean
	// Return true if macOS and ARM architecture, false otherwise
	return This:C1470._arch.arm
	
	
	
	// Getter function to check if the system is running on macOS Intel architecture
Function get is_mac_intel : Boolean
	// Return true if macOS and Intel architecture, false otherwise
	return This:C1470._arch.intel
	
	
	
	// Getter function to check if the system is running on Microsoft Windows
Function get is_microsoft : Boolean
	// Return true if the system is Windows, false otherwise
	return Is Windows:C1573
	
	
	