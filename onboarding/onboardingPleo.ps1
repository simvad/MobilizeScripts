

#Make Pleo account 
$userPrincipalName = "testuser" #CHANGE FROM TEST VALUE LATER>!!!!!!
$PLtoken = Get-Content 'PleoToken.txt'
$email = $userPrincipalName +"@mobilize-nordic.com"
$headers=@{}
$headers.Add("accept", "application/json")
$headers.Add("content-type", "application/json")
$headers.Add("authorization", $PLtoken)
$body = @{
    email = $email
} | ConvertTo-Json
$response = Invoke-WebRequest -Uri 'https://openapi.pleo.io/v1/employees' -Method POST -Headers $headers -ContentType 'application/json'  -Body $body

#Catch error
if ($response.StatusCode -ne 200){
    Write-Host "Error: " $response.StatusCode
    Write-Host "Error: " $response.StatusDescription
    Write-Host "Error: " $response.Content
}