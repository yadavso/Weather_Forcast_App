import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_forcast_project/pages/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool? loginData = false;
  late AnimationController _lottieAnimation;
  final transitionDuration = Duration(seconds: 1);
  var expanded = false;
  double _bigFontSize = kIsWeb ? 234 : 178;

  @override
  void initState() {
    _lottieAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    Future.delayed(Duration(seconds: 1))
        .then((value) => setState(() => expanded = true))
        // .then((value) => Duration(seconds: 1))
        .then(
          (value) => Future.delayed(Duration(seconds: 1)).then(
            (value) => _lottieAnimation.forward().then(
                  (value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false),
                ),
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 20, 35, 91),
            Color.fromARGB(255, 149, 80, 161),
          ],
        )),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AnimatedDefaultTextStyle(
                    duration: transitionDuration,
                    curve: Curves.fastOutSlowIn,
                    style: TextStyle(
                      color: Color.fromARGB(250, 242, 208, 255),
                      fontSize: !expanded ? _bigFontSize : 50,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                    child: Text(
                      "M",
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstCurve: Curves.fastOutSlowIn,
                  crossFadeState: !expanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: transitionDuration,
                  firstChild: Container(),
                  secondChild: _logoRemainder(),
                  alignment: Alignment.centerLeft,
                  sizeCurve: Curves.easeInOut,
                ),
              ],
            ),
            Positioned(top: 750, left: 170, child: Text('BY  SUMIT')),
          ],
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "aosam",
          style: TextStyle(
            color: Color.fromARGB(250, 242, 208, 255),
            fontSize: 50,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        LottieBuilder.asset(
          'assets/weather.json',
          onLoaded: (composition) {
            _lottieAnimation..duration = composition.duration;
          },
          frameRate: FrameRate.max,
          repeat: false,
          animate: false,
          height: 100,
          width: 100,
          controller: _lottieAnimation,
        )
      ],
    );
  }
}
