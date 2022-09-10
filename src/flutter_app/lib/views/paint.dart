import 'package:flutter/material.dart';

class PaintApp extends StatefulWidget{

  const PaintApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PainAppState();

}

class PainAppState extends State<PaintApp>{
  List<DrawingPoint?> _lstDrawingPoints = [];

  // create a painter cache so that they can be reused for each drawn point.
  final List<Paint> _painters = [];
  Paint _currentPainter = Paint() ..color = Colors.black ..strokeWidth = 3.0 ..strokeCap = StrokeCap.butt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(onPressed: () => _resetCanvas(context), icon: const Icon(Icons.fiber_new_sharp))
        ]
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(backgroundColor: Colors.black, onPressed: () => _changeColour(Colors.black)),
          FloatingActionButton(backgroundColor: Colors.red, onPressed: () => _changeColour(Colors.red)),
          FloatingActionButton(backgroundColor: Colors.green, onPressed: () => _changeColour(Colors.green)),
          FloatingActionButton(backgroundColor: Colors.blue, onPressed: () => _changeColour(Colors.blue)),
          FloatingActionButton(backgroundColor: Colors.pink, onPressed: () => _changeColour(Colors.pink))
        ],
      ),
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          size: Size.infinite,
          painter: MyPainter(lstPointsCache: _lstDrawingPoints)
        ),
      ),
    );
  }

  void _changeColour(Color changeColor){
    for(Paint p in _painters){
      // if there exists a painter with these attributes use it.
      if(p.color.value == changeColor.value && p.strokeWidth == _currentPainter.strokeWidth){
        _currentPainter = p;
        return;
      }
    }

    // else create a new one.
    _currentPainter = Paint() ..color = changeColor ..strokeWidth = _currentPainter.strokeWidth ..strokeCap = StrokeCap.butt;
    _painters.add(_currentPainter);

  }

  void _resetCanvas(BuildContext context) {
    showDialog (
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to clear the canvas?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    setState(() => _lstDrawingPoints = []);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),

              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void _onHoldScreenGesture(DrawingPoint? touchPoint){
    setState(() => _lstDrawingPoints.add(touchPoint));
  }

  void _onPanStart(DragStartDetails details){
    _onHoldScreenGesture(DrawingPoint(point: details.globalPosition, painter: _currentPainter));
  }

  void _onPanUpdate(DragUpdateDetails details){
    _onHoldScreenGesture(DrawingPoint(point: details.globalPosition,  painter: _currentPainter));

  }

  void _onPanEnd(DragEndDetails details){
    _onHoldScreenGesture(null);
  }

}

class DrawingPoint{
  Offset point;
  Paint painter;
  DrawingPoint({required this.point, required this.painter});
}

class PainterAttributes{
  Color color;
  double strokeWidth;
  StrokeCap brushType = StrokeCap.butt;
  PainterAttributes({required this.color, required this.strokeWidth});
}

class MyPainter extends CustomPainter{
  List<DrawingPoint?> lstPointsCache;

  MyPainter({required this.lstPointsCache});

  @override
  void paint(Canvas canvas, Size size) {
    for(int i = 0; i < lstPointsCache.length - 1; i++){
      DrawingPoint? p1 = lstPointsCache[i];
      DrawingPoint? p2 = lstPointsCache[i+1];
      if (p1 == null || p2 == null) continue;
      canvas.drawLine(p1.point , p2.point, p1.painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
