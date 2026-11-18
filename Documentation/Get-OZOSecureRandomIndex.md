# Get-OZOSecureRandomIndex
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Returns an unbiased, cryptographically secure random integer from zero up to, but not including, the specified upper bound. This is an used by `New-OZOSecurePassword`.

## Syntax
```
Get-OZOSecureRandomIndex
    -UpperBound <Int32>
    -Generator  <RandomNumberGenerator>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`UpperBound`|The exclusive upper bound for the returned index. Must be between 1 and 32767.|
|`Generator`|A `System.Security.Cryptography.RandomNumberGenerator` instance used to obtain random bytes. The caller is responsible for disposing of it.|

## Examples
Run within the module scope with a generator instance:
```powershell
Get-OZOSecureRandomIndex -UpperBound 10 -Generator $Generator
4
```

## Outputs
`System.Int32`
