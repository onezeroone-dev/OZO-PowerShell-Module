# OZO PowerShell Module

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

```powershell
Install-Module OZO
```

## Usage
Import this module in your script or console to make the functions available for use:

```powershell
Import-Module OZO
```

## Functions

- [Get-OZO64BitPowerShell](#get-ozo64bitpowershell)
- [Get-OZOFileToBase64](#get-ozofiletobase64)
- [Get-OZOHostname](#get-ozohostname)
- [Get-OZONumberIsOdd](#get-ozonumberisodd)
- [Set-OZOBase64ToFile](#set-ozobase64tofile)
- [Test-OZOPath](#test-ozopath)

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
#### Outputs
`System.Boolean`

---
### Get-OZOFileToBase64
#### Description
Returns a Base-64 string representing a valid file, or "File not found" if the file does not exist or cannot be read.
#### Syntax
```
Get-OZOFileToBase64
    -Path <String>
```
#### Examples
```powershell
Get-OZOFileToBase64 -Path ".\README.md"
IyBPWk8gUG93ZXJTaGVsbCBNb2R1bGUgSW5zdGFsbGF... <snip>
```
#### Parameters
|Parameter|Description|
|---------|-----------|
|`Path`|The path to the file to convert to a base-64 string.|
#### Outputs
`System.String`

---
### Get-OZOHostname
#### Description
Returns the hostname for a given fully qualified domain name ("FQDN"). If executed without parameters, it returns the hostname of the running system.
#### Syntax
```
Get-OZOHostname
    -FQDN <String>
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
    -Number <Int32>
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

---
### Set-OZOBase64ToFile
#### Description
Writes a base-64 string to disk as a file. Returns TRUE on success and FALSE on failure.
#### Syntax
```
Set-OZOBase64ToFile
    -Base64 <String>
    -Path   <String>
```
#### Examples
```powershell
Set-OZOBase64ToFile -Base64 "IyBPWk8gUG93ZXJTaGVsbCBNb2R1bGUgSW5zdGFsbGF..." -Path ".\README.md"
True
```
#### Parameters
|Parameter|Description|
|---------|-----------|
|`Base64`|The base-64 string to convert.|
|`Path`|The output file path. If the file exists, it will be overwritten.|

---
### Test-OZOPath
#### Description
Determines if a path exists and is readable. Optionally tests if the path is writable.
#### Syntax
```
Test-OZOPath
    -Path <String>
```
#### Examples
```powershell
Test-OZOPath -Path ".\README.md"
True
```
#### Parameters
|Parameter|Description|
|---------|-----------|
|`Path`|The path to test. Returns TRUE if the path exists and is readable and otherwise returns FALSE.|
|`Writable`|Determines if the path is writable. Returns TRUE if the path is writable and otherwise returns FALSE.|
