
/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : _qpdf_attachment
   ID[4DBF2A4725A641C1A04C329AF5C8BE28]
   Created : 03-04-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/

// Define properties
property _name : Text
property _cid : Text
property _value : 4D:C1709.Blob
property _extenion : Text
property _type : Text
property _success : Boolean


Class constructor
	
	
	// Getter function to access the success property
Function get success : Boolean
	return This:C1470._success
	
	
	// Getter function to access the name property
Function get name : Text
	return This:C1470._name
	
	
	// Getter function to access the extension property
Function get extension : Text
	return This:C1470._extension
	
	
	// Getter function to access the fullName property
Function get fullName : Text
	return This:C1470.name+This:C1470.extension
	
	
	// Getter function to access the content property
Function get content : 4D:C1709.Blob
	return This:C1470._value
	
	
	// Getter function to access the size property
Function get size : Real
	return This:C1470._value.size
	
	
	// Getter function to access the type property
Function get type : Text
	return This:C1470._type
	
	
	// Getter function to convert attachment to object
Function get to_object : Object
	var $o : Object
	
	// Initialize object
	$o:={}
	
	// Set object properties
	$o.name:=This:C1470.name
	$o.extension:=This:C1470.extension
	$o.fullName:=This:C1470.fullName
	$o.success:=This:C1470.success
	$o.content:=This:C1470.content
	$o.size:=This:C1470.size
	$o.mimeType:=""
	
	// If type property is not null, set mimeType
	If (This:C1470._type#Null:C1517)
		$o.mimeType:=This:C1470._type
	End if 
	
	// If mimeType is still empty, attempt to get it based on extension
	If ($o.mimeType="")
		var $mime : cs:C1710.mime
		
		$mime:=cs:C1710.mime.new()
		
		If ($mime.success)
			$o.mimeType:=$mime.get_mime($o.extension)
		End if 
		
	End if 
	
	// Include other properties if available
	If (This:C1470._checksum#Null:C1517)
		$o.checksum:=This:C1470._checksum
	End if 
	
	If (This:C1470._creationDate#Null:C1517)
		$o.creationDate:=This:C1470._creationDate
	End if 
	
	If (This:C1470._modificationDate#Null:C1517)
		$o.modificationDate:=This:C1470._modificationDate
	End if 
	
	
	return $o
	
	