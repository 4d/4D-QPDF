
The use of PDF/A-3 files is set to become mandatory in various countries within the European Community (see [here](https://entreprendre.service-public.fr/actualites/A15683#:~:text=L'obligation%20de%20recevoir%20des,le%201er%20septembre%202026.) for France and [here](https://www.ihk-muenchen.de/ihk/documents/Recht-Steuern/Steuerrecht/Ordnungsgem%C3%A4%C3%9Fe-Rechnung-(USt-)-2020.pdf) for Germany). As a result, the ability to extract the XML files they contain will become essential. Moreover, PDF/A-3 files can contain a variety of embedded files, which you will undoubtedly need to extract. Understanding and utilizing tools to manage these files effectively is becoming increasingly important in ensuring compliance and maximizing the utility of embedded documents.

The 4D-QPDF component provides you with a single command to simply extract attachments from PDF/A-3 files.



# PDF Get attachments

> PDF Get attachments ( pdfFile : 4D.File ) : Collection

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

## Example

```4d

var $path : 4D.File
var $_attachments : Collection
var $_errors : Collection

$path:=File("/RESOURCES/tests/Many Included Files.pdf")

// user error mode 
$_attachments:=PDF Get attachments($path)

// silent mode
$_attachments:=Try(PDF Get attachments($path)) // if failed $_attachments is Null

// code error management
Try
    $_attachments:=PDF Get attachments($path) 
Catch
    // some errors are accessibles with Last errors command
    // $_attachments is Null
    $_errors:=Last errors
End try 

```

