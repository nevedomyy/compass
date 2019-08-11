import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Compass(),
    );
  }
}

class Compass extends StatefulWidget {
  @override
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double _angle = 0;

  @override
  initState() {
    super.initState();
    FlutterCompass.events.listen((double angle) {
      setState(() {
        _angle = angle;
      });
    });
  }

  Widget _letters(double w){
    List<Widget> list = List();
    List<String> listLetters = ['N', 'E', 'S', 'W'];
    double top;
    double left;
    for(int i=0; i<4; i++) {
      switch(i){
        case 0: top = 0; left = (w-80)/2-15; break;
        case 1: top = (w-80)/2-15; left = w-80-50; break;
        case 2: top = w-80-50; left = (w-80)/2-15; break;
        case 3: top = (w-80)/2-15; left = 0;
      }
      list.add(Positioned(
        top: top,
        left: left,
        child: RotatedBox(
          quarterTurns: i,
          child: Text(
            listLetters[i],
            style: TextStyle(color: listLetters[i] == 'N' ? Colors.red[900] : Colors.white, fontSize: 40.0, fontFamily: 'OldStandardTT'),
          ),
        ),
      ));
    }
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Stack(
        children: list,
      ),
    );
  }

  Widget _units(double w){
    List<Widget> list = List();
    for(int i=-9; i<9; i++){
      list.add(Positioned(
        top: w-7+(w-19)*math.cos(i*20*math.pi/180),
        left: w-10+(w-19)*math.sin(i*20*math.pi/180),
        child: Transform.rotate(
          alignment: FractionalOffset.center,
          angle: (180-i*20)*math.pi/180,
          child: Text(
            (180-i*20).toString(),
            style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'OldStandardTT'),
          ),
        ),
      ));
    }
    return Stack(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width-32.0;
    return Material(
      color: Color.alphaBlend(Color.fromRGBO(114, 135, 164, 0.2), Colors.white),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            height: width,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size(width, width),
                  painter: Panel(),
                ),
                _letters(width),
                _units(width/2),
                Padding(
                  padding: EdgeInsets.only(top: width/2-20, left: 20.0),
                  child: Transform.rotate(
                    alignment: FractionalOffset.center,
                    angle: (90+_angle)*math.pi/180,
                    child: CustomPaint(
                      size: Size(width-40, 40),
                      painter: Arrow(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Panel extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    double w = size.width/2;
    canvas.drawCircle(Offset(w, w), w, Paint()..color = Color.fromRGBO(69, 90, 111, 1));
    canvas.drawCircle(Offset(w, w), w-10, Paint()..color = Color.fromRGBO(96, 120, 144, 1));
    canvas.drawCircle(Offset(w, w), w-12, Paint()..color = Color.fromRGBO(83, 104, 125, 1));
    canvas.drawCircle(Offset(w, w), w-28, Paint()..color = Color.fromRGBO(114, 135, 164, 1));
    for(int i=0; i<360; i++) canvas.drawLine(Offset(w+(w-40)*math.sin(i*math.pi/180), w+(w-40)*math.cos(i*math.pi/180)),
          Offset(w+(w-(i%10==0?25:30))*math.sin(i*math.pi/180), w+(w-(i%10==0?25:30))*math.cos(i*math.pi/180)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Arrow extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width/2;
    double h = size.height/2;
    var path1 = Path();
    path1.moveTo(w, 20+h);
    path1.lineTo(2*w, 20);
    path1.lineTo(w, 20-h);
    path1.close();
    canvas.drawPath(path1, Paint()..color = Colors.white);
    canvas.drawShadow(path1, Colors.black38, 2, true);
    var path2 = Path();
    path2.moveTo(w, 20+h);
    path2.lineTo(0, 20);
    path2.lineTo(w, 20-h);
    path2.close();
    canvas.drawPath(path2, Paint()..color = Colors.red[900]);
    canvas.drawShadow(path2, Colors.black38, 2, true);
    var path3 = Path();
    path3.arcTo(Rect.fromLTWH(w-h-5, 20-h-5, 2*h+10, 2*h+10), 0, math.pi*1.99, true);
    canvas.drawPath(path3, Paint()..color = Color.fromRGBO(69, 90, 111, 1));
    canvas.drawShadow(path3, Colors.black38, 4, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
