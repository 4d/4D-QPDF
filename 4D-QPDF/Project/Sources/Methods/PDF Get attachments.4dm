//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : PDF get attachments
   ID[DEFDD6E574F54D709360F26B0AFCD3D2]
   Created : 08-04-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

#DECLARE($pdf : 4D:C1709.File)->$attachments : Collection

var $qpdf : cs:C1710.qpdf

$attachments:=[]

$qpdf:=cs:C1710.qpdf.new()

If ($qpdf.ready)
	
	$qpdf.pdf_file:=$pdf
	
	$attachments:=$qpdf.attachments()
	
Else 
	
	throw:C1805({errCode: -1; message: "QPDF is not installed !"; componentSignature: "QPDF"; deferred: True:C214})
	
End if 







