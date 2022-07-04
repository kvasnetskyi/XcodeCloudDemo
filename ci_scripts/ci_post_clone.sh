#!/bin/sh

#  ci_post_clone.sh
#  XcodeCloudDemo
#
#  Created by Artem Kvasnetskyi on 08.06.2022.
#

# Install CocoaPods using Homebrew.
brew install cocoapods

echo $CI_WORKSPACE

# Install dependencies you manage with CocoaPods.
pod install
