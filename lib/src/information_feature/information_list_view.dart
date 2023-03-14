import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

//import '../settings/settings_view.dart';
import 'information.dart';
import 'information_details_view.dart';
import 'information_new.dart';

Future<List<Information>> fetchInfos(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8000/information/'));

  return compute(parseInfos, response.body);
}

// A function that converts a response body into a List<Photo>.
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
  final _navBarBgColor = const Color.fromARGB(105, 89, 53, 181);
  late Future<List<Information>> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = fetchInfos(http.Client());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 42, 94),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Unknown',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Icon(
                        Icons.square,
                        size: 60,
                        color: Colors.white,
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 80,
                      height: 100,
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, top: 20, bottom: 20),
                      child: const ExampleExpandableFab(),
                    ),
                  ],
                )
              ],
            ),
          ), ///////////////////////////////////
          Center(
            child:
                ElevatedButton(onPressed: () {}, child: const Text('account')),
          ), //////////////////////////////////
          Center(
            child:
                ElevatedButton(onPressed: () {}, child: const Text('settings')),
          ), /////////////////////////////////
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                //type: BottomNavigationBarType.shifting,
                backgroundColor: _navBarBgColor,
                elevation: 20,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
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
    );
  }
}

class InfosList extends StatelessWidget {
  const InfosList({super.key, required this.infos});

  final List<Information> infos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      restorationId: 'InformationListView',
      itemCount: infos.length,
      itemBuilder: (BuildContext context, int index) {
        final item = infos[index];

        return ListTile(
            title: Text(
              '${item.userName}\n${item.website}',
              style: const TextStyle(color: Colors.white),
            ),
            leading: const CircleAvatar(
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                SampleItemDetailsView.routeName,
              );
            });
      },
    );
  }
}

//Navigator.restorablePushNamed(context, SettingsView.routeName);


