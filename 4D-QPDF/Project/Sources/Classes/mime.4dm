/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : mime
   ID[09E3285FA838445CBB1ED1C355BA99A9]
   Created : 03-19-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/


Class constructor
	
	
	This:C1470._file:=File:C1566("/RESOURCES/mimes/mime&extentions.json")
	
	
	This:C1470._dic:=JSON Parse:C1218(This:C1470._file.getText())
	
	
	// Check if the file exists and the dictionary is successfully parsed
Function get success : Boolean
	return This:C1470._file.exists && (This:C1470._dic#Null:C1517)
	
	
	// Get MIME type based on file extension or provided MIME type
Function get_mime($something : Variant) : Text
	var $_ : Collection
	
	Case of 
			
		: (Value type:C1509($something)=Is text:K8:3)
			
			$something:=$something=".@" ? Substring:C12($something; 2) : $something
			
			$_:=This:C1470._dic.query(" extension = :1 "; $something)
			If ($_.length>0)
				return $_[0].mimeType
			End if 
			
		: (Value type:C1509($something)#Is object:K8:27)
			
		: (OB Instance of:C1731($something; 4D:C1709.File))
			
			return This:C1470.get_mime($something.extension)
			
	End case 
	
	
	// Get file extension based on MIME type
Function get_extension($mime : Text) : Text
	var $_ : Collection
	
	$_:=This:C1470._dic.query(" mimeType = :1 "; $mime)
	
	If ($_.length>0)
		
		return "."+$_[0].extension
	End if 
	
	
	