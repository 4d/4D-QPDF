//%attributes = {"invisible":true}

var $o : Object
var $_ : Collection
var $json : Text


$o:={value: 1}

$_:=[$o]


$json:=JSON Stringify:C1217($o; *)
If (is.json_object($json))
	
	
End if 



$json:=JSON Stringify:C1217($_; *)
If (is.json_collection($json))
	
	
End if 