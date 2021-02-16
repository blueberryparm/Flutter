# Using a Platform to Power Flutter Apps

## With the use of Flutter, you can build for both Android as well as iOS. It uses the Dart programming language to do so. However, Dart does not compile to Android's Dalvik bytecode or Objective C bindings on iOS. This indicates that Dart code, by default, does not have direct access to platform-specific APIs.

## Here are a few sets of examples where deeper integration with the host environment might be needed:

## Applications using camera capabilities and geo-tagging features 
## Reading device information, such as an OS version and device specifications
## Reading folders and files from the device 
## Pushing notifications to the app  
## Sharing information with other applications
## Location tracking
## Using sensors
## Using persisted preferences

## The list continues as per the support provided by the environment. Using Flutter, enabling the calling of platform-specific APIs, which are available in Java/Kotlin code on Android, Objective C, or Swift on iOS, is not a difficult task.

## We will cover the following topics in this chapter:

## Using Flutter packages
## Using platform channels
## Building and publishing your own plugin