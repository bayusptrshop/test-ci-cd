#!/bin/bash

echo "🚀 CI/CD TEST SUITE"
echo "==================="

# Function to test workflow
test_workflow() {
    local workflow=$1
    local event=$2
    local branch=${3:-main}
    
    echo -e "\n🔍 Testing $workflow on $event ($branch)..."
    
    # Time the execution
    start_time=$(date +%s)
    
    if act --container-architecture linux/amd64 -W ".github/workflows/$workflow" "$event" -b "$branch" --quiet; then
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        echo "✅ $workflow: SUCCESS (${duration}s)"
        return 0
    else
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        echo "❌ $workflow: FAILED (${duration}s)"
        return 1
    fi
}

# Test scenarios
echo "Starting comprehensive tests..."

# Test 1: CI on main branch
test_workflow "ci.yml" "push" "main"

# Test 2: CI on develop branch  
test_workflow "ci.yml" "push" "develop"

# Test 3: CI on pull request
test_workflow "ci.yml" "pull_request" "main"

# Test 4: CD on main branch
test_workflow "cd.yml" "push" "main"

# Test 5: CD on release
test_workflow "cd.yml" "release" "main"

echo -e "\n📊 TEST SUMMARY COMPLETE"
