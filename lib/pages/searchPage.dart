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
  // List<Location> addr = [];
  // String? loc = '';
  List<Results>? results = [];
  double? screenHeight;
  double? screenWidth;


  getGeoLocation() async {
    setState(() {
      Api.name = _controller.text;
    });
    Geocoding responseModel = await get_geocoding(context);
    try {
      results = responseModel.results;
    }catch(e){
      print(e.toString());
    }
    // results != null ? print(results![1].name) : print(null);
  }
  @override
  void initState() {
    // TODO: implement initState
   // _controller.addListener(() {getGeoLocation();});
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                    height: screenHeight!*0.06,
                  ),
                  Padding(
                    padding:  EdgeInsets.all(screenWidth!*0.022),
                    child: TextField(
                     // focusNode: myfocus,
                      controller: _controller,
                      onChanged: (text)async {

                      await  getGeoLocation();

                      },
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
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(50.0))),
                    ),
                  ),SizedBox(height: screenHeight!*0.01,),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     FocusScope.of(context).unfocus();
                  //     // await getGeoLocation();
                  //     setState(() {});
                  //
                  //   },
                  //   child: Icon(Icons.search),
                  //   style: ElevatedButton.styleFrom(
                  //     shape: CircleBorder(),
                  //     padding: EdgeInsets.all(screenWidth!*0.04),
                  //     backgroundColor: Color.fromARGB(250, 132, 99, 204),
                  //     // Color.fromARGB(250, 48, 86, 232), // <-- Button color
                  //     foregroundColor: Colors.white, // <-- Splash color
                  //   ),
                  // ),
                  // Text('History'),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      child: results==null?NotFoundMessage():ListView.builder(
                        itemCount: results==null?0:results!.length,
                        itemBuilder: (BuildContext context, index) => InkWell(
                          onTap: () {
                            setState(() {
                              Api.lon = results![index].longitude!;
                              Api.lat = results![index].latitude!;
                            });
                            Navigator.pop(context);
                          },
                          child:  LocationTile(
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
      leading: Icon(Icons.location_on_outlined, color: Colors.white),
      title: Text('$name,$country', style: TextStyle(color: Colors.white)),
      subtitle: Text(
        '$long  $lat',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
  Widget NotFoundMessage(){
    return Padding(
      padding:  EdgeInsets.only(top: screenHeight!*0.15),
      child: Text('No Location found!',style: TextStyle(color: Colors.white,fontSize: 20),),
    );
  }
}
