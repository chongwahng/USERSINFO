#!/bin/bash

# Prerequisites:
# - Cloud Foundry trial account on SAP Cloud Platform with 
#   entitlement for Business Rules service and application runtime
# - Build tool 'mbt' installed globally
# - cf CLI installed with the 'multiapps' plugin installed
# - cf CLI already authenticated against the CF endpoint

# Recommended:
# - Role collection containing RuleRepositorySuperUser and
#   RuleRuntimeSuperUser assigned tothe trial account user

clear
# Show current CF target
echo Deploying to:
cf target
cd $HOME/projects
pwd
# Create an instance of the service, with the free 'lite' service plan, called businessrules
# (reason for the name is because that's how it's referred to in the mta.yaml to come). If the
# service instance 'businessrules' already exists it won't be re-created.
#cf create-service business-rules lite businessrules

# Download the project containing the multi target application descriptor for the rules editor
# (see https://bit.ly/handsonsapdev#ep44 for background).
rm -rf archive.zip editor/
curl -o archive.zip -s https://raw.githubusercontent.com/SAP-samples/cloud-businessrules-samples/master/cf-apps/cf-businessruleseditor.zip
unzip -q -d editor ./archive.zip

# Kick off the build - this should produce an archive in mta_archives/ directory.
cd $HOME/projects/editor
mbt build

# Deploy the archive
#cf deploy mta_archives/businessruleseditor_0.0.1.mtar