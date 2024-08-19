//%attributes = {"invisible":true}
var $_list : Collection


var $brew : cs:C1710.brew
var $qpdf : cs:C1710.qpdf

$qpdf:=cs:C1710.qpdf.new()

If ($qpdf.uninstall())
	
	$brew:=cs:C1710.brew.new()
	
	$_list:=$brew.list()
	
	
/*
	
warning will uninstall brew and all brew modules
activate this line below only if you known what you do at your own risk
	
*/
	
	//$brew.uninstall()
	
/*
	
*/
	
End if 