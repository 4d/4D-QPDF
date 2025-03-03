//%attributes = {"shared":true}
var $build : cs:C1710.Build4D.Component
var $settings : Object
var $success : Boolean


/* -------------------------------------------------- */
/* DEFINE BUILD SETTINGS                              */

$settings:={}
$settings.projectFile:="../4D-QPDF/Project/4D-QPDF.4DProject"

/*
/!\ WARNING: THE CONTENTS OF THE DESTINATION FOLDER WILL BE DELETED BEFORE THE BUILD.
*/

$settings.destinationFolder:="../4D-QPDF_UnitTests/Components/"

$settings.buildName:="4D-QPDF"

$settings.includePaths:=[]
$settings.includePaths.push({source: "../4D-QPDF/Documentation/"})
$settings.includePaths.push({source: "../4D-QPDF/Helpers/"})
$settings.includePaths.push({source: "../4D-QPDF/Resources/"})

$settings.deletePaths:=[]
$settings.deletePaths.push("Resources/test-files/")




$settings.versioning:={}
$settings.versioning.version:="20.7.0"
$settings.versioning.copyright:="©4D SAS 2023-2025"


/* -------------------------------------------------- */
/* DEFINE YOUR OWN CERTIFICATE TO SIGN YOUR COMPONENT */

$settings.signApplication:={}
$settings.signApplication.macSignature:=True:C214
$settings.signApplication.macCertificate:="Developer ID Application: CEDRIC GAREAU (BSE3R8CQZT)"



/* -------------------------------------------------- */
/* BUILD THE COMPONENT */

$build:=cs:C1710.Build4D.Component.new($settings)

$success:=$build.build()

If ($success)
	
	SHOW ON DISK:C922($build.settings.destinationFolder.platformPath)
	
Else 
	//look the logs: $build.logs (from top to bottom)
End if 

