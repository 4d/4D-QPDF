# PDF get attachments

> PDF get attachments ( pdfFile : 4D.File ) : Collection

| Parameter | Type |     | Description |
| --- | --- | --- | --- |
| pdfFile  | 4D.File | -> | 4D file object referencing a PDF/A3 file with attachments |
| Function result | Collection | <- | Collection of objects __OR__ Null|

## Description

This command retrieves PDF/A3 file attachments from the _pdfFile_ object and returns them in a collection of objects. 

Each object of the returned collection represents an included attachment file and can contain the following properties:

| Property | Type | Description |  Example|
| --- | --- | --- | ---|
| name  | string | file name without extension | "4dlogo" |
|fullname  | string |file name with extension | "4dlogo.png" |
| extension  | string | file extension |".png"|
| mimeType  | string | Mime type | "image/png"|
| content   | 4D.Blob | Blob containing the attachment file ||
| size   | number | (if available)  File size in bytes|72184|
| creationDate   | date | (if available) Date of attachment file creation ||
| modificationDate   | date | (if available) Date of attachment file modification ||
| checksum   | integer | (if available) File checksum ||
| success   | boolean | True if all is ok, False if the extraction failed |true|
| error    | text | Error text, available only if success is false ||

If _pdfFile_ file does not contain PDF attachments, an empty collection is returned. 

If _pdfFile_ file is not a valid PDF file , Null value is returned and an error is generated

## Examples

```4d

var $path : 4D.File
var $_attachments : Collection
var $_errors : Collection

$path:=File("/RESOURCES/tests/Many Included Files.pdf")

// user error mode 
$_attachments:=PDF get attachments($path)

// silent mode
$_attachments:=Try(PDF get attachments($path)) // if failed $_attachments is Null

// code error management
Try
    $_attachments:=PDF get attachments($path) 
Catch
    // some errors are accessibles with Last errors command
    // $_attachments is Null
    $_errors:=Last errors
End try 

```

