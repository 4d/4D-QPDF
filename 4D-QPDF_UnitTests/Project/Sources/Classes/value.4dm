
Class extends type

property _value : Variant

Class constructor($value : Variant)
	
	Super:C1705()
	
	If (Count parameters:C259>0)
		This:C1470.value:=$value
	End if 
	
	
	
Function to_collection($convert : Boolean) : Collection
	var $result : Collection
	
	If (This:C1470.is_collection)
		
		return This:C1470.value
		
	Else 
		
		$result:=[]
		If (This:C1470.is_array)
			
			var $pointer : Pointer
			
			$pointer:=This:C1470.value
			
			If (This:C1470.type=Array 2D:K8:24)
				
				var $i; $size : Integer
				var $_ : Collection
				
				For ($i; 1; Size of array:C274($pointer->))
					
					$_:=[]
					
					ARRAY TO COLLECTION:C1563($_; $pointer->{$i})
					
					$result.push($_)
					
				End for 
				
			Else 
				
				ARRAY TO COLLECTION:C1563($result; $pointer->)
				
			End if 
			
			
		Else 
			
			$result.push(This:C1470.value)
			
		End if 
		
		Case of 
			: (Count parameters:C259<1)
				
			: ($convert)
				This:C1470.value:=$result
				
		End case 
		
	End if 
	
	return $result  // defaut return 
	
	
	//Function get path : Text
	
	//If (This.is_folder || This.is_file)
	
	//return Convert path system to POSIX(This._value.platformPath)
	
	//End if 
	
	
	
Function to_string($convert : Boolean) : Text
	var $string : Text
	
	$string:=String:C10(This:C1470.value)
	
	Case of 
		: (Count parameters:C259<1)
			
		: ($convert)
			This:C1470.value:=$string
			
	End case 
	
	return $string
	
	
	
Function to_number($convert : Boolean) : Real
	var $real : Real
	
	$real:=Num:C11(This:C1470.value)
	
	Case of 
		: (Count parameters:C259<1)
			
		: ($convert)
			This:C1470.value:=$real
			
	End case 
	
	return $real
	
	
	
Function to_blob($convert : Boolean) : 4D:C1709.Blob
	
	var $bin : Blob
	
	Case of 
		: (This:C1470.is_blob)
			
			return This:C1470.value
			
		Else 
			
			var $type : Integer
			
			$type:=This:C1470.type
			
			SET BLOB SIZE:C606($blob; 0)
			
			Case of 
				: ($type=Is text:K8:3)
					TEXT TO BLOB:C554(This:C1470.to_string(); $blob)
					
					
				: ($type=Is picture:K8:10)
					PICTURE TO BLOB:C692(This:C1470.value; $blob; ".4pct")
					
				: ($type=Is collection:K8:32)
					
					TEXT TO BLOB:C554(JSON Stringify:C1217(This:C1470.value); $blob)
					
				: ($type=Is object:K8:27)
					
					TEXT TO BLOB:C554(JSON Stringify:C1217(This:C1470.value); $blob)
					
				Else 
					
			End case 
			
			Case of 
				: (Count parameters:C259<1)
					
				: ($convert)
					This:C1470.value:=$blob
					
			End case 
			
			return $blob
			
	End case 
	
	
	
Function to_object($convert : Boolean) : Object
	
	var $buffer : Text
	var $file : 4D:C1709.File
	var $zipfile : 4D:C1709.ZipFile
	
	Case of 
			
		: (This:C1470.is_zip_file)
			
			$zipfile:=This:C1470.value
			
			If ($zipfile.exists)
				$buffer:=$zipfile.getText()
				
				If (cs:C1710.is.me.json_object($buffer))  // is
					
					return JSON Parse:C1218($buffer)
					
				End if 
				
			End if 
			
			
		: (This:C1470.is_zip_folder)
			
			
		: (This:C1470.is_zip_archive)
			
			
		: (This:C1470.is_file)
			
			$file:=This:C1470.value
			If ($file.exists)
				$buffer:=$file.getText()
				
				If (cs:C1710.is.me.json_object($buffer))  // is
					
					return JSON Parse:C1218($buffer)
					
				End if 
				
			End if 
			
		: (This:C1470.is_folder)
			
			
		: (This:C1470.is_object)
			
			return This:C1470.value
			
			
			
		: (This:C1470.is_text)
			
			If (cs:C1710.is.me.json_object(This:C1470.value))  // is
				
				return JSON Parse:C1218(This:C1470.value)
				
			End if 
			
			
		Else 
			
			
			
	End case 
	