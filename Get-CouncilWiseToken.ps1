function Get-CouncilWiseToken {
  <#
    .SYNOPSIS
        used to get a token from the API
    .DESCRIPTION
        Just calls out to the CouncilWise API and ask's for a token, the token that is handed back will expire after 24hours from it's inital issue.
    .NOTES
        -
    .LINK
        Made by the staff of CouncilWise Pty Ltd (https://cwcoreapi.councilwise.com.au/documentation/swagger/index.html)
    .EXAMPLE
      Get-CouncilWiseToken -AppID "asdasd-123edas-asdasd" -Secret "asdasdd2acsdasdcas"
  #>
  param(

    [Parameter(Mandatory = $true)]
    [string]$AppID,

    [Parameter(Mandatory = $true)]
    [string]$Secret
  )


  $body = @{}
  $body.Add("ApplicationId", "$($AppID)")
  $body.Add("ApplicationSecret", "$($Secret)")

  try {
    $response = Invoke-RestMethod -Method Post -Uri "https://cwcoreapi.councilwise.com.au/Auth/token" -Body $($body | ConvertTo-Json) -ContentType "application/json"
    return $response
  }
  catch {
    Write-Error $Error[0]
    throw
  }
}