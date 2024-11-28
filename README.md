# OZO PowerShell Module Installation and Usage

## Installation
This module is published to the PowerShell Gallery. Register the repository and then execute the following in an _Administrator_ PowerShell:

`Install-Module OZO`

## Usage
Import this module in your script or console to make the functions available for use:

`Import-Module OZO`

## Functions

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
System.Boolean

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
#### Inputs
System.String
#### Outputs
System.String

---

### Get-OZONumberIsOdd
#### Description
Takes a number as input and returns $true if the number is odd or $false if the number is even.
#### Syntax
```
Get-OZONumberIsOdd
    [-Number <Float>]
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
|`Number`||The number to evaluate. Accepts pipeline input.|
#### Inputs
System.Float
#### Outputs
System.Boolean
