# Get-OZO8601Date
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Returns the current local date, optionally including the local time. Output formats are `yyyyMMdd`, `yyyy-MM-dd`, `yyyyMMddHHmmss`, and `yyyy-MM-dd HH:mm:ss`; time values do not include a time-zone offset.

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
Get-OZO8601Date
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
