import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:zodiac_zone_app/gradient_app_bar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zodiac Zone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Zodiac Zone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime _dateTime;
  TimeOfDay _timeOfDay;
  TimeOfDay _now1 = new TimeOfDay.now();
  int _selectedIndex = -1;
  int _selectedIndex1 = 0;
  int _valueChoose = 15;
  String _value;
  List listItem = ['15 Mins', '30 Mins', '45 Mins', '60 Mins'];
  Map<int, String> _listItem = {15: '15 Mins', 30: '30 Mins', 45: '45 Mins', 60: '60 Mins'};
  //List<DateTime> _week1;

  final _startTime = TimeOfDay(hour: 9, minute: 0);
  final _endTime = TimeOfDay(hour: 23, minute: 0);
  Duration _step = Duration(minutes: 15);
  List _times;
  List times;
  // List<Positioned> pos;

  String weekday(int dayNo)
  {
    return dayNo%7==0 ? "Sun" : dayNo%7==1 ? "Mon" : dayNo%7==2 ? "Tue" : dayNo%7==3 ? "Wed" : dayNo%7==4 ? "Thu" : dayNo%7==5 ? "Fri" : "Sat";
  }

  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  int day1(DateTime dt, int day)
  {
    if(isLeapYear(dt.year) && dt.month == 2 && day != 29)
      return (day%29);
    if((dt.month == 1 || dt.month == 3 || dt.month == 5 || dt.month == 7 || dt.month == 8 || dt.month == 10 || dt.month == 12) && day != 31)
      return (day%31);
    else if((dt.month == 4 || dt.month == 6 || dt.month == 9 || dt.month == 11) && day != 30)
      return (day%30);
    else if(dt.month == 2 && day !=28)
      return (day%28);
    else
      return (day);
  }

  String day(DateTime dt, int day)
  {
    if(isLeapYear(dt.year) && dt.month == 2 && day != 29)
      return (day%29).toString();
    if((dt.month == 1 || dt.month == 3 || dt.month == 5 || dt.month == 7 || dt.month == 8 || dt.month == 10 || dt.month == 12) && day != 31)
      return (day%31).toString();
    else if((dt.month == 4 || dt.month == 6 || dt.month == 9 || dt.month == 11) && day != 30)
      return (day%30).toString();
    else if(dt.month == 2 && day !=28)
      return (day%28).toString();
    else
      return (day).toString();
  }

  Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  bool compTime(TimeOfDay time1, TimeOfDay time2)
  {
    double _doubleyourTime = time1.hour.toDouble() + (time1.minute.toDouble() /60);
    double _doubleNowTime = time2.hour.toDouble() + (time2.minute.toDouble() / 60);
    if (_doubleyourTime > _doubleNowTime)
      return true;
    else
      return false;
  }

  Positioned pos(int x, int y, bool flag1, int arrNo)//flag1 for times and _times and flag2 for disabled or enabled
  {
    bool flag2 = false;
    int hr, min;
    String s = (flag1 == true ? _times[arrNo] : times[arrNo]);
    hr = int.parse(s.split(":")[0]);
    if(s.split(" ")[1] == "PM")
    {
      s = s.split(" ")[0];
      min = int.parse(s.split(":")[1]);
      setState(() {
        hr = hr + 12;
      });
      if(hr==24)
      {
        setState(() {
          hr = 0;
        });
      }
    }
    else
    {
      s = s.split(" ")[0];
      min = int.parse(s.split(":")[1]);
    }
    TimeOfDay _time = TimeOfDay(hour:hr,minute: min);
    setState(() {
      if(_timeOfDay == null)
      {
        if(compTime(_time, _now1))
          flag2 = true;
      }
      else
      {
        if(compTime(_time, _timeOfDay))
          flag2 = true;
      }
    });
    return Positioned(
      top: 20 + x*(MediaQuery.of(context).size.width/10 + 35),
      left: 0 + y*(MediaQuery.of(context).size.height/8 + 35),
      height: MediaQuery.of(context).size.width/10,
      width: MediaQuery.of(context).size.height/6,
      child: FlatButton(
        onPressed: (flag2 == false && _selectedIndex <= 1) ? null : () {},
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: (flag2 == false && _selectedIndex <= 1) ? Colors.grey[300] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 10.0,
                  offset: Offset(10.0, 10.0),
                ),
              ]
          ),
          child: Text(
              flag1 == true ? _times[arrNo] : times[arrNo],
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime _now = new DateTime.now();
    String _formattedate = new DateFormat.MMM().format(_now);
    String _formattetime;
    if(_now1.hour>12)
      _formattetime = '${_now1.hour-12} : ${_now1.minute} pm';
    else
      _formattetime = '${_now1.hour} : ${_now1.minute} am';

    //List<DateTime> _week = [new DateTime(_now.year, _now.month, _now.day), new DateTime(_now.year, _now.month, _now.day + 1), new DateTime(_now.year, _now.month, _now.day + 2), new DateTime(_now.year, _now.month, _now.day + 3), new DateTime(_now.year, _now.month, _now.day + 4), new DateTime(_now.year, _now.month, _now.day + 5), new DateTime(_now.year, _now.month, _now.day + 6)];
    List<int> keys;
    setState(() {
      times = getTimes(new TimeOfDay(hour: 9, minute: 0), new TimeOfDay(hour: 23, minute: 0), new Duration(minutes: 15)).map((tod) => tod.format(context)).toList();
      keys = _listItem.keys.toList();
      _value = "15 Mins";
    });
    // List<Positioned> pos1 = calculateItems(context, _valueChoose);
    return Scaffold(
      appBar: GradientAppBar(
        title: widget.title,
        gradientBegin: Color(0xffed376d),
        gradientEnd: Color(0xfff6be53),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width/7*3,
              margin: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 10.0,
                    offset: Offset(10.0, 10.0),
                  ),
                ]
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    top: 30.0,
                    height: 40.0,
                    child: Neumorphic(
                        style: NeumorphicStyle(
                          lightSource: LightSource.topLeft,
                          depth: -10,
                          color: Colors.white,
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                        ),
                        child: Center(
                            child: Text(
                                'Book Appointment for',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            )
                        ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    height: 70,
                    width: 70,
                    top:85,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex1 = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: _selectedIndex1 == 1 ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xffed376d),
                                  Color(0xfff6be53),
                                ]
                            ) :
                            LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xffffffff),
                                  Color(0xffffffff),
                                ]
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 10.0,
                                offset: Offset(10.0, 10.0),
                              ),
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.margin),
                            Text(
                              'Call',
                              style: TextStyle(
                                color: _selectedIndex1 == 1 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    height: 70,
                    width: 70,
                    top:85,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex1 = 2;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: _selectedIndex1 == 2 ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xffed376d),
                                  Color(0xfff6be53),
                                ]
                            ) :
                            LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xffffffff),
                                  Color(0xffffffff),
                                ]
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 10.0,
                                offset: Offset(10.0, 10.0),
                              ),
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.margin),
                            Text(
                              'Video Call',
                              style: TextStyle(
                                color: _selectedIndex1 == 2 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 240,
                    height: 70,
                    width: 70,
                    top: 85,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex1 = 3;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: _selectedIndex1 == 3 ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xffed376d),
                                  Color(0xfff6be53),
                                ]
                            ) :
                            LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xffffffff),
                                  Color(0xffffffff),
                                ]
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 10.0,
                                offset: Offset(10.0, 10.0),
                              ),
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.margin),
                            Text(
                              'Chat',
                              style: TextStyle(
                                color: _selectedIndex1 == 3 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/7*2.5,
              margin: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      offset: Offset(10.0, 10.0),
                    ),
                  ]
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Icon(Icons.calendar_today),
                  ),
                  Positioned(
                    top: 0,
                    left: 40,
                    child: _dateTime == null ? FlatButton(
                      color: Colors.white70,
                      child: Text(
                        '${_formattedate},${_now.year}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(_now.year + 1),
                        ).then((date) {
                          setState(() {
                            _dateTime = date;
                            if(_selectedIndex != -1)
                              _selectedIndex = -1;
                          });
                        });
                      },
                    ) :
                    FlatButton(
                      color: Colors.white70,
                        child: Text(
                          '${new DateFormat.MMM().format(_dateTime)},${_dateTime.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2022),
                          ).then((date) {
                            setState(() {
                              _dateTime = date;
                            });
                          });
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: _timeOfDay == null ? FlatButton(
                      color: Colors.white70,
                      child: Text(
                          _formattetime,
                      ),
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          setState(() {
                            _timeOfDay = time;
                            if(_timeOfDay.hour>12)
                              _formattetime = '${_timeOfDay.hour-12} : ${_timeOfDay.minute} pm';
                            else
                              _formattetime = '${_timeOfDay.hour} : ${_timeOfDay.minute} am';
                          });
                        });
                      },
                    ) :
                    FlatButton(
                      color: Colors.white70,
                      child: Text(
                          _timeOfDay.hour>12 ? '${_timeOfDay.hour-12} : ${_timeOfDay.minute} pm' : '${_timeOfDay.hour} : ${_timeOfDay.minute} am',
                      ),
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          setState(() {
                            _timeOfDay = time;
                            if(_timeOfDay.hour>12)
                              _formattetime = '${_timeOfDay.hour-12} : ${_timeOfDay.minute} pm';
                            else
                              _formattetime = '${_timeOfDay.hour} : ${_timeOfDay.minute} am';
                          });
                        });
                      },
                    ),
                  ),
                  Positioned(
                    left: 30,
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 1 ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday) : weekday(_now.weekday),
                              style: TextStyle(
                                color: _selectedIndex == 1 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day) : day(_now,_now.day),
                              style: TextStyle(
                                color: _selectedIndex == 1 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30 + MediaQuery.of(context).size.width/10 + 10,
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 2 ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday + 1) : weekday(_now.weekday + 1),
                              style: TextStyle(
                                color: _selectedIndex == 2 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day + 1) : day(_now,_now.day + 1),
                              style: TextStyle(
                                color: _selectedIndex == 2 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30 + 2*(MediaQuery.of(context).size.width/10 + 10),
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 3 ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday + 2) : weekday(_now.weekday + 2),
                              style: TextStyle(
                                color: _selectedIndex == 3 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day + 2) : day(_now,_now.day + 2),
                              style: TextStyle(
                                color: _selectedIndex == 3 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30 + 3*(MediaQuery.of(context).size.width/10 + 10),
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 4 ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday + 3) : weekday(_now.weekday + 3),
                              style: TextStyle(
                                color: _selectedIndex == 4 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day + 3) : day(_now,_now.day + 3),
                              style: TextStyle(
                                color: _selectedIndex == 4 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30 + 4*(MediaQuery.of(context).size.width/10 + 10),
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 5;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 5 ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday + 4) : weekday(_now.weekday + 4),
                              style: TextStyle(
                                color: _selectedIndex == 5 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day + 4) : day(_now,_now.day + 4),
                              style: TextStyle(
                                color: _selectedIndex == 5 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30 + 5*(MediaQuery.of(context).size.width/10 + 10),
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 6;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 6 ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday + 5) : weekday(_now.weekday + 5),
                              style: TextStyle(
                                color: _selectedIndex == 6 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day + 5) : day(_now,_now.day + 5),
                              style: TextStyle(
                                color: _selectedIndex == 6 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30 + 6*(MediaQuery.of(context).size.width/10 + 10),
                    top: 57,
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width/10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 7;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: _selectedIndex == 7 ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffed376d),
                                Color(0xfff6be53),
                              ]
                          ) :
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ]
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _dateTime != null ? weekday(_dateTime.weekday + 6) : weekday(_now.weekday + 6),
                              style: TextStyle(
                                color: _selectedIndex == 7 ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              _dateTime != null ? day(_dateTime,_dateTime.day + 6) : day(_now,_now.day + 6),
                              style: TextStyle(
                                color: _selectedIndex == 7 ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/7*2.5,
              margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      offset: Offset(10.0, 10.0),
                    ),
                  ]
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 14,
                    left: 20,
                    child: Icon(Icons.access_time),
                  ),
                  Positioned(
                    top: 15,
                    left: 55,
                    child: Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 20,
                    child: Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 20,
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 20,
                    child: DropdownButton(
                      value: _listItem[_valueChoose],
                      onChanged: (newValue) {
                        setState(() {
                          //_valueChoose = int.parse((_listItem[_valueChoose]).substring(0, 2));
                          _valueChoose = int.parse((newValue).substring(0, 2));
                          _listItem[_valueChoose] = newValue;
                          _step = Duration(minutes: int.parse((newValue).substring(0, 2)));
                          _times = getTimes(_startTime, _endTime, _step).map((tod) => tod.format(context)).toList();
                          // pos = calculateItems(context, _valueChoose);
                        });
                      },
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                         value: valueItem,
                         child: Text(
                           valueItem,
                         ),
                       );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    top: 102,
                    right: 25,
                    child: Text(
                      'Free',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/7*2.5,
              margin: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                  color: Colors.white70,
              ),
              // child: (_dateTime != null ? weekday(_dateTime.weekday + _selectedIndex - 1) : weekday(_now.weekday + _selectedIndex - 1)) != DateTime.sunday ?
              child: SingleChildScrollView(
                child: _valueChoose == 15 ? Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/7*25,
                    ),
                    pos(0, 0, false, 0),
                    pos(0, 1, false, 1),
                    pos(0, 2, false, 2),
                    pos(1, 0, false, 3),
                    pos(1, 1, false, 4),
                    pos(1, 2, false, 5),
                    pos(2, 0, false, 6),
                    pos(2, 1, false, 7),
                    pos(2, 2, false, 8),
                    pos(3, 0, false, 9),
                    pos(3, 1, false, 10),
                    pos(3, 2, false, 11),
                    pos(4, 0, false, 12),
                    pos(4, 1, false, 13),
                    pos(4, 2, false, 14),
                    pos(5, 0, false, 15),
                    pos(5, 1, false, 16),
                    pos(5, 2, false, 17),
                    pos(6, 0, false, 18),
                    pos(6, 1, false, 19),
                    pos(6, 2, false, 20),
                    pos(7, 0, false, 21),
                    pos(7, 1, false, 22),
                    pos(7, 2, false, 23),
                    pos(8, 0, false, 24),
                    pos(8, 1, false, 25),
                    pos(8, 2, false, 26),
                    pos(9, 0, false, 27),
                    pos(9, 1, false, 28),
                    pos(9, 2, false, 29),
                    pos(10, 0, false, 30),
                    pos(10, 1, false, 31),
                    pos(10, 2, false, 32),
                    pos(11, 0, false, 33),
                    pos(11, 1, false, 34),
                    pos(11, 2, false, 35),
                    pos(12, 0, false, 36),
                    pos(12, 1, false, 37),
                    pos(12, 2, false, 38),
                    pos(13, 0, false, 39),
                    pos(13, 1, false, 40),
                    pos(13, 2, false, 41),
                    pos(14, 0, false, 42),
                    pos(14, 1, false, 43),
                    pos(14, 2, false, 44),
                    pos(15, 0, false, 45),
                    pos(15, 1, false, 46),
                    pos(15, 2, false, 47),
                    pos(16, 0, false, 48),
                    pos(16, 1, false, 49),
                    pos(16, 2, false, 50),
                    pos(17, 0, false, 51),
                    pos(17, 1, false, 52),
                    pos(17, 2, false, 53),
                    pos(18, 0, false, 54),
                    pos(18, 1, false, 55),
                  ],
                ) :
                _valueChoose == 30 ? Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/7*13.7,
                    ),
                    pos(0, 0, true, 0),
                    pos(0, 1, true, 1),
                    pos(0, 2, true, 2),
                    pos(1, 0, true, 3),
                    pos(1, 1, true, 4),
                    pos(1, 2, true, 5),
                    pos(2, 0, true, 6),
                    pos(2, 1, true, 7),
                    pos(2, 2, true, 8),
                    pos(3, 0, true, 9),
                    pos(3, 1, true, 10),
                    pos(3, 2, true, 11),
                    pos(4, 0, true, 12),
                    pos(4, 1, true, 13),
                    pos(4, 2, true, 14),
                    pos(5, 0, true, 15),
                    pos(5, 1, true, 16),
                    pos(5, 2, true, 17),
                    pos(6, 0, true, 18),
                    pos(6, 1, true, 19),
                    pos(6, 2, true, 20),
                    pos(7, 0, true, 21),
                    pos(7, 1, true, 22),
                    pos(7, 2, true, 23),
                    pos(8, 0, true, 24),
                    pos(8, 1, true, 25),
                    pos(8, 2, true, 26),
                    pos(9, 0, true, 27),
                  ],
                ) :
                _valueChoose == 45 ? Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/7*10.1,
                    ),
                    pos(0, 0, true, 0),
                    pos(0, 1, true, 1),
                    pos(0, 2, true, 2),
                    pos(1, 0, true, 3),
                    pos(1, 1, true, 4),
                    pos(1, 2, true, 5),
                    pos(2, 0, true, 6),
                    pos(2, 1, true, 7),
                    pos(2, 2, true, 8),
                    pos(3, 0, true, 9),
                    pos(3, 1, true, 10),
                    pos(3, 2, true, 11),
                    pos(4, 0, true, 12),
                    pos(4, 1, true, 13),
                    pos(4, 2, true, 14),
                    pos(5, 0, true, 15),
                    pos(5, 1, true, 16),
                    pos(5, 2, true, 17),
                    pos(6, 0, true, 18),
                  ],
                ) :
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/7*7.4,
                    ),
                    pos(0, 0, true, 0),
                    pos(0, 1, true, 1),
                    pos(0, 2, true, 2),
                    pos(1, 0, true, 3),
                    pos(1, 1, true, 4),
                    pos(1, 2, true, 5),
                    pos(2, 0, true, 6),
                    pos(2, 1, true, 7),
                    pos(2, 2, true, 8),
                    pos(3, 0, true, 9),
                    pos(3, 1, true, 10),
                    pos(3, 2, true, 11),
                    pos(4, 0, true, 12),
                    pos(4, 1, true, 13),
                  ],
                ),
              // ) :
              // Center(
              //   child: Text(
              //     'Not Available on Sunday',
              //     style: TextStyle(
              //       fontSize: 20.0,
              //     ),
              //   ),
              // ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/7*1.5,
              margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      offset: Offset(10.0, 10.0),
                    ),
                  ]
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 18,
                    left: 20,
                    child: Text(
                      'Free',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 20,
                    height: 35,
                    width: 160,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xffed376d),
                              Color(0xfff6be53),
                            ]
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Set your schedule',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
