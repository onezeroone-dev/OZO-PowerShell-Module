# Set-OZOBase64ToFile
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Writes a base-64 string to disk as a file. Returns TRUE on success and FALSE on failure.

## Syntax
```
Set-OZOBase64ToFile
    -Base64 <String>
    -Path   <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Base64`|The base-64 string to convert.|
|`Path`|The output file path. If the file exists, it will be overwritten.|

## Examples
```powershell
Set-OZOBase64ToFile -Base64 "IyBPWk8gUG93ZXJTaGVsbCBNb2R1bGUgSW5zdGFsbGF..." -Path ".\README.md"
True
```
