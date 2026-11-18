Function Get-OZO64BitPowerShell {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns True if the PowerShell environment is 64-bit and otherwise False.
        .EXAMPLE
        Get-OZO64BitPowerShell
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZO64BitPowerShell.md
    #>
    # Return
    return [System.Environment]::Is64BitProcess
}

Function Get-OZO8601Date {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the current local date, optionally including local time. Time values do not include a time-zone offset.
        .PARAMETER Pretty
        Include punctuation and spacing for a more human-readable date string.
        .PARAMETER Time
        Include the time.
        .EXAMPLE
        Get-OZO8601Date
        20250215
        .EXAMPLE
        Get-OZO8601Date -Pretty
        2025-02-15
        .EXAMPLE
        Get-OZO8601Date -Time
        20250215171532
        .EXAMPLE
        Get-OZO8601Date -Pretty -Time
        2025-02-15 17:15:32
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZO8601Date.md
    #>
    # Parameters
    [CmdLetBinding()] Param(
        [Parameter(Mandatory=$false,HelpMessage="Include punctuation and spacing")][Switch]$Pretty,
        [Parameter(Mandatory=$false,HelpMessage="Include the time")][Switch]$Time
    )
    # Get the datetime object for the current date and time
    [DateTime]$dateTime = (Get-Date)
    # Determine if Pretty and Time were specified
    If ($Pretty -eq $true -And $Time -eq $true) {
        # Pretty and Time were specified
        return $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
    # Determine if only Pretty was specified
    } ElseIf ($Pretty -eq $true -And $Time -eq $false) {
        # Only Pretty was specified
        return $dateTime.ToString("yyyy-MM-dd")
    # Determine if only Time was specified
    } ElseIf ($Pretty -eq $false -And $Time -eq $true) {
        # Only Time was specified
        return $dateTime.ToString("yyyyMMddHHmmss")
    # Determine if neither Pretty nor Time were specified
    } Else {
        # Neither Pretty or Time were specified
        return $dateTime.ToString("yyyyMMdd")
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOHostname.md
    #>
    # Parameters
    [CmdLetBinding()] Param (
        [Parameter(Mandatory=$false,HelpMessage="The fully qualified domain name",ValueFromPipeline=$true)][String]$FQDN
    )
    # Process each FQDN supplied through the pipeline
    Process {
        # Determine if FQDN is null or empty
        If ([String]::IsNullOrEmpty($FQDN)) {
            # FQDN is null or empty; return the local hostname
            $Env:COMPUTERNAME
        } Else {
            # FQDN is not null or empty; parse and return the hostname
            ($FQDN -Split "\.",2)[0]
        }
    }
}

Function Get-OZONumberIsOdd {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns True if the number is odd and otherwise False.
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZONumberIsOdd.md
    #>
    # Parameters
    [CmdLetBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The number to evaluate",ValueFromPipeline=$true)][Int32]$Number
    )
    # Return whether each pipeline number is odd
    Process {
        [Boolean]($Number%2)
    }
}

Function Get-OZOUserInteractive {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns True if the PowerShell session is user-interactive and otherwise False.
        .EXAMPLE
        Get-OZOUserInteractive
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOUserInteractive.md
    #>
    # Return
    return [System.Environment]::UserInteractive
}

Function Get-OZOYesNo {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Prompts the user for a Yes or No response, ignores empty input, and returns the lowercase first letter.
        .EXAMPLE
        Get-OZOYesNo
        (Y/N): y
        y
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOYesNo.md
    #>
    # Variables
    [String] $Response = $null
    # Loop until a valid response is received
    Do {
        $InputResponse = Read-Host "(Y/N)"
        # Ignore empty or whitespace-only responses
        If ([String]::IsNullOrWhiteSpace($InputResponse)) {
            $Response = ""
        } Else {
            # Normalize the first non-whitespace character
            $Response = $InputResponse.Trim().Substring(0,1).ToLowerInvariant()
        }
    } Until ($Response -eq "y" -Or $Response -eq "n")
    # Return the validated response
    return $Response
}

# Return a cryptographically random index without modulo bias
Function Get-OZOSecureRandomIndex {
    [CmdLetBinding()] Param(
        [Parameter(Mandatory=$true)][ValidateRange(1,32767)][Int32]$UpperBound,
        [Parameter(Mandatory=$true)][System.Security.Cryptography.RandomNumberGenerator]$Generator
    )
    # Allocate bytes for an unsigned 32-bit random value
    [Byte[]]$Bytes = New-Object Byte[] 4
    # Find the largest divisible range to avoid modulo bias
    [UInt64]$Range = 4294967296
    [UInt64]$Bound = $UpperBound
    [UInt64]$Limit = $Range - ($Range % $Bound)
    # Reject values outside the divisible range
    Do {
        $Generator.GetBytes($Bytes)
        [UInt64]$Value = [BitConverter]::ToUInt32($Bytes,0)
    } While ($Value -ge $Limit)
    # Return an index within the requested upper bound
    return [Int32]($Value % $Bound)
}

Function New-OZOSecurePassword {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns a randomly generated password as a plain-text string.
        .PARAMETER CharacterCount
        The total number of characters in the string. Defaults to 16. Must be between 2 and 32767.
        .PARAMETER SpecialsCount
        The number of special characters. Defaults to 2 and must be between 0 and CharacterCount.
        .EXAMPLE
        (New-OZOSecurePassword).Length
        16
        .EXAMPLE
        (New-OZOSecurePassword -CharacterCount 64 -SpecialsCount 16).Length
        64
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/New-OZOSecurePassword.md

    #>
    [CmdLetBinding()] Param(
        [Parameter(Mandatory=$false,HelpMessage="The number of characters in the password")][ValidateRange(2,32767)][Int16]$CharacterCount = 16,
        [Parameter(Mandatory=$false,HelpMessage="The number of special characters")][ValidateRange(0,32767)][Int16]$SpecialsCount = 2
    )
    # Ensure the requested special-character count fits the password length
    If ($SpecialsCount -gt $CharacterCount) {
        throw [System.ArgumentOutOfRangeException]::new("SpecialsCount","SpecialsCount cannot exceed CharacterCount.")
    }
    # Define the characters allowed in each part of the password
    [Char[]]$AlphanumericCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
    [Char[]]$SpecialCharacters = "!@#$%^&*()-_=+[]{};:,.?/".ToCharArray()
    # Allocate the password buffer and calculate the alphanumeric portion
    [Char[]]$PasswordCharacters = New-Object Char[] $CharacterCount
    [Int32]$AlphanumericCount = $CharacterCount - $SpecialsCount
    # Create a cryptographically secure random-number generator
    $Generator = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    Try {
        # Fill the buffer with the requested number of alphanumeric characters
        For ($Index = 0; $Index -lt $AlphanumericCount; $Index++) {
            $RandomIndex = Get-OZOSecureRandomIndex -UpperBound $AlphanumericCharacters.Length -Generator $Generator
            $PasswordCharacters[$Index] = $AlphanumericCharacters[$RandomIndex]
        }
        # Fill the remaining positions with special characters
        For ($Index = $AlphanumericCount; $Index -lt $CharacterCount; $Index++) {
            $RandomIndex = Get-OZOSecureRandomIndex -UpperBound $SpecialCharacters.Length -Generator $Generator
            $PasswordCharacters[$Index] = $SpecialCharacters[$RandomIndex]
        }
        # Shuffle all characters so special characters are not grouped at the end
        For ($Index = $CharacterCount - 1; $Index -gt 0; $Index--) {
            $RandomIndex = Get-OZOSecureRandomIndex -UpperBound ($Index + 1) -Generator $Generator
            $Character = $PasswordCharacters[$Index]
            $PasswordCharacters[$Index] = $PasswordCharacters[$RandomIndex]
            $PasswordCharacters[$RandomIndex] = $Character
        }
        # Return the generated password
        return (-join $PasswordCharacters)
    } Finally {
        # Dispose of the random-number generator
        $Generator.Dispose()
    }
}

Function Send-OZOMail {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Sends an email message using an anonymous, unencrypted SMTP relay on port 25. Returns True on success. Returns False and writes an error if the server is unreachable, an attachment path is missing, or SMTP sending fails. Invalid addresses and other setup errors are reported as terminating errors.
        .PARAMETER To
        A comma-separated list of message recipients. You must supply at least one recipient. You may supply a simple email address e.g., "noreply@onezeroone.dev" or you can use the "One Zero One Noreply <noreply@onezeroone.dev>" syntax for "prettier" headers.
        .PARAMETER Cc
        A comma-separated list of additional recipients. Addresses may be formatted as described in the "To" parameter.
        .PARAMETER Bcc
        A comma-separated list of additional [hidden] recipients. Addresses may be formatted as described in the "To" parameter.
        .PARAMETER From
        The message sender. Addresses may be formatted as described in the "To" parameter.
        .PARAMETER Subject
        The message subject.
        .PARAMETER Body
        The message body.
        .PARAMETER Attachments
        A list of file paths to attach. A missing file causes the function to return False and write an error; inaccessible files can produce a terminating error.
        .PARAMETER MailServer
        The SMTP relay server to use.
        .OUTPUTS
        System.Boolean
        .EXAMPLE
        Send-OZOMail -To "OZO Info <info@onezeroone.dev>" -From "OZO Noreply <noreply@onezeroone.dev>" -Subject "Test" -Body "This is a test." -MailServer "smtp.onezeroone.dev"
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Send-OZOMail.md
    #>
    [CmdLetBinding()] Param(
        [Parameter(Mandatory=$true,HelpMessage="A list of message recipients")][Array]$To,
        [Parameter(Mandatory=$false,HelpMessage="A list of additional recipients")][Array]$Cc = $null,
        [Parameter(Mandatory=$false,HelpMessage="A list of additional [hidden] recipients")][Array]$Bcc = $null,
        [Parameter(Mandatory=$true,HelpMessage="The message sender")][String]$From,
        [Parameter(Mandatory=$true,HelpMessage="The message subject")][String]$Subject,
        [Parameter(Mandatory=$true,HelpMessage="The message body.")][String]$Body,
        [Parameter(Mandatory=$false,HelpMessage="A list of files to attach")][Array]$Attachments = $null,
        [Parameter(Mandatory=$true,HelpMessage="The SMTP relay server to use")][String]$MailServer
    )
    # Initialize disposable objects for cleanup
    $ozoMail = $null
    $ozoSMTP = $null
    # Use the standard SMTP port
    [Int16] $MailPort = 25
    # Determine whether the SMTP server is reachable
    $Connection = Test-NetConnection -ComputerName $MailServer -Port $MailPort
    If (-not $Connection.TcpTestSucceeded) {
        # Unable to reach the SMTP server
        Write-Error -Message "Unable to connect to SMTP server '$MailServer' on port $MailPort." -Category ConnectionError -TargetObject $MailServer
        return $false
    }
    Try {
        # Construct a mail message object
        $ozoMail = New-Object Net.Mail.MailMessage
        # Add the To recipients
        ForEach ($Recipient in $To) { $ozoMail.To.Add($Recipient) }
        # Add the From sender, subject, and body
        $ozoMail.From = $From
        $ozoMail.Subject = $Subject
        $ozoMail.Body = $Body
        # Add the Cc and Bcc recipients, if supplied
        If ($null -ne $Cc) { ForEach ($Recipient in $Cc) { $ozoMail.CC.Add($Recipient) } }
        If ($null -ne $Bcc) { ForEach ($Recipient in $Bcc) { $ozoMail.Bcc.Add($Recipient) } }
        # Add the attachments, if supplied
        If ($null -ne $Attachments) {
            ForEach ($Path in $Attachments) {
                # Verify that each attachment path identifies a file
                If (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
                    Write-Error -Message "Attachment file '$Path' was not found." -Category ObjectNotFound -TargetObject $Path
                    return $false
                }
                # Resolve the file path and attach the file
                $ResolvedPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath
                $ozoMail.Attachments.Add((New-Object Net.Mail.Attachment($ResolvedPath)))
            }
        }
        # Establish an SMTP connection
        $ozoSMTP = New-Object Net.Mail.SmtpClient($MailServer,$MailPort)
        # Attempt to send the message
        Try {
            $ozoSMTP.Send($ozoMail)
            # Return success
            return $true
        } Catch [System.Net.Mail.SmtpException] {
            # Report SMTP send failures
            Write-Error -ErrorRecord $_
            return $false
        } Catch [System.InvalidOperationException] {
            # Report invalid SMTP operation failures
            Write-Error -ErrorRecord $_
            return $false
        }
    } Finally {
        # Dispose of the SMTP client and message, including any attachments
        If ($null -ne $ozoSMTP) { $ozoSMTP.Dispose() }
        If ($null -ne $ozoMail) { $ozoMail.Dispose() }
    }
}

Function Test-OZOLocalAdministrator {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns True if the current user is a local administrator and otherwise False.
        .EXAMPLE
        Test-OZOLocalAdministrator
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Test-OZOLocalAdministrator.md
    #>
    # Return
    return (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Export-ModuleMember -Function `
    Get-OZO64BitPowerShell,
    Get-OZO8601Date,
    Get-OZOHostname,
    Get-OZONumberIsOdd,
    Get-OZOSecureRandomIndex,
    Get-OZOUserInteractive,
    Get-OZOYesNo,
    New-OZOSecurePassword,
    Send-OZOMail,
    Test-OZOLocalAdministrator
