import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'information_list_view.dart';
import 'information.dart';

class InformationDetailsView extends StatefulWidget {
  const InformationDetailsView({super.key, required this.information});

  final Information information;
  static const routeName = '/info_item';

  @override
  State<InformationDetailsView> createState() => _InformationDetailsViewState();
}

class _InformationDetailsViewState extends State<InformationDetailsView> {
  static int _infoId = 0;
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInfo(widget.information.id);
  }

  Future<void> _fetchInfo(int infoId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/information/$infoId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _infoId = data['id'];
        _userNameController.text = data['userName'];
        _passwordController.text = data['password'];
        _websiteController.text = data['website'];
      });
    }
  }

  Future<SnackBar> updateInfo(int infoId) async {
    final map = {
      'userName': _userNameController.text,
      'password': _passwordController.text,
      'website': _websiteController.text,
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/information/$infoId'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: map,
    );

    final message = (response.statusCode == 200)
        ? 'Your information is updated now!'
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
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Username :',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),
                      controller: _userNameController,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.copy),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: _userNameController.text));
                            },
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'Password :',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.copy),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: _passwordController.text));
                            },
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(100, 5, 14, 199)),
                      onPressed: () {
                        fetchRandomPassword().then((value) {
                          _passwordController.text = value;
                        });
                      },
                      child: const Text('Generate Random Password'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Website Address :',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),
                      controller: _websiteController,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: IconButton(
                            icon: const Icon(Icons.copy, color: Colors.white),
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: _websiteController.text));
                            },
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 12, 12),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "PTSansNarrow",
                          fontSize: 20,
                        ),
                      ),
                      child: const Text('Save'),
                      onPressed: () {
                        updateInfo(_infoId).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(value);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
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
      ),
    );
  }
}
