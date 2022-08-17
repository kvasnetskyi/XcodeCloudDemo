# Xcode Cloud Demo

You can find more information in the [presentation](https://github.com/kvasnetskyi/XcodeCloudDemo/files/9364705/XcodeCloud.Report.pdf) and [video](https://chiswdevelopment.sharepoint.com/:v:/s/iOSteam/Ea0OjsaRnQtBr0K09ORfVV4BfDqPPZQ8ZdRZSF9Qk_ZfcA?e=lBbF3h).

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Connection](#connection)
4. [Workflow](#workflow)
5. [Dependencies](#dependencies)
6. [Ignore Changes](#ignore-changes)
7. [Build Number](#build-number)
8. [Webhooks](#webhooks)
9. [Disconnecting the project from Xcode Cloud](#disconnecting-the-project-from-xcode-cloud)

# Overview
Xcode Cloud is a CI/CD built into Xcode and designed specifically for Apple developers. It combines Xcode, TestFlight and App Store Connect.

**It unlocks features such as:**
- Automatically test apps on Apple devices in Simulator.
- Automatically submitting an app to TestFlight.
- Automatically send the app for review before publishing to the App Store.
- Access to Apple's cloud infrastructure.
- Potential bug notifications.

*This feature is available starting with Xcode 13, and is currently in beta testing.*

# Requirements
To work with Xcode Cloud you need to meet some requirements.

**Developer account requirements:**
- You must be registered with the Apple Developer Program.
- An Apple ID must be added to Xcode.
- The app must have been created in App Store Connect or you must have permission to create it.

**Project and workspace requirements:**
- The project must contain an Xcode project or workspace file.
- A shared schema must be used.
- Archiving action for the schema must be enabled.
- A [new build system](https://help.apple.com/xcode/mac/11.4/#/dev396bc94c7) must be used.
- Dependencies and libraries must be available for Xcode cloud.
- Automatic code signing must be used.

**Version control system requirements**

Xcode Cloud requires the code to be in a Git repository. In addition, you will need a specific permission or role to connect Xcode Cloud to your repository. It supports the following source control providers:
- Bitbucket Cloud and Bitbucket Server – requires the administrator role to connect.
- GitHub and GitHub Enterprise – requires the organization owner or administrator role (if the organization is not used).
- GitLab and self-managed GitLab – maintainer role required.

**You cannot connect Xcode Cloud to more than one account or instance of the same SCM provider.**

# Connection
To connect, you need:
1. **Open the project in Xcode.**

2. **Go to the Report navigation tab.**

3. **Select the Cloud tab.**

The functionality is currently in beta, so you will be redirected to the website where you need to apply for testing. If you are already approved, you can move on with a next step.

4. **Select a product.**

When you start setting up a project to use Xcode Cloud, Xcode analyses it to determine the project's settings and lists its applications and platforms, called products. You can be a member of multiple development teams, in which case Xcode asks you to select a team. After selecting a product, Xcode proposes the first workflow for the product.

5. **Configure the first workflow.**

When setting up Xcode Cloud, the first workflow includes:
- Build for each change or pull request associated with the default branch.
- Using the latest version of macOS and Xcode for a temporary environment.
- Using the archiving action.
- Sending an email with information about the build upon completion.

*You can edit the first workflow if you need.*

6. **Setting up a repository**

Xcode Cloud requires access to a Git repository with the project. It uses this access to automatically create and test code when changes are made.

You will need to go through the authorization process at your GIT provider's website. 
 
When the repository is given access and if the app is created in Appstore Connect, the first build can be run. If the app has not yet been created, Xcode Cloud will help you create it.

# Workflow
Workflow is the configuration of the steps you want to perform in Xcode Cloud.

**Workflow includes the following settings:**
- [General](#general)
- [Environment](#environment)
- [Start Condition](#start-condition)
- [Actions](#actions)
- [Post Actions](#post-actions)
- [Custom build scripts](#custom-build-scripts)

**You can add new workflows or edit, duplicate, delete and suspend existing ones from Xcode or App Store Connect.**

## General
Here you specify the main information of your workflow:
- **Name.**

- **Description.**

- **Ability to limit the people who can edit the workflow.**

If this checkbox is selected, only the Admin or App Managers of an Apple Development account can make changes to the workflow.

## Environment
This is where you specify information about the temporary build environment:
- **The versions of Xcode and macOS temporary enviroment.**

- **Disable/enable caching.**

Xcode Cloud saves the cache during build to save time for the next build. If necessary, you can select Clean to remove this cache, but it has a big impact on build time.

- **Custom Environment Variables**

You can specify custom enviroment variables, which you can later use in your custom scripts.


## Start Condition
Determine when Xcode Cloud starts a workflow.

- **Branch Changes**

Any, a specific, or several specific branches have been changed. 

- **Pull Request Changes**

A PR has been created or changed.

- **Tag Changes**

A Git tag was created or changed. 

- **On a Schedule for a Branch**

A pre-set time has elapsed.

For all conditions except "On a Schedule" you can select "Monitor or Ignore Specific Files and Folders", which can help you ignore, or alternatively, pay attention to changes if they affect:
- Any file in a specific folder.
- A specific file in any or a specific folder.
- A file with a specified extension in any folder or specific folder.

## Actions
These are the actions that will be performed when conditions are called from Start Condition.

When Xcode Cloud runs an actions it:
1. Create temporary environment.
2. Clone Git repository.
3. Resolve dependencies.
4. Run `xcodebuild` command.
5. Save artifacts.

You can choose from the following available actions:
- [Build](#build)
- [Analyse](#analyse)
- [Test](#test)
- [Archive](#archive)

### Build
When Xcode Cloud performs the build action, it accesses the source code and runs the `xcodebuild build` command to create the build product.

Once complete, Xcode Cloud makes the following artefacts available:
- build product,
- build logs,
- result bundle.

### Analyse
Analysis can help look for memory leaks or other problems.

*This step is quite time-consuming, so it is not recommended to run it regularly.*

When Xcode Cloud performs the analysis action, it accesses your source code and runs the `xcodebuild analyze` command.

### Test
The test action is performed in two separate steps:
1. `xcodebuild build-for-testing` command
In the first step, Xcode Cloud accesses the source code and runs the `xcodebuild build-for-testing` command.

2. `xcodebuild test-without-building`
In the second step, Xcode Cloud uses the build created in the first step to run your tests with the `xcodebuild test-without-building` command.

### Archive
When Xcode Cloud performs the archive action, it accesses your code and runs the `xcodebuild archive` command.

When archiving, you will need to select the destination of your archive. Possible options:
- **None**

Use this option if you are not setting up a workflow to distribute the application.

- **TestFlight (Internal Testing Only)**

The exported application archive is suitable for distribution to internal testers and developers using TestFlight.

- **TestFlight and App Store**

The exported application archive is suitable for distribution to external testers using TestFlight and for release to the App Store.

## Post Actions

Actions that take place after building.

- **Setting up custom notifications**

Xcode Cloud can send notifications to email or Slack when a build succeeds or fails.

- **Publish to TestFlight**

Xcode Cloud can distribute a new version of the application in TestFlight for both internal and external testers.

## Custom build scripts
These are your custom shell scripts with which you can extend the functionality of Xcode Cloud.

1. [Custom build scripts overview](#custom-build-scripts-overview)
2. [Creating custom build scripts](#creating-custom-build-scripts)
3. [Add resources to the CI scripts directory](#add-resources-to-the-ci-scripts-directory)
4. [Access environment variables](#access-environment-variables)
5. [Debug information](#debug-information)
6. [Write resilient scripts](#write-resilient-scripts)

### Custom build scripts overview
Xcode Cloud recognises three different types of scripts:
1. **post-clone script**

Runs after Xcode Cloud clone Git repository.

2. **pre-xcodebuild script**

Runs before Xcode Cloud run `xcodebuild` command.

3. **post-xcodebuild script**

Runs after Xcode Cloud run `xcodebuild` command.

**Important:**
- You cannot gain administrator rights using sudo.
- Files you create with scripts are not available to other scripts – Xcode Cloud deletes all files created by scripts.

### Creating custom build scripts
**To create the scripts you need:**
1. Create a folder called `ci_scripts` in the project root.
2. Create Shell Script using Xcode template without adding it to the target. 
3. Name the script depending on its type: `ci_post_clone.sh`, `ci_pre_xcodebuild.sh` or `ci_post_xcodebuild.sh`.
4. From the terminal go to the `ci_scripts` folder, and make the script executable by running the command:
```swift
chmod +x ci_post_clone.sh // or another script name
```
5. Add the script to the file, including `#!/bin/sh` first line.
6. Commit the script in the repository.

### Add resources to the CI scripts directory
Custom build scripts run in a temporary build environment where the source code may not be available. Therefore, all resources accessed by the scripts must be placed in the `ci_scripts` directory.

If you need to edit a specific file associated with your source code, you can create a symbolic link to the file in the `ci_scripts` directory.

**The script files should always be directly in the ci_scripts folder.**

### Access environment variables
Environment variables make the script as flexible as possible. You can use your own custom environment variables, for example, you can put an API key in there which will be used by the script to send logs to the server. Also, Xcode Cloud sends already prepared environment variables.

```shell
if [[ -n $CI_PULL_REQUEST_NUMBER ]];
then
    echo "This build started from a pull request"
fi
```

The list of prepared variables can be seen at [link](https://developer.apple.com/documentation/xcode/environment-variable-reference).

### Debug information
The logs from your script appear in the build report's build logs, which can be useful for debugging. But it's worth remembering that **confidential information shouldn't be logged unless it's a secret custom environment variable**. In the case of secret custom environment variables Xcode Cloud replaces it with sprocket characters in the build logs.

### Write resilient scripts
Custom build scripts can perform important tasks. You can write a script that returns a nonzero exit code if the script fails. This is how you tell Xcode Cloud that something has gone wrong and allow it to complete the build to let you know there is a problem.

```shell
#!/bin/sh

# Set the -e flag to stop running the script in case a command returns
# a nonzero exit code.
set -e

# A command or script succeeded.
echo "A command or script was successful."
exit 0

...

# Something went wrong.
echo "Something went wrong. Include helpful information here."
exit 1
```

# Dependencies
1. [Swift Packages](#swift-packages)
2. [CocoaPods and Carthage](#cocoapods-and-carthage)

## Swift Packages
Xcode Cloud supports public packages managed by Git out of the box. However, if the package is private, access to the private repository must be granted by Xcode Cloud.

In order for Xcode Cloud to allow SPM dependencies **your Package.resolved file must be committed.**

## CocoaPods and Carthage
The temporary environment does not include any third-party tools other than Homebrew.

You can use it to install CocoaPods or Carthage with `ci_post_clone` script.
```shell
#!/bin/sh
 
brew install cocoapods
 
pod install
```

Also, you can install CocoaPods using Bundler. In order to do this, you will need to:
1. Install bundler using the command `gem install bundler`.
2. Create a bundler in the project folder using the `bundler init` command.
3. Insert the following into your `Gemfile` file:
```
# frozen_string_literal: true

source "https://rubygems.org"

gem 'cocoapods'

# gem "rails"
```
4. Create a `ci_post_clone` script with the following contents:
```shell
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
```

To use Cocoapods, **your Podfile and Podfile.lock must be committed.**

# Ignore Changes
Xcode Cloud knows how to ignore certain changes in Git. To avoid triggering a workflow related to branch changes, when writing a commit comment, write `[ci skip]` at the end.

# Build Number
Xcode Cloud assigns a number to each build, starting with 1, and automatically increments it.

You may therefore have a problem when developing applications for the Mac. You need to set up the build number so that it is constantly incrementing. App Store Connect is used to solve this situation.

To set up the next build number:
1. Go to your app page on the App Store Connect.
2. Click the Xcode Cloud tab and select Settings.
3. Click the Build Number tab under Settings.
4. Click the Edit button next to Next Build Number.
5. Enter the new build number and save your changes.

**For this you need the Admin or App Manager role.**

# Webhooks
You can connect up to five custom services that can somehow react to Xcode Cloud events.

Xcode Cloud sends an HTTP request to a given endpoint every time it **creates, starts and completes a build**. In turn, the service must send an HTTP status code in response. If it returns a server error that can be repeated or Xcode Cloud does not receive a response within 30 seconds, it resends the request until it receives a successful response. What the JSON request from Xcode Cloud looks like can be seen at [link](https://developer.apple.com/documentation/xcode/configuring-webhooks-in-xcode-cloud).

**To create a webhook in Xcode Cloud you need:**
1. Go to Xcode Cloud in App Store Connect.
2. In the sidebar, select Settings > Webhooks > Add button.
3. Enter a unique name for your webhook.
4. Enter the URL of a service that can receive and handle HTTPS requests from Xcode Cloud.

# Disconnecting the project from Xcode Cloud
Disconnecting Xcode Cloud from the project takes place in three steps:
1. **Deleting data from Xcode Cloud**

In Xcode Navigator, go to Report, right-click on your app, and select Delete Xcode Cloud Data. After that, go to App Store Connect to the app you want, select Settings and click Delete Xcode Cloud Data. 

*These apps will no longer be available immediately and will be removed from the Apple system within 30 days.*

2. **Disconnecting Xcode Cloud from the repository:**
- Bitbucket Server, GitHub Enterprise, or self-managed GitLab:

Go to App Store Connect under Users and Access, select Xcode Cloud tab, hover over the SCM provider, click Remove.

- Bitbucket, GitHub, or GitLab:

Go to App Store Connect under Users and Access, select Xcode Cloud tab, select Integrations in the sidebar, click Unlink next to the SCM provider. 

Then you need to disable the Personal Access Tokens or Apps that allowed Xcode Cloud access to the repository. Disabling depends on the SCM provider. For more detailed [instructions](https://developer.apple.com/documentation/xcode/removing-your-project-from-xcode-cloud).

3. **Disconnect Xcode Cloud from Slack** *(optional)*

Open Slack workspace in the Slack app and select Settings & administration > Manage apps. Select "Apps" in the sidebar, then select the Xcode Cloud app. Click "Remove App".

Developed By
------------

* Kvasnetskyi Artem, Kosyi Vlad, CHI Software

License
--------

Copyright 2022 CHI Software.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
