//%attributes = {"invisible":true,"preemptive":"incapable"}

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : _get_uuid
   ID[F5BD76A9943F483D8FDA4CFD40A46AD6]
   Created : 08-04-2024 by Dominique Delahaye
   Commented by:
   ----------------------------------------------------
*/


var $comment : Text
var $date : Text

$date:=Replace string:C233(String:C10(Current date:C33; System date short:K1:1); "/"; "-")

$comment:=\
"/*  ----------------------------------------------------\r"+\
"   Project: 4D-QPDF\r"+\
"   Project method : \r"+\
"   ID["+Generate UUID:C1066+"]\r"+\
"   Created : "+$date+" by Dominique Delahaye\r"+\
"   ----------------------------------------------------\r"+\
"*/"


SET TEXT TO PASTEBOARD:C523($comment)
