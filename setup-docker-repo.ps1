# Docker Hub Repository Setup Helper Script (PowerShell)
# This script helps troubleshoot and set up Docker Hub repositories

Write-Host "=== Docker Hub Repository Setup Helper ===" -ForegroundColor Green
Write-Host ""

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker first." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Get current user's Docker Hub username
Write-Host "Current Docker Hub username:" -ForegroundColor Yellow
try {
    $username = docker info | Select-String "Username"
    if ($username) {
        Write-Host $username.Line -ForegroundColor Cyan
    } else {
        Write-Host "Not logged in to Docker Hub" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Not logged in to Docker Hub" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Troubleshooting Steps ===" -ForegroundColor Green
Write-Host ""

Write-Host "1. **Check if you're logged in to Docker Hub:**" -ForegroundColor Yellow
Write-Host "   docker login" -ForegroundColor White
Write-Host ""

Write-Host "2. **Create the repository on Docker Hub:**" -ForegroundColor Yellow
Write-Host "   - Go to https://hub.docker.com/" -ForegroundColor White
Write-Host "   - Click 'Create Repository'" -ForegroundColor White
Write-Host "   - Name it 'mock-api'" -ForegroundColor White
Write-Host "   - Choose visibility (public or private)" -ForegroundColor White
Write-Host ""

Write-Host "3. **Update the Jenkinsfile with your actual username:**" -ForegroundColor Yellow
Write-Host "   Replace 'your-username' in the IMAGE variable with your actual Docker Hub username" -ForegroundColor White
Write-Host ""

Write-Host "4. **Test the push manually:**" -ForegroundColor Yellow
Write-Host "   docker build -t your-username/mock-api:test ." -ForegroundColor White
Write-Host "   docker push your-username/mock-api:test" -ForegroundColor White
Write-Host ""

Write-Host "5. **Common issues and solutions:**" -ForegroundColor Yellow
Write-Host "   - Repository doesn't exist: Create it on Docker Hub first" -ForegroundColor White
Write-Host "   - Permission denied: Make sure you own the repository or have write access" -ForegroundColor White
Write-Host "   - Wrong namespace: Use your own username, not 'bmc' unless you have access" -ForegroundColor White
Write-Host ""

Write-Host "6. **For organization repositories:**" -ForegroundColor Yellow
Write-Host "   - Use: organization-name/mock-api" -ForegroundColor White
Write-Host "   - Make sure you have push permissions to the organization" -ForegroundColor White
Write-Host ""

Write-Host "=== Current Jenkins Configuration ===" -ForegroundColor Green
Write-Host ""

# Check if Jenkinsfile exists and show current image name
if (Test-Path "Jenkinsfile") {
    Write-Host "Current image name in Jenkinsfile:" -ForegroundColor Yellow
    $imageLine = Get-Content "Jenkinsfile" | Select-String "IMAGE = "
    if ($imageLine) {
        Write-Host $imageLine.Line -ForegroundColor Cyan
    } else {
        Write-Host "IMAGE variable not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Jenkinsfile not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Green
Write-Host "1. Update the IMAGE variable in Jenkinsfile with your actual Docker Hub username" -ForegroundColor White
Write-Host "2. Create the repository on Docker Hub if it doesn't exist" -ForegroundColor White
Write-Host "3. Ensure your Jenkins credentials have the correct Docker Hub username/password" -ForegroundColor White
Write-Host "4. Test the push manually before running the Jenkins pipeline" -ForegroundColor White
