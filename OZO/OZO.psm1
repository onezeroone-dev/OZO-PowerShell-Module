Function Get-OZO64BitPowerShell {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns True if the PowerShell environment is 64-bit and False if not.
        .EXAMPLE
        Get-OZO64BitPowerShell
        True
        .OUTPUTS
        System.Boolean
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozo64bitpowershell
    #>
    return [Environment]::Is64BitProcess
}

Function Get-OZODelimiterSubString {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Parses a String and returns a List of substrings found between Start and End delimiters. If the start delimiter is not found, the List contains a single string leading up to the end delimiter. If the end delimiter is not found, the List contains a single string trailing the start delimiter. If neither delimiter is found, the List contains a single string (the original string).
        .PARAMETER String
        The string to process.
        .PARAMETER Start
        The start delimiter.
        .PARAMETER End
        The end delimiter.
        .EXAMPLE
        $subStringsList = Get-OZODelimiterSubString -String "2023-06-20T14:18:09-05:00{226da830-da5c-42af-83fd-37467b753ec6}" -Start "{" -End "}"
        $subStringsList[0]
        226da830-da5c-42af-83fd-37467b753ec6
        .EXAMPLE
        (Get-OZODelimiterSubString -String "2023-06-20T14:18:09-05:00{226da830-da5c-42af-83fd-37467b753ec6}" -Start "{" -End "}")[0]
        226da830-da5c-42af-83fd-37467b753ec6
        .EXAMPLE
        Get-OZODelimiterSubString -String "2023-06-20T14:18:09-05:00{226da830-da5c-42af-83fd-37467b753ec6}" -Start "{" -End "}" | Select-Object -First 1
        226da830-da5c-42af-83fd-37467b753ec6
        .EXAMPLE
        $subStringsList = Get-OZODelimiterSubString -String "2023-06-20T14:18:09-05:00{226da830-da5c-42af-83fd-37467b753ec6}" -Start ":" -End ":"
        $subStringsList[0]
        18
        $subStringsList[1]
        09-05
        .OUTPUTS
        System.Collections.Generic.List[String]
        .NOTES
        Thanks to this Stack Overflow post (https://stackoverflow.com/questions/67626879/system-collections-generic-liststring-as-return-value that helped me understand how to write a function that consistently returns a List.
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozodelimitersubstring
    #>
    # Parameters
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory=$true,HelpMessage="The string to parse")][String]$String,
        [Parameter(Mandatory=$true,HelpMessage="The starting delimiter")][Char]$Start,
        [Parameter(Mandatory=$true,HelpMessage="The ending delimiter")][Char]$End
    )
    # Variables
    [System.Collections.Generic.List[String]]$Results = @()
    # Determine if the string contains the Start and End characters
    If ($String -Like ("*" + $Start + "*") -And $String -Like ("*" + $End + "*")) {
        # String contains Start and End characters; add each of the results to the List
        ForEach ($Result in [Regex]::Matches($String,"(?<=\$Start).+?(?=\$End)").Value) { $Results.Add($Result) }
    # ElseIf determine if String contains the Start character
    } ElseIf ($String -Like ("*" + $Start + "*")) {
        # String contains the Start character; add the resulting string to the List
        $Results.Add([Regex]::Matches($String,"(?<=\$Start).*").Value)
    # ElseIf determine if String contains the End character
    } ElseIf ($String -Like ("*" + $End + "*")) {
        # String contains the End character; add the resulting string to the List
        $Results.Add([Regex]::Matches($String,".*(?=\$End)").Value)
    # Else add the original string to the List
    } Else {
        $Results.Add($String)
    }
    # Return
    $PSCmdlet.WriteObject($Results)
}

Function Get-OZOEndSubString {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the last "Length" characters of a string. If Length is longer than String, the original string is returned.
        .PARAMETER String
        The string to parse. Accepts pipeline input.
        .PARAMETER Length
        The number of characters to return.
        .EXAMPLE
        Get-OZOEndSubString -String "The quick brown fox jumps over the lazy dog." -Length 8
        azy dog.
        .EXAMPLE
        "The quick brown fox jumps over the lazy dog." | Get-OZOEndSubString -Length 8
        azy dog.
        .OUTPUTS
        System.String
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozoendsubstring
    #>
    # Parameters
    param (
        [Parameter(Mandatory=$true,HelpMessage="The string to parse",ValueFromPipeline=$true)][String]$String,
        [Parameter(Mandatory=$true,HelpMessage="The number of characters to return")][Int32]$Length
    )
    # Determine if Length is shorter than or equal to String length
    If ($First -le $String.Length) { 
        # Length is shorter than or equal to String length; return the desired substring
        return $String.Substring($String.Length - $Length)
    } Else {
        # Length is *not* shorter than or equal to String length
        return $String
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

Function Get-OZOIndexSubString {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the inner part of a string based on a starting index and length. If the length between the start index and the end of the string is longer than Length, the string trailing the start index is returned. If Length is longer than String, the original string is returned.
        .PARAMETER String
        The string to process. Accepts pipeline input.
        .PARAMETER Index
        The starting character index.
        .PARAMETER Length
        The number of characters to return.
        .EXAMPLE
        Get-OZOIndexSubString -String "The quick brown fox jumps over the lazy dog." -Index 8 -Length 4
        ck b
        .EXAMPLE
        "The quick brown fox jumps over the lazy dog." | Get-OZOIndexSubString -Index 8 -Length 4
        ck b
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozoindexsubstring
    #>
    # Parameters
    param (
        [Parameter(Mandatory=$true,HelpMessage="The string to parse",ValueFromPipeline=$true)][String]$String,
        [Parameter(Mandatory=$true,HelpMessage="The starting character number")][Int32]$Index,
        [Parameter(Mandatory=$true,HelpMessage="The number of characters to return")][Int32]$Length

    )
    # Determine if Start = or Start = 1
    If ($Index -eq 0 -Or $Index -eq 1) {
        # Start is 0 or 1; call Get-OZOStartSubString
        return (Get-OZOStartSubString -String $String -Length $Length)
    } ElseIf ($Index -eq $String.Length) {
        # Start character is equal to the length of String; return the last character
        return $String.Substring($String.Length - 1)
    } ElseIf ($Index -lt $String.Length) {
        # Shift Start to be inclusive
        $Index = $Index - 1
        # Determine that the start character is shorter than String length
        If ($Index -lt $String.Length) {
            # Start character shorter than String length; determine that the difference length is less than or equal to Length
            If ($Length -le ($String.Length - $Index)) {
                # Difference length is less than or equal to Length; return the desired substring
                return $String.Substring($Index,$Length)
            } Else {
                # Difference length is *not* less than or equal to Length; return the substring starting at StartCharacter
                return $String.Substring($String.Length - ($String.Length - $Index))
            }

        } Else {
            # Start character is *not* less than the length of the string; return the original String
            return $String
        }
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

Function Get-OZOStartSubString {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the first "Length" characters of a string. If Length is longer than String, the original string is returned.
        .PARAMETER String
        The string to parse. Accepts pipeline input.
        .PARAMETER Length
        The number of characters to return.
        .EXAMPLE
        Get-OZOStartSubString -String "The quick brown fox jumps over the lazy dog." -Length 8
        The quic
        .EXAMPLE
        "The quick brown fox jumps over the lazy dog." | Get-OZOStartSubString -Length 8
        The quic
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md#get-ozostartsubstring
    #>
    # Parameters
    param (
        [Parameter(Mandatory=$true,HelpMessage="The string to parse",ValueFromPipeline=$true)][String]$String,
        [Parameter(Mandatory=$true,HelpMessage="The number of characters to return")][Int32]$Length
    )
    # Determine if Length shorter than or or equal to String length
    If ($Length -le $String.Length) {
        # Length is shorter than or equal to String length; return the desired substring
        return $String.Substring(0,$Length)
    } Else {
        # Length is *not* shorter tahn equal to String length; return String
        return $String
    }
}

Export-ModuleMember -Function Get-OZO64BitPowerShell,Get-OZODelimiterSubString,Get-OZOEndSubString,Get-OZOHostname,Get-OZOIndexSubString,Get-OZONumberIsOdd,Get-OZOStartSubString
