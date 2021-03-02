# Chapter 10

## ToDo App - Leveraging the BLoC Pattern and Sembast

## Designing the structure or architecture of an app is often one of the most important problems that developers need to solve when creating or upgrading an app, especially when the complexity and size of the project grows.

## Each language has a 'favorite' pattern, such as model–view–controller (MVC), or model–view–viewmodel (MVVM). Flutter is no exception, and the pattern that Google developers are suggesting at this time is the BLoC (business logic components) pattern. There are many advantages of using BLoCs, and one of them is that they don't require any plugin, as they're already integrated into Flutter.

## For this project, we'll introduce another tool so that you can choose the best solution in different contexts—the simple embedded application store database (short for sembast).

## The following topics will be covered in this chapter:

## Using the simple embedded application store database, or sembast
## Introducing the BLoC pattern
## Using BLoCs and streams to update the UI

## The following facts when using the BLoC pattern in Flutter:

## The pipe is called a Stream.
## To control the stream, you use a StreamController.
## The way into the stream is the sink property of the StreamController.
## The way out of the stream is the stream property of the StreamController.
## In order to use the Stream and be notified when something comes out of it, you need to listen to the Stream. You define a listener with a StreamSubscription object.
## The StreamSubscription is notified every time an event related to the Stream is triggered—for example, whenever some data flows out from the stream or when there is an error.

## The BLoC guideline step by step:
## Create a class that will serve as the BLoC.
## In the class, declare the data that needs to be updated in the app (in this case, the list of Todo objects).
## Set the StreamControllers.
## Create the getters for streams and sinks.
## Add the logic of the BLoC.
## Add a constructor in which you'll set data and listen to changes.
## Set the dispose() method.
## From the UI, create an instance of the BLoC.
## Use a StreamBuilder to build the widgets that will use the BLoC data.
## Add events to the sink for any changes to the data.
## Call the dispose() method.