function ForkAndClone {
    param (
        [string]$BoilerplateRepoUrl,
        [string]$ProjectName,
        [string]$GitHubUser
    )

    Write-Host "Forking boilerplate repository..."

    # Extract the repository owner and name from the URL
    $RepoParts = $BoilerplateRepoUrl -split "/"
    $RepoOwner = $RepoParts[-2]
    $RepoName = $RepoParts[-1].Replace(".git", "")

    # Fork the repository using GitHub CLI
    gh repo fork "$RepoOwner/$RepoName" --clone=false
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to fork the repository. Ensure GitHub CLI is installed and configured."
        exit
    }

    # Clone the forked repository to the project directory
    $ForkedRepoUrl = "https://github.com/$GitHubUser/$RepoName.git"
    git clone $ForkedRepoUrl $ProjectName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Cloned forked repository to: $PWD\$ProjectName"
    } else {
        Write-Host "Failed to clone forked repository."
        exit
    }

    # Navigate into the project directory and set the upstream remote
    Push-Location $ProjectName
    git remote add upstream $BoilerplateRepoUrl
    Write-Host "Upstream set to original repository: $BoilerplateRepoUrl"
    Pop-Location
}

function CloneBoilerplate {
    param (
        [string]$BoilerplateRepoUrl,
        [string]$TargetPath
    )

    if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
        Write-Host "Git is not installed or not available in PATH."
        exit
    }

    if (-not (Test-Path -Path $TargetPath)) {
        git clone $BoilerplateRepoUrl $TargetPath | Out-Null
        Write-Host "Cloned boilerplate repository to: $TargetPath"
    } else {
        Write-Host "Target project folder already exists: $TargetPath"
        exit
    }
}

function InitializeGit {
    param (
        [string]$TargetPath,
        [string]$ProjectName
    )

    Set-Location -Path $TargetPath
    Remove-Item -Recurse -Force -Path ".git" | Out-Null
    git init | Out-Null
    git add . | Out-Null
    git commit -m "Initial commit for $ProjectName" | Out-Null
    Write-Host "Reinitialized Git repository."
}

function CreateGitHubRepo {
    param (
        [string]$GitHubUser,
        [string]$ProjectName,
        [string]$TargetPath
    )

    if (-not (Get-Command "gh" -ErrorAction SilentlyContinue)) {
        Write-Host "The GitHub CLI ('gh') is not installed or not available in PATH. Please install it."
        exit
    }

    $AuthStatus = & gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "You are not logged into GitHub CLI. Starting login process..."
        & gh auth login
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to authenticate with GitHub. Please retry login manually using 'gh auth login'."
            exit
        }
        Write-Host "GitHub authentication successful."
    }

    $RepoName = $ProjectName -replace " ", "-"
    $CreateRepoCommand = "gh repo create $GitHubUser/$RepoName --public"
    Invoke-Expression -Command $CreateRepoCommand
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create GitHub repository. Please check your GitHub CLI configuration."
        exit
    }
    Write-Host "Created GitHub repository: $GitHubUser/$RepoName"

    git remote add origin "https://github.com/$GitHubUser/$RepoName.git"
    git branch -M main
    git push -u origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to push changes to GitHub. Please check your repository settings."
        exit
    }
    Write-Host "Pushed initial commit to GitHub."
}

function CreateProject {
    param (
        [string]$ProjectName,
        [string]$GitHubUser,
        [string]$BoilerplateRepoUrl
    )

    $ScriptDirectory = Get-Location
    $TargetPath = Join-Path -Path $ScriptDirectory -ChildPath $ProjectName

    CloneBoilerplate -BoilerplateRepoUrl $BoilerplateRepoUrl -TargetPath $TargetPath
    #ForkAndClone -BoilerplateRepoUrl $BoilerplateRepoUrl -TargetPath $TargetPath
    InitializeGit -TargetPath $TargetPath -ProjectName $ProjectName
    CreateGitHubRepo -GitHubUser $GitHubUser -ProjectName $ProjectName -TargetPath $TargetPath

    Write-Host "Project setup complete. You can start coding in $TargetPath"
    Set-Location -Path $ScriptDirectory
}
