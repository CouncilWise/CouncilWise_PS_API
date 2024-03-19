function Get-CouncilWiseAssociate {
  <#
    .SYNOPSIS
        Get a specific Associate out of the system
    .DESCRIPTION
        -
    .NOTES
        -
    .LINK
        Made by the staff of CouncilWise Pty Ltd (https://cwcoreapi.councilwise.com.au/documentation/swagger/index.html)
    .EXAMPLE
        Get-CouncilWiseAssociate -Token $($CWToken.result.token) -associateId 12
  #>
  param(

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Token,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [int]$associateId
  )

  $headers = @{}
  $headers.Add("Authorization", "Bearer $Token")

  $queryParams = @{
    "associateId" = $associateId
  }
  $url = "https://cwcoreapi.councilwise.com.au/Legacy/Associates/Details" + "?" + $(($queryParams.GetEnumerator() | ForEach-Object { $_.Key + "=" + $_.Value }) -join ('&'))

  try {
    $Responce = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -ContentType "application/json"
    if ($Responce.success -eq $true) {
      return $Responce.result
      return $Responce
    }
    else {
      return $Responce
    }
  }
  catch {
    Write-Error $Error[0]
    Write-Error $url
    throw
  }
}