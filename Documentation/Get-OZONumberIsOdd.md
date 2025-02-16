# Get-OZONumberIsOdd
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Evaluates an integer and returns True if the number is odd or False if the number is even.

## Syntax
```
Get-OZONumberIsOdd
    -Number <Int32>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Number`|The number to evaluate. Accepts pipeline input.|

## Examples

### Example 1
```powershell
Get-OZONumberIsOdd -Number 5
True
```

### Example 2
`````powershell
Get-OZONumberIsOdd -Number 4
False
`````

## Outputs
`System.Boolean`
