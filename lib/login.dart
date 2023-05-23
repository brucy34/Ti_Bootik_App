import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ti_bootik_app/Components/my_button.dart';
import 'package:ti_bootik_app/Components/my_textfield.dart';
import 'package:ti_bootik_app/main.dart';
import 'package:ti_bootik_app/classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class mailProvider extends ChangeNotifier {
  String _mail = 'mymail';

  String get mail => _mail;

  set mail2 (String newName) {
    _mail = newName;
    notifyListeners();
  }

}

class ProviderExample extends StatelessWidget {
  const ProviderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create:  (context) => mailProvider(),
      child: MaterialApp(
        title: 'Ti bootik aw',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage2(),
      ),
    );
  }
}
class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  LoginPage createState() => LoginPage();
}
class LoginPage extends State<HomePage2> {
  // LoginPage({super.key});

  // text editing controllers
  final passwordController = TextEditingController();
  final mailController = TextEditingController();


  double _sigmaX = 5; // from 0-10
  double _sigmaY = 5; // from 0-10
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;
  final _formKey = GlobalKey<FormState>();
  List<User> _users = [];

  Future<void> _fetchData() async {
    final response = await http.get(
        Uri.parse('https://api.escuelajs.co/api/v1/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
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
  }

  // sign user in method
  void signUserIn() {
    if (_formKey.currentState!.validate()) {
      print('valid');
    } else {
      print('not valid');
    }
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://anmg-production.anmg.xyz/yaza-co-za_sfja9J2vLAtVaGdUPdH5y7gA',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.07),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.26),
                    const Text("Log in",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02),
                    ClipRect(
                      child: BackdropFilter(
                        filter:
                        ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 1)
                                  .withOpacity(_opacity),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.4,
                          child: Form(
                            key: _formKey,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Row(children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            'https://anmg-production.anmg.xyz/yaza-co-za_sfja9J2vLAtVaGdUPdH5y7gA'),
                                      ),
                                      SizedBox(
                                          width:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.05),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Text("Enter",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                          Text("your credentials",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18))
                                        ],
                                      )
                                    ]),
                                  ),
                                  SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.03),
                                  MyTextField(
                                    controller: mailController,
                                    hintText: 'youremail@domain.com',
                                    obscureText: false,
                                  ),
                                  SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.03),
                                  MyTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.03),
                                  MyButtonAgree(
                                      text: "Continue",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) {
                                              for (int i = 0; i <
                                                  _users.length; i += 1) {
                                                if (mailController.text ==
                                                    _users[i].email &&
                                                    passwordController.text ==
                                                        _users[i].password) {
                                                  return HomePage1(mail:mailController.text);
                                                }
                                                else if (i == _users.length) {
                                                  return Center(
                                                    child: Text(
                                                        'Credentials don\'t exist'),
                                                  );
                                                }
                                              }
                                              return HomePage2();
                                            },
                                          ),
                                        );
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }