function ConvertTo-SqlInsertScript {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true)]
      [string]$TableName,

      [Parameter(Mandatory = $true)]
      [psobject[]]$DataArray
  )

  if ($DataArray.Count -eq 0) {
      Write-Error "DataArray is empty. Please provide data to convert."
      return
  }

  $sqlScript = ""
  foreach ($row in $DataArray) {
      $columns = @()
      $values = @()

      foreach ($property in $row.PSObject.Properties) {
          $columns += $property.Name
          $value = $property.Value

          if ($value -is [string]) {
              $values += "'$($value.Replace("'", "''"))'"
          }
          elseif ($value -is [datetime]) {
              $values += "'$($value.ToString("yyyy-MM-dd HH:mm:ss"))'"
          }
          elseif ($value -eq $null) {
              $values += "NULL"
          }
          else {
              $values += $value
          }
      }

      $columnList = ($columns -join ", ")
      $valueList = ($values -join ", ")
      $sqlScript += "INSERT INTO $TableName ($columnList) VALUES ($valueList);`n"
  }

  return $sqlScript
}