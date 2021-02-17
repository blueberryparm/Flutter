# Adding BLoCs to Firestore Client App Pages

## In this chapter, you'll continue to edit and complete the mood journaling app you've worked on in Chapters 14 and 15. For your convenience, you can use the ch15_final_journal project as your starting point and make sure you add your GoogleService‐Info.plist file to the Xcode project and the google‐services.json file to the Android project that you downloaded in Chapter 14 from your Firebase console.

## You'll learn how to apply the BLoC, service, provider, model, and utility classes to the UI widget pages. The benefit of using the BLoC pattern allows for separation of the UI widgets from the business logic. You'll learn how to use dependency injection to inject service classes into the BLoC classes. By using dependency injection, the BLoCs remain platform‐agnostic.

## You'll also learn how to apply app‐wide state management by implementing the AuthenticationBlocProvider class to the main page. You'll learn how to pass state between pages and the widget tree by implementing the HomeBlocProvider and JournalEditBlocProvider classes. You'll learn how to create a Login page that implements the LoginBloc class to validate emails, passwords, and user credentials. You'll modify the home page and learn how to implement the HomeBloc class to handle the journal entries list and add and delete individual entries. You'll learn how to create the journal edit page that implements the JournalEditBloc class to add, modify, and save existing entries.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How to pass app‐wide state management between pages
### How to apply local‐state management in the widget tree
### How to apply the InheritedWidget as a provider to pass state between widgets and pages
### How to use dependency injection to inject service classes to the BLoC classes to achieve platform independence
### How to apply the LoginBloc class to the Login page
### How to apply the AuthenticationBloc class to manage user credentials for app‐wide state management
### How to apply the HomeBloc class to the home page to list, add, and delete journal entries
### How to apply the JournalEditBloc to the journal edit page to add or modify an existing entry
### How to build reactive widgets by implementing the StreamBuilder widget
### How to use the ListView.separated constructor to build a list of journal entries with a divider line by using the Divider() widget
### How to use the Dismissible widget to swipe and delete an entry
### How to use the Dismissible widget confirmDismiss property to prompt a delete confirmation dialog
### How to use the DropdownButton() widget to present a list of moods with the title, color, and icon rotation
### How to apply the MoodIcons class to retrieve the mood title, color, rotation, and icon
### How to apply the Matrix4 rotateZ() method to rotate icons according to the mood in conjunction with the MoodIcons class
### How to apply the FormatDates class to format dates