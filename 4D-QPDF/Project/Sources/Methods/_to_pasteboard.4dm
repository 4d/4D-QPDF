//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($something : Variant)

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : _to_pasteboard
   ID[DF387BFD99B149EDB355E7A7C88730EA]
   Created : 08-04-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

Case of 
		
	: (Value type:C1509($something)=Is text:K8:3)
		
		SET TEXT TO PASTEBOARD:C523($something)
		
		
	: (Value type:C1509($something)=Is picture:K8:10)
		
		SET PICTURE TO PASTEBOARD:C521($something)
		
		
	: (Value type:C1509($something)=Is BLOB:K8:12)
		
		// quick preview of blob content
		SET TEXT TO PASTEBOARD:C523(BLOB to text:C555($something; UTF8 text without length:K22:17))
		
	: (Value type:C1509($something)=Is object:K8:27) && (OB Instance of:C1731($something; 4D:C1709.Blob))
		
		var $blob : Blob
		
		$blob:=$something
		
		SET TEXT TO PASTEBOARD:C523(BLOB to text:C555($blob; UTF8 text without length:K22:17))
		
		
	Else 
		
		
		
End case 