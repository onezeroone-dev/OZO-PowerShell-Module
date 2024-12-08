# OZO PowerShell Module Installation and Usage

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

`Install-Module OZO`

## Usage
Import this module in your script or console to make the functions available for use:

`Import-Module OZO`

## Functions

- [Get-OZO64BitPowerShell](#get-ozo64bitpowershell)
- [Get-OZOHostname](#get-ozohostname)
- [Get-OZONumberIsOdd](#get-ozonumberisodd)

### Get-OZO64BitPowerShell
#### Description
Returns True if the PowerShell environment is 64-bit and False if not.
#### Syntax
```
Get-OZO64BitPowerShell
```
#### Examples
```powershell
Get-OZO64BitPowerShell
True
```
#### Parameters
None.
#### Inputs
None.
#### Outputs
`System.Boolean`

---

### Get-OZOHostname
#### Description
Returns the hostname for a given fully qualified domain name ("FQDN"). If executed without parameters, it returns the hostname of the running system.
#### Syntax
```
Get-OZOHostname
    [-FQDN <String>]
```
#### Examples
##### Example 1
```powershell
Get-OZOHostname -FQDN "example.contoso.com"
example
```
##### Example 2
```powershell
Get-OZOHostname
DESKTOP-OZO80202
```
#### Parameters
|Parameter|Description|
|---------|-----------|
|`FQDN`|The fully qualified domain name. Accepts pipeline input.|
#### Outputs
`System.String`

---

### Get-OZONumberIsOdd
#### Description
Evaluates an integer and returns True if the number is odd or False if the number is even.
#### Syntax
```
Get-OZONumberIsOdd
    [-Number <Int32>]
```
#### Examples
##### Example 1
```powershell
Get-OZONumberIsOdd -Number 5
True
```
##### Example 2
`````powershell
Get-OZONumberIsOdd -Number 4
False
`````
#### Parameters
|Parameter|Description|
|---------|-----------|
|`Number`|The number to evaluate. Accepts pipeline input.|
#### Outputs
`System.Boolean`
