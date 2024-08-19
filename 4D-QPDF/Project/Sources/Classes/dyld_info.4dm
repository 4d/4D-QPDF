/*  ----------------------------------------------------
   Project: 4D-QPDF
   Project class : dyld_info
   ID[CD83917541EF4C79A29FDB9E47F66751]
   Created : 16-07-2024 by Dominique Delahaye
   ----------------------------------------------------
*/


Class extends cli



Class constructor()
	
	Super:C1705("/usr/bin/dyld_info")
	
	
	
	
Function platform($target : Text) : Object
	
	var $worker : 4D:C1709.SystemWorker
	var $o:={}
	var $_; $_field; $_value : Collection
	var $i; $index : Integer
	var $arch : Text
	
	$worker:=This:C1470.execute(" -platform \""+$target+"\"")
	
	$_:=Split string:C1554($worker.response; "\n"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
	
	$index:=$_.indexOf($target+" @")
	
	If ($index>=0)
		
		$arch:=Replace string:C233($_[$index]; $target; "")
		
		$arch:=Split string:C1554($arch; "["; sk ignore empty strings:K86:1+sk trim spaces:K86:2)[0]
		$arch:=Split string:C1554($arch; "]"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)[0]
		
		$o[$arch]:={arch: $arch}
		
		$index+=2
		
		$_field:=Split string:C1554($_[$index]; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		$_value:=Split string:C1554($_[$index+1]; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
		For ($i; 0; $_field.length-1)
			$o[$arch][$_field[$i]]:=$_value[$i]
		End for 
		
		
		$index:=$_.indexOf($target+" @"; $index+1)
		
		If ($index>=0)
			$arch:=Replace string:C233($_[$index]; $target; "")
			
			$arch:=Split string:C1554($arch; "["; sk ignore empty strings:K86:1+sk trim spaces:K86:2)[0]
			$arch:=Split string:C1554($arch; "]"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)[0]
			
			$o[$arch]:={arch: $arch}
			
			$index+=2
			
			$_field:=Split string:C1554($_[$index]; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			$_value:=Split string:C1554($_[$index+1]; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			For ($i; 0; $_field.length-1)
				$o[$arch][$_field[$i]]:=$_value[$i]
			End for 
			
		End if 
		
	End if 
	
	return $o
	
	
	
Function validate($target : Text) : Boolean
	
	var $worker : 4D:C1709.SystemWorker
	
	//This.dataType:="text"
	//This.no_time_out()
	
	$worker:=This:C1470.execute(" -validate_only \""+$target+"\"")
	
	// $worker.exitCode=0
	
	return ($worker.response="")