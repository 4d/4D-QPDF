//%attributes = {}

//var $ut : cs.unit.ut
//$ut:=cs.unit.ut.new()

//var $_ : Collection

//var $folder : 4D.Folder
//var $pdf : 4D.File

//var OK; Error : Integer

//OK:=1
//Error:=0


//var $catcher : cs.error_catcher

////$catcher:=cs.error_catcher.new()

////$catcher.use_error_handling("silent_error_catcher"; ek local)  //
////$catcher.use_error_handling("silent_error_catcher"; ek global)  //
////$catcher.use_error_handling("silent_error_catcher"; ek errors from components)

//var $errorhandler : Text
//$errorhandler:=Method called on error

////ON ERR CALL("silent_error_catcher"; ek errors from components)
////ON ERR CALL("")




//$folder:=Folder(fk resources folder).folder("qpdf-test-files")

//$folder:=Folder($folder.platformPath; fk platform path)

//$ut.suite("qpdf-environ")

//$ut.test("test folder").isTrue($folder.exists)

//If ($ut.successful)

//$_:=PDF Get attachments



//$pdf:=$folder.file("Many Included Files.pdf")


//$ut.test("test file many").isTrue($pdf.exists)

//$_:=PDF Get attachments($pdf)


//$ut.test("attachements count").expect($_.length; 3)


//$pdf:=$folder.file("utf16le.pdf")


//$ut.test("test file utf16le").isTrue($pdf.exists)

//$_:=PDF Get attachments($pdf)



//$pdf:=$folder.file("utf8.pdf")


//$ut.test("test file utf8").try.isTrue($pdf.exists)

//$_:=PDF Get attachments($pdf)

//$_:=Try(PDF Get attachments($pdf)) || []


//Try
//$_:=PDF Get attachments($pdf)
//Catch

//$_:=Last errors

//End try



//End if 

//ON ERR CALL($errorhandler)

////$catcher.release().release().release()

