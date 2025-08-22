param(
    [string]$CommitMessage
)

# Function to check if we're in a git repository
function Test-GitRepository {
    try {
        git rev-parse --git-dir 2>$null
        return $?
    }
    catch {
        return $false
    }
}

# Check if we're in a git repository
if (-not (Test-GitRepository)) {
    Write-Host "Error: Not in a git repository!" -ForegroundColor Red
    Write-Host "Please run this script from within a git repository directory." -ForegroundColor Yellow
    exit 1
}

# Get commit message if not provided as parameter
if ([string]::IsNullOrEmpty($CommitMessage)) {
    $CommitMessage = Read-Host "Enter commit message"
    
    # Check if user provided a message
    if ([string]::IsNullOrEmpty($CommitMessage)) {
        Write-Host "Error: Commit message cannot be empty!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Starting git operations..." -ForegroundColor Green
Write-Host "Commit message: '$CommitMessage'" -ForegroundColor Cyan

try {
    # Step 1: git add .
    Write-Host "`n1. Adding all changes..." -ForegroundColor Yellow
    git add .
    if ($LASTEXITCODE -ne 0) {
        throw "git add failed"
    }
    Write-Host "✓ Changes added successfully" -ForegroundColor Green

    # Step 2: git commit
    Write-Host "`n2. Committing changes..." -ForegroundColor Yellow
    git commit -m "$CommitMessage"
    if ($LASTEXITCODE -ne 0) {
        throw "git commit failed"
    }
    Write-Host "✓ Changes committed successfully" -ForegroundColor Green

    # Step 3: git push
    Write-Host "`n3. Pushing to remote..." -ForegroundColor Yellow
    git push
    if ($LASTEXITCODE -ne 0) {
        throw "git push failed"
    }
    Write-Host "✓ Changes pushed successfully" -ForegroundColor Green

    Write-Host "`n🎉 All operations completed successfully!" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Git operations failed. Please check the error above." -ForegroundColor Yellow
    exit 1
}