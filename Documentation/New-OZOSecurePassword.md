# New-OZOSecurePassword
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Returns a secure string (password).

## Syntax
```
New-OZOSecurePassword
    -CharacterCount <Int16>
    -SpecialsCount  <Int16>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`CharacterCount`|The total number of characters in the string. Defaults to 16.|
|`SpecialsCount`|The number of special characters. If you do not specify this parameter, or if you specify a value that is higher than the total number of characters, the secure string will contain 2 special characters.|

## Examples

### Example 1
```powershell
New-OZOSecurePassword
z?p/1zD-d(:Xd[R|
```

### Example 2
`````powershell
New-OZOSecurePassword -CharacterCount 64 -SpecialsCount 16
t.kgL@yoBv+f68oYEGVRTpBTZ{>.:qQ=RABH/F%X1g*U6]rX|2|KWErZ@b#m{i$o
`````

## Outputs
`System.String`        
