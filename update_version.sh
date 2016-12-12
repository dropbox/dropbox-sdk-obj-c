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
user_agent=./Source/ObjectiveDropboxOfficial/Shared/Handwritten/Networking/DBTransportClientBase.m
ios_version=Source/ObjectiveDropboxOfficial/ObjectiveDropboxOfficial_iOS/Info.plist
mac_version=Source/ObjectiveDropboxOfficial/ObjectiveDropboxOfficial_macOS/Info.plist

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
cat $podspec | grep $1
echo

echo "Replacing README version number..."
sed -i '' -E "s/~> $version_regex/~> $1/" $readme
cat $readme | grep $1
echo

echo "Replacing User Agent version number..."
sed -i '' -E "s/kVersion = @\"$version_regex\";/kVersion = @\"$1\";/" $user_agent
cat $user_agent | grep $1
echo

echo "Replacing iOS xcodeproj version number..."
sed -i '' -E "s/$version_regex/$1/" $ios_version
cat $ios_version | grep $1
echo

echo "Replacing macOS xcodeproj version number..."
sed -i '' -E "s/$version_regex/$1/" $mac_version
cat $mac_version | grep $1
echo
