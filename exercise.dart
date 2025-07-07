void main()
{
  final sarah = Person(name: "Sarah", age: 36, height: 5.8);
  final elias = Person(name: "Elias", age: 22, height: 6.1);

  sarah.printDescription();
  elias.printDescription();
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
    required this.height
  });
  final String name;
  final int age;
  final double height;

  void printDescription()
  {
    print("My name is ${this.name}. I'm ${this.age} years old, I'm ${this.height} feet tall.");
  }
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