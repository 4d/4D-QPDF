

property _attributs : Object

Class constructor($attr : Object)
	
	This:C1470._attributs:=$attr=Null:C1517 ? {} : $attr
	
	This:C1470._attributs.invisible:=(This:C1470._attributs.invisible=Null:C1517) ? False:C215 : This:C1470._attributs.invisible
	This:C1470._attributs.shared:=(This:C1470._attributs.shared=Null:C1517) ? False:C215 : This:C1470._attributs.shared
	This:C1470._attributs.preemptive:=(This:C1470._attributs.preemptive=Null:C1517) ? "indifferent" : This:C1470._attributs.preemptive
	
	This:C1470._attributs.publishedWeb:=(This:C1470._attributs.publishedWeb=Null:C1517) ? False:C215 : This:C1470._attributs.publishedWeb
	This:C1470._attributs.publishedSoap:=(This:C1470._attributs.publishedSoap=Null:C1517) ? False:C215 : This:C1470._attributs.publishedSoap
	This:C1470._attributs.publishedWsdl:=(This:C1470._attributs.publishedWsdl=Null:C1517) ? False:C215 : This:C1470._attributs.publishedWsdl
	This:C1470._attributs.publishedSql:=(This:C1470._attributs.publishedSql=Null:C1517) ? False:C215 : This:C1470._attributs.publishedSql
	
	This:C1470._attributs.executedOnServer:=(This:C1470._attributs.executedOnServer=Null:C1517) ? False:C215 : This:C1470._attributs.executedOnServer
	
	
	
Function to_object : Object
	var $attr : Object
	
	$attr:={\
		invisible: This:C1470.invisible; \
		preemptive: This:C1470.preemptive ? "capable" : ""; \
		publishedWeb: This:C1470.web; \
		publishedSoap: This:C1470.soap; \
		publishedWsdl: This:C1470.wsdl; \
		shared: This:C1470.shared; \
		publishedSql: This:C1470.sql; \
		executedOnServer: This:C1470.server\
		}
	
	return $attr
	
	
	
Function get visible : Boolean
	If (This:C1470._attributs.invisible=Null:C1517)
		return False:C215
	Else 
		return Not:C34(This:C1470._attributs.invisible)
	End if 
	
	
Function get invisible : Boolean
	
	If (This:C1470._attributs.invisible=Null:C1517)
		return True:C214
	Else 
		return This:C1470._attributs.invisible
	End if 
	
	
	
Function get preemptive : Boolean
	return This:C1470._attributs.preemptive="capable"
	
	
	
Function get cooperative : Boolean
	return This:C1470._attributs.preemptive="incapable"
	
	
	
Function get adaptative : Boolean
	return This:C1470._attributs.preemptive="indifferent"
	
	
	
	
Function get shared : Boolean
	If (This:C1470._attributs.shared=Null:C1517)
		return False:C215
	Else 
		return This:C1470._attributs.shared
	End if 
	
	
	
Function get server : Boolean
	If (This:C1470._attributs.executedOnServer=Null:C1517)
		return False:C215
	Else 
		return This:C1470._attributs.executedOnServer
	End if 
	
	
	
Function get web : Boolean
	If (This:C1470._attributs.publishedWeb=Null:C1517)
		return False:C215
	Else 
		return This:C1470._attributs.publishedWeb
	End if 
	
	
	
Function get soap : Boolean
	If (This:C1470._attributs.publishedSoap=Null:C1517)
		return False:C215
	Else 
		return This:C1470._attributs.publishedSoap
	End if 
	
	
	
Function get wsdl : Boolean
	If (This:C1470._attributs.publishedWsdl=Null:C1517)
		return False:C215
	Else 
		return This:C1470._attributs.publishedWsdl
	End if 
	
	
	
Function get sql : Boolean
	If (This:C1470._attributs.publishedSql=Null:C1517)
		return False:C215
	Else 
		return This:C1470._attributs.publishedSql
	End if 
	
	
	
	
	
	
	
	