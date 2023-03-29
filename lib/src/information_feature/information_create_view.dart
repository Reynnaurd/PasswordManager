import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'information_list_view.dart';

class CreateInfoPage extends StatefulWidget {
  const CreateInfoPage({super.key});

  @override
  State<CreateInfoPage> createState() => _CreateInfoPageState();
}

class _CreateInfoPageState extends State<CreateInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  var map = <String, dynamic>{};
  var userName = '';
  var password = '';
  var websiteName = '';
  var message = '';

  var borderColor = const Color.fromARGB(255, 44, 82, 119);
  var submitBtnColor = const Color.fromARGB(255, 9, 55, 92);

  bool isFetchedRandomPassword = false;
  bool isPasswordVisible = false;

  Future<String>? futureRandomPassword;

  Future<SnackBar> postForm() async {
    final map = {
      'userName': userName,
      'password': passwordController.text,
      'website': websiteName,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/information/'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: map,
    );

    final message = (response.statusCode == 201)
        ? 'Your new information is saved now!'
        : 'Sorry, Something went wrong!';

    return SnackBar(content: Text(message));
  }

  Future<dynamic> fetchRandomPassword() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/information/randomPassword/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send website.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              //Colors.black87,
              Color.fromARGB(180, 62, 84, 109),
              Color.fromARGB(255, 62, 84, 109),
              Color.fromARGB(120, 47, 65, 85),
            ],
          ),
        ),
        margin: const EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                ),
                const Text(
                    style: TextStyle(
                        color: Color.fromARGB(199, 38, 58, 92),
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PTSansNarrow'),
                    'Information'),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                            'Please type in the email address or username which you want to store:'),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 50),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email address or username is required!';
                            } else {
                              userName = value;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                            'Please type in the password which you want to store:'),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child:
                            Stack(alignment: Alignment.centerRight, children: [
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: passwordController,
                            obscureText:
                                isPasswordVisible == false ? true : false,
                            obscuringCharacter: '*',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required!';
                              } else if (isFetchedRandomPassword == false) {
                                passwordController.text = value;
                              }

                              return null;
                            },
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isPasswordVisible == false) {
                                    isPasswordVisible = true;
                                  } else {
                                    isPasswordVisible = false;
                                  }
                                });
                              },
                              child: const Icon(Icons.remove_red_eye),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 182, 10, 1)),
                          onPressed: () {
                            fetchRandomPassword().then((value) {
                              isFetchedRandomPassword = true;
                              passwordController.text = value;
                            });
                          },
                          child: const Text('Generate Random Password'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                            'Please type in the website\'s login page address which you want to store:'),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 50),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Website address is required!';
                            } else {
                              websiteName = value;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: submitBtnColor,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "PTSansNarrow",
                              fontSize: 20,
                            ),
                          ),
                          child: const Text('Submit'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              postForm().then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(value);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  height: 50,
                  width: double.maxFinite,
                  child: OutlinedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InformationListView(),
                        ),
                      );
                    },
                    child: const Text(
                        style: TextStyle(color: Colors.white), 'Home Page'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
