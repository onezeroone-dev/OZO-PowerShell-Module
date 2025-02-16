Function Get-OZO64BitPowerShell {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns True if the PowerShell environment is 64-bit and False if not.
        .EXAMPLE
        Get-OZO64BitPowerShell
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozo64bitpowershell
    #>
    return [System.Environment]::Is64BitProcess
}

Function Get-OZOFileToBase64 {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns a Base-64 string representing a valid file, or "File not found" if the file does not exist or cannot be read.
        .PARAMETER Path
        The path to the file to convert to a base-64 string.
        .EXAMPLE
        Get-OZOFileToBase64 -Path .\README.md
        IyBPWk8gUG93ZXJTaGVsbCBNb2R1bGUgSW5zdGFsbGF... <snip>
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozofiletobase64
    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="The path to the file to convert to a base-64 string",ValueFromPipeline=$true)][String]$Path
    )
    # Determine if Path is readable
    If ((Test-OZOPath -Path $Path) -eq $true) {
        # Path is readable; convert file to base-64 string
        return [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Resolve-Path -Path $Path)))
    } Else {
        # Path is not readable; report
        return "File not found"
    }
}

Function Get-OZOHostname {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the hostname for a given fully qualified domain name ("FQDN"). If executed without parameters, it returns the hostname of the running system.
        .PARAMETER FQDN
        The fully qualified domain name.
        .EXAMPLE
        Get-OZOHostname -FQDN "example.contoso.com"
        example
        .EXAMPLE
        Get-OZOHostname
        DESKTOP-OZO80202
        .OUTPUTS
        System.String
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozohostname
    #>
    # Parameters
    param (
        [Parameter(Mandatory=$false,HelpMessage="The fully qualified domain name",ValueFromPipeline=$true)][String]$FQDN
    )
    # Determine if FQDN is null or empty
    If ([String]::IsNullOrEmpty($FQDN)) {
        # FQDN is null or empty; return the local hostname
        return $Env:COMPUTERNAME
    } Else {
        # FQDN is not null or empty; parse and return the hostname
        return ($FQDN -Split "\.",2)[0]
    }
}

Function Get-OZONumberIsOdd {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Evaluates an integer and returns True if the number is odd or False if the number is even.
        .PARAMETER Number
        The number to evaluate. Accepts pipeline input.
        .EXAMPLE
        Get-OZONumberIsOdd -Number 5
        True
        .EXAMPLE
        Get-OZONumberIsOdd -Number 4
        False
        .OUTPUTS
        System.Boolean
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozonumberisodd
    #>
    # Parameters
    param (
        [Parameter(Mandatory=$true,HelpMessage="The number to evaluate",ValueFromPipeline=$true)][Int32]$Number
    )
    # Return
    return [Boolean]($Number%2)
}

Function Set-OZOBase64ToFile {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Writes a base-64 string to disk as a file. Returns TRUE on success and FALSE on failure.
        .PARAMETER Base64
        The base-64 string to convert.
        .PARAMETER Path
        The output file path. If the file exists, it will be overwritten.
        .EXAMPLE
        Set-OZOBase64ToFile -Base64 "IyBPWk8gUG93ZXJTaGVsbCBNb2R1bGUgSW5zdGFsbGF..." -Path .\README.md
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#set-ozobase64tofile
    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="The base-64 string",ValueFromPipeline=$true)][String]$Base64,
        [Parameter(Mandatory=$true,HelpMessage="The output file path")][String]$Path
    )
    # Split Directory from Path
    [String] $Directory = (Split-Path -Path $Path -Parent)
    # Ensure the Directory exists and is writable
    If ((Test-OZOPath -Path $Directory -Writable) -eq $true) {
        # Path
        [System.IO.File]::WriteAllBytes($Path,[Convert]::FromBase64String($Base64))
        # Determine if the file exists
        If ((Test-Path -Path $Path) -eq $true) {
            # File exists
            return $true
        } Else {
            # File does not exist
            return $false
        }
    }
}

Function Test-OZOPath {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Determines if a path exists and is readable. Optionally tests if the path is writable.
        .PARAMETER Path
        The path to test. Returns TRUE if the path exists and is readable and otherwise returns FALSE.
        .PARAMETER Writable
        Determines if the path is writable. Returns TRUE if the path is writable and otherwise returns FALSE.
        .EXAMPLE
        Test-OZOPath -Path .\README.md
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#test-ozopath
    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="The path to test",ValueFromPipeline=$true)][String]$Path,
        [Parameter(Mandatory=$false,HelpMessage="Test if Path is writable")][Switch]$Writable
    )
    # Booleans for readable and writable
    [Boolean] $isReadable = $false
    [Boolean] $isWritable = $false
    # Object to hold path properties
    [System.IO.FileSystemInfo] $Item = $null
    # Try to get the item
    Try {
        $Item = Get-Item -Path $Path -ErrorAction Stop
        # Success; Determine if path is a File
        If ((Test-Path -Path $Path -PathType Leaf -ErrorAction SilentlyContinue) -eq $true) {
            # File; if not read only, set readable and writable
            $isReadable = -Not $Item.IsReadOnly
            $isWritable = $Item.IsReadOnly
        } Else {
            # Directory
            [String] $TestPath = (Join-Path -Path $Path -ChildPath (New-Guid).Guid)
            # Set readable
            $isReadable = [Boolean](Get-ChildItem -Path $Path -ErrorAction SilentlyContinue)
            # Try to write a file
            Try {
                New-Item -ItemType File -Path $TestPath -ErrorAction Stop | Out-Null
                # Success; set writable to True and clean up
                $isWritable = $true
                Remove-Item -Path $TestPath -ErrorAction Stop
            } Catch {
                # Failure; set writable to False
                $isWritable = $false
            }
        }
    } Catch {
        # Failure; path does not exist or is not accessible; set readable and writable
        $isReadable = $false
        $isWritable = $false
    }
    # Determine if Writable was specified
    If ($Writable -eq $true) {
        # return Writable
        return $isWritable
    } Else {
        # return Readable
        return $isReadable
    }
}

Export-ModuleMember -Function Get-OZO64BitPowerShell,Get-OZOFileToBase64,Get-OZOHostname,Get-OZONumberIsOdd,Set-OZOBase64ToFile,Test-OZOPath
