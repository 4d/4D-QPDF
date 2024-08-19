//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($param : Text)

/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project method : on_startup_application
   ID[AB25E773051544B0948F14A97B7E393A]
   Created : 08-04-2024 by Dominique Delahaye
   ----------------------------------------------------
*/

//https://doc.4d.com/4Dv20/4D/20.2/Interface-ligne-de-commande.300-6750128.fr.html



Case of 
	: (Count parameters:C259=0)
		
		var $result : Integer
		var $userParam : Text
		
		
		$result:=Get database parameter:C643(User param value:K37:94; $userParam)
		
		If (Length:C16($userParam)>0)
			
			$result:=New process:C317(Current method path:C1201; 0; "start up"; $userParam; *)
			
		End if 
		
	Else 
		
		var $_args : Collection
		var $arg : Text
		var $exit : Boolean
		
		$_args:=Split string:C1554($param; " "; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
		
		For each ($arg; $_args)
			
			Case of 
					
				: ($arg="-c") || ($arg="--component")
					//USE QPDF COMPONENT //todo: make a silent mode version
					
					
				: ($arg="-s") || ($arg="--system")
					//USE QPDF SYSTEM //todo: make a silent mode version
					
					
				: ($arg="-u") || ($arg="--update")
					//UPDATE QPDF  //todo: make a silent mode version
					
					
				: ($arg="-q")
					
					$exit:=True:C214  //:deffered call
					
					//ALERT("Quit 4D ")
					
			End case 
			
			
		End for each 
		
		If ($exit)
			CALL WORKER:C1389("cooperative bridge"; "_exit_to_shell_")
		End if 
		
		
		
		//ALERT(JSON Stringify($_args; *))
		
		
End case 