# OZO PowerShell Module Installation and Usage

## Installation
This module is published to the PowerShell Gallery. Register the repository and then execute the following in an _Administrator_ PowerShell:

`Install-Module OZO`

## Usage
Import this module in your script or console to make the functions available for use:

`Import-Module OZO`

## Functions

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
```
Get-OZOHostname -FQDN "example.contoso.com"
example
```

##### Example 2
```
Get-OZOHostname
DESKTOP-OZO80202
```

#### Parameters
|Parameter|Description|
|---------|-----------|
|`FQDN`|The fully qualified domain name.|

#### Outputs
System.String
