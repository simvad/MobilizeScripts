Connect-ExchangeOnline

#get displayname and alias as input

$displayName = Read-Host -Prompt 'Enter display name'
$alias = Read-Host -Prompt 'Enter alias'

#Create group
New-UnifiedGroup -DisplayName $displayName -Alias $alias -AccessType Private -AutoSubscribeNewMembers:$false -RequireSenderAuthenticationEnabled:$false -Verbose

#Turn off welcome messages
Set-UnifiedGroup -Identity $displayName -UnifiedGroupWelcomeMessageEnabled:$false
