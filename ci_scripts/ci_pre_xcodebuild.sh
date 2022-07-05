#!/bin/sh

#  ci_pre_xcodebuild.sh
#  XcodeCloudDemo
#
#  Created by Artem Kvasnetskyi on 04.07.2022.
#  

# Set app icon to project
if [[ $CI_XCODEBUILD_ACTION = 'archive' ]];
then
    echo "Setting App Icon"
    APP_ICON_PATH=$CI_WORKSHPACE/Resources/Assets.xcassets/AppIcon.appiconset

    # Remove existing app icon
    rm -rf $APP_ICON_PATH
    
    # Add new icon set
    mv "$CI_WORKSPACE/ci_scripts/AppIcon-Beta.appiconset" $APP_ICON_PATH
fi
