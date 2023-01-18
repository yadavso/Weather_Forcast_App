import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_forcast_project/helper/Api.dart';
import 'package:weather_forcast_project/pages/HomePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode myfocus = FocusNode();
  TextEditingController _controller = TextEditingController();
  List<Location> addr = [];
  String? loc = '';

  _getlocation() async {
    final query = _controller.text;
    addr = await locationFromAddress(query);

    var first = addr.first;
    setState(() {});
    setState(() {
      Api.lon = addr.first.longitude;
      Api.lat = addr.first.latitude;
    });
    print("${first.latitude} : ${first.longitude}");
  }

  // Future<void> _getAddressFromLatLng() async {
  //   await placemarkFromCoordinates(addr.first.latitude, addr.first.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     print(place.name);
  //     setState(() {
  //       loc = place.name;
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(130, 48, 86, 232),
                  Color.fromARGB(255, 139, 66, 155),
                ],
              )),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      focusNode: myfocus,
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          focusColor: Color.fromARGB(250, 132, 99, 204),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(50.0)),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon: Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                          // labelText: 'Search',
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(50.0))),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _getlocation();
                      // await _getAddressFromLatLng();
                      Navigator.pop(context);
                    },
                    child: Text('Get'),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Color.fromARGB(250, 132, 99, 204),
                      // Color.fromARGB(250, 48, 86, 232), // <-- Button color
                      foregroundColor: Colors.white, // <-- Splash color
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
