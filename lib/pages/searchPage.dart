import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forcast_project/helper/Api.dart';
import 'package:weather_forcast_project/models/Geocoding_model.dart';
import 'package:weather_forcast_project/pages/HomePage.dart';
import 'package:weather_forcast_project/repository/common_repository.dart';

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
  List<Results>? results = [];
  // List<String>? history = ['no data'];

  _getlocation() async {
    final query = _controller.text;
    addr = await locationFromAddress(query);
    // history!.add(query);

    var first = addr.first;

    setState(() {
      Api.lon = addr.first.longitude;
      Api.lat = addr.first.latitude;
    });
    print("${first.latitude} : ${first.longitude}");
  }

  getGeoLocation() async {
    setState(() {
      Api.name = _controller.text;
    });
    Geocoding responseModel = await get_geocoding(context);
    results = responseModel.results;

    results != null ? print(results![1].name) : print(null);
  }

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
                      FocusScope.of(context).unfocus();
                      await getGeoLocation();
                      setState(() {});

                      // await _getlocation();
                      //  await setdata();
                      // await _getAddressFromLatLng();
                      //  Navigator.pop(context);
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
                  // Text('History'),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: results!.length,
                        itemBuilder: (BuildContext context, index) => InkWell(
                          onTap: () {
                            setState(() {
                              Api.lon = results![index].longitude!;
                              Api.lat = results![index].latitude!;
                            });
                            Navigator.pop(context);
                          },
                          child: LocationTile(
                              results![index].name!,
                              results![index].admin1 == null ||
                                      results![index].admin1 ==
                                          results![index].name
                                  ? results![index].country!
                                  : results![index].admin1!,
                              results![index].longitude!,
                              results![index].latitude!),
                        ),
                      ))
                ],
              ),
            ),
          ]),
        ));
  }

  Widget LocationTile(String name, String country, double long, double lat) {
    return ListTile(
      leading: Icon(Icons.location_city, color: Colors.white),
      title: Text('$name,$country', style: TextStyle(color: Colors.white)),
      subtitle: Text(
        '$long  $lat',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
