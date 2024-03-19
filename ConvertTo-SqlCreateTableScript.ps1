function ConvertTo-SqlCreateTableScript {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true)]
      [string]$TableName,

      [Parameter(Mandatory = $true)]
      [psobject[]]$DataArray
  )

  if ($DataArray.Count -eq 0) {
      Write-Error "DataArray is empty. Please provide data to generate the table schema."
      return
  }

  $columnsSql = @()
  $firstRow = $DataArray[0]

  foreach ($property in $firstRow.PSObject.Properties) {
      $columnName = $property.Name
      $value = $property.Value
      $columnType = "VARCHAR(255)" # Default

      switch ($value.GetType().Name) {
          'Int32' { $columnType = "INT" }
          'Int64' { $columnType = "BIGINT" }
          'Boolean' { $columnType = "BIT" }
          'DateTime' { $columnType = "DATETIME" }
          'Double' { $columnType = "FLOAT" }
          'Decimal' { $columnType = "DECIMAL(19,4)" }
          String { 
              if ($value.Length -gt 255) { 
                  $columnType = "VARCHAR(MAX)" 
              } else { 
                  $columnType = "VARCHAR(255)"
              } 
          }
      }

      $columnsSql += "`t[$columnName] $columnType"
  }

  $columnsSqlString = $columnsSql -join ",`n"
  $sqlScript = "CREATE TABLE [$TableName] (`n$columnsSqlString`n);"

  return $sqlScript
}