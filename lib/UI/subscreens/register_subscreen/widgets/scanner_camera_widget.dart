import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerCameraWidget extends StatefulWidget {
  const ScannerCameraWidget({super.key});

  @override
  State<ScannerCameraWidget> createState() => _ScannerCameraWidgetState();
}

class _ScannerCameraWidgetState extends State<ScannerCameraWidget> {
  bool isVisibleBottons = false;
  bool isOnCamera = false;
  MobileScannerController _controller1 = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isOnCamera) {
      return Expanded(
          child: Stack(
        children: [
          GestureDetector(
              child: MobileScanner(
            controller: _controller1,
          )),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isOnCamera = false;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.power_settings_new),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      await _controller1.stop();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScannerCameraFullScreen(),
                          ));

                      await _controller1.start();

                      setState(() {
                        isOnCamera = false;
                      });

                      Future.delayed(
                        Duration(seconds: 1),
                        () {
                          setState(() {
                            isOnCamera = true;
                          });
                        },
                      );

                      //I dont now why this works  but works and that is the important,technical debt for you
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.fullscreen),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ));
    }

    return Expanded(
        child: Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isOnCamera = true;
                  _controller1.start();
                });
              },
              child: Icon(
                Icons.power_settings_new,
                size: size.height * 0.07,
              ),
            ),
            Text(
              "Abrir Camara",
              style: TextStyle(fontSize: size.height * 0.015),
            )
          ],
        ),
      ),
    ));
  }
}

class ScannerCameraFullScreen extends StatefulWidget {
  ScannerCameraFullScreen();

  @override
  State<ScannerCameraFullScreen> createState() =>
      _ScannerCameraFullScreenState();
}

class _ScannerCameraFullScreenState extends State<ScannerCameraFullScreen> {
  MobileScannerController _controller = MobileScannerController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.start();
  }

  @override
  void dispose() async {
    // TODO: implement dispose

    super.dispose();
    _controller.dispose();
    Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: _controller,
    );
  }
}
