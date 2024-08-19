//%attributes = {}
#DECLARE()

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : QPDF Use system
   ID[48F7AB00F4EE4D169A16C5C8CB87C5B4]
   Created : 08-04-2024 by Dominique Delahaye
   Documented by : chatGPT 3.5
   ----------------------------------------------------
*/


var $config : cs:C1710.config
var $folder : 4D:C1709.Folder
var $o : Object

$config:=cs:C1710.config.new("qpdf")


$o:=$config.read_system()

If (Bool:C1537($o.use_system))
	
Else 
	$o.use_system:=True:C214
	$config.write_system($o)
End if 

$folder:=$config._system_config_folder()
show_on_disk($folder)

