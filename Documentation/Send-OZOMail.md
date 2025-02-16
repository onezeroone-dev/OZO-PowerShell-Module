# Send-OZOMail
This function is part of the [OZO PowerShell Module](https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/README.md).

## Description
Sends an email message using an anonymous, unencrypted SMTP relay. Returns TRUE on success and FALSE on failure.

## Syntax
```
Send-OZOMail.md
    -To          <Array>
    -Cc          <Array>
    -Bcc         <Array>
    -From        <String>
    -Subject     <String>
    -Body        <String>
    -Attachments <Array>
    -MailServer  <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`To`|A comma-separated list of message recipients. You must supply at least one recipient. You may supply a simple email address e.g., "noreply@onezeroone.dev" or you can use the "One Zero One Noreply <noreply@onezeroone.dev>" syntax for "prettier" headers.|
|`Cc`|A comma-separated list of additional recipients. Addresses may be formatted as described in the "To" parameter.|
|`Bcc`|A comma-separated list of additional [hidden] recipients. Addresses may be formatted as described in the "To" parameter.|
|`From`|The message sender. Addresses may be formatted as described in the "To" parameter.|
|`Subject`|The message subject.|
|`Body`|The message body.|
|`Attachments`|A comma-separated list of file paths to attach. If a file is not found or cannot be read, the message will not be sent.|
|`MailServer`|The SMTP relay server to use.
|

## Examples
`````powershell
Send-OZOMail -To "OZO Info <info@onezeroone.dev>" -From "OZO Noreply <noreply@onezeroone.dev" -Subject "Test" -Body "This is a test." -MailServer "smtp.onezerone.dev"
True
`````

## Outputs
`System.Boolean`
