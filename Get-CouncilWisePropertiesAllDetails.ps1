function Get-CouncilWisePropertiesAllDetails {
  <#
    .SYNOPSIS
        Get property details alone with (all) associated items
    .DESCRIPTION
        A process to get all properties, and everything associated with them, for example animals or parcels (title/land)
    .NOTES
        -
    .LINK
        Made by the staff of CouncilWise Pty Ltd (https://cwcoreapi.councilwise.com.au/documentation/swagger/index.html)
    .EXAMPLE
        Get-CouncilWisePropertiesAllDetails -Token $($CWToken.result.token) -filters 'DateModified gt "2024/03/01 00:00:00"'
        Get-CouncilWisePropertiesAllDetails -Token $($CWToken.result.token)
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
    [ValidateSet("PropertyNumber", "FullStreetAddress", "CompositeOwnerName", "CompositeRatepayerName", "Suburb", "PropertyId", "PaymentReference", "PropertyName", "VolumeFolio", "ItemId", "QuickSearchPropertyNumber")]
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
  Write-Verbose "Execiting call to the API"
  try {
    do {
      $url = "https://cwcoreapi.councilwise.com.au/Legacy/Properties/AllDetails" + "?" + $(($queryParams.GetEnumerator() | ForEach-Object { $_.Key + "=" + $_.Value }) -join ('&'))
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