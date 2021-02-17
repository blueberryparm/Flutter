# Adding the Firebase and Firestore Backend

## n this chapter, in Chapter 15, and in Chapter 16, you'll use techniques that you have learned in previous chapters along with new concepts and tie them together to create a production‐level mood‐journaling app. In the previous chapters, you created many projects that taught you different ways to implement specific tasks and objectives. In a production‐level app, you need to combine what you have learned to improve performance by redrawing only the widgets with data changes, pass state between pages and up the widget tree, handle the user authentication credentials, sync data between devices and the cloud, and create classes that handle platform‐independent logic between mobile and web apps.

## Because Google has open‐sourced Flutter support for desktop and web apps, the Firebase backend services can be used for Flutter desktop and web apps, not just mobile. That's why in this chapter you'll learn how to develop a production‐level mobile app.

## Specifically, you'll learn how to use authentication and persist data to a cloud database by using Google's Firebase (backend server infrastructure), Firebase Authentication, and Cloud Firestore. You'll learn how to create and set up a Firebase project using Cloud Firestore as the cloud database. Cloud Firestore is a NoSQL document database to store, query, and sync data with offline support for mobile and web apps. Did I say offline? Yes, I did. The ability of a mobile app to function while an Internet connection is not available is a must‐have feature that users expect. Another great feature of using Cloud Firestore is the ability to synchronize live data between devices automatically. The data syncing is fast, allowing collaboration between different devices and users. The amazing part of using these powerful features is that you don't have to deal with setting up and managing the server's infrastructure. This feature allows you to build serverless applications.

## You'll configure the Firebase backend authentication provider, database, and security rules to sync data between multiple devices and platforms. To enable authentication and database services for the client‐side Flutter project, you'll add the firebase_auth and cloud_firestore packages. In Chapter 15 and Chapter 16 you'll learn how to implement app‐wide and local state management by using the InheritedWidget class and maximize platform code sharing by implementing the Business Logic Component pattern. You'll use app‐wide and local state management to request data from different service classes.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How to create a Firebase project
### How to register the iOS and Android projects to use Firebase
### How to add a Cloud Firestore database
### How to structure and create a data model for the Cloud Firestore database
### How to enable and add Firebase authentication
### How to create Firestore security rules
### How to create the Flutter client app base structure
### How to add Firebase to iOS and how to add the Android projects with the Google service files
### How to add the Firebase and Cloud Firestore packages
### How to add the intl package to format dates
### How to customize the AppBar and BottomAppBar look and feel by using the BoxDecoration and LinearGradient widgets