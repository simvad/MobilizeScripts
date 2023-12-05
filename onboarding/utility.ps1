# Check if all parameters are provided
if (-not $navn -or -not $pw -or -not $nick -or -not $land) {
    Write-Host "Manglende parametre. Kræver -navn (fulde navn), -pw (password), -nick (3 bogstavs initialer) og -land (DK/NO)"
    exit 1
}

$upn = $nick + '@mobilize-nordic.com'

$choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    New-Object System.Management.Automation.Host.ChoiceDescription "&S - Student", "Student"
    New-Object System.Management.Automation.Host.ChoiceDescription "&G - Graduate", "Graduate"
    New-Object System.Management.Automation.Host.ChoiceDescription "&K - Konsulent", "Konsulent"
    New-Object System.Management.Automation.Host.ChoiceDescription "&P - Partner", "Partner"
)

$decision = $Host.UI.PromptForChoice("User Type Selection", "Choose a user type:", $choices, 0)

$userTypes = @('Student', 'Graduate', 'Konsulent', 'Senior Konsulent', 'Partner')
$type= $userTypes[$decision]

function Read-Date {
    param(
      [String] $prompt
    )
    $result = $null
    do {
      $s = Read-Host $prompt
      if ( $s ) {
        try {
          $result = Get-Date $s
          break
        }
        catch [Management.Automation.PSInvalidCastException] {
          Write-Host "Dato ikke valid. Prøv igen."
        }
      }
      else {
        break
      }
    }
    while ( $true )
    $result
  }