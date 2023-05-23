// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        image:json['image']
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  final String category;
  // final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category
    // required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      price: json['price'],
      image: json['images'][0],
      category: json['category']['name'],
    );
  }

  Map<String,dynamic> mapping(){
    return {'id':id,
      'name':name,
      'price':price,
      'category':category,
      'description':description,
      'image':image};
  }

  @override
  String toString(){
    return 'Product{id:$id,name: $name,category: $category,price: $price,description: $description,image: $image}';
  }
}


class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String avatar;
  // final bool isFavorite;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.avatar,
    // required this.isFavorite,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }

  Map<String,dynamic> mapping(){
    return {'id':id,
      'name':name,
      'email':email,
      'password':password,
      'role':role,
      'avatar':avatar};
  }

}

class productsByCategory extends StatelessWidget{
  List<Product> myList=[];
  String idCategory;
  productsByCategory({super.key,required this.myList,required this.idCategory});

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "products.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
      },
      version: 1,
    );
  }

  Future<Database> initializeDB1() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "favorites_products.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
      },
      version: 1,
    );
  }

  Future<String> insertProd(Product prod) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'products',
      prod.mapping(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 'Add correctly';
  }

  Future<String> insertProd1(Product prod) async {
    // Get a reference to the database.
    final db = await initializeDB1();

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'products',
      prod.mapping(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 'Add correctly';
  }

  Future<List<Product>> prodList() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('products');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        image: maps[i]['image'],
      );
    });
  }

  Future<List<Product>> prodList1() async {
    // Get a reference to the database.
    final db = await initializeDB1();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('products');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        image: maps[i]['image'],
      );
    });
  }
  @override
  Widget build(BuildContext context){
    List<Product> theList=[];
    for(Product prod in myList){
        if(prod.category == idCategory){
          theList.add(prod);
        }
    }
    return  Scaffold(
      appBar: AppBar(
        title: Text('Product of $idCategory'),
      ),
      body: Container(
        height: 800.0,
        child:GridView.count(
          crossAxisCount: 2,
          children:
          theList.map(
                (product) =>
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      InkWell(
                        child:
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:  <Widget>[
                                IconButton(
                                  icon:  Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.lightGreen,
                                    size: 24.0,
                                    // semanticLabel: 'Text to announce in accessibility modes',
                                  ),
                                  onPressed: (){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: FutureBuilder(
                                          future: insertProd(product),
                                          builder: (context, AsyncSnapshot<String> snapshot) {
                                            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                            if (snapshot.hasData) return Text('${snapshot.data}');
                                            return const CircularProgressIndicator();
                                          },
                                        ))
                                    );
                                  },
                                ),
                                IconButton(
                                  icon:  Icon(
                                    Icons.favorite,
                                    color: Colors.pinkAccent,
                                    size: 30.0,
                                    // semanticLabel: 'Text to announce in accessibility modes',
                                  ),
                                  onPressed: (){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: FutureBuilder(
                                          future: insertProd1(product),
                                          builder: (context, AsyncSnapshot<String> snapshot) {
                                            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                            if (snapshot.hasData) return Text('${snapshot.data}');
                                            return const CircularProgressIndicator();
                                          },
                                        ))
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:(_){return infoProducts(produ: product);}
                          )
                          );
                        },
                      )
                    ],
                  ),
                ),
          )
              .toList(),
        ),
      ),
    );
  }
}
class payment extends StatelessWidget{
  payment({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.payment_rounded),
                  Text('Moncash')
                ],
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[800])),
            ),
            ElevatedButton(onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.payment_rounded),
                  Text('Natcash')
                ],
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange[800])),
            ),
            ElevatedButton(onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.paypal),
                  Text('Paypal')
                ],
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[800])),
            ),
            ElevatedButton(onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.payment_rounded),
                  Text('Visa')
                ],
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black38)),
            ),
            ElevatedButton(onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.payment_rounded),
                  Text('MasterCard')
                ],
              ),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            ),
          ],
        ),
      )
    );
  }
}


class allCategories extends StatelessWidget{
  List<Category> myList;
  List<Product> mylist;
  allCategories({super.key,required this.myList,required this.mylist});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("All categories"),
        ),
        body:GridView.count(
          crossAxisCount: 1,
            children: myList.map((category){
              return InkWell(
                child:
                Card(
                  child:
                  Column(
                      children:[
                        Container(
                          width: 500,
                          height: 150.0,
                          child:Image.network(
                              category.image,
                              fit: BoxFit.cover),
                        ),
                        Text(category.name)
                      ]
                  ),
                ),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_){return productsByCategory(myList: mylist,idCategory: category.name,);}
                  )
                  );
                },

              );

            },
            ).toList(),
          ),
    );
  }
}

class allProducts extends StatelessWidget{
  List<Product> myList;
  allProducts({super.key,required this.myList});
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "products.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
      },
      version: 1,
    );
  }

  Future<Database> initializeDB1() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "favorites_products.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
      },
      version: 1,
    );
  }

  Future<String> insertProd(Product prod) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'products',
      prod.mapping(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 'Add correctly';
  }

  Future<String> insertProd1(Product prod) async {
    // Get a reference to the database.
    final db = await initializeDB1();

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'products',
      prod.mapping(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 'Add correctly';
  }

  Future<List<Product>> prodList() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('products');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        image: maps[i]['image'],
      );
    });
  }

  Future<List<Product>> prodList1() async {
    // Get a reference to the database.
    final db = await initializeDB1();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('products');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        image: maps[i]['image'],
      );
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("All products"),
        ),
        body:Container(
          height: 800.0,
          child:GridView.count(
            crossAxisCount: 2,
            children:
            myList.map(
                  (product) =>
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        Expanded(
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        InkWell(
                          child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${product.price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:  <Widget>[
                                  IconButton(
                                    icon:  Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.lightGreen,
                                      size: 24.0,
                                      // semanticLabel: 'Text to announce in accessibility modes',
                                    ),
                                    onPressed: (){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: FutureBuilder(
                                            future: insertProd(product),
                                            builder: (context, AsyncSnapshot<String> snapshot) {
                                              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                              if (snapshot.hasData) return Text('${snapshot.data}');
                                              return const CircularProgressIndicator();
                                            },
                                          ))
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon:  Icon(
                                      Icons.favorite,
                                      color: Colors.pinkAccent,
                                      size: 30.0,
                                      // semanticLabel: 'Text to announce in accessibility modes',
                                    ),
                                    onPressed: (){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: FutureBuilder(
                                            future: insertProd1(product),
                                            builder: (context, AsyncSnapshot<String> snapshot) {
                                              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                              if (snapshot.hasData) return Text('${snapshot.data}');
                                              return const CircularProgressIndicator();
                                            },
                                          ))
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                          onTap: (){ Navigator.push(context, MaterialPageRoute(builder:(_){return infoProducts(produ: product);}
    )
    );},
                        )
                      ],
                    ),
                  ),
            )
                .toList(),
          ),
        )

    );
  }
}

class infoProducts extends StatelessWidget{
  Product produ;
  infoProducts({super.key,required this.produ});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
          title:Text('Information sur ${produ.name}')
      ),
      body: Center(
        child: Text('\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t${produ.name}\n\n${produ.description}\n\n\t\t\$${produ.price}'),
      ),
    );
  }
}
