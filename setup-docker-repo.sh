#!/bin/bash

# Docker Hub Repository Setup Helper Script
# This script helps troubleshoot and set up Docker Hub repositories

echo "=== Docker Hub Repository Setup Helper ==="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Get current user's Docker Hub username
echo "Current Docker Hub username:"
docker info | grep Username || echo "Not logged in to Docker Hub"
echo ""

echo "=== Troubleshooting Steps ==="
echo ""

echo "1. **Check if you're logged in to Docker Hub:**"
echo "   docker login"
echo ""

echo "2. **Create the repository on Docker Hub:**"
echo "   - Go to https://hub.docker.com/"
echo "   - Click 'Create Repository'"
echo "   - Name it 'mock-api'"
echo "   - Choose visibility (public or private)"
echo ""

echo "3. **Update the Jenkinsfile with your actual username:**"
echo "   Replace 'your-username' in the IMAGE variable with your actual Docker Hub username"
echo ""

echo "4. **Test the push manually:**"
echo "   docker build -t your-username/mock-api:test ."
echo "   docker push your-username/mock-api:test"
echo ""

echo "5. **Common issues and solutions:**"
echo "   - Repository doesn't exist: Create it on Docker Hub first"
echo "   - Permission denied: Make sure you own the repository or have write access"
echo "   - Wrong namespace: Use your own username, not 'bmc' unless you have access"
echo ""

echo "6. **For organization repositories:**"
echo "   - Use: organization-name/mock-api"
echo "   - Make sure you have push permissions to the organization"
echo ""

echo "=== Current Jenkins Configuration ==="
echo ""

# Check if Jenkinsfile exists and show current image name
if [ -f "Jenkinsfile" ]; then
    echo "Current image name in Jenkinsfile:"
    grep "IMAGE = " Jenkinsfile || echo "IMAGE variable not found"
else
    echo "❌ Jenkinsfile not found"
fi

echo ""
echo "=== Next Steps ==="
echo "1. Update the IMAGE variable in Jenkinsfile with your actual Docker Hub username"
echo "2. Create the repository on Docker Hub if it doesn't exist"
echo "3. Ensure your Jenkins credentials have the correct Docker Hub username/password"
echo "4. Test the push manually before running the Jenkins pipeline"
