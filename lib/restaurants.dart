import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<List<Restaurant>> fetchRestaurants() async {
  stdout.writeln("getting restaurants");
  var response = await http.get('https://www.turkulaiset.fi/lounas/');
  if (response.statusCode == 200) {
    var document = parse(response.body);
    var rows = document
        .getElementsByClassName("lounaspaikat")[0]
        .getElementsByTagName("tr");
    stdout.writeln(rows);
    List<Restaurant> restaurants = new List();
    for (var row in rows) {
      if (row.className.toLowerCase() == "lisarivi") {
        continue;
      }
      var name = row.getElementsByTagName("td")[1].text;
      var address =
          row.getElementsByTagName("td")[2].text.replaceAll("kartta", "");
      stdout.writeln("Restaurant name " + name + " address: " + address);
      restaurants.add(new Restaurant(name, address));
    }
    stdout.writeln(
        "Added " + restaurants.length.toString() + " restaurants to list");
    return restaurants;
  } else {
    throw Exception('Failed to load restaurants');
  }
}

List<Restaurant> drawRestaurants(List<Restaurant> restaurants, int results) {
  final _random = new Random();
  List<Restaurant> resultRestaurants = new List();
  int counter = 0;
  while (counter < results) {
    resultRestaurants.add(restaurants[_random.nextInt(restaurants.length)]);
    counter++;
  }
  return resultRestaurants;
}

class Restaurant {
  String name;
  String address;
  Restaurant(this.name, this.address);
}
