function Get-CouncilWiseAssesmentRatingDetails {
  <#
    .SYNOPSIS
        Get an assesment's rating details out for a specific,.. well, assesment
    .DESCRIPTION
        Will return how an assesment is setup to be rated. Note: this can change quite often, due to supps etc.
    .NOTES
        -
    .LINK
        Made by the staff of CouncilWise Pty Ltd (https://cwcoreapi.councilwise.com.au/documentation/swagger/index.html)
    .EXAMPLE
        Get-CouncilWiseAssesmentRatingDetails -Token $($CWToken.result.token) -assessmentId 1 -propertyNumber 3 -propertyAddress "some property address"
  #>
  param(

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Token,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]$assessmentId,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$propertyNumber,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$propertyAddress
  )

  $headers = @{}
  $headers.Add("Authorization", "Bearer $Token")

  $Body = @{}
  if ($assessmentId) {
    $Body.Add("assessmentId", $assessmentId)
  }
  if ($propertyNumber) {
    $Body.Add("propertyNumber", $propertyNumber)
  }
  if ($propertyAddress) {
    $Body.Add("propertyAddress", $propertyAddress)
  }
  if ($Body -eq @{}) {
    Write-Error "nothing provided"
    throw
  }

  try {
      $url = "https://cwcoreapi.councilwise.com.au/Legacy/Properties/Assessment/RatingDetails"# + "?" + $(($queryParams.GetEnumerator() | ForEach-Object { $_.Key + "=" + $_.Value }) -join ('&'))
      $Responce = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -ContentType "application/json" -Body $($Body | ConvertTo-Json)
    return $Responce
  }
  catch {
    Write-Error $url
    throw
  }
}