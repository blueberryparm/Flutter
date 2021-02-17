# journal

## The mood‐journal app is to have the ability to list, add, and modify journal entries by collecting a date, a mood, a note, and the user's ID.

## There's a login page to authenticate users through the email/password Firebase Authentication sign‐in provider.

## The main presentation page implements a ListView widget by using the separated constructor sorted by DESC (descending) date, meaning last entered record first. The ListTile widget easily formats how you'll display the List of records.

## The journal entry page uses the showDatePicker widget to select a date from a calendar, a DropdownButton widget to select from a list of moods, and a TextField widget to enter the note.

## Persist and secure data over app launches by using Google's Firebase, Firebase Authentication, and Cloud Firestore. Firebase is the infrastructure that doesn't require the developer to set up or maintain backend servers. The Firebase platform allows you to connect and share data between iOS, Android, and web apps.