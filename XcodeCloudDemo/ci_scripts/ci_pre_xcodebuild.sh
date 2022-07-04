#!/bin/sh

#  ci_pre_xcodebuild.sh
#  XcodeCloudDemo
#
#  Created by Artem Kvasnetskyi on 04.07.2022.
#  

# Set app icon to project
if [[ -n $CI_XCODEBUILD_ACTION = 'archive' ]];
then
    echo "Setting App Icon"
    APP_ICON_PATH=$CI_WORKSPACE/Resources/Assets.xcassets/AppIcon.appiconset
    
    rm -rf $APP_ICON_PATH
    
    mv "$CI_WORKSPACE/ci_scripts/AppIcon.appiconset" $APP_ICON_PATH
fi
