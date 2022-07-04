#!/bin/sh

#  ci_post_clone.sh
#  XcodeCloudDemo
#
#  Created by Artem Kvasnetskyi on 08.06.2022.
#

# Install CocoaPods using Homebrew.
brew install cocoapods

# Install dependencies you manage with CocoaPods.
pod install

# Set app icon to project
if [[ -n $CI_XCODE_BUILD_ACTION = 'archive' ]];
then
    echo "Setting App Icon"
    APP_ICON_PATH=$CI_WORKSPACE/Resources/Assets.xcassets/AppIcon.appiconset
    
    rm -rf $APP_ICON_PATH
    
    mv "$CI_WORKSPACE/ci_scripts/AppIcon.appiconset" $APP_ICON_PATH
fi
