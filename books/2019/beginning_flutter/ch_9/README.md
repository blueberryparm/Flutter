# Creating Scrolling Lists and Effects

## In this chapter, you'll learn to create scrolling lists that help users view and select information. You'll start with the Card widget in this chapter because it is commonly used in conjunction with list‐capable widgets to enhance the user interface (UI) and group data. In the previous chapter, you took a look at using the basic constructor for the ListView, and in this chapter, you'll use the ListView.builder to customize the data. The GridView widget is a fantastic widget that displays a list of data by a fixed number of tiles (groups of data) in the cross axis. The Stack widget is commonly used to overlap, position, and align widgets to create a custom look. A good example is a shopping cart with the number of items to purchase on the upper‐right side.

## The CustomScrollView widget allows you to create custom scrolling effects by using a list of slivers widgets. Slivers are handy, for instance, if you have a journal entry with an image on the top of the page and the diary description below. When the user swipes to read more, the description scrolling is faster than the image scrolling, creating a parallax effect.

## WHAT YOU WILL LEARN IN THIS CHAPTER

### How Card is a great way to group information with the container having rounded corners and a drop shadow
### How to build a linear list of scrollable widgets with ListView
### How to display tiles of scrollable widgets in a grid format with GridView
### How Stack lets you overlap, position, and align its children widgets
### How to create custom scrolling effects using CustomScrollView and slivers