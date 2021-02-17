# Saving Data with Local Persistence

## In this chapter, you'll learn how to persist data—that is, save data on the device's local storage directory—across app launches by using the JSON file format and saving the file to the local iOS and Android filesystem. JavaScript Object Notation (JSON) is a common open‐standard and language‐independent file data format with the benefit of being human‐readable text. Persisting data is a two‐step process; first you use the File class to save and read data, and second, you parse the data from and to a JSON format. You'll create a class to handle saving and reading the data file that uses the File class. You'll also create a class to parse the full list of data by using json.encode and json.decode and a class to extract each record. And you'll create another class to handle passing an action and an individual journal entry between pages.

## You'll build a journal app that saves and reads JSON data to the local iOS NSDocumentDirectory and Android AppData filesystem. The app uses a ListView to display a list of journal entries sorted by date, and you'll create a data entry screen to enter a date, mood, and note.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How to persist saving and reading data locally
### How to structure data by using the JSON file format
### How to create model classes to handle JSON serialization
### How to access local iOS and Android filesystem locations using the path provider package
### How to format dates by using the internationalization package
### How to use the Future class with the showDatePicker to present a calendar to choose dates
### How to use the Future class to save, read, and parse JSON files
### How to use the ListView.separated constructor to section records with a Divider
### How to use List().sort to sort journal entries by date
### How to use textInputAction to customize keyboard actions
### How to use FocusNode and FocusScope with the keyboard onSubmitted to move the cursor to the next entry's TextField
### How to pass and receive data in a class by using the Navigator