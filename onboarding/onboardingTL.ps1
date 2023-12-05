#-----------------TIMELOG SECTION------------------
$TLtoken = Get-Content 'TLToken.txt'
$headers=@{}
$headers.Add("accept", "application/json")
$headers.Add("content-type", "application/json")
$headers.Add("authorization", $TLtoken)

$response = Invoke-WebRequest -Uri 'https://app1.timelog.com/mobilize/api/v1/hourly-rate?$pagesize=200' -Method 'Get' -Headers $headers

$res = $response.Content | ConvertFrom-Json

#------Hourly rate ID------

if ($role -eq 'PM'){
    $rateRole = 392
}

if ($role -eq 'Graduate' -or $role -eq 'Konsulent'){
    $rateRole = 399
}

if (role -eq 'Seniorkonsulent'){
    $rateRole = 391
}

if ($role -eq 'Partner') {
    $rateRole = 400
}

#----------- Employee No. ------------

$employeeNo = ($res.Properties.TotalRecord + 1).ToString()

#Get user input for the employment date
$employmentDate = $Host.UI.PromptForChoice('Ansættelsesdato', 'Vælg dato', ('&I dag', '&Andet'), 0)
switch ($employmentDate) {
    0 {$employmentDate = Get-Date -Format "o"}
    1 {$employmentDate = Read-Date -Prompt "Indtast ansættelsesdato (dd/mm/yyyy)"} #Test read-date
}

#------- Legal Entity ID --------
$legalEntityID = 1

#------- Department ID --------
$departmentID = 2
if ($location -eq 'DK'){
    $departmentID = 1
}

#------- Approval Manager ID --------
#69 is the ID of sva. Change if needed
$approvalManagerID = 69

#------- Employee Type ID --------
$employeeTypeID = 0
if ($role -eq 'PM'){
    $employeeTypeID = 6
}
if ($role -eq 'Graduate' -or $role -eq 'Konsulent' -or $role -eq 'Seniorkonsulent'){
    $employeeTypeID = 5
}

if ($role -eq 'Partner'){
    $employeeTypeID = 4
}

#------- Holiday calendar ID --------
$holidayCalendarID = 3

if ($location -eq 'DK'){
    $holidayCalendarID = 1
}

#----------Cost price ID ------------

if ($role -eq 'PM' ){
    $costPriceID = 227
}

#Har graduate og konsulent samme cost price????????
if ($role -eq 'Graduate' -or $role -eq 'Konsulent'){
    $costPriceID = 226
}

if ($role -eq 'Seniorkonsulent'){
    $costPriceID = 247
}

if ($role -eq 'Partner'){
    $costPriceID = 225
}

#---------- Allowance Legislation ID ------------
$allowanceLegislationID = 2

#---------- Normal Working Time ID ------------
$normalWorkingTimeID = 1
if ($role -eq 'PM'){
    $normalWorkingTimeID = 5
}

#---------- Salary Group ID ------------
$salaryGroupID = 1

#---------- User Role ID ------------
$userRoleIDs = 6,7,8,4,,9,11,12,5
if ($role -eq 'PM'){
    #append int 2 to array
    $userRoleIDs += 2
}

$splitName = $displayName.Split(" ")


$body = ConvertTo-Json @{
    UserName = $userPrincipalName
    FirstName = $splitName[0]
    LastName = $splitName[1]
    Initials = $mailNickname
    Email = $userPrincipalName
    Title = $role
    EmployeeNo = $employeeNo
    EmploymentDate = $employmentDate
    LegalEntityID = $legalEntityID
    DepartmentID = $departmentID
    ApprovalManagerID = $approvalManagerID
    EmployeeTypeID = $employeeTypeID
    StandardHourlyRateID = $rateRole
    CostPriceID = $costPriceID
    PublicHolidayCalendarID = $holidayCalendarID
    AllowanceLegislationID = $allowanceLegislationID
    NormalWorkingTimeID = $normalWorkingTimeID
    SalaryGroupID = $salaryGroupID
    UserRoleIDs = $userRoleIDs
}

$response = Invoke-WebRequest -Uri 'https://app1.timelog.com/mobilize/api/v1/role' -Method 'Get' -Headers $headers -Body $body

#catch error
if ($response.StatusCode -ne 200){
    Write-Host "Error: " $response.StatusCode
    Write-Host "Error: " $response.StatusDescription
    Write-Host "Error: " $response.Content
}