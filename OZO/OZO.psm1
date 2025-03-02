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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZO64BitPowerShell.md
    #>
    return [System.Environment]::Is64BitProcess
}

Function Get-OZO8601Date {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns a formatted ISO 8601 date string.
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
    param(
        [Parameter(Mandatory=$false,HelpMessage="Include punctuation and spacing")][Switch]$Pretty,
        [Parameter(Mandatory=$false,HelpMessage="Include the time")][Switch]$Time
    )
    # Get the datetime object for the current date and time
    [DateTime]$dateTime = (Get-Date)
    # Determine if Pretty and Time were specified
    If ($Pretty -eq $true -And $Time -eq $true) {
        # Pretty and Time were specified
        return $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
    } ElseIf ($Pretty -eq $true -And $Time -eq $false) {
        # Only Pretty was specified
        return $dateTime.ToString("yyyy-MM-dd")
    } ElseIf ($Pretty -eq $false -And $Time -eq $true) {
        # Only Time was specified
        return $dateTime.ToString("yyyyMMddHHmmss")
    } Else {
        # Neither Pretty or Time were specified
        return $dateTime.ToString("yyyyMMdd")
    }
}

Function Get-OZOChildWriteTime {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the newest or oldest write time for all files within a given path. Returns the newest write time when executed with no parameters.
        .PARAMETER Oldest
        Return the oldest date time.
        .PARAMETER Path
        The path to inspect. Defaults to the current directory. If Path is invalid or inaccessible, the script returns a datetime object representing 1970-01-01 00:00:00.
        .EXAMPLE
        Get-OZOChildWriteTime -Path (Join-Path -Path $Env:USERPROFILE -ChildPath "Git")
        Saturday, February 15, 2025 17:44:45
        .EXAMPLE
        Get-OZOChildWriteTime -Path (Join-Path -Path $Env:USERPROFILE -ChildPath "Git") -Oldest
        Friday, February 9, 2024 18:03:56
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOChildWriteTime.md
    #>
    param(
        [Parameter(Mandatory=$false,HelpMessage="Include punctuation and spacing")][Switch]$Oldest,
        [Parameter(Mandatory=$false,HelpMessage="The path to inspect")][String]$Path = (Get-Location)
        
    )
    # Get datetime objects
    [DateTime] $newestChildWriteTime = (Get-Date -Year 1970 -Month 01 -Day 01 -Hour 00 -Minute 00 -Second 00)
    [DateTime] $oldestChildWriteTime = (Get-Date)
    # Determine if the path is valid
    If ((Test-OZOPath -Path $Path) -eq $true) {
        # Iterate through the children of the path
        ForEach ($childItem in (Get-ChildItem -Recurse -Path $Path)) {
            # Determine if the write time is newer than the current newestChildWriteTime
            If ($childItem.LastWriteTime -gt $newestChildWriteTime) {
                # Write time is newer; update newestChildWriteTime
                $newestChildWriteTime = $childItem.LastWriteTime
            }
            # Determine if the write time is older than the current oldestChildWriteTime
            If ($childItem.LastWriteTime -lt $oldestChildWriteTIme) {
                # Write time is older; update oldestChildWriteTime
                $oldestChildWriteTime = $childItem.LastWriteTime
            }
        }
        # Determine if Oldest was specified
        If ($Oldest -eq $true) {
            # Oldest was specified; return with oldestChildWriteTime
            return $oldestChildWriteTime
        } Else {
            # Oldest was not specified; return with newestChildWriteTime
            return $newestChildWriteTime
        }
    } Else {
        # Path is invalid; return datetime object representing 1970-01-01 00:00:00
        return $newestChildWriteTime
    }
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOFileToBase64.md
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documenation/Get-OZOHostname.md
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZONumberIsOdd.md
    #>
    # Parameters
    param (
        [Parameter(Mandatory=$true,HelpMessage="The number to evaluate",ValueFromPipeline=$true)][Int32]$Number
    )
    # Return
    return [Boolean]($Number%2)
}

Function Get-OZOUserInteractive {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns TRUE if the PowerShell session is user-interactive and FALSE if not.
        .EXAMPLE
        Get-OZOUserInteractive
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOUserInteractive.md
    #>
    return [System.Environment]::UserInteractive
}

Function New-OZOSecurePassword {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns a secure string (password).
        .PARAMETER CharacterCount
        The total number of characters in the string. Defaults to 16.
        .PARAMETER SpecialsCount
        The number of special characters. If you do not specify this parameter, or if you specify a value that is higher than the total number of characters, the secure string will contain 2 special characters.
        .EXAMPLE
        New-OZOSecurePassword
        z?p/1zD-d(:Xd[R|
        .EXAMPLE
        New-OZOSecurePassword -CharacterCount 64 -SpecialsCount 16
        t.kgL@yoBv+f68oYEGVRTpBTZ{>.:qQ=RABH/F%X1g*U6]rX|2|KWErZ@b#m{i$o
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/New-OZOSecurePassword.md

    #>
    param(
        [Parameter(Mandatory=$false,HelpMessage="The number of characters in the string")][Int16]$CharacterCount = 16,
        [Parameter(Mandatory=$false,HelpMessage="The number of special characters")][Int16]$SpecialsCount = 2
    )
    # Load the required assembly
    [Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
    # Determine if SpecialsCount is greater than or equal to CharacterCount; and if yes, set it to 2
    If ($SpecialsCount -ge $CharacterCount) { $SpecialsCount = 2}
    # return the secure string
    return [System.Web.Security.Membership]::GeneratePassword($CharacterCount,$SpecialsCount)
}

Function Send-OZOMail {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Sends an email message using an anonymous, unencrypted SMTP relay. Returns TRUE on success and FALSE on failure.
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
        A comma-separated list of file paths to attach. If a file is not found or cannot be read, the message will not be sent.
        .PARAMETER MailServer
        The SMTP relay server to use.
        .OUTPUTS
        System.Boolean
        .EXAMPLE
        Send-OZOMail -To "OZO Info <info@onezeroone.dev>" -From "OZO Noreply <noreply@onezeroone.dev" -Subject "Test" -Body "This is a test." -MailServer "smtp.onezerone.dev"
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Send-OZOMail.md

    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="A list of message recipients")][Array]$To,
        [Parameter(Mandatory=$false,HelpMessage="A list of additional recipients")][Array]$Cc = $null,
        [Parameter(Mandatory=$false,HelpMessage="A list of additional [hidden] recipients")][Array]$Bcc = $null,
        [Parameter(Mandatory=$true,HelpMessage="The message sender")][String]$From,
        [Parameter(Mandatory=$true,HelpMessage="The message subject")][String]$Subject,
        [Parameter(Mandatory=$true,HelpMessage="The message body.")][String]$Body,
        [Parameter(Mandatory=$false,HelpMessage="A list of files to attach")][Array]$Attachments = $null,
        [Parameter(Mandatory=$true,HelpMessage="The SMTP relay server to use")][String]$MailServer
    )
    # Variables
    [Boolean] $Return   = $true
    [Boolean] $Send     = $true
    [Int16]   $MailPort = 25
    # Determine that we can reach the SMTP server on port 25
    If ((Test-NetConnection -ComputerName $MailServer -Port $MailPort) -eq $true) {
        # Reached SMTP server on port 25
        # Construct a mail message object
        $ozoMail = New-Object Net.Mail.MailMessage
        # Add the To recipients
        ForEach ($Recipient in $To) { $ozoMail.To.Add($Recipient)}
        # Add the From sender
        $ozoMail.From = $From
        # Add the Subject
        $ozoMail.Subject = $Subject
        # Add the Body
        $ozoMail.Body = $Body
        # Add the Cc recipients (if any)
        If ($null -ne $Cc) {ForEach ($Recipient in $Cc) { $ozoMail.CC.Add($Receipient)}}
        # Add the Bcc recipients (if any)
        If ($null -ne $Bcc) {ForEach ($Recipient in $Bcc) { $ozoMail.Bcc.Add($Recipient)}}
        # Add the Attachments (if any)
        If ($null -ne $Attachments) {
            # Iterate through the attachments
            ForEach ($Path in $Attachments) {
                If ((Test-Path -Path (Resolve-Path -Path $Path)) -eq $true) {
                    $ozoMail.Attachments.Add((New-Object Net.Mail.Attachment((Resolve-Path -Path $Path))))
                } Else {
                    $Send = $false
                }
            }
        }
        # Determine if Send is true (all prerequisites satisfied)
        If ($Send -eq $true) {
            # Establish an SMTP connection
            $ozoSMTP = New-Object Net.Mail.SmtpClient($MailServer,$MailPort)
            # Attempt to send the message
            Try {
                $ozoSMTP.Send($ozoMail)
                # Success
            } Catch {
                # Failure
                $Return = $false
            }
        }
    } Else {
        # Unable to reach mail server
        $Return = $false
    }
    # Return
    return $Return
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Set-OZOBase64ToFile.md
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

Function Test-OZOLocalAdministrator {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns TRUE if the current user is a local administrator and FALSE if not.
        .EXAMPLE
        Test-OZOLocalAdministrator
        True
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Test-OZOLocalAdministrator.md
    #>
    return (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
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
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Test-OZOPath.md
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

Export-ModuleMember -Function Get-OZO64BitPowerShell,Get-OZO8601Date,Get-OZOChildWriteTime,Get-OZOFileToBase64,Get-OZOHostname,Get-OZONumberIsOdd,Get-OZOUserInteractive,New-OZOSecurePassword,Send-OZOMail,Set-OZOBase64ToFile,Test-OZOLocalAdministrator,Test-OZOPath
