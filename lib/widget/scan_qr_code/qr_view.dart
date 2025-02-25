import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:statistics_app/widget/scan_qr_code/qr_scan_box.dart';

import '../../utils/my_route.dart';
import '../../utils/my_toast.dart';
// import 'package:r_scan/r_scan.dart';

class IMQrcodeUrl {
}

typedef QRCodeResultCallback = void Function(String result);

class QrcodeView extends StatefulWidget {
  final QRCodeResultCallback? onResult;
  const QrcodeView({Key? key, this.onResult}) : super(key: key);

  @override
  _QrcodeViewState createState() => _QrcodeViewState();
}

class _QrcodeViewState extends State<QrcodeView> with TickerProviderStateMixin {
  final _picker = ImagePicker();

  // Barcode? result;
  // QRViewController? controller;
  ScanController controller = ScanController();

  // Stream? stream;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController? _animationController;
  Timer? _timer;
  var scanArea = 300.0;
  var cutOutBottomOffset = 40.0;

  void _upState() {
    setState(() {});
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000)).then((e) {
      if (mounted) {
        _initAnimation();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // stream?.cancel();
    _clearAnimation();
    // controller.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animationController!
      ..addListener(_upState)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.reverse(from: 1.0);
          });
        } else if (state == AnimationStatus.dismissed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.forward(from: 0.0);
          });
        }
      });
    _animationController!.forward(from: 0.0);
  }

  void _clearAnimation() {
    _timer?.cancel();
    if (_animationController != null) {
      _animationController?.dispose();
      _animationController = null;
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pause();
    }
    controller.resume();
  }

  void _readImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (null != image) {
      // final result = await RScan.scanImagePath(image.path);
      String? str = await Scan.parse(image.path);
      _parse(str);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initAnimation();
    // });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildQrView(),
          _scanOverlay(),
          _buildBackView1(),
          _buildTools(),
        ],
      ),
    );
  }

  Widget _buildTools() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Spacer(),
                Text(
                  ' ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 120), // 添加一个空白的空间用于间距
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 45, height: 45),
                    GestureDetector(
                      onTap: () async {
                        controller.toggleTorchMode();
                        setState(() {});
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(color: Colors.white30, width: 12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.flashlight_on, size: 35,color: Colors.white30,),
                      ),
                    ),
                    SizedBox(width: 45, height: 45),
                  ],
                ),
              ],
            )),
      );

  Widget _scanOverlay() => Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(bottom: cutOutBottomOffset * 2),
          child: CustomPaint(
            size: Size(scanArea, scanArea),
            painter: QrScanBoxPainter(
              boxLineColor: Colors.cyanAccent,
              animationValue: _animationController?.value ?? 0,
              isForward:
                  _animationController?.status == AnimationStatus.forward,
            ),
          ),
        ),
      );
  Widget _buildBackView1() => Container(
        width: double.infinity,
        height: 88,
        child: Column(
          children: [
            Container(
              height: 44,
              width: double.infinity,
            ),
            Container(
              height: 44,
              width: double.infinity,
              // color: Colors.red,
              padding: EdgeInsets.only(left: 22, right: 22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.arrow_left, size: 24, color: Colors.white,),
                  ),
                  Expanded(
                    child: Text(
                      '扫描二维码',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _readImage();
                    },
                    child: Text(
                      '相册',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );

  Widget _buildQrView() {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = 300.w;
    // var scanArea = (MediaQuery.of(context).size.width < 400.w ||
    //     MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width, // custom wrap size
        height: MediaQuery.of(context).size.height,
        child: ScanView(
          controller: controller,
      // custom scan area, if set to 1.0, will scan full area
          scanAreaScale: 1,
          scanLineColor: Colors.transparent,
          onCapture: (data) {
            _parse(data);
          },
        ),
      ),
    );


    // return QRView(
    //   key: qrKey,
    //   onQRViewCreated: _onQRViewCreated,
    //   overlay: QrScannerOverlayShape(
    //       borderColor: Colors.white,
    //       borderRadius: 12,
    //       borderLength: 0,
    //       borderWidth: 0,
    //       cutOutBottomOffset: cutOutBottomOffset,
    //       cutOutSize: scanArea),
    //   onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    // );
  }


  void _parse(String? result) {
    if (null != result) {
      // 确保在暂停摄像头操作之前Mount。
      if (mounted) {
        controller.pause();
      }
      if (mounted) {
        widget.onResult?.call(result);
        MyRoute.pop(result: result);
      }
    } else {
      if (mounted) {
        MyToast.show('未识别到二维码');
      }
    }
  }

  // void _onPermissionSet(BuildContext context, bool p) {
  //   log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  //   if (!p) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('no Permission')),
  //     );
  //   }
  // }
}
