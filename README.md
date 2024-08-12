# SharePointRepoModule

SharePointRepoModule is a PowerShell module that simplifies interaction with a SharePoint folder used as a PowerShell script repository. 
It provides functions to connect to the repository, list scripts, download scripts, and register the repository as a trusted source.

## Features

- Connect to a SharePoint repository
- List available scripts in the repository
- Download scripts from the repository
- Register the repository as a trusted source
- User-friendly aliases for common operations

## Installation

1. Clone this repository or download the `SharePointRepoModule.psm1` file.
2. Place the file in a folder named `SharePointRepoModule` in your PowerShell modules directory.
3. Import the module in your PowerShell session:

```powershell
Import-Module SharePointRepoModule
```

## Usage

Connect to the default SharePoint repository (Set $repoUrl team team repo in module.psm1):
```powershell
connect-repo
```

Or connect to a specific SharePoint repository:
```powershell
connect-repo -Url "https://yourcompany.sharepoint.com/sites/yoursite/Shared Documents/ScriptRepository"
```

List available commands:
```powershell
help-repo
```

List scripts in the repository:
```powershell
list-reposcripts
```

Download a script:
```powershell
get-reposcript -ScriptName "MyScript.ps1" -LocalPath "C:\LocalScripts\MyScript.ps1"
```

Register the repository as a trusted source:
```powershell
trust-repo
```

## Available Commands

- `connect-repo`: Connect to the SharePoint repo
- `trust-repo`: Register the repo as a trusted source
- `list-reposcripts`: List all scripts in the repo
- `get-reposcript`: Download a script from the repo
- `help-repo`: Show help message

## Notes

- Version: 1.0
- Creation Date: 2024-08-09
- Copyright (c) 2023 https://github.com/bentman
- https://github.com/bentman/PoSh-ScriptRepo/SharePointRepoModule

### GNU General Public License
This script is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This script is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this script.  If not, see <https://www.gnu.org/licenses/>.
