# New-OZOSecurePassword
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Returns a randomly generated password as a plain-text `System.String`.

## Syntax
```
New-OZOSecurePassword
    -CharacterCount <Int16>
    -SpecialsCount  <Int16>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`CharacterCount`|The total number of characters in the password. Defaults to 16. Must be between 2 and 32767.|
|`SpecialsCount`|The exact number of special characters. Defaults to 2. Must be between 0 and `CharacterCount`; larger values produce an error.|

Passwords are generated using a cryptographically secure random-number generator. Alphanumeric characters are drawn from `A-Z`, `a-z`, and `0-9`; special characters are drawn from `!@#$%^&*()-_=+[]{};:,.?/`.

## Examples

### Example 1
```powershell
(New-OZOSecurePassword).Length
16
```

### Example 2
`````powershell
(New-OZOSecurePassword -CharacterCount 64 -SpecialsCount 16).Length
64
`````

## Outputs
`System.String`        
