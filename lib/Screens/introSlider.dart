import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:googlemaps/Screens/waitingWidget.dart';
import 'package:googlemaps/Widgets/IntroSliderItem.dart';
import 'package:googlemaps/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class introSlider extends StatefulWidget {
  static String introid = "id";
  @override
  _introSliderState createState() => _introSliderState();

}

class _introSliderState extends State<introSlider> {

  static int currentindex = 0;
  static double currentindexdots = 0;
  void initState() {
    currentindex = 0;
    currentindexdots = 0;
  }

  PageController controller = PageController(initialPage: currentindex);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            PageView(
              physics:new NeverScrollableScrollPhysics(),
              pageSnapping: false,
              allowImplicitScrolling: false,
              reverse: false,
              controller: controller,
              children: <Widget>[
               IntroSliderItem(firstTitle:"Discover",secondTitle: "Discover places and explore like a teen ",imageUrl: "images/intro1.svg",),
                IntroSliderItem(firstTitle:"Find",secondTitle: "Find top- favourite places and hangout spots, wherever you are ",imageUrl: "images/intro2.svg",),
                IntroSliderItem(firstTitle:"Decide",secondTitle: "Decide on the best places to go with reviews, ratings, and pictures ",imageUrl: "images/intro3.svg",),
                IntroSliderItem(firstTitle:"Help",secondTitle: "Help other teens to discover the best places by sharing reviews, photos and more",imageUrl: "images/intro4.svg",),
                IntroSliderItem(
                  firstTitle: "",
                  secondTitle:
                  "By clicking agree that’s mean you agree to take part in this survey and it may  be used for research purposes\n\n"
                      " - If you don’t want to continue press skip\n\n"
                      "If you are under 18 Make sure that you use this app  under your"
                      "guardian supervision",
                  imageUrl: "images/intro5.svg",
                ),
               //  IntroSliderItem(firstTitle:"Agree?",secondTitle: "By clicking agree that’s mean you agree to take part in this survey and it may  be used for research purposes"
               //      '- If you don’t want to continue press skip'
               // ' If you are under 18 Make sure that you use this app  under your'
               //  'guardian supervision',imageUrl: "images/intro5.svg",),
              ],
            ),
            Positioned(
              bottom: height*0.2,
              left: width*0.2,
              right: width*0.2,
              child: new DotsIndicator(
                dotsCount: 5,
                position:currentindexdots,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  activeColor: constants.primarycolor
                ),
              ),
            ),
            Positioned(
              bottom: height*0.1,
              left: width*0.2,
              right: width*0.2,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: width * 0.7,
                      height: height * 0.06,
                      child: FlatButton(child: Text(currentindex==4?"Agree":"Next",style: TextStyle(fontFamily: 'font'),),color: constants.primarycolor
                      ,shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),onPressed: (){
                        if (currentindex<4&&currentindexdots<4){
                          setState(() {
                            currentindex++;
                            currentindexdots++;
                          });
                          controller.animateToPage(currentindex, duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
                        }else{
                          ShowIntroCounter();
                          Navigator.pushNamed(context, waitngWidget.id);
                        }
                        }
                        ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    currentindex == 4 ? Container(
                      width: width * 0.7,
                      height: height * 0.06,
                      child: FlatButton(
                          child: Text(
                            currentindex == 4 ? "Skip" : "Next",
                            style: TextStyle(fontFamily: 'font'),
                          ),
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            if (currentindex < 4 && currentindexdots < 4) {
                              setState(() {
                                currentindex++;
                                currentindexdots++;
                              });
                              controller.animateToPage(currentindex,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInCubic);
                            } else {
                              Navigator.pushNamed(context, waitngWidget.id);
                            }
                          }),
                    ):Container(),
                  ],
                ),
              )),

          ],
        ),
      ),
    );
  }
  ShowIntroCounter()async{
    final prefs = await SharedPreferences.getInstance();

// set value
    prefs.setDouble('Introcounter', 1);
  }
}
