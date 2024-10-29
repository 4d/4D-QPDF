//%attributes = {"invisible":true}

var $brew : cs:C1710.brew

var $zsh : cs:C1710.zsh
var $_ : Collection
var $package : Object


$zsh:=cs:C1710.zsh.new()

$zsh.currentDirectory:="/"


$brew:=cs:C1710.brew.new()

If ($brew.update())
	
	$_:=$brew.packages()
	For each ($package; $_)
		
		$brew.update_package($package.name)
		
	End for each 
	
	
End if 



var $version; $path : Text

$version:=$brew.version
$path:=$brew.path

