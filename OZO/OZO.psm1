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
    return [Environment]::Is64BitProcess
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

Export-ModuleMember -Function Get-OZO64BitPowerShell,Get-OZOHostname,Get-OZONumberIsOdd
