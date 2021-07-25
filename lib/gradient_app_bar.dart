import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget{
  // This widget is the root of your application.
  final double _prefferedHeight = 100.0;

  String title;
  Color gradientBegin, gradientEnd;

  GradientAppBar({this.title, this.gradientBegin, this.gradientEnd}) : assert(title != null), assert(gradientBegin != null), assert(gradientEnd != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            color: Colors.transparent,
            child: Container(
              //height: _prefferedHeight,
              padding: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      gradientBegin,
                      gradientEnd
                    ]
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.0)
                ),
              ),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width/7,
                        right: MediaQuery.of(context).size.width/7
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width/20,
                          right: MediaQuery.of(context).size.width/20
                      ),
                      child: Icon(Icons.ac_unit_outlined)
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 20,
                        // right: MediaQuery.of(context).size.width / 20
                      ),
                      child: Icon(Icons.sanitizer_outlined)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
            child: Container(
              color: Color(0xfff6be53),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(75.0)
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}