void main() {
 print('Hello, Dart!');
 ['World', 'Mars', 'Oregon', 'Barry', 'David Bowie',].forEach((name) => print('${helloDart(name)}'));
}

String helloDart(String name) => 'Hello $name';