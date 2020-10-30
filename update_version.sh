#!/bin/sh

# Script for updating ObjectiveDropboxOfficial version number

echo

if [ "$#" -ne 1 ]; then
    echo "Requires 1 parameter. Usage: \`./update_version <VERSION>\`"
    exit 1
fi

arg_version_regex="^[0-9]+\.[0-9]+\.[0-9]+$"
version_regex="[0-9]+\.[0-9]+\.[0-9]+"

podspec=./ObjectiveDropboxOfficial.podspec
readme=./README.md
user_agent=Source/ObjectiveDropboxOfficial/Shared/Handwritten/Resources/DBSDKConstants.m
ios_version=Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_iOS/Info.plist
mac_version=Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_macOS/Info.plist

if ! [[ $1 =~ $arg_version_regex ]]; then
    echo "\"$1\" version string must have format x.x.x"
    exit 1
else
    echo "Updating SDK text to version \"$1\""
fi

echo
echo

echo "Replacing podspec version number..."
sed -i '' -E "s/s.version      = '$version_regex'/s.version      = '$1'/" $podspec
echo '--------------------'
cat $podspec | grep $1
echo '--------------------'
echo

echo "Replacing README version number..."
sed -i '' -E "s/~> $version_regex/~> $1/" $readme
echo '--------------------'
cat $readme | grep $1
echo '--------------------'
echo

echo "Replacing User Agent version number..."
sed -i '' -E "s/kDBSDKVersion = @\"$version_regex\";/kDBSDKVersion = @\"$1\";/" $user_agent
echo '--------------------'
cat $user_agent | grep $1
echo '--------------------'
echo

echo "Replacing iOS xcodeproj version number..."
sed -i '' -E "s/$version_regex/$1/" $ios_version
echo '--------------------'
cat $ios_version | grep $1
echo '--------------------'
echo

echo "Replacing macOS xcodeproj version number..."
sed -i '' -E "s/$version_regex/$1/" $mac_version
echo '--------------------'
cat $mac_version | grep $1
echo '--------------------'
echo
echo
echo "Committing changes and tagging commit."
git commit -am "$1 release."
git tag "$1"
echo
echo "Changes ready for review and push"
echo
