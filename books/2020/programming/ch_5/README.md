# Network and Storage I/O and Navigation

## Writing apps that are isolated to the user’s own phone is fine for some applications, but a great majority of apps need to interact with a web API or back end, which is what we’ll be doing in this chapter.

## Flutter’s standard library doesn’t include a standard networking component: even though you can actually use the network to fetch images, you can’t make standard HTTP requests using just the Flutter/Dart standard library.

## This is the reason why we are going to talk about it now: Flutter has a Google-developed package on Pub called http, which allows us to make HTTP requests and connect our app to a Web API.