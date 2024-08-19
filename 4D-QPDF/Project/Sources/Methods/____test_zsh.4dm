//%attributes = {"invisible":true}


var $zsh : cs:C1710.zsh
var $qpdf : Text
var $_ : Collection
var $env : Object
var $result : Variant


$zsh:=cs:C1710.zsh.new()


$env:=$zsh.env()


$result:=$zsh.sudo("/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""; "4D need to install Homebrew...")
If ($result.exitCode=0)
	
	$_:=Split string:C1554($result.response; "==>"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
End if 


//$zsh.currentDirectory:=!00-00-00!

//$zsh.currentDirectory:=Null  //Folder("/usr"; fk posix path)

//$qpdf:=$zsh.where("qpdf")
$qpdf:=$zsh.which("qpdf")


var $e : Text
var $c : Collection

$e:=$zsh.echo("$PATH")
$e:=$zsh.echo("$SHELL")
$e:=$zsh.echo("$PWD")  // current working directory

$c:=$zsh.cat("/etc/paths")

//$c:=$zsh.cat("/opt/paths")

$zsh.currentDirectory:=Folder:C1567("/")

$_:=$zsh.ls()
$env:=$zsh.env()


$_:=$zsh.find("brew")
$_:=$zsh.find("qpdf")

/*


ls /rep/qpdf

responseCode #0 N/A : BINGO






*/