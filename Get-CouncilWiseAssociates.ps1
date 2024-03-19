function Get-CouncilWiseAssociates {
  <#
    .SYNOPSIS
        Get the Associates out of the system
    .DESCRIPTION
        Allows you to get the associates out of the CouncilWise API, this can be used without filters to get out all associates. Or more preferably, all the associates modified after a specific date.
    .NOTES
        -
    .LINK
        Made by the staff of CouncilWise Pty Ltd (https://cwcoreapi.councilwise.com.au/documentation/swagger/index.html)
    .EXAMPLE
        Get-CouncilWiseAssociates -Token $($CWToken.result.token) -filters "SearchBy=Nick" -sortKey AssociateId -sortOrder Descending -Verbose $true
        Get-CouncilWiseAssociates -Token $($CWToken.result.token) -filters "LastName=Smith" -sortKey AssociateId -sortOrder Descending -Verbose $true
        Get-CouncilWiseAssociates -Token $($CWToken.result.token) -filters "LastName=Smith" -sortKey AssociateId -sortOrder Descending -Verbose $true
        Get-CouncilWiseAssociates -Token $($CWToken.result.token) -DateModified 'eq "2023/05/20 20:00:00 to 2023/05/20 20:00:00"' -Verbose $true
  #>
  param(

    [Parameter(Position = 90, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Token,

    [Parameter(Position = 91, Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$filters,

    [Parameter(Position = 92, Mandatory = $false)]
    [ValidateSet("Ascending", "Descending")]
    [string]$sortOrder,

    [Parameter(Position = 93, Mandatory = $false)]
    [ValidateSet("AssociateId", "FullNameForward", "Gender", "PostalName", "PostalAddress", "ResidentialAddressLine1", "ContactPhoneNumberMobile", "AssociateType", "ResidentialAddressSuburb", "ResidentialAddressState", "ResidentialAddressPostCode", "ContactEmailAddressWork", "ContactEmailAddressHome", "ContactPhoneNumberWork", "ContactPhoneNumberHome", "ABN")]
    [string]$sortKey,

    [Parameter(Position = 94, Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$DateModified
  )

  $headers = @{}
  $headers.Add("Authorization", "Bearer $Token")

  $Page = 1
  $queryParams = @{
    "pageNumber" = $Page
    "pageSize"   = 50
  }
  if ($sortOrder -eq "Ascending") {
    $queryParams.Add("sortOrder", 0)
  }
  elseif ($sortOrder -eq "Descending") {
    $queryParams.Add("sortOrder", 1)
  }
  if ($sortKey) {
    $queryParams.Add("sortKey", $sortKey)
  }
  if ($filters) {
    $queryParams.Add("filters", $filters)
  }
  if ($DateModified) {
    $queryParams.Add("DateModified", $DateModified)
  }

  $ResponceData = @()
  try {
    do {
      $url = "https://cwcoreapi.councilwise.com.au/Legacy/Associates" + "?" + $(($queryParams.GetEnumerator() | ForEach-Object { $_.Key + "=" + $_.Value }) -join ('&'))
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