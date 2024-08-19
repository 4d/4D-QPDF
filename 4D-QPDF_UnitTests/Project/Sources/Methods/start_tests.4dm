//%attributes = {}

var $component : cs:C1710.component
var $error:={}
var $_tu:=[]
var $ms : Integer
var $system : Object
var $application : Object
var $build : Integer
var $version : Text

$system:=Get system info:C1571
$application:=Get application info:C1599

$version:=Application version:C493($build; *)

$ms:=Milliseconds:C459
$_tu.push("4D-QPDF unit test : "+Timestamp:C1445)
$_tu.push("OS-version : "+$system.osVersion)
$_tu.push("4D-version : "+$version+"-"+String:C10($build))


//mark:-
/*

check component 4D-QPDF is available

*/


$component:=cs:C1710.components.me.query("4D-QPDF").first()

If ($component#Null:C1517)
	$_tu.push("component: exist."+"\t OK").push("").push("status: success")
Else 
	$_tu.push("component does not exist."+"\t  KO").push("").push("status: FAILED")
End if 
$_tu.push("")  // report separator 



//mark:- count shared methods 

$_tu:=$_tu.concat(____test_count_shared($component)).push("")


//mark:- count visible methods 

$_tu:=$_tu.concat(____test_count_visible($component)).push("")


//mark:- check method "PDF Get attachments"

$_tu:=$_tu.concat(____test_PDF_GET_ATTACHMENT($component)).push("")


//mark:- check method "QPDF Check environment"

$_tu:=$_tu.concat(____test_QPDF_Check_environment($component)).push("")


//mark:- check method "QPDF Check environment"

$_tu:=$_tu.concat(____test_QPDF_Update($component)).push("")


//mark:- check method "QPDF Use component"

$_tu:=$_tu.concat(____test_QPDF_Use_component($component)).push("")


//mark:- check method "QPDF Use system"

$_tu:=$_tu.concat(____test_QPDF_Use_system($component)).push("")


//mark:- test folder test files

$_tu:=$_tu.concat(____test_folders_test_files()).push("")


//mark:- test command with no parameter

$_tu:=$_tu.concat(____test_no_param()).push("")


//mark:- test command with valid pdf no attachment

$_tu:=$_tu.concat(____test_valid_pdf()).push("")


//mark:- test command with valid pdf with attachment

$_tu:=$_tu.concat(____test_valid_pdf_attachments()).push("")


//mark:- test command with not valid pdf file

$_tu:=$_tu.concat(____test_not_valid_pdf()).push("")



//mark:- test command with not valid pdf file

$_tu:=$_tu.concat(____test_pdf_with_warning()).push("")


//mark:-
$ms:=Abs:C99(Milliseconds:C459-$ms)


$_tu.push(Current method path:C1201+" : "+String:C10($ms)+"ms")

//mark:-

var $index : Integer

$index:=$_tu.findIndex(Formula:C1597($1.value=$2); "@\t  KO")

$_tu.push("")
If ($index>0)
	
	
	$_tu.push("GLOBAL RESULT : FAILED")
	
Else 
	
	$_tu.push("GLOBAL RESULT : SUCCESS")
	
End if 

var $stdio : cs:C1710.stdio
var $sw : 4D:C1709.SystemWorker

$stdio:=cs:C1710.stdio.new("UT-4D-QPDF")


$sw:=$stdio.splash($stdio.show($stdio.out($_tu.join("\n"))))





