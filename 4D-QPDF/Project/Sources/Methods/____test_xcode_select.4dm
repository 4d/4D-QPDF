//%attributes = {"invisible":true}
var $path : Text
var $version : Text

var $xcode : cs:C1710.xcode_select

$xcode:=cs:C1710.xcode_select.new()

$path:=$xcode.path

$version:=$xcode.version

$xcode.install()
