//%attributes = {"invisible":true}


var $qpdf : cs:C1710.qpdf
var $_ : Collection
var $path; $version : Text

var $folder : 4D:C1709.Folder

var $a : 4D:C1709.MailAttachment
var $data : Blob
var $name; $cid; $type; $disposition : Text
var $infos : Object

//SET BLOB SIZE($data; 10)

//$a:=MAIL New attachment($data; $name; $cid; $type; $disposition)


$qpdf:=cs:C1710.qpdf.new()


$path:=$qpdf.path



//$qpdf.uninstall()

//$qpdf.install()



$infos:=$qpdf.infos()



//$qpdf.use_system:=True

$path:=$qpdf.path

//SHOW ON DISK($path)


//$folder:=Folder(fk user preferences folder)

//SHOW ON DISK($folder.platformPath)

$folder:=$qpdf.component_folder



$version:=$qpdf.version



var $file : 4D:C1709.File
var $toc : Object

$file:=File:C1566("/RESOURCES/tests/Many Included Files.pdf"; fk posix path:K87:1)


$qpdf.pdf_file:=$file

$toc:=$qpdf.toc

$_:=$qpdf.list_attachments()


$_:=$qpdf.attachments()


