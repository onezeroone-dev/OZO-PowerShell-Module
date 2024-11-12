# OZO PowerShell Module Development Prerequisites
## NuGet
Make sure nuget.exe is [up to date](https://github.com/PowerShell/PowerShellGetv2/issues/303).
```powershell
Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
```
## PowerShellGet
Make sure the latest PowerShellGet [is installed](https://github.com/PowerShell/PowerShellGetv2/issues/288).
```powershell
Update-Module -Name PowerShellGet
``` 
