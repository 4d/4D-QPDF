
Class extends value

property _success : Boolean
property _error : Collection

Class constructor($value : Variant)
	
	
	If (Count parameters:C259>0)
		Super:C1705($value)
	Else 
		Super:C1705()
	End if 
	
	This:C1470._success:=True:C214
	This:C1470._error:=[]
	
	
	
Function get success : Boolean
	return This:C1470._success
	
	
Function get fail : Boolean
	return Not:C34(This:C1470._success)
	
	
Function set success($value : Boolean)
	This:C1470._success:=$value
	
	
Function set fail($value : Boolean)
	This:C1470._success:=Not:C34($value)
	
	
Function get has_error : Boolean
	return This:C1470._error.length>0
	
	
Function get count_error : Integer
	return This:C1470._error.length
	
	
Function get error : Object
	If (This:C1470._error.length>0)
		return This:C1470._error[0]
	Else 
		return {code: 0; message: ""}  // return a no error code
	End if 
	
	
Function get errors : Collection
	return This:C1470._error.copy()
	
	
Function set_error($code : Integer; $message : Text) : Object
	
	var $error : Object
	
	$error:={code: $code; message: ""}
	
	If ($code#0)
		This:C1470._success:=False:C215
		
		$error.message:=(Count parameters:C259<2) ? "" : $message
		
		This:C1470._error.push($error)
	End if 
	
	return $error