
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Class : is
   ID[2A97A501D6544832AB096006CEA8F6AD]
   Created : 04-06-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

singleton Class constructor
	
	
	
	
Function json_object($json : Text) : Boolean
	
	return Match regex:C1019("(?ms-i)^\\{.*\\}$"; $json; 1)
	
	
	
	
Function json_collection($json : Text) : Boolean
	
	return Match regex:C1019("(?ms-i)^\\[.*\\]$"; $json; 1)
	
	
	
	
	
	//mark:-
	
	// Check if the path is valid
Function valid_path($path : Variant) : Boolean
	
	$path:=to.posix($path)
	
	$path:=Convert path POSIX to system:C1107($path)
	
	return Test path name:C476($path)>=0
	
	