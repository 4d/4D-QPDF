//%attributes = {"invisible":true}

var $brew : cs:C1710.brew

var $zsh : cs:C1710.zsh
var $_ : Collection


$zsh:=cs:C1710.zsh.new()

$zsh.currentDirectory:="/"


$brew:=cs:C1710.brew.new()


$_:=$brew.packages()


var $version; $path : Text

$version:=$brew.version
$path:=$brew.path

