if(-not (Get-Module Microsoft.Graph.Users -ListAvailable)){
    Install-Module Microsoft.Graph.Users -Scope CurrentUser -Force
    }

if (-not (Get-Module Microsoft.Graph.Calendar -ListAvailable)){
    Install-Module Microsoft.Graph.Calendar -Scope CurrentUser -Force
    }


$RequiredScopes = @(Directory.AccessAsUser.All, Directory.ReadWrite.All, User.ReadWrite.All, Organization.Read.All)
Connect-MgGraph -Scopes $RequiredScopes

$PasswordProfile = @{
    Password = $pw
    }
  New-MgUser -DisplayName $navn -PasswordProfile $PasswordProfile -AccountEnabled -MailNickName $nick -UserPrincipalName $upn
  

$BS = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq 'O365_BUSINESS_PREMIUM' 
$E1 = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq 'STANDARDPACK'

if ($type -eq 'Student'){
    Set-MgUserLicense -UserId $upn -AddLicenses @{SkuId = $E1.SkuId} -RemoveLicenses @()
}
else {
    Set-MgUserLicense -UserId $upn -AddLicenses @{SkuId = $BS.SkuId} -RemoveLicenses @()
}

Connect-ExchangeOnline
$identity = $upn+':\kalender'

Set-MailboxFolderPermission -Identity $identity -User Default -AccessRights Reviewer
Disconnect-ExchangeOnline -Confirm:$false


$groups = @()

#Add groups for all 
$groups += Get-MgGroup -Filter "displayName eq 'Mobilize Strategy Consulting'"
$groups += Get-MgGroup -Filter "displayName eq 'Mobilize'"

if ($type -eq 'Partner'){
    $groups += Get-MgGroup -Filter "displayName eq 'Partner'"
}

#Add groups for DK
if ($land -eq 'DK'){
    $groups += Get-MgGroup -Filter "displayName eq 'Mobilizekontordk'"
}

#Add groups for NO
if ($land -eq 'NO'){
    $groups += Get-MgGroup -Filter "displayName eq 'Mobilize Norge'"
}

#Add groups for PM
if ($type -eq 'Student'){
    $groups += Get-MgGroup -Filter "displayName eq 'Studenter Alle'"
    if ($land -eq 'DK'){
        $groups += Get-MgGroup -Filter "displayName eq 'StudenterDK'"
    }
    if ($land -eq 'NO'){
        $groups += Get-MgGroup -Filter "displayName eq 'Studenter Norge'"
    }
}

#Add groups for Graduate
if ($type -eq 'Graduate'){
    $groups += Get-MgGroup -Filter "displayName eq 'Graduates'"
    $groups += Get-MgGroup -Filter "displayName eq 'Konsulenter'"
}

#Add groups for Konsulent
if ($type -eq 'Konsulent' ){
    $groups += Get-MgGroup -Filter "displayName eq 'Konsulenter'"
}

Disconnect-MgGraph