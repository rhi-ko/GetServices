$a=$m=$d=0
$lsvc=$lsys=$nsvc=$osn=0
$objWMIService = Get-WmiObject -Class win32_service -computer localhost

foreach ($i in $objWMIService)
{
switch ($i.startmode)
{
"auto"          { $a++ ; $auto+="$($i.name)`n"}
"manual"        { $m++ ; $manual+="$($i.name)`n"}
"disabled"      { $d++ ; $disabled+="$($i.name)`n"}
DEFAULT { }
}
switch -regex ($i.startname)
{
"localsystem"      { $lsys++}
"localservice"     { $lsvc++}
"networkservice"   { $nsvc++}
DEFAULT            { $osn++ ; $otherservicenames+="$($i.startname)`n"}
}
}

$string = @"
There are $($objWMIService.length) services defined
They start as follows:
automatic $a Manual $m disabled $d

The automatic services are:
___________________________
$auto

The manual services are:
------------------------
$manual 

The disabled services are:
--------------------------
$disabled


The services start using the following accounts:
 localsystem $lsys times
 localService $lsvc times
 networkService $nsvc times
 other user id $osn times
"@

if($osn -ne 0)
 {
 $string+=@"
 
 The other ids in use are listed here:
 $otherservicenames
 
 You should investigate the passwords being used by:
 $otherservicenames
"@
 }
 out-file -inputobject $string -filepath c:\temp\checkservices.txt
