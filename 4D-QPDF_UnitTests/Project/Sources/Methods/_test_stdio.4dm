//%attributes = {}

var $stdio : cs:C1710.stdio
var $sw : 4D:C1709.SystemWorker

$stdio:=cs:C1710.stdio.new("UT-4D-QPDF")


$sw:=$stdio.splash($stdio.out("hello"))

