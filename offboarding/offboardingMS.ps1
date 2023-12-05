Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes User.ReadWrite.All

$filter = "userPrincipalName -eq '$upn'"

$deletedUser = Get-MgUser -Filter $filter

Remove-MgUser -UserId $deletedUser.id -Force

