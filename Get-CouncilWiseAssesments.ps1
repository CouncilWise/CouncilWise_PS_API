function Get-CouncilWiseAssesments {
  <#
    .SYNOPSIS
        Get the Assesments
    .DESCRIPTION
        -
    .NOTES
        -
    .LINK
        Made by the staff of CouncilWise Pty Ltd (https://cwcoreapi.councilwise.com.au/documentation/swagger/index.html)
    .EXAMPLE
        Get-CouncilWiseAssesments -Token $($CWToken.result.token)
  #>
  param(

    [Parameter(Position = 90, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Token
  )

  $headers = @{}
  $headers.Add("Authorization", "Bearer $Token")

  $Page = 1
  $queryParams = @{
    "pageNumber" = $Page
    "pageSize"   = 50
  }

  $ResponceData = @()
  try {
    do {
      $url = "https://cwcoreapi.councilwise.com.au/Legacy/Properties/Assessments" + "?" + $(($queryParams.GetEnumerator() | ForEach-Object { $_.Key + "=" + $_.Value }) -join ('&'))
      $Responce = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -ContentType "application/json"
      $ResponceData += $Responce.result.result
      $queryParams.pageNumber ++
      Write-Host "URL: $url"
      Write-Host "Fetched $($ResponceData.count) of $($Responce.result.total)"
    } until ($ResponceData.count -eq $Responce.result.total)
    return $ResponceData
  }
  catch {
    Write-Error $Error[0]
    Write-Error $url
    throw
  }
}