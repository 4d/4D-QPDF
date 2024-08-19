
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Class : is
   ID[2A97A501D6544832AB096006CEA8F6AD]
   Created : 04-06-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

singleton Class constructor
	
	
	
	
Function json_object($json : Text) : Boolean
	
	//$json:=to.text($json)
	
	return Match regex:C1019("(?ms-i)^\\{.*\\}$"; $json; 1)
	
	
	
	
Function json_collection($json : Text) : Boolean
	
	//$json:=to.text($json)
	
	return Match regex:C1019("(?ms-i)^\\[.*\\]$"; $json; 1)
	
	
	//mark:-
Function text($something : Variant) : Boolean
	
	return Value type:C1509($something)=Is text:K8:3
	
	
Function pointer($something : Variant) : Boolean
	
	If (Value type:C1509($something)=Is pointer:K8:14)
		
		return Is nil pointer:C315($something)=False:C215
		
	End if 
	
	
	
	
Function array($something : Variant) : Boolean
	var $type : Integer
	
	$type:=Value type:C1509($something)
	
	Case of 
		: ($type#Is pointer:K8:14)
			
		: (Is nil pointer:C315($something))
			
		Else 
			
			$type:=Type:C295($something->)
			
			Case of 
				: ($type=Array 2D:K8:24)
					return True:C214
					
				: ($type=Blob array:K8:30)
					return True:C214
					
				: ($type=Boolean array:K8:21)
					return True:C214
					
				: ($type=Date array:K8:20)
					return True:C214
					
				: ($type=Integer array:K8:18)
					return True:C214
					
				: ($type=LongInt array:K8:19)
					return True:C214
					
				: ($type=Object array:K8:28)
					return True:C214
					
				: ($type=Picture array:K8:22)
					return True:C214
					
				: ($type=Pointer array:K8:23)
					return True:C214
					
				: ($type=Real array:K8:17)
					return True:C214
					
				: ($type=Text array:K8:16)
					return True:C214
					
				: ($type=Time array:K8:29)
					return True:C214
					
				: ($type=String array:K8:15)
					return True:C214
					
			End case 
	End case 
	
	//mark:-
Function zip_file($something : Variant) : Boolean
	
	If (Value type:C1509($something)=Is object:K8:27)
		return OB Instance of:C1731($something; 4D:C1709.ZipFile)
	End if 
	
Function file($something : Variant) : Boolean
	
	If (Value type:C1509($something)=Is object:K8:27)
		
		
		Case of 
			: (OB Instance of:C1731($something; 4D:C1709.File))
				
				return True:C214
				
				
			: (OB Instance of:C1731($something; 4D:C1709.ZipFile))
				
				return True:C214
				
				
				
				//: (OB Instance of($something; 4D.ZipArchive))
				
				//return True
				
				
		End case 
		
		
	End if 
	
	
	
Function singleton($something : Variant) : Boolean
	
	var $type : Integer
	
	$type:=Value type:C1509($something)
	
	Case of 
			
		: ($type=Is object:K8:27)
			
			If (OB Instance of:C1731($something; 4D:C1709.Class))
				
				return Bool:C1537($something.isSingleton)
				
			End if 
			
			
		: ($type=Is text:K8:3)
			
			return This:C1470.singleton(cs:C1710[$something])  // contert class name to 4D Class
			
			
			
			
	End case 
	
	
	//mark:-
	
	// Check if the path is valid
Function valid_path($path : Variant) : Boolean
	
	$path:=to.posix($path)
	
	$path:=Convert path POSIX to system:C1107($path)
	
	return Test path name:C476($path)>=0
	
	