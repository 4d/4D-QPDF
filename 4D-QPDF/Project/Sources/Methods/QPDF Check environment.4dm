//%attributes = {}

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : QPDF Check  environment
   ID[466208F6D6154DE3AE6649810D403EFE]
   Created : 09-04-2024 by Dominique Delahaye
   Documented by : chatGPT 3.5
   ----------------------------------------------------
*/

var $qpdf : cs:C1710.qpdf
var $config : Object
var $version : Text

$qpdf:=cs:C1710.qpdf.new()

$config:=$qpdf._config

Case of 
	: ($qpdf.ready)
		
		$version:=$qpdf.version
		
		If ($qpdf.use_system)
			
			ALERT:C41("\"System\" QPDF ready!\r QPDF version: "+$version)
			
		Else 
			
			ALERT:C41("Component \"4D QPDF\" ready!\r QPDF version: "+$version)
			
		End if 
		
	: ($config=Null:C1517)
		
		ALERT:C41("Config file not found, run \"QPDF UPDATE\" method!")
		
	Else 
		
		$config:=$config._system_config_object()
		
		Case of 
				
			: ($config.use_system)
				
				ALERT:C41("QPDF is not installed on your system : \rRun \"QPDF UPDATE\" method or \"QPDF Use component\" method!")
				
			Else 
				
				ALERT:C41("QPDF is not installed in your \"4D QPDF\" component : Run \"QPDF UPDATE\" method or \"QPDF Use system\" method!")
				
		End case 
		
End case 