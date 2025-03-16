# Check if the script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch the script with admin rights
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AppData\Roaming\.emacs.d\init.el" -Target "$env:USERPROFILE\Workspace\dotfiles\.emacs.d\init.el" -Force