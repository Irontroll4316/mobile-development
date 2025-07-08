import 'dart:math';

Future<void> main() async
{
  await countdown(5);
  print("Done");
}

List<T> where<T>(List<T> items, bool Function(T) f)
{
    var results = <T>[];
    for (var item in items)
    {
      if (f(item))
      {
        results.add(item);
      }
    }
    return results;
}

T firstWhere<T>(List<T> items, bool Function(T) f, {required T Function() orElse})
{
  for (var item in items)
  {
    if (f(item))
    {
      return item;
    }
  }
  return orElse(); 
}

class Person
{
  Person({
    required this.name,
    required this.age,
  });
  final String name;
  final int age;

  void printDescription()
  {
    print("My name is ${this.name}. I'm ${this.age} years old.");
  }

  factory Person.fromJson(Map<String, Object> json)
  {
    final name = json['name'];
    final age = json['age'];
    if (name is String && age is int)
    {
      return Person(name: name, age: age);
    }
    else {throw StateError('Name or age is of the wrong type');}
  }
  Map<String, Object> toJson() => 
  {
    'name' : name,
    'age' : age,
  };
}

class Resturant
{
  const Resturant({
    required this.name,
    required this.cuisine,
    required this.ratings,
  });

  final String name;
  final String cuisine;
  final List<double> ratings;

  int get numRatings => ratings.length;
  double averageRatings()
  {
    if (ratings.isEmpty)
    {
      return 0;
    }
    return ratings.reduce((value, element) => value + element) / ratings.length;
  }
}

abstract class Shape
{
  double get area;
  double get perimeter;

  void printValues()
  {
    print(this.area);
    print(this.perimeter);
  }
}

class Square extends Shape
{
  Square(this.side);
  final double side;

  @override
  double get area => side * side;
  @override
  double get perimeter => 4 * side;
}

class Circle extends Shape
{
  Circle(this.radius);
  final double radius;

  @override
  double get area => pi * radius * radius;
  @override
  double get perimeter => 2 * pi * radius;
}

class Point
{
  const Point(this.x, this.y);
  final int x;
  final int y;

  @override
  String toString() => 'Point($x, $y)';
  @override
  bool operator ==(covariant Point other)
  {
    return x == other.x && y == other.y;
  }

  Point operator +(covariant Point other)
  {
    return Point(x + other.x, y + other.y);
  }

  Point operator *(covariant int other)
  {
    return Point(x * other, y * other);
  }
}

extension Range on int
{
  List<int> rangeTo(int other)
  {
    if (other < this)
    {
      return [];
    }
    var list = [this];
    for (var i = this + 1; i <= other; i++)
    {
      list.add(i);
    }
    return list;
  }
}

class EmailAddress
{
  EmailAddress(this.email)
  {
    if (email.isEmpty || !email.contains('@'))
    {
      throw FormatException('Email must contain @ character');
    }
  }
  final String email;
  @override
  String toString() => "$email";
}

Future<void> countdown(int n) async
{
  for (var i = n; i >= 0; i--)
  {
    await Future.delayed(Duration(seconds: 1), () => print(i));
  }
}