import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:ti_bootik_app/login.dart';
import 'package:ti_bootik_app/classes.dart';

void main() {
  runApp(ProviderExample());
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ti bootik aw',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: HomePage1(),
//     );
//   }
// }
class HomePage1 extends StatefulWidget {
  final String mail;
  const HomePage1({Key? key,required this.mail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(mail: mail);
}

class _HomePageState extends State<HomePage1> {
  String mail;
  _HomePageState({required this.mail});
  int _currentIndex=1;

  late Widget selectWidget;
  List<Category> _categories = [];
  List<Product> _products = [];
  List<User> _users=[];

  Future<void> _fetchData() async {
    final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _categories = data.map((e) => Category.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to fetch categories');
    }

    final response2 = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/products'));

    if (response2.statusCode == 200) {
      final List<dynamic> data = json.decode(response2.body);
      setState(() {
        _products = data.map((e) => Product.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to fetch products');
    }

    final response3 = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/users'));

    if (response2.statusCode == 200) {
      final List<dynamic> data = json.decode(response3.body);
      setState(() {
        _users = data.map((e) => User.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchData();
    prodList();
    prodList1();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "products.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE ${mail.substring(0,mail.indexOf('@'))}products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
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
            "CREATE TABLE ${mail.substring(0,mail.indexOf('@'))}products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER, category TEXT,description TEXT,image TEXT )");
      },
      version: 1,
    );
  }

  Future<String> insertProd(Product prod) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same product is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      '${mail.substring(0,mail.indexOf('@'))}products',
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
      '${mail.substring(0,mail.indexOf('@'))}products',
      prod.mapping(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return 'Add correctly';
  }

  Future<List<Product>> prodList() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('${mail.substring(0,mail.indexOf('@'))}products');
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
    final List<Map<String, dynamic>> maps = await db.query('${mail.substring(0,mail.indexOf('@'))}products');
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

  Future<void> deleteProd(int id) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Remove the Dog from the database.
    await db.delete(
      '${mail.substring(0,mail.indexOf('@'))}products',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteProd1(int id) async {
    // Get a reference to the database.
    final db = await initializeDB1();

    // Remove the Dog from the database.
    await db.delete(
      '${mail.substring(0,mail.indexOf('@'))}products',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
List<Product> prod =[];
List<Product> prod1 =[];




  User myUser(String mail) {
    User myUser=User(id: 0, name: 'name', email: 'email', password: 'password', role: 'role', avatar: 'avatar');
    for (User user in _users) {
      print(mail);
      if (mail ==
          user.email) {
        return user;
      }
    }
    return myUser;
  }


  @override
  Widget build(BuildContext context) {
    User myUser1=myUser(mail);
    prodList().then((value) => prod=value);
    prodList1().then((value) => prod1=value);
    final List <Widget> _widget=[data1(response: prod,mail: mail),data2(cate: _categories, prod: _products,mail: mail,),data3(response:prod1,mail: mail)];
    return Scaffold(
        drawer: Drawer(
        child: ListView(
        children:[
        DrawerHeader(child: Image.network(myUser1.avatar,fit: BoxFit.fill,),
    decoration: BoxDecoration(color: Colors.greenAccent),),
    ListTile(title:Text(myUser1.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30))),
    SizedBox(height: 30.0,),
    ListTile(title:Text("All categories"),onTap:(){Navigator.push(context, MaterialPageRoute(builder:(_){return allCategories(myList: _categories,mylist: _products,);}
    )
    );} ,),
    ListTile(title:Text("All products"),onTap:(){Navigator.push(context, MaterialPageRoute(builder:(_){return allProducts(myList: _products);}
    )
    );} ,),
    ListTile(title:Text("Pay"),onTap:(){
      Navigator.push(context, MaterialPageRoute(builder:(_){return payment();}
      )
      );
    } ,),
    ListTile(title:Text("Log out"),onTap:(){
      Navigator.push(context, MaterialPageRoute(builder:(_){return ProviderExample();}));
    } ,),
    ]
    ),
    ),
    appBar: AppBar(
    title: Text('Ti bootik aw'),
    ),
    body: selectWidget=_widget[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value){
          setState(() {
            _currentIndex=value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
        ],
      ),
    );
  }
}


class data1 extends StatelessWidget{
  List<Product> response;
  String mail;
  data1({super.key,required this.response,required this.mail});

  @override
  Widget build(BuildContext context) {

    return GridView.count(
      crossAxisCount: 2,
        children:response.map(
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
                                  Icons.delete,
                                  color: Colors.pink,
                                  size: 24.0,
                                  // semanticLabel: 'Text to announce in accessibility modes',
                                ),
                                onPressed: (){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: FutureBuilder(
                                        future: _HomePageState(mail: mail).deleteProd(product.id),
                                        builder: (context, AsyncSnapshot<void> snapshot) {
                                          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                          if (snapshot.hasData) return Text('Deleted correctly');
                                          return const CircularProgressIndicator();
                                        },
                                      ))
                                  );
                                },
                              ),
                              IconButton(
                                icon:  Icon(
                                  Icons.payment,
                                  color: Colors.greenAccent,
                                  size: 30.0,
                                  // semanticLabel: 'Text to announce in accessibility modes',
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder:(_){return payment();}
                                  )
                                  );},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        )
            .toList(),
    );
  }
}

class data2 extends StatelessWidget{
  List<Category> cate=[];
  List<Product> prod=[];
  String mail;
  data2({super.key,required this.cate,required this.prod,required this.mail});
  // const data2(List<Category> cate=const [],List<Product> prod=const[]);
  @override
  Widget build(BuildContext context){
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap:true,
        children:[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Top 4 Categories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: cate.take(4).map((category){
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
                        Navigator.push(context, MaterialPageRoute(builder:(_){return productsByCategory(myList: prod,idCategory: category.name,);}
                        )
                        );

                      },

                    );

                  },
                  ).toList(),

                ),
                SizedBox(height: 30,),
                Text("Top 6 Produits",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                Container(
                  height: 800.0,
                  child:
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children:
                    prod.take(6)
                        .map(
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
                                                    future: _HomePageState(mail: mail).insertProd(product),
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
                                                    future: _HomePageState(mail: mail).insertProd1(product),
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

                )
              ]
          )
        ]
    );
  }
}


class data3 extends StatelessWidget{
  List<Product> response;
  String mail;
  data3({super.key,required this.response, required this.mail});

  @override
  Widget build(BuildContext context) {

    return GridView.count(
      crossAxisCount: 2,
      children:response.map(
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
                                Icons.delete,
                                color: Colors.pink,
                                size: 24.0,
                                // semanticLabel: 'Text to announce in accessibility modes',
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: FutureBuilder(
                                      future: _HomePageState(mail: mail).deleteProd1(product.id),
                                      builder: (context, AsyncSnapshot<void> snapshot) {
                                        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                        if (snapshot.hasData) return Text('Deleted correctly');
                                        return const CircularProgressIndicator();
                                      },
                                    ))
                                );
                              },
                            ),
                            IconButton(
                              icon:  Icon(
                                Icons.add_shopping_cart_outlined,
                                color: Colors.greenAccent,
                                size: 30.0,
                                // semanticLabel: 'Text to announce in accessibility modes',
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: FutureBuilder(
                                      future: _HomePageState(mail: mail).insertProd(product),
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
                ],
              ),
            ),
      )
          .toList(),
    );
  }
}