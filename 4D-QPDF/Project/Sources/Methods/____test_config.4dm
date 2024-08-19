//%attributes = {"invisible":true}


var $config : cs:C1710.config
var $o : Object


$config:=cs:C1710.config.new("qpdf")


//$folder:=$config.host_user_preferences_folder()


//$folder:=$config.host_config_folder()

//$file:=$config.host_config_file()


$o:=$config.read()
$o:={}

$o.use_system:=True:C214
$o.custom_path:=""


$config.update_template($o)
$config.write($o)

//$file:=$config.component_config_file()
show_on_disk($config)


