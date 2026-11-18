# Get-OZOYesNo
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Prompts the user for a Yes or No response, ignores empty or whitespace-only input, and returns the lowercase first non-whitespace letter. For example, `Yes` returns `y`.

## Syntax
```
Get-OZOYesNo
```

## Parameters
None.

## Examples
`````powershell
Get-OZOYesNo
(Y/N): y
y
`````

## Outputs
`System.String`
