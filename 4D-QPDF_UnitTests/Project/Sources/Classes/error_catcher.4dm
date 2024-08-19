

property _stack_component : Collection
property _stack_global : Collection
property _stack_local : Collection
property _stack_order : Collection

Class constructor
	
	This:C1470._stack_order:=[]
	
	This:C1470._stack_component:=[]
	This:C1470._stack_global:=[]
	This:C1470._stack_local:=[]
	
	
	
Function use_error_handling($name : Text; $scope : Integer) : cs:C1710.error_catcher
	var $method : cs:C1710.method
	
	$method:=cs:C1710.method.new($name)
	
	Case of 
		: ($name="")
			
		: ($method.exists)
			
			Case of 
					
				: ($scope=ek errors from components:K92:3)
					This:C1470._stack_component.push(Method called on error:C704($scope))
					This:C1470._stack_order.push($scope)
					ON ERR CALL:C155($method.name; $scope)
					
				: ($scope=ek global:K92:2)
					This:C1470._stack_global.push(Method called on error:C704($scope))
					This:C1470._stack_order.push($scope)
					ON ERR CALL:C155($method.name; $scope)
					
				Else 
					
					This:C1470._stack_local.push(Method called on error:C704(ek local:K92:1))
					This:C1470._stack_order.push(ek local:K92:1)
					ON ERR CALL:C155($method.name; $scope)
					
					
			End case 
			
			
		Else 
			
			
			
	End case 
	
	return This:C1470
	
	
	
Function release() : cs:C1710.error_catcher
	var $scope : Integer
	var $method : Text
	
	If (This:C1470._stack_order.length>0)
		
		$scope:=This:C1470._stack_order.pop()
		
		Case of 
				
			: ($scope=ek errors from components:K92:3)
				$method:=This:C1470._stack_component.pop()
				ON ERR CALL:C155($method; $scope)
				
			: ($scope=ek global:K92:2)
				$method:=This:C1470._stack_global.pop()
				ON ERR CALL:C155($method; $scope)
				
			Else 
				
				$method:=This:C1470._stack_local.pop()
				ON ERR CALL:C155($method; $scope)
				
		End case 
		
	End if 
	
	
	
	return This:C1470
	
	
	