<#
.SYNOPSIS
Runs standalone smoke tests for the OZO PowerShell module.

.DESCRIPTION
Imports the module from this repository and verifies its exported functions without requiring Pester or contacting an SMTP server.

.EXAMPLE
.\Tests\ozo-tests.ps1
#>
[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"
$script:Passed = 0
$script:Skipped = 0
$script:Failures = @()

Function Assert-Equal {
    Param(
        [Parameter(Mandatory=$true)][AllowNull()][Object]$Expected,
        [Parameter(Mandatory=$true)][AllowNull()][Object]$Actual,
        [Parameter(Mandatory=$true)][String]$Message
    )
    If ($null -eq $Expected -And $null -eq $Actual) { return }
    If ($null -eq $Expected -Or $null -eq $Actual -Or $Expected -ne $Actual) {
        throw "$Message Expected '$Expected'; received '$Actual'."
    }
}

Function Assert-SequenceEqual {
    Param(
        [Parameter(Mandatory=$true)][Object[]]$Expected,
        [Parameter(Mandatory=$true)][Object[]]$Actual,
        [Parameter(Mandatory=$true)][String]$Message
    )
    If ($Expected.Count -ne $Actual.Count) {
        throw "$Message Expected $($Expected.Count) items; received $($Actual.Count)."
    }
    For ($Index = 0; $Index -lt $Expected.Count; $Index++) {
        Assert-Equal -Expected $Expected[$Index] -Actual $Actual[$Index] -Message $Message
    }
}

Function Assert-Matches {
    Param(
        [Parameter(Mandatory=$true)][String]$Pattern,
        [Parameter(Mandatory=$true)][String]$Actual,
        [Parameter(Mandatory=$true)][String]$Message
    )
    If (-not [System.Text.RegularExpressions.Regex]::IsMatch($Actual,$Pattern)) {
        throw "$Message Value '$Actual' did not match '$Pattern'."
    }
}

Function Assert-Throws {
    Param(
        [Parameter(Mandatory=$true)][ScriptBlock]$ScriptBlock,
        [Parameter(Mandatory=$true)][String]$Message
    )
    $Threw = $false
    Try {
        & $ScriptBlock | Out-Null
    } Catch {
        $Threw = $true
    }
    If (-not $Threw) { throw $Message }
}

Function Invoke-TestCase {
    Param(
        [Parameter(Mandatory=$true)][String]$Name,
        [Parameter(Mandatory=$true)][ScriptBlock]$Test
    )
    Try {
        $null = & $Test
        $script:Passed++
        Write-Host "[PASS] $Name" -ForegroundColor Green
    } Catch {
        $script:Failures += "$Name`: $($_.Exception.Message)"
        Write-Host "[FAIL] $Name`: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Function Skip-TestCase {
    Param([Parameter(Mandatory=$true)][String]$Name)
    $script:Skipped++
    Write-Host "[SKIP] $Name" -ForegroundColor Yellow
}

Function Invoke-MockedYesNo {
    Param([Parameter(Mandatory=$true)][AllowEmptyString()][String[]]$Responses)
    & $script:ModuleInfo {
        Param([AllowEmptyString()][String[]]$InputResponses)
        $script:OZOTestReadHostResponses = $InputResponses
        $script:OZOTestReadHostIndex = 0
        Function Read-Host {
            $script:OZOTestReadHostIndex++
            If ($script:OZOTestReadHostIndex -gt $script:OZOTestReadHostResponses.Count) {
                throw "Get-OZOYesNo requested more input than the test supplied."
            }
            return $script:OZOTestReadHostResponses[$script:OZOTestReadHostIndex - 1]
        }
        Try {
            Get-OZOYesNo
        } Finally {
            Remove-Item Function:\Read-Host -ErrorAction SilentlyContinue
            Remove-Variable -Name OZOTestReadHostResponses,OZOTestReadHostIndex -Scope Script -ErrorAction SilentlyContinue
        }
    } $Responses
}

Function Invoke-MockedMail {
    Param(
        [Parameter(Mandatory=$true)][Boolean]$TcpTestSucceeded,
        [Parameter(Mandatory=$false)][String[]]$Attachments = @()
    )
    & $script:ModuleInfo {
        Param(
            [Boolean]$MockTcpTestSucceeded,
            [String[]]$MockAttachments
        )
        $script:OZOTestTcpTestSucceeded = $MockTcpTestSucceeded
        Function Test-NetConnection {
            [PSCustomObject]@{ TcpTestSucceeded = $script:OZOTestTcpTestSucceeded }
        }
        Try {
            $MailArguments = @{
                To = @("to@example.com")
                Cc = @("cc@example.com")
                Bcc = @("bcc@example.com")
                From = "from@example.com"
                Subject = "OZO test"
                Body = "This message is never sent by this test."
                MailServer = "mail.example.com"
                ErrorAction = "SilentlyContinue"
            }
            If ($MockAttachments.Count -gt 0) {
                $MailArguments.Attachments = $MockAttachments
            }
            Send-OZOMail @MailArguments
        } Finally {
            Remove-Item Function:\Test-NetConnection -ErrorAction SilentlyContinue
            Remove-Variable -Name OZOTestTcpTestSucceeded -Scope Script -ErrorAction SilentlyContinue
        }
    } $TcpTestSucceeded $Attachments
}

$RepositoryRoot = Split-Path -Path $PSScriptRoot -Parent
$ModulePath = Join-Path -Path $RepositoryRoot -ChildPath "OZO\OZO.psd1"
If (-not (Test-Path -LiteralPath $ModulePath -PathType Leaf)) {
    throw "Module manifest was not found at '$ModulePath'."
}
$ModulePath = (Resolve-Path -LiteralPath $ModulePath).Path
$Manifest = Import-PowerShellDataFile -Path $ModulePath
$script:ModuleInfo = Import-Module -Name $ModulePath -Force -PassThru -ErrorAction Stop

Invoke-TestCase -Name "Manifest exports match imported commands" -Test {
    $ExpectedFunctions = @($Manifest.FunctionsToExport | Sort-Object)
    $ActualFunctions = @(Get-Command -Module $script:ModuleInfo.Name -CommandType Function |
        ForEach-Object { $_.Name } | Sort-Object)
    Assert-SequenceEqual -Expected $ExpectedFunctions -Actual $ActualFunctions -Message "Exported function list mismatch."
}

Invoke-TestCase -Name "Get-OZO64BitPowerShell" -Test {
    Assert-Equal -Expected ([System.Environment]::Is64BitProcess) -Actual (Get-OZO64BitPowerShell) -Message "Incorrect process bitness."
}

Invoke-TestCase -Name "Get-OZO8601Date formats" -Test {
    Assert-Matches -Pattern '^\d{8}$' -Actual (Get-OZO8601Date) -Message "Basic date format is incorrect."
    Assert-Matches -Pattern '^\d{4}-\d{2}-\d{2}$' -Actual (Get-OZO8601Date -Pretty) -Message "Pretty date format is incorrect."
    Assert-Matches -Pattern '^\d{14}$' -Actual (Get-OZO8601Date -Time) -Message "Basic date-time format is incorrect."
    Assert-Matches -Pattern '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' -Actual (Get-OZO8601Date -Pretty -Time) -Message "Pretty date-time format is incorrect."
}

Invoke-TestCase -Name "Get-OZOHostname" -Test {
    Assert-Equal -Expected "example" -Actual (Get-OZOHostname -FQDN "example.contoso.com") -Message "FQDN parsing failed."
    $Hostnames = @("alpha.example","beta.example" | Get-OZOHostname)
    Assert-SequenceEqual -Expected @("alpha","beta") -Actual $Hostnames -Message "Hostname pipeline results are incorrect."
    Assert-Equal -Expected $env:COMPUTERNAME -Actual (Get-OZOHostname) -Message "Local hostname result is incorrect."
}

Invoke-TestCase -Name "Get-OZONumberIsOdd" -Test {
    Assert-Equal -Expected $true -Actual (Get-OZONumberIsOdd -Number 5) -Message "Positive odd number check failed."
    Assert-Equal -Expected $false -Actual (Get-OZONumberIsOdd -Number 4) -Message "Even number check failed."
    Assert-Equal -Expected $true -Actual (Get-OZONumberIsOdd -Number -3) -Message "Negative odd number check failed."
    $OddResults = @(5,4,3 | Get-OZONumberIsOdd)
    Assert-SequenceEqual -Expected @($true,$false,$true) -Actual $OddResults -Message "Number pipeline results are incorrect."
}

Invoke-TestCase -Name "Get-OZOUserInteractive" -Test {
    Assert-Equal -Expected ([System.Environment]::UserInteractive) -Actual (Get-OZOUserInteractive) -Message "Interactive-session result is incorrect."
}

Invoke-TestCase -Name "Get-OZOSecureRandomIndex" -Test {
    $Generator = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    Try {
        Assert-Equal -Expected 0 -Actual (Get-OZOSecureRandomIndex -UpperBound 1 -Generator $Generator) -Message "An upper bound of one must return zero."
        For ($Index = 0; $Index -lt 100; $Index++) {
            $RandomIndex = Get-OZOSecureRandomIndex -UpperBound 10 -Generator $Generator
            If ($RandomIndex -lt 0 -Or $RandomIndex -ge 10) {
                throw "Random index '$RandomIndex' was outside the range 0-9."
            }
        }
    } Finally {
        $Generator.Dispose()
    }
    Assert-Throws -ScriptBlock {
        $Generator = [System.Security.Cryptography.RandomNumberGenerator]::Create()
        Try {
            Get-OZOSecureRandomIndex -UpperBound 0 -Generator $Generator
        } Finally {
            $Generator.Dispose()
        }
    } -Message "An upper bound of zero was not rejected."
}

Invoke-TestCase -Name "Get-OZOYesNo retries empty input and normalizes answers" -Test {
    Assert-Equal -Expected "y" -Actual (Invoke-MockedYesNo -Responses @("","   ","Yes")) -Message "Empty-input retry or yes normalization failed."
    Assert-Equal -Expected "n" -Actual (Invoke-MockedYesNo -Responses @("N")) -Message "No normalization failed."
}

Invoke-TestCase -Name "New-OZOSecurePassword length, character set, and special count" -Test {
    $Cases = @(
        @{ Length = 2; Specials = 2 },
        @{ Length = 16; Specials = 2 },
        @{ Length = 64; Specials = 16 },
        @{ Length = 32; Specials = 0 }
    )
    $AllowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{};:,.?/"
    ForEach ($Case in $Cases) {
        $Password = New-OZOSecurePassword -CharacterCount $Case.Length -SpecialsCount $Case.Specials
        Assert-Equal -Expected $Case.Length -Actual $Password.Length -Message "Password length is incorrect."
        $SpecialCount = 0
        ForEach ($Character in $Password.ToCharArray()) {
            If ($AllowedCharacters.IndexOf($Character) -lt 0) {
                throw "Password contains unsupported character '$Character'."
            }
            If (-not [Char]::IsLetterOrDigit($Character)) { $SpecialCount++ }
        }
        Assert-Equal -Expected $Case.Specials -Actual $SpecialCount -Message "Password special-character count is incorrect."
    }
    Assert-Throws -ScriptBlock { New-OZOSecurePassword -CharacterCount 1 } -Message "CharacterCount below two was not rejected."
    Assert-Throws -ScriptBlock { New-OZOSecurePassword -CharacterCount 4 -SpecialsCount 5 } -Message "SpecialsCount above CharacterCount was not rejected."
}

Invoke-TestCase -Name "Send-OZOMail handles unreachable server and missing attachment" -Test {
    $UnreachableResult = Invoke-MockedMail -TcpTestSucceeded $false
    Assert-Equal -Expected $false -Actual $UnreachableResult -Message "Unreachable SMTP server did not return False."

    $MissingAttachment = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "OZO-$([Guid]::NewGuid().ToString('N')).missing"
    $AttachmentResult = Invoke-MockedMail -TcpTestSucceeded $true -Attachments @($MissingAttachment)
    Assert-Equal -Expected $false -Actual $AttachmentResult -Message "Missing attachment did not return False."
}

If ($env:OS -eq "Windows_NT") {
    Invoke-TestCase -Name "Test-OZOLocalAdministrator" -Test {
        $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $Principal = New-Object System.Security.Principal.WindowsPrincipal($Identity)
        $Expected = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
        Assert-Equal -Expected $Expected -Actual (Test-OZOLocalAdministrator) -Message "Administrator-role result is incorrect."
    }
} Else {
    Skip-TestCase -Name "Test-OZOLocalAdministrator (Windows only)"
}

Write-Host ""
Write-Host "Results: $script:Passed passed, $($script:Failures.Count) failed, $script:Skipped skipped."
If ($script:Failures.Count -gt 0) {
    $script:Failures | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}
