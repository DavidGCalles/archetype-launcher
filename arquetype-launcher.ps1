param (
    [string]$Order,
    [string]$ProjectName,
    [string]$GitHubUser,
    [switch]$FrontToo,  # Boolean switch for frontend setup
    [string]$BackendBoilerplateRepoUrl = "https://github.com/DavidGCalles/Back-Arquetipo.git",
    [string]$FrontendBoilerplateRepoUrl = "https://github.com/DavidGCalles/Front-Arquetipo.git"
)

# Import helper functions
. "$PSScriptRoot\helpers-creation.ps1"

if (-not $Order) {
    Write-Host "Please provide an order using -Order (create or run)"
    exit
}

switch ($Order) {
    "create" {
        if (-not $ProjectName) {
            Write-Host "Please provide a project name using -ProjectName"
            exit
        }

        if (-not $GitHubUser) {
            Write-Host "Please provide a GitHub username using -GitHubUser"
            exit
        }

        

        # If FrontToo is enabled, create Frontend Project
        if ($FrontToo) {
            $FrontendProjectName = "front-$ProjectName"
            CreateProject -ProjectName $FrontendProjectName -GitHubUser $GitHubUser -BoilerplateRepoUrl $FrontendBoilerplateRepoUrl
        }

        # Create Backend Project
        $BackendProjectName = "back-$ProjectName"
        CreateProject -ProjectName $BackendProjectName -GitHubUser $GitHubUser -BoilerplateRepoUrl $BackendBoilerplateRepoUrl
    }

    "run" {
        if (-not $ProjectName) {
        Write-Host "Please provide a project name using -ProjectName"
        exit
        }

        # Define paths for backend and frontend
        $BackendPath = Join-Path -Path (Get-Location) -ChildPath $ProjectName
        $FrontendPath = Join-Path -Path (Get-Location) -ChildPath "front-$ProjectName"

        # Import helper functions
        . "$PSScriptRoot\helpers-run.ps1"

        # Run backend
        RunBackend -BackendPath $BackendPath

        # Run frontend if it exists
        RunFrontend -FrontendPath $FrontendPath
    }

    default {
        Write-Host "Invalid order provided. Use 'create' or 'run'."
    }
}
