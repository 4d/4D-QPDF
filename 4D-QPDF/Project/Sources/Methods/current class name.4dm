//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE() : Text

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : Current class name
   ID[EC483C0F0F5C46F98239E84F86D832D4]
   Created : 08-04-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

var $_stack : Collection

$_stack:=Get call chain:C1662.query(" type = :1 "; "classFunction")

Case of 
	: ($_stack.length<1)
		
	: (Position:C15("."; $_stack[0].name; *)>0)  // member function
		return Split string:C1554($_stack[0].name; ".")[0]
		
	: (Position:C15(":"; $_stack[0].name; *)>0)  // constuctor
		return Split string:C1554($_stack[0].name; ":")[0]
		
End case 

