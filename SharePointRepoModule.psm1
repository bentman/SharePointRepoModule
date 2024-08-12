# SharePointRepoModule.psm1

<#
.SYNOPSIS
    SharePoint Repository Module for PowerShell Scripts
.DESCRIPTION
    This module provides a set of functions to interact with a SharePoint folder
    used as a PowerShell script repository. It allows users to connect to the 
    repository, list scripts, download scripts, and register the repository as 
    a trusted source.
.NOTES
    Version:        1.0
    Creation Date:  2024-08-09
    Copyright (c) 2023 https://github.com/bentman
    https://github.com/bentman/PoSh-ScriptRepo/SharePointRepoModule
.EXAMPLE
    Import-Module SharePointRepoModule
    connect-repo -Url "https://yourcompany.sharepoint.com/sites/yoursite/Shared Documents/ScriptRepository"
#>

# Module-wide variables
$script:repoUrl = $null
$script:headers = @{
    "Accept"       = "application/json;odata=verbose"
    "Content-Type" = "application/json;odata=verbose"
}

# Set $Url to team repo
$Url = "https://yourcompany.sharepoint.com/sites/teamsite/Shared Documents/ScriptRepository"

function Connect-SharePointRepo {
    [CmdletBinding()]
    param ( [Parameter(Mandatory = $true)] [string]$Url )

    $script:repoUrl = $Url
    $script:webUrl = $Url.Substring(0, $Url.IndexOf("/_api/web"))
    Connect-SPOService -Url $webUrl
    Write-Host "Connected to SharePoint repo: $Url"
    Show-RepoCommands
}

function Get-SharePointRepoScripts {
    [CmdletBinding()]
    param()

    if (-not $script:repoUrl) {
        Write-Error "Not connected to a SharePoint repo. Use Connect-SharePointRepo first."
        return
    }
    $listUrl = "$script:repoUrl/_api/web/GetFolderByServerRelativeUrl('$($script:repoUrl.Split('/')[-1])')/Files"
    $files = Invoke-RestMethod -Uri $listUrl -Headers $script:headers -Method Get
    $files.d.results | Select-Object Name, ServerRelativeUrl
}

function Get-SharePointRepoScript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [string]$ScriptName,
        [Parameter(Mandatory = $true)] [string]$LocalPath
    )

    if (-not $script:repoUrl) {
        Write-Error "Not connected to a SharePoint repo. Use Connect-SharePointRepo first."
        return
    }
    $fileUrl = "$script:repoUrl/$ScriptName"
    Invoke-RestMethod -Uri $fileUrl -Headers $script:headers -Method Get -OutFile $LocalPath
    Write-Host "Downloaded $ScriptName to $LocalPath"
}

function Register-SharePointRepoAsTrusted {
    [CmdletBinding()]
    param()

    if (-not $script:repoUrl) {
        Write-Error "Not connected to a SharePoint repo. Use Connect-SharePointRepo first."
        return
    }
    if (-not (Get-Module -ListAvailable -Name PowerShellGet -ea 0)) {
        try { Install-Module -Name PowerShellGet -Force -AllowClobber }
        catch { $_.Exception.Message }
    }
    $repoName = "SharePointScriptRepo"
    Register-PSRepository -Name $repoName -SourceLocation $script:repoUrl -InstallationPolicy Trusted
    Write-Host "Registered $script:repoUrl as a trusted script repository named $repoName"
}

function Show-RepoCommands {
    [CmdletBinding()]
    param()

    Write-Host "Available SharePoint Repo Commands:"
    Write-Host "------------------------------------"
    Write-Host "connect-repo      : Connect to the SharePoint repo"
    Write-Host "trust-repo        : Register the repo as a trusted source"
    Write-Host "list-reposcripts  : List all scripts in the repo"
    Write-Host "get-reposcript    : Download a script from the repo"
    Write-Host "help-repo         : Show this help message"
}

# Create aliases
New-Alias -Name trust-repo -Value Register-SharePointRepoAsTrusted -Description 'Register the repo as a trusted source' -ea 0
New-Alias -Name connect-repo -Value Connect-SharePointRepo -Description 'Connect to the SharePoint repo' -ea 0
New-Alias -Name list-reposcripts -Value Get-SharePointRepoScripts -Description 'List all scripts in the repo' -ea 0
New-Alias -Name get-reposcript -Value Get-SharePointRepoScript -Description 'Download a script from the repo' -ea 0
New-Alias -Name help-repo -Value Show-RepoCommands -Description 'Show this help message' -ea 0

# Export functions and aliases
Export-ModuleMember -Function Connect-SharePointRepo, Get-SharePointRepoScripts, Get-SharePointRepoScript, Register-SharePointRepoAsTrusted, Show-RepoCommands
Export-ModuleMember -Alias connect-repo, list-reposcripts, get-reposcript, trust-repo, help-repo
