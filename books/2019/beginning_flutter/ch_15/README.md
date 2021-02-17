# Adding State Management to the Firestore Client App

## In this chapter, you'll continue to edit the mood journaling app created in Chapter 14. For your convenience, you can use the ch14_final_journal project as your starting point and make sure you add your GoogleService‐Info.plist file to the Xcode project and the google‐services.json file to the Android project that you downloaded in Chapter 14 from your Firebase console.

## You'll learn how to implement app‐wide and local‐state management that uses the InheritedWidget class as a provider to manage and pass State between widgets and pages.

## You'll learn how to use the Business Logic Component (BLoC) pattern to create BLoC classes, for example managing access to the Firebase Authentication and Cloud Firestore database service classes. You'll learn how to use a reactive approach by using StreamBuilder, StreamController, and Stream to populate and refresh data.

## You'll learn how to create a service class to manage the Firebase Authentication API by implementing an abstract class that manages the user login credentials. You'll create a separate service class to handle the Cloud Firestore database API. You'll learn how to create a Journal model class to handle the mapping of the Cloud Firestore QuerySnapshot to individual records. You'll learn how to create a mood icons class to manage a list of mood icons, a description, and an icon rotation position according to the selected mood. You'll learn how to create a date formatting class using the intl package.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How to use state management to control Firebase Authentication and the Cloud Firestore database
### How to use the BLoC pattern to separate business logic
### How to use the InheritedWidget class as a provider to manage and pass state
### How to implement abstract classes
### How to use StreamBuilder to receive the latest data from Firebase Authentication and the Cloud Firestore database
### How to use StreamController, Stream, and Sink to handle Firebase Authentication and Cloud Firestore data events
### How to create service classes to handle Firebase Authentication and Cloud Firestore API calls with Stream and Future classes
### How to create a model class for individual journal entries and convert Cloud Firestore QuerySnapshot and map it to the Journal class
### How to use the optional Firestore Transaction to save data to the Firestore database
### How to create a class to handle mood icons, descriptions, and rotation
### How to create a class to handle date formatting
### How to use the ListView.separated named constructor