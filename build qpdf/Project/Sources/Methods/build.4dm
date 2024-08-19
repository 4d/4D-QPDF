//%attributes = {"shared":true}
var $build : cs:C1710.Build4D.Component
var $settings : Object
var $success : Boolean

$settings:=New object:C1471()
$settings.projectFile:="../4D-QPDF/Project/4D-QPDF.4DProject"
$settings.destinationFolder:="../4D-QPDF_UnitTests/Components/"
$settings.buildName:="4D-QPDF"

$settings.includePaths:=New collection:C1472
$settings.includePaths.push(New object:C1471("source"; "../4D-QPDF/Documentation/"))
$settings.includePaths.push(New object:C1471("source"; "../4D-QPDF/Helpers/"))
$settings.includePaths.push(New object:C1471("source"; "../4D-QPDF/Resources/"))

$settings.deletePaths:=New collection:C1472
$settings.deletePaths.push("Resources/test-files/")

$build:=cs:C1710.Build4D.Component.new($settings)
$success:=$build.build()


