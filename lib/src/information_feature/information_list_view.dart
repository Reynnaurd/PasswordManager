import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

//import '../settings/settings_controller.dart';
//import '../settings/settings_service.dart';
import 'package:password_manager/src/settings/settings_view.dart';
import 'package:password_manager/src/information_feature/information.dart';
import 'package:password_manager/src/information_feature/information_details_view.dart';
import 'package:password_manager/src/information_feature/information_create_view.dart';
//import 'package:password_manager/src/accounts/registration_form.dart';
//import 'information_new.dart';

Future<List<Information>> fetchInfos(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8000/information/'));

  return compute(parseInfos, response.body);
}

// A function that converts a response body into a List<Information>.
List<Information> parseInfos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Information>((json) => Information.fromJson(json)).toList();
}

class InformationListView extends StatefulWidget {
  const InformationListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<InformationListView> createState() => _InformationListViewState();
}

class _InformationListViewState extends State<InformationListView> {
  int _selectedIndex = 0;
  final _navBarBgColor = const Color.fromARGB(181, 59, 82, 108);
  final _settingsBtnColor = const Color.fromARGB(100, 76, 105, 139);
  late Future<List<Information>> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = fetchInfos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 62, 84, 109),
              Color.fromARGB(161, 47, 65, 85),
            ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                            bottom: 10,
                          ),
                          height: 75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(8),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/flutter_logo.png'),
                                    ),
                                  ),
                                  const Text('Unknown',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  futureInfo = fetchInfos(http.Client());
                                }),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: FutureBuilder<List<Information>>(
                          future: futureInfo,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('An error has occurred!'),
                              );
                            } else if (snapshot.hasData) {
                              return InfosList(infos: snapshot.data!);
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: FloatingActionButton(
                          //ExampleExpandableFab(),
                          backgroundColor: Colors.indigo,
                          child: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateInfoPage(),
                              ),
                            );
                          },
                        ))
                  ],
                ),
              ), ///////////////////////////////////
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: SizedBox(
                  height: 70,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      backgroundColor: _settingsBtnColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.restorablePushNamed(
                          context, SettingsView.routeName);
                    },
                    child: const Text('All Accounts'),
                  ),
                ),
              ), //////////////////////////////////
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: SizedBox(
                  height: 70,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      backgroundColor: _settingsBtnColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.restorablePushNamed(
                          context, SettingsView.routeName);
                    },
                    child: const Text('Theme'),
                  ),
                ),
              ), /////////////////////////////////
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding:
                const EdgeInsets.only(right: 30, left: 30, bottom: 25, top: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                  unselectedItemColor: Colors.grey,
                  //type: BottomNavigationBarType.shifting,
                  backgroundColor: _navBarBgColor,
                  elevation: 20,
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  iconSize: 32,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.manage_accounts),
                      label: 'Accounts',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class InfosList extends StatefulWidget {
  const InfosList({super.key, required this.infos});

  final List<Information> infos;

  @override
  State<InfosList> createState() => _InfosListState();
}

class _InfosListState extends State<InfosList> {
  final _listTileBgColor = const Color.fromARGB(76, 59, 82, 108);
  var message = '';

  Future<SnackBar> deleteInfo(int infoId) async {
    final response = await http
        .delete(Uri.parse('http://10.0.2.2:8000/information/$infoId'));

    if (response.statusCode == 204) {
      message = 'Your item was successfully removed!';
      var snackBar = SnackBar(
        content: Text(message),
      );
      return snackBar;
    } else {
      message = 'Sorry, Something went wrong...';
      var snackBar = SnackBar(
        content: Text(message),
      );
      return snackBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      restorationId: 'InformationListView',
      itemCount: widget.infos.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.infos[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InformationDetailsView(information: item)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _listTileBgColor,
            ),
            height: 105,
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              Expanded(
                flex: 90,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        color: Color.fromARGB(255, 146, 146, 146),
                        size: 38,
                        Icons.person,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            item.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              item.website,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Warning'),
                              content: const Text(
                                  'Are you sure you want to delete this item?'),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      deleteInfo(item.id).then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(value);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const InformationListView()),
                                        );
                                      });
                                    },
                                    child: const Text('DELETE')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const InformationListView()),
                                      );
                                    },
                                    child: const Text('No'))
                              ],
                            );
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}

// onTap: () {
//                 Navigator.restorablePushNamed(
//                   context,
//                   SampleItemDetailsView.routeName,
//                 );
//               }



// ListTile(
//               leading: Container(
//                 height: 45,
//                 width: 45,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Icon(
//                   size: 38,
//                   Icons.person,
//                 ),
//               ),
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   item.website,
//                   style: const TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//               ),
//               title: Text(
//                 item.userName,
//                 style: const TextStyle(fontSize: 16, color: Colors.white),
//               ),
//               onTap: () {
//                 Navigator.restorablePushNamed(
//                   context,
//                   SampleItemDetailsView.routeName,
//                 );
//               })


