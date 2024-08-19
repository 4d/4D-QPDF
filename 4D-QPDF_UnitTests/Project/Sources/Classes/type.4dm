

property _value : Variant
property _value_type : Integer
property _is_pointer : Boolean
property _is_nil : Boolean
property _type : Integer

Class constructor
	
	This:C1470._value_type:=Is undefined:K8:13
	This:C1470._is_pointer:=False:C215
	This:C1470._is_nil:=True:C214
	This:C1470._type:=Is undefined:K8:13
	
	
Function get value : Variant
	var $nil : Pointer
	
	If (This:C1470._is_nil)
		return $nil
	Else 
		return This:C1470._value
	End if 
	
	
Function set value($value : Variant)
	This:C1470._value:=$value
	This:C1470._value_type:=Value type:C1509($value)
	
	This:C1470._is_pointer:=This:C1470._value_type=Is pointer:K8:14
	This:C1470._is_nil:=(This:C1470._is_pointer && (This:C1470._value_type=Is null:K8:31))
	
	Case of 
			
		: ((This:C1470._value_type=Is object:K8:27) && (OB Instance of:C1731(This:C1470._value; 4D:C1709.Blob)))
			This:C1470._type:=Is BLOB:K8:12
			
		: (This:C1470._is_nil)
			This:C1470._type:=Is null:K8:31
			
		: (This:C1470._is_pointer)
			This:C1470._type:=Type:C295(This:C1470._value->)
			
		Else 
			This:C1470._type:=This:C1470._value_type
	End case 
	
	
	
Function get type : Integer
	
	return This:C1470._type
	
	
Function get type_name : Text
	var $type : Integer
	
	$type:=This:C1470._type
	
	Case of 
			
		: ($type=Array 2D:K8:24)
			return "matrix"
			
		: ($type=Blob array:K8:30)
			return "blob array"
			
		: ($type=Boolean array:K8:21)
			return "boolean array"
			
		: ($type=Date array:K8:20)
			return "date array"
			
		: ($type=Integer array:K8:18)
			return "integer array"
			
		: ($type=LongInt array:K8:19)
			return "longint array"
			
		: ($type=Object array:K8:28)
			return "object array"
			
		: ($type=Picture array:K8:22)
			return "picture array"
			
		: ($type=Pointer array:K8:23)
			return "pointer array"
			
		: ($type=Real array:K8:17)
			return "real array"
			
		: ($type=Text array:K8:16)
			return "text array"
			
		: ($type=Time array:K8:29)
			return "time array"
			
		: ($type=Is alpha field:K8:1)
			return "text"
			
		: ($type=Is BLOB:K8:12)
			return "blob"
			
		: ($type=Is boolean:K8:9)
			return "boolean"
			
		: ($type=Is collection:K8:32)
			return "collection"
			
		: ($type=Is date:K8:7)
			return "date"
			
		: ($type=Is integer:K8:5)
			return "integer"
			
		: ($type=Is integer 64 bits:K8:25)
			return "int64"
			
		: ($type=Is longint:K8:6)
			return "longint"
			
		: ($type=Is null:K8:31)
			return "null"
			
		: ($type=Is object:K8:27)
			return "object"
			
		: ($type=Is picture:K8:10)
			return "picture"
			
		: ($type=Is pointer:K8:14)
			return "pointer"
			
		: ($type=Is real:K8:4)
			return "real"
			
		: ($type=Is text:K8:3)
			return "text"
			
		: ($type=Is time:K8:8)
			return "time"
			
		: ($type=Is undefined:K8:13)
			return "undefined"
			
		: ($type=Is variant:K8:33)
			return "variant"
			
			
			// deprecated
		: ($type=String array:K8:15)
			return "_o_string array"
			
		: ($type=Is string var:K8:2)
			return "_o_string"
			
		: ($type=Is subtable:K8:11)
			return "_o_subtable"
			
		Else 
			
			
			
	End case 
	
	
	
	
	
	//mark:-
	
Function get is_folder : Boolean
	If (This:C1470._value_type=Is object:K8:27)
		
		Case of 
			: (This:C1470._value=Null:C1517)
				
				
			: (OB Instance of:C1731(This:C1470._value; 4D:C1709.Folder))
				
				return True:C214
				
				
			: (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipFolder))
				
				return True:C214
				
				
				
			: (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipArchive))
				
				return True:C214
				
				
		End case 
		
		
	End if 
	
	
Function get is_file : Boolean
	
	If (This:C1470._value_type=Is object:K8:27)
		
		Case of 
			: (This:C1470._value=Null:C1517)
				
				
			: (OB Instance of:C1731(This:C1470._value; 4D:C1709.File))
				
				return True:C214
				
				
			: (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipFile))
				
				return True:C214
				
				
				
			: (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipArchive))
				
				return True:C214
				
				
		End case 
		
		
	End if 
	
	
Function get is_zip_file : Boolean
	If (This:C1470._value_type=Is object:K8:27)
		
		If (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipFile))
			
			return True:C214
			
		End if 
		
	End if 
	
	
Function get is_zip_folder : Boolean
	If (This:C1470._value_type=Is object:K8:27)
		
		If (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipFolder))
			
			return True:C214
			
		End if 
		
	End if 
	
	
Function get is_zip_archive : Boolean
	If (This:C1470._value_type=Is object:K8:27)
		
		If (OB Instance of:C1731(This:C1470._value; 4D:C1709.ZipArchive))
			
			return True:C214
			
		End if 
		
	End if 
	
	
	
	
	
	//mark:-
	
Function get is_object : Boolean
	If (This:C1470._value_type=Is object:K8:27)
		
		return OB Class:C1730(This:C1470._value).name="Object"
		
	End if 
	
	
Function get is_instance : Boolean
	If (This:C1470._value_type=Is object:K8:27)
		
		return OB Class:C1730(This:C1470._value).name#"Object"
		
	End if 
	
Function get class_name : Text
	
	Case of 
		: (This:C1470._value_type#Is object:K8:27)
			
		Else 
			var $class : 4D:C1709.Class
			$class:=OB Class:C1730(This:C1470._value)
			If ($class.name#"Object")
				return $class.name
			End if 
	End case 
	
	
	
	
	
Function get is_undefined : Boolean
	return This:C1470._value_type=Is undefined:K8:13
	
	
Function get is_pointer : Boolean
	
	return This:C1470._is_pointer
	
	
Function get is_null : Boolean
	
	return This:C1470._value_type=Is null:K8:31
	
	
Function get is_nil : Boolean
	
	return This:C1470._is_nil
	
	
Function get is_array : Boolean
	
	var $type : Integer
	
	If (This:C1470._is_pointer)
		
		If (This:C1470._value_type=Is null:K8:31)
			return False:C215
		Else 
			
			$type:=Type:C295(This:C1470._value->)
			
			Case of 
				: ($type=Array 2D:K8:24)
				: ($type=Blob array:K8:30)
				: ($type=Boolean array:K8:21)
				: ($type=Date array:K8:20)
				: ($type=Integer array:K8:18)
				: ($type=LongInt array:K8:19)
				: ($type=Object array:K8:28)
				: ($type=Picture array:K8:22)
				: ($type=Pointer array:K8:23)
				: ($type=Real array:K8:17)
				: ($type=Text array:K8:16)
				: ($type=Time array:K8:29)
				: ($type=String array:K8:15)  // still alive ?
					
				Else 
					return False:C215
			End case 
			
			return True:C214
		End if 
		
	Else 
		return False:C215
	End if 
	
	
Function get is_collection : Boolean
	
	return This:C1470._value_type=Is collection:K8:32 && (This:C1470._value_type#Is null:K8:31)
	
	
Function get is_blob : Boolean
	return (This:C1470._value_type=Is object:K8:27) && (OB Instance of:C1731(This:C1470._value; 4D:C1709.Blob))
	
	
Function get is_text : Boolean
	return This:C1470._value_type=Is text:K8:3
	
	
	
	
	//mark:-
	
	
Function is_instance_of($class : 4D:C1709.Class) : Boolean
	
	Case of 
			
		: (Count parameters:C259<1)
		: (OB Instance of:C1731($class; 4D:C1709.Class)=False:C215)
		Else 
			
			return OB Class:C1730(This:C1470._value).name=$class.name
			
	End case 
	
	
	
	
	
	