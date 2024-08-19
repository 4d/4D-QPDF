//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($pdf : Variant) : Collection

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : PDF list attachments
   ID[B40BF8CBBA0C4586B27E0F4BC1387C8D]
   Created : 08-04-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

var $qpdf : cs:C1710.qpdf
var $_; $_split : Collection
var $toc; $desc : Object
var $i : Integer
var $name; $key : Text


$qpdf:=cs:C1710.qpdf.new()


$qpdf.pdf_file:=$pdf


$toc:=$qpdf.toc.attachments

$_:=$qpdf.list_attachments()

For ($i; 0; $_.length-1)
	
	$_split:=Split string:C1554($_[$i]; "->"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
	
	$_[$i]:={name: $_split[0]; key: $_split[1]}
	
	$desc:=$toc[$_[$i].name]
	
	For each ($name; $desc.streams)
		
		For each ($key; $desc.streams[$name])
			
			$_[$i][$key]:=$desc.streams[$name][$key]
			
		End for each 
	End for each 
	
	
End for 

return $_



