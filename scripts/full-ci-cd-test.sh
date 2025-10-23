#!/bin/bash

echo "🎯 FULL CI/CD TEST EXECUTION"
echo "============================"

# Test 1: Basic validation
echo -e "\n1. Validating YAML files..."
yamllint -c .yamllint.yml .github/workflows/ && echo "✅ YAML Validation: PASS"

# Test 2: Dry run semua workflows
echo -e "\n2. Dry run semua workflows..."
act --container-architecture linux/amd64 -n && echo "✅ Dry Run: PASS"

# Test 3: Test CI workflow dengan real execution
echo -e "\n3. Testing CI workflow (real execution)..."
time act --container-architecture linux/amd64 -W .github/workflows/ci.yml push --quiet
CI_EXIT=$?
[ $CI_EXIT -eq 0 ] && echo "✅ CI Workflow: PASS" || echo "❌ CI Workflow: FAIL"

# Test 4: Test CD workflow dengan real execution
echo -e "\n4. Testing CD workflow (real execution)..."
time act --container-architecture linux/amd64 -W .github/workflows/cd.yml push --quiet
CD_EXIT=$?
[ $CD_EXIT -eq 0 ] && echo "✅ CD Workflow: PASS" || echo "❌ CD Workflow: FAIL"

# Test 5: Verify project structure
echo -e "\n5. Verifying project structure..."
[ -f "package.json" ] && echo "✅ package.json: EXISTS" || echo "❌ package.json: MISSING"
[ -f ".github/workflows/ci.yml" ] && echo "✅ ci.yml: EXISTS" || echo "❌ ci.yml: MISSING"
[ -f ".github/workflows/cd.yml" ] && echo "✅ cd.yml: EXISTS" || echo "❌ cd.yml: MISSING"

# Final summary
echo -e "\n📊 FINAL TEST SUMMARY"
echo "===================="
if [ $CI_EXIT -eq 0 ] && [ $CD_EXIT -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED! CI/CD setup is working correctly."
    echo "🚀 Ready to push to GitHub!"
else
    echo "⚠️  Some tests failed. Check the output above."
    echo "Exit codes - CI: $CI_EXIT, CD: $CD_EXIT"
fi
