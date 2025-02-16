# Get-OZOHostname
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Returns the hostname for a given fully qualified domain name ("FQDN"). If executed without parameters, it returns the hostname of the running system.

## Syntax
```
Get-OZOHostname
    -FQDN <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`FQDN`|The fully qualified domain name. Accepts pipeline input.|

## Examples

### Example 1
```powershell
Get-OZOHostname -FQDN "example.contoso.com"
example
```

### Example 2
```powershell
Get-OZOHostname
DESKTOP-OZO80202
```

## Outputs
`System.String`
