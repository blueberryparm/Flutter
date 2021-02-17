import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Offset _startLastOffset = Offset.zero;
  Offset _lastOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;
  double _lastScale = 1.0;
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Detector'),
      ),
      body: _buildBody(context),
    );
  }

  GestureDetector _buildBody(BuildContext context) => GestureDetector(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _transformScaleAndTranslate(),
            _transformMatrix4(),
            _positionedStatusBar(context),
            _positionedInkWellAndInkResponse(context),
          ],
        ),
        // handle moving and scaling gestures
        onScaleStart: _onScaleStart,
        // handle moving and scaling gestures
        onScaleUpdate: _onScaleUpdate,
        // handle double tap to increase zoom
        onDoubleTap: _onDoubleTap,
        // handle long press to reset zoom to original default value
        onLongPress: _onLongPress,
      );

  Transform _transformScaleAndTranslate() => Transform.scale(
        scale: _currentScale,
        child: Transform.translate(
          offset: _currentOffset,
          child: Image(
            image: AssetImage(
              'assets/images/elephant.jpg',
            ),
          ),
        ),
      );

  Transform _transformMatrix4() => Transform(
        transform: Matrix4.identity()
          ..scale(_currentScale, _currentScale)
          ..translate(_currentOffset.dx, _currentOffset.dy),
        alignment: FractionalOffset.center,
        child: Image(
          image: AssetImage(
            'assets/images/elephant.jpg',
          ),
        ),
      );

  Positioned _positionedStatusBar(BuildContext context) => Positioned(
        top: 0.0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: 50.0,
          color: Colors.white54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Scale: ${_currentScale.toStringAsFixed(4)}'),
              Text('Current: $_currentOffset'),
            ],
          ),
        ),
      );

  // Called when the user starts to move or scale the image
  void _onScaleStart(ScaleStartDetails details) {
    print('ScaleStartDetails: $details');
    _startLastOffset = details.focalPoint;
    _lastOffset = _currentOffset;
    _lastScale = _currentScale;
  }

  // Called when the user is either moving or scaling the image
  void _onScaleUpdate(ScaleUpdateDetails details) {
    print('ScaleUpdateDetails: $details - Scale: ${details.scale}');

    if (details.scale != 1.0) {
      // Scaling
      double currentScale = _lastScale * details.scale;
      if (currentScale < 0.5) _currentScale = 0.5;
      setState(() => _currentScale = currentScale);
      print('_scale: $_currentScale - _lastScale: $_lastScale');
    } else if (details.scale == 1.0) {
      // We are not scaling but dragging around screen
      // Calculate offset depending on current Image scaling
      Offset offsetAdjustedForScale =
          (_startLastOffset - _lastOffset) / _lastScale;
      Offset currentOffset =
          details.focalPoint - (offsetAdjustedForScale * _currentScale);
      setState(() => _currentOffset = currentOffset);
      print(
          'offsetAdjustedForScale: $offsetAdjustedForScale - _currentOffset: $_currentOffset');
    }
  }

  //  When a double tap is detected, the image is scaled twice as large
  void _onDoubleTap() {
    print('onDoubleTap');

    // Calculate current scale and populate the _lastScale with currentScale
    // If currentScale is greater than 16 times the original image, reset scale to default, 1.0
    double currentScale = _lastScale * 2.0;
    print(currentScale);
    if (currentScale > 16.0) {
      currentScale = 1.0;
      _resetToDefaultValues();
    }
    _lastScale = currentScale;
    setState(() => _currentScale = currentScale);
  }

  // When a long press is detected, the image is reset to its original position and scale
  void _onLongPress() {
    print('onLongPress');
    setState(() => _resetToDefaultValues());
  }

  // Reset all the values to default with the Image widget centered on the screen
  // and scaled back to its original size
  void _resetToDefaultValues() {
    _startLastOffset = Offset.zero;
    _lastOffset = Offset.zero;
    _currentOffset = Offset.zero;
    _lastScale = 1.0;
    _currentScale = 1.0;
  }

  Positioned _positionedInkWellAndInkResponse(BuildContext context) =>
      Positioned(
        top: 50.0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: 56,
          color: Colors.white54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                  height: 48.0,
                  width: 128.0,
                  color: Colors.black12,
                  child: Icon(
                    Icons.touch_app,
                    size: 32.0,
                  ),
                ),
                splashColor: Colors.lightGreenAccent,
                highlightColor: Colors.lightBlueAccent,
                // scale the image to half the original size
                onTap: _setScaleSmall,
                // scale the image to 16 times the original size
                onDoubleTap: _setScaleBig,
                // reset all values to the original positions and sizes
                onLongPress: _onLongPress,
              ),
              InkResponse(
                child: Container(
                  height: 48.0,
                  width: 128.0,
                  color: Colors.black12,
                  child: Icon(
                    Icons.touch_app,
                    size: 32.0,
                  ),
                ),
                splashColor: Colors.lightGreenAccent,
                highlightColor: Colors.lightBlueAccent,
                // scale the image to half the original size
                onTap: _setScaleSmall,
                // scale the image to 16 times the original size
                onDoubleTap: _setScaleBig,
                // reset all values to the original positions and sizes
                onLongPress: _onLongPress,
              ),
            ],
          ),
        ),
      );

  void _setScaleSmall() => setState(() => _currentScale = 0.5);
  void _setScaleBig() => setState(() => _currentScale = 16.0);
}
