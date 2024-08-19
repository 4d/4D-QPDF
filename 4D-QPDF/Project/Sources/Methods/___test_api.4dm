//%attributes = {"invisible":true,"preemptive":"capable"}

var $_a : Collection
var $path : Text
var $picture : Picture
var $xml : Text
var $attachment : Object
var $qpdf : cs:C1710.qpdf

var $feature : Text
var $folder : 4D:C1709.Folder
var $_files : Collection
var $file : 4D:C1709.File

$feature:="https://github.com/4d/4d/issues/4831"


$path:="/RESOURCES/test-files/Many Included Files.pdf"


/*
*/

//$path:="/RESOURCES/tests/utf16le.pdf"



$file:=File:C1566($path; fk posix path:K87:1)

//#TM file
//$folder:=Folder("/Users/4d/Downloads")

//$_files:=$folder.files().query(" extension = :1 "; ".pdf")

//$file:=$_files.first()


//var $_l:Collection
//$_l:=PDF list attachments($path)

//$_l:=PDF list attachments($file)


//$_l:=$_l.remove(1; 1)


$qpdf:=cs:C1710.qpdf.new()


//show_on_disk($qpdf.path)

//$_:=$qpdf.dependencies()



$qpdf._show_config()
$_a:=PDF Get attachments

$_a:=PDF Get attachments($file)  //; $_l)

For each ($attachment; $_a)
	
	Case of 
			
		: ($attachment.mimeType=Null:C1517)
		: ($attachment.mimeType="image/png")
			
			BLOB TO PICTURE:C682($attachment.content; $picture)
			to_pasteboard($picture)
			
		: ($attachment.mimeType="text/xml")
			
			$xml:=BLOB to text:C555($attachment.content; UTF8 text without length:K22:17)
			
			to_pasteboard($xml)
			
			
		: ($attachment.mimeType="application/pdf")
			BLOB TO PICTURE:C682($attachment.content; $picture)
			to_pasteboard($picture)
			
		Else 
			
			to_pasteboard($attachment.content)
			
			
	End case 
	
	
End for each 