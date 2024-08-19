//%attributes = {}

var $set_ok_true; $set_ok_false; $set_error_2 : 4D:C1709.Function


$set_ok_true:=Formula from string:C1601("OK:=1"; sk execute in host database:K88:5)
$set_ok_false:=Formula from string:C1601("OK:=0"; sk execute in host database:K88:5)
$set_error_2:=Formula from string:C1601("Error:=-2"; sk execute in host database:K88:5)


OK:=1
Error:=0

$set_ok_false.call()
$set_ok_true.call()
$set_error_2.call()


var $current_error_catcher : Text

$current_error_catcher:=Method called on error:C704  //(ek errors from components)
ON ERR CALL:C155("silent_error_catcher")  //; ek errors from components)


OK:=1
Error:=0

$set_ok_false.call()
$set_ok_true.call()
$set_error_2.call()


ON ERR CALL:C155($current_error_catcher)  //; ek errors from components)
