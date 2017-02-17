#!/bin/sh

# Release checklist
#
# 0. Check on DBApp, Chime, Paper. Run analyzer.
# 1. Make sure test data is reset
# 2. Run generator
# 3. Check pod spec lint
# 4. Check test project, run unit tests
# 5. Increment version
# 6. Update Carthage example project
# 7. Push to CocoaPods
#

cat TestObjectiveDropbox/IntegrationTests/TestData.m

# python generate_base_client.py

# pod spec lint
