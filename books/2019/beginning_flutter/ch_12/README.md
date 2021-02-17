# Writing Platform‐Native Code

## Platform channels give you the ability to use native features such as accessing the device information, GPS location, local notifications, local file system, sharing, and many more. In the “External Packages” section of Chapter 2, “Creating a Hello World App,” you learned how to use third‐party packages to add functionality to your apps. In this chapter, instead of relying on third‐party packages, you'll learn how to add custom functionality to your apps by using platform channels and writing the API code yourself. You'll build an app that asks the iOS and Android platforms to return the device information.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How to use platform channels to send and receive messages from the Flutter app to iOS and Android to access specific API functionality
### How to write native platform code in iOS Swift and Android Kotlin to access device information
### How to use MethodChannel to send messages from the Flutter app (on the client side)
### How to use FlutterMethodChannel on iOS and MethodChannel on Android to receive calls and send back results (on the host side)