import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'landing_page.dart';

// void main() => runApp(App());

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
//     );

//     return MaterialApp(
//       title: 'Introduction screen',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: OnBoardingPage(),
//     );
//   }
// }

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LandingPageScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.jpg', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Your one stop app",
          body:
              "Shop everything from groceries to electronics from your couch.",
          image: _buildImage('online_shopping'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Stay safe",
          body:
              "Stay home and stay safe, with our delivery option. Rest assured you'll never miss a sale.",
          image: _buildImage('stayhome'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "One card to rule them all",
          body:
              "No need to fuss with many loyalty cards across stores, Coin points work wherever you go.",
          image: _buildImage('card1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Keep track of your spending",
          body:
              "Know exactly how much you've spent and where. We'll help take the guess work out of budgeting.",
          image: _buildImage('budget'),
          decoration: pageDecoration,
        ),

        // PageViewModel(
        //   title: "Another title page",
        //   body: "Another beautiful body text for this example onboarding",
        //   image: _buildImage('spelt_penne'),
        //   footer: RaisedButton(
        //     onPressed: () {
        //       introKey.currentState?.animateScroll(0);
        //     },
        //     child: const Text(
        //       'FooButton',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     color: Colors.lightBlue,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //   ),
        //   decoration: pageDecoration,
        // ),
        // PageViewModel(
        //   title: "Title of last page",
        //   bodyWidget: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: const [
        //       Text("Click on ", style: bodyStyle),
        //       Icon(Icons.edit),
        //       Text(" to edit a post", style: bodyStyle),
        //     ],
        //   ),
        //   image: _buildImage('img1'),
        //   decoration: pageDecoration,
        // ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        // color: Color(0xFFBDBDBD),
        color: Colors.black,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
