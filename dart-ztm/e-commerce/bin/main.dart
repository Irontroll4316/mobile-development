import "dart:io";
import '../lib/product.dart';
import '../lib/cart.dart';

const allProducts = 
[
  Product(id: 1, name: 'apples', price: 1.60),
  Product(id: 2, name: 'bananas', price: 0.70),
  Product(id: 3, name: 'courgettes', price: 1.00),
  Product(id: 4, name: 'grapes', price: 2.00),
  Product(id: 5, name: 'mushrooms', price: 0.80),
  Product(id: 6, name: 'potatoes', price: 1.50),
];

void main()
{
  final cart = Cart();
  while(true)
  {
    stdout.write("Would you like to (v)iew you cart, (a)dd an item, or (c)heckout? ");
    final response = stdin.readLineSync();
    if (response == 'v')
    {
      print(cart);
    } else if (response == 'a')
    {
      final product = chooseProduct();
      if (product != null)
      {
        cart.addProduct(product);
        print(cart);
      }
    } else if (response == 'c')
    {
      if (checkout(cart))
      {
        break;
      }
    } else 
    {
      print("Invalid Response! Try again!");
    }
  }
}

Product? chooseProduct()
{
  final productsList = allProducts.map((product) => product.displayName).join('\n'); 
  stdout.write("Available Products\n$productsList\nYour Choice: ");
  final choice = stdin.readLineSync();
  for (var product in allProducts)
  {
    if (product.initial == choice)
    {
      return product;
    }
  }
  print("Not Found");
  return null;
}

bool checkout(Cart cart)
{
  if (cart.isEmpty)
  {
    print("Cart is empty");
    return false;
  }
  final total = cart.total();
  print("Total: \$$total");
  stdout.write("Payment in cash: ");
  final input = stdin.readLineSync();
  if (input == null || input.isEmpty)
  {
    return false;
  }
  final paid = double.tryParse(input);
  if (paid == null)
  {
    return false;
  }
  if (paid >= total)
  {
    final change = paid - total;
    print("Change: \$${change.toStringAsFixed(2)}");
    return true;
  } else 
  {
    print("Not enough cash");
    return false;
  }
}