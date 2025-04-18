function RunBackend {
    param (
        [string]$BackendPath
    )

    if (-not (Test-Path -Path $BackendPath)) {
        Write-Host "Backend directory does not exist: $BackendPath"
        exit
    }

    Set-Location -Path $BackendPath

    if (-not (Test-Path -Path "run.py")) {
        Write-Host "Backend entry file 'run.py' not found in: $BackendPath"
        exit
    }

    Write-Host "Starting backend..."
    python run.py
}

function RunFrontend {
    param (
        [string]$FrontendPath
    )

    if (-not (Test-Path -Path $FrontendPath)) {
        Write-Host "Frontend directory does not exist: $FrontendPath"
        return
    }

    Set-Location -Path $FrontendPath

    if (-not (Test-Path -Path "package.json")) {
        Write-Host "Frontend entry file 'package.json' not found in: $FrontendPath"
        return
    }

    Write-Host "Installing frontend dependencies..."
    npm install

    Write-Host "Starting frontend..."
    npm run dev
}