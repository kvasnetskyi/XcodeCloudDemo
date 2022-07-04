#!/bin/sh

#  ci_post_clone.sh
#  XcodeCloudDemo
#
#  Created by Artem Kvasnetskyi on 08.06.2022.
#

# Install CocoaPods using Homebrew.
# brew install --cask cocoapods

# Install dependencies you manage with CocoaPods.
# pod install

cd ..
 
echo ">>> SETUP ENVIRONMENT"
echo 'export GEM_HOME=$HOME/gems' >>~/.bash_profile
echo 'export PATH=$HOME/gems/bin:$PATH' >>~/.bash_profile
export GEM_HOME=$HOME/gems
export PATH="$GEM_HOME/bin:$PATH"
 
echo ">>> INSTALL BUNDLER"
gem install bundler --install-dir $GEM_HOME
 
echo ">>> INSTALL DEPENDENCIES"
bundle install
 
echo ">>> INSTALL PODS"
bundle exec pod install
