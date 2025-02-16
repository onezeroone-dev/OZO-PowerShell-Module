# Get-OZO8601Date
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Returns a formatted ISO 8601 date string.

## Syntax
```
Get-OZO8601Date
    -Pretty
    -Time
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Pretty`|Include punctuation and spacing for a more human-readable date string.|
|`Time`|Include the time.|

## Examples

### Example 1
```powershell
Get-OZO8601Date -Pretty
20250215
```

### Example 2
```powershell
Get-OZO8601Date -Pretty
2025-02-15
```

### Example 3
```powershell
Get-OZO8601Date -Time
20250215171532
```

### Example 4
```powershell
Get-OZO8601Date -Pretty -Time
2025-02-15 17:15:32
```

## Outputs
`System.String`
