//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($what : Variant)

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : show_on_disk
   ID[2E2AB69C6AA54355B3B3E13B97A88DC9]
   Created : 08-04-2024 by Dominique Delahaye
   ----------------------------------------------------
*/


var $path : Text

Case of 
		
	: (Value type:C1509($what)=Is text:K8:3)
		$path:=$what
		
		If (Position:C15(Folder separator:K24:12; $path; *)>0)
		Else 
			$path:=Convert path POSIX to system:C1107($path)
		End if 
		
		If (Test path name:C476($path)#-1)
			SHOW ON DISK:C922($path)
		End if 
		
	: (Value type:C1509($what)#Is object:K8:27)
		
		
	: (OB Instance of:C1731($what; 4D:C1709.File))
		$path:=$what.platformPath
		SHOW ON DISK:C922($path)
		
	: (OB Instance of:C1731($what; 4D:C1709.Folder))
		$path:=$what.platformPath
		SHOW ON DISK:C922($path)
		
	: ($what.platformPath#Null:C1517)
		SHOW ON DISK:C922($what.platformPath)
		
	: ($what.path#Null:C1517)
		
		If (Position:C15(Folder separator:K24:12; $what.path; *)>0)
			$path:=$what.path
		Else 
			$path:=Convert path POSIX to system:C1107($what.path)
		End if 
		
		SHOW ON DISK:C922($path)
		
End case 
