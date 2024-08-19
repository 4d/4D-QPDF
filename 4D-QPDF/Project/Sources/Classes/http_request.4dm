/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : http_request
   ID[C860057AA20B4802B0B79407D7D5055A]
   Created : 04-02-2024 by Dominique Delahaye
   Commented by: chatGPT 3.5
   ----------------------------------------------------
*/

property _url : Text
property _headers : Object
property _result : Object

Class constructor($url : Text)
	
	This:C1470._url:=$url
	This:C1470._header:={}  // Initialize headers as an empty object
	
	//todo:http:// user:password@
	
	
	// Check if the URL protocol is HTTPS
Function get is_https : Boolean
	return This:C1470.protocol="https"
	
	
	// Check if the URL protocol is HTTP
Function get is_http : Boolean
	return This:C1470.protocol="http"
	
	
	// Get the protocol of the URL
Function get protocol : Text
	return Split string:C1554(This:C1470._url; "://"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)[0]
	
	
	// Get the host of the URL
Function get host : Text
	var $_ : Collection
	
	$_:=Split string:C1554(This:C1470._url; "://"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
	$_:=Split string:C1554($_[1]; "/"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	return $_[0]
	
	
	// Get the path of the URL
Function get path : Text
	var $_ : Collection
	
	$_:=Split string:C1554(This:C1470._url; "://"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
	$_:=Split string:C1554($_[1]; "/"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	$_.pop()
	$_.shift()
	
	return "/"+$_.join("/")+"/"
	
	
	// Get the resource name of the URL
Function get res_name : Text
	var $_ : Collection
	
	If (This:C1470._res_name=Null:C1517)
		$_:=Split string:C1554(This:C1470._url; "://"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
		$_:=Split string:C1554($_[1]; "/"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
		return $_[$_.length-1]
	Else 
		return This:C1470._res_name
	End if 
	
	
	// Set the resource name of the URL
Function set res_name($name : Text)
	
	This:C1470._res_name:=$name
	
	
	// Get the complete URL
Function get url : Text
	
	return This:C1470.protocol+"://"+This:C1470.host+This:C1470.path+This:C1470.res_name
	
	
	// Get the headers of the query
Function get headers : Object
	return This:C1470._headers
	
	
	// Perform an HTTP GET request and return the result
Function get : Object
	var $i; $http_code : Integer
	var $answer; $body : Blob
	var $headers; $result : Object
	var $_key : Collection
	
	$headers:=This:C1470._headers
	
	$_key:=OB Keys:C1719($headers)
	
	ARRAY TEXT:C222($_header; $_key.length)
	ARRAY TEXT:C222($_value; $_key.length)
	
	For ($i; 0; $_key.length-1)
		$_header{$i+1}:=$_key[$i]
		$_value{$i+1}:=$headers[$_key[$i]]
	End for 
	
	$result:={}
	$result.url:=This:C1470.url
	$result.method:=HTTP GET method:K71:1
	
	$http_code:=HTTP Request:C1158($result.method; $result.url; $body; $answer; $_header; $_value)
	
	$result.code:=$http_code
	$result.answer:=$answer
	
	$result.header:={}
	
	For ($i; 1; Size of array:C274($_header))
		$result.header[$_header{$i}]:=$_value{$i}
	End for 
	
	$result.success:=($http_code\100=2)  //This.success
	
	This:C1470._result:=$result
	
	return OB Copy:C1225($result)
	
	
	// Check if the HTTP request was successful
Function get success : Boolean
	
	If (This:C1470._result#Null:C1517) && (This:C1470._result.code#Null:C1517)
		
		return ((This:C1470._result.code\100)=2)
		
	End if 
	
	
	// Get the content type from the response headers
Function get content_type : Text
	If (This:C1470.success)
		
		If (This:C1470._result.header["Content-Type"]#Null:C1517)
			return Split string:C1554(This:C1470._result.header["Content-Type"]; ";"; sk trim spaces:K86:2)[0]
		End if 
		
	End if 
	
	
	