import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tapioca/tapioca.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_editors/controllers/form_controller.dart';
import 'package:video_editors/controllers/select_item_controller.dart';
import 'package:video_editors/screens/downloaded_video_screen.dart';
import 'package:video_editors/screens/test_camera.dart';
import 'package:video_player/video_player.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../themes/colors.dart';
import '../utils/route.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.data});

  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            Image.asset('assets/navigate.png'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        ruta(
                            CameraApp(
                              data: data,
                            ),
                            const Offset(0, 2)));
                  },
                  child: const Text('+ Crear proyecto')), //Create project
            )
          ],
        ),
      ),
    );
  }
}

class EditorScreenTest extends StatefulWidget {
  final String path;
  final XFile? video;
  final String pathImage;
  final Map<String, dynamic> data;
  final bool isSavedVideo;

  const EditorScreenTest(
      {super.key,
      required this.path,
      this.video,
      required this.pathImage,
      required this.data,
      this.isSavedVideo = false});
  @override
  State<EditorScreenTest> createState() => _MyAppStateTest();
}

class _MyAppStateTest extends State<EditorScreenTest> {
  final navigatorKey = GlobalKey<NavigatorState>();
  late XFile _video;
  bool isLoading = false;
  static const EventChannel _channel = EventChannel('video_editor_progress');
  late StreamSubscription _streamSubscription;
  int processPercentage = 0;
  late String path;
  final List<_DraggableText> _texts = [];
  final List<DraggableResizableItem> _images = [];
  List<Color> colors = [Colors.black, Colors.white];
  final List<String> _paths = [];
  bool loadedImages = false;

  late VideoPlayerController _controller;
  late final SelectItemController _selectItemController;
  late final FormController _formController;

  final GlobalKey _textKey = GlobalKey();

  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    path = widget.path;
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    //initializeController();

    //onControllerChange();

    _selectItemController = Get.find<SelectItemController>();

    _formController = Get.find<FormController>();

    _enableEventReceiver();
  }

  /*Future <void> onControllerChange () async {
    if (_controller == null) { //if current controller is null
      initializeController(); //method to initialize your video controller
    } else {
      final oldController = _controller;
      await oldController.dispose();
      initializeController();
    }
  }
  initializeController () {
    path = widget.path;
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      _setLoginInfo();
      _setImage();
      _setText();
      firstTime = false;
    }
  }

  void _handlePinchUpdate(ScaleUpdateDetails details, _DraggableText text) {
    setState(() {
      text.scale = details.scale;
    });
  }

  void _setLoginInfo() {
    if (widget.data != null) {
      var countG = Platform.isAndroid
          ? 550
          : 540.0;
      var count = Platform.isAndroid
          ? 570
          : 550.0;
      widget.data.forEach((index, value) {
        print(value);
        if (index != '_id' &&
            index != 'userId' &&
            index != '__v' &&
            index != 'createdAt' &&
            index != 'updatedAt') {
          if ((index == 'foto' || index == 'logo') && value != null) {
            _paths.add(value);
          } else {
            if (index == 'nombreAsesor' &&
                _formController.showNombreAsesor.value) {
              countG = Platform.isAndroid
                  ? countG + 10
                  : countG + 10;
              count =
                  Platform.isAndroid ? count + 10 : count + 10;
              _texts.add(_DraggableText(
                  text: value,
                  size: 28,
                  x: Platform.isAndroid
                      ? 360
                      : 360,
                  y: Platform.isAndroid
                      ? 1180
                      : 1180,
                  xG: Platform.isAndroid
                      ? 150
                      : 150,
                  yG: Platform.isAndroid
                      ? 545
                      : 545));
            }
            if (index == 'telefono' && _formController.showTelefono.value) {
              countG = Platform.isAndroid
                  ? countG + 10
                  : countG + 10;
              count =
                  Platform.isAndroid ? count + 10 : count + 10;
              _texts.add(_DraggableText(
                  text: value,
                  size: 28,
                  x: Platform.isAndroid
                      ? 450
                      : 450,
                  y: Platform.isAndroid
                      ? 1200
                      : 1200,
                  xG: Platform.isAndroid
                      ? 150
                      : 150,
                  yG: Platform.isAndroid
                      ? 560
                      : 560));
            }
          }
        }
      });
    }
  }

  void _setText() async {
    if (_formController.title.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.title.value,
          size: 10,
          x: Platform.isAndroid
              ? 300
              : 400,
          y: Platform.isAndroid
              ? 120
              : 120,
          xG: Platform.isAndroid
              ? 150
              : 200,
          yG: Platform.isAndroid
              ? 100
              : 100));
    }
    if (_formController.subtitle.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.subtitle.value,
          size: 10,
          x: Platform.isAndroid
              ? 300
              : 200,
          y: Platform.isAndroid
              ? 140
              : 140,
          xG: Platform.isAndroid
              ? 150
              : 200,
          yG: Platform.isAndroid
              ? 110
              : 110));
    }
    if (_formController.price.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.price.value,
          size: 10,
          x: Platform.isAndroid
              ? 680
              : 680,
          y: Platform.isAndroid
              ? 1160
              : 1140,
          xG: Platform.isAndroid
              ? 340
              : 340,
          yG: Platform.isAndroid
              ? 560
              : 560));
    }
    if (_formController.amountRooms.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.amountRooms.value,
          size: 10,
          x: Platform.isAndroid
              ? 350
              : 350,
          y: Platform.isAndroid
              ? 1090
              : 1060,
          xG: Platform.isAndroid
              ? 150
              : 170,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.amountBathRooms.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.amountBathRooms.value,
          size: 10,
          x: Platform.isAndroid
              ? 460
              : 460,
          y: Platform.isAndroid
              ? 1090
              : 1060,
          xG: Platform.isAndroid
              ? 205
              : 225,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.amountGarages.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.amountGarages.value,
          size: 10,
          x: Platform.isAndroid
              ? 570
              : 600,
          y: Platform.isAndroid
              ? 1090
              : 1060,
          xG: Platform.isAndroid
              ? 260
              : 280,
          yG: Platform.isAndroid
              ? MediaQuery.of(context).size.height * 0.62
              : 530));
    }
    if (_formController.metersBuilt.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.metersBuilt.value,
          size: 10,
          x: Platform.isAndroid
              ? 340
              : 360,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 315
              : 335,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.totalMeters.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.totalMeters.value,
          size: 10,
          x: Platform.isAndroid
              ? 395
              : 420,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 370
              : 390,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    /*if (_formController.refNumber.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.refNumber.value,
          color: Colors.black,
          size: 10,
          x: 310,
          y: 470));
    }*/
    if (_formController.kilometers.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.kilometers.value,
          size: 10,
          x: Platform.isAndroid
              ? 175
              : 175,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 150
              : 170,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.fuel.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.fuel.value,
          size: 10,
          x: Platform.isAndroid
              ? 230
              : 230,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 205
              : 225,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.gearbox.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.gearbox.value,
          size: 10,
          x: Platform.isAndroid
              ? 285
              : 300,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 260
              : 280,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.year.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.year.value,
          size: 10,
          x: Platform.isAndroid
              ? 340
              : 360,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 315
              : 335,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
    if (_formController.enginePower.value.isNotEmpty) {
      _texts.add(_DraggableText(
          text: _formController.enginePower.value,
          size: 10,
          x: Platform.isAndroid
              ? 395
              : 420,
          y: Platform.isAndroid
              ? 545
              : 530,
          xG: Platform.isAndroid
              ? 370
              : 390,
          yG: Platform.isAndroid
              ? 530
              : 530));
    }
  }

  void _setImage() async {
    final bytes =
        (await rootBundle.load(widget.pathImage)).buffer.asUint8List();

    img.Image? img1 = img.decodeImage(bytes!);
    img.Image resized = Platform.isAndroid
        ? img.copyResize(img1!,
            // Imagen background en video ya guardado
            width: 720,
            height: 1280)
        : img.copyResize(img1!, width: 720, height: 1280);
    final resizedImg = Uint8List.fromList(img.encodePng(resized));

    final tempImageFile = await _createTempFile(resizedImg);
    _images.add(DraggableResizableItem(
      image: resizedImg,
      x: Platform.isAndroid
          ? 0
          : 0,
      y: Platform.isAndroid
          ? 0
          : 0,
      xG: Platform.isAndroid ? 0 : 0,
      yG: Platform.isAndroid ? 0 : 0,
      child: Image.file(
        File(tempImageFile.path),
        // Imagen background preview
        width: Platform.isAndroid ? 420 : 480,
        height: Platform.isAndroid ? 600 : 600,
        fit: BoxFit.fill,
      ),
    ));
    setState(() {});
    if (_paths.isNotEmpty) {
      var index = 0;
      for (var p in _paths) {
        final bytes = (await NetworkAssetBundle(Uri.parse(p)).load(p))
            .buffer
            .asUint8List();
        img.Image? img1 = img.decodeImage(bytes!);
        img.Image resized = Platform.isAndroid
            ? img.copyResize(img1!,
                width: 145,
                height:
                    120)
            : img.copyResize(img1!, width: 145, height: 120);
        final resizedImg = Uint8List.fromList(img.encodePng(resized));
        _images.add(DraggableResizableItem(
          image: resizedImg,
          x: index == 0
              ? Platform.isAndroid // X de Lays
                  ? 535
                  : 535
              : Platform.isAndroid // X de Usuario
                  ? 50
                  : 50,
          y: index == 0
              ? Platform.isAndroid // Y de Lays
                  ? 80
                  : 80
              : Platform.isAndroid // Y de usuario
                  ? 1100
                  : 1100,
          xG: index == 0
              ? Platform.isAndroid
                  ? 290
                  : 290
              : Platform.isAndroid
                  ? 10
                  : 10,
          yG: index == 0
              ? Platform.isAndroid
                  ? 0
                  : 30
              : Platform.isAndroid
                  ? 450
                  : 450,
          child: Image(
            image: NetworkImage(p),
            width: Platform.isAndroid ? 150 : 150,
            height: Platform.isAndroid ? 150 : 150,
            fit: BoxFit.contain,
          ),
        ));
        index++;
        setState(() {});
      }
    }
    setState(() {
      loadedImages = true;
    });
  }

  void saveVideo(Size size, {bool saveVideo = true}) async {
    int index = 0;
    await _pickVideo();
    var tempDir = await getTemporaryDirectory();
    var path =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';

    var indice = 1;

    List<TapiocaBall> tapiocaBalls = [];

    File videotmp = File(path);
    var path1 =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
    if ((_texts.length <= 1 && _images.length <= 1)) {
      for (var image in _images) {
        if (Platform.isAndroid) {
          tapiocaBalls.add(TapiocaBall.imageOverlay(
              image.image, image.x.toInt(), image.y.toInt()));
        } else {
          tapiocaBalls.add(TapiocaBall.imageOverlay(
              image.image,
              image.x.isNegative
                  ? size.width.toInt() - 100
                  : (image.x + 100) < (size.width / 2)
                      ? ((image.x + (size.width / 2)).toInt())
                      : (image.x).toInt() > size.width / 3
                          ? 0
                          : ((image.x).toInt() - 100),
              image.y.isNegative
                  //ARRIBA
                  ? size.height.toInt() + 250
                  : (image.y - size.height).isNegative
                      //ABAJO
                      ? size.height.toInt() - image.y.toInt() + 100
                      : (image.y - size.height).toInt()));
        }
      }
      for (var texto in _texts) {
        tapiocaBalls.add(TapiocaBall.textOverlay(texto.text, texto.x.toInt(),
            texto.y.toInt(), texto.size.toInt(), texto.color));
      }

      var cup = Cup(Content(_video.path), tapiocaBalls);

      await cup.suckUp(path).then((_) async {
        print('exito');
      }).catchError((e) {
        print('Got error:');
      });

      if (saveVideo) {
        GallerySaver.saveVideo(path).then((bool? success) {
          debugPrint(success.toString());
        });
      } else {
        Share.shareFiles([path], subject: 'video');
      }
    } else {
      for (var image in _images) {
        if (tapiocaBalls.isNotEmpty) tapiocaBalls.clear();
        if (Platform.isAndroid) {
          tapiocaBalls.add(TapiocaBall.imageOverlay(
              image.image, image.x.toInt(), image.y.toInt()));
        } else {
          tapiocaBalls.add(TapiocaBall.imageOverlay(
              image.image,
              image.x.isNegative
                  ? size.width.toInt() - 100
                  : (image.x + 100) < (size.width / 2)
                      ? ((image.x + (size.width / 2)).toInt())
                      : (image.x).toInt() > size.width / 3
                          ? 0
                          : ((image.x).toInt() - 100),
              image.y.isNegative
                  //ARRIBA
                  ? size.height.toInt() + 250
                  : (image.y - size.height).isNegative
                      //ABAJO
                      ? size.height.toInt() - image.y.toInt() + 100
                      : (image.y - size.height).toInt()));
        }

        if (indice == 1) {
          var cup = Cup(Content(_video.path), tapiocaBalls);

          await cup.suckUp(path).then((_) async {
            print('exito');
          }).catchError((e) {
            print('Got error:');
          });
          videotmp = File(path);
          path1 =
              '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
        } else {
          var cup1 = Cup(Content(videotmp.path), tapiocaBalls);

          await cup1.suckUp(path1).then((_) async {
            print('exito');
          }).catchError((e) {
            print('Got error:');
          });

          if ((_texts.isEmpty && indice < _images.length) ||
              _texts.isNotEmpty) {
            videotmp = File(path1);
            path1 =
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
          }
        }

        indice++;
      }

      indice = 1;

      for (var texto in _texts) {
        if (tapiocaBalls.isNotEmpty) tapiocaBalls.clear();
        tapiocaBalls.add(TapiocaBall.textOverlay(texto.text, texto.x.toInt(),
            texto.y.toInt(), texto.size.toInt(), texto.color));

        if (indice == 1 && _images.isEmpty) {
          var cup = Cup(Content(_video.path), tapiocaBalls);

          await cup.suckUp(path).then((_) async {
            print('exito');
          }).catchError((e) {
            print('Got error:');
          });
          videotmp = File(path);
          path1 =
              '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
        } else {
          var cup1 = Cup(Content(videotmp.path), tapiocaBalls);

          await cup1.suckUp(path1).then((_) async {
            print('exito');
          }).catchError((e) {
            print('Got error:');
          });

          if (indice < _texts.length) {
            videotmp = File(path1);
            path1 =
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
          }
        }

        indice++;
      }

      if (saveVideo) {
        GallerySaver.saveVideo(path1).then((bool? success) {
          debugPrint(success.toString());
        });
      } else {
        Share.shareFiles([path1], subject: 'video');
      }
    }

    setState(() {
      isLoading = false;
      if (saveVideo) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DownloadedVideoScreen(
                      data: widget.data,
                    )));
      }
    });
  }

  Future<Uint8List> changeBackgroundOfImage(
      {required Uint8List bytes,
      required List<int> removeColorRGB,
      required List<int> addColorRGB}) async {
    img.Image image = img.decodeImage(bytes) as img.Image;
    img.Image newImage = await _customeColor(
        src: image, removeColorRGB: removeColorRGB, addColorRGB: addColorRGB);
    var newPng = img.encodePng(newImage);
    return newPng;
  }

  Future<img.Image> _customeColor(
      {required img.Image src,
      required List<int> removeColorRGB,
      required List<int> addColorRGB}) async {
    var pixels = src.getBytes();
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      if (pixels[i] == removeColorRGB[0] &&
          pixels[i + 1] == removeColorRGB[1] &&
          pixels[i + 2] == removeColorRGB[2]) {
        pixels[i] = addColorRGB[0];
        pixels[i + 1] = addColorRGB[1];
        pixels[i + 2] = addColorRGB[2];
      }
    }

    return src;
  }

  void _showTextInputDialog(BuildContext context) {
    String text = '';
    double size = 24;
    Color color = Colors.black;
    showGeneralDialog(
      barrierColor: const Color(0xff1A212B).withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      barrierLabel: "",
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
        return SlideTransition(
          position:
              tween.animate(anim.drive(CurveTween(curve: Curves.easeOutCubic))),
          child: child,
        );
      },
      barrierDismissible: true,
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: AppColors.black,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ingrese el texto',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextField(
                      onChanged: (value) {
                        text = value;
                      },
                    ),
                    Text(
                      'Ingrese el tamaño',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextField(
                      onChanged: (value) {
                        size = double.tryParse(value) ?? 24;
                      },
                    ),
                    DialogWidget(onChange: (value) {
                      color = value;
                    }),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            //_texts.clear();
                            _texts.add(_DraggableText(
                                text: text, color: color, size: size));
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disableEventReceiver();
  }

  void _enableEventReceiver() {
    _streamSubscription =
        _channel.receiveBroadcastStream().listen((dynamic event) {
      setState(() {
        print(processPercentage);
        processPercentage = (event.toDouble() * 100).round();
      });
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, cancelOnError: true);
  }

  void _disableEventReceiver() {
    _streamSubscription.cancel();
  }

  _pickVideo() async {
    try {
      XFile? video = widget.video;
      if (video != null) {
        var tempDir = await getTemporaryDirectory();
        setState(() {
          _video = video;
          isLoading = true;
        });

        // Redimensionar el video a 720x1280
        final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
        String outputFilePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}resized.mp4';

        int rc = await _flutterFFmpeg.execute(
            '-i ${_video.path} -vf "scale=720:1280" $outputFilePath');

        if (rc == 0) {
          // La redimensión fue exitosa, utiliza el nuevo archivo de video
          _video = XFile(outputFilePath);
        } else {
          // La redimensión falló, utiliza el archivo original
          debugPrint('Error al redimensionar el video');
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _getImageFromGallery() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final imageBytes = await imageFile.readAsBytes();
      img.Image? img1 = img.decodeImage(imageBytes!);
      img.Image resized = Platform.isAndroid
          ? img.copyResize(
              img1!,
              width: 150,
              height: 150,
            )
          : img.copyResize(img1!, width: 150, height: 150);

      final resizedImg = Uint8List.fromList(img.encodePng(resized));

      final tempImageFile = await _createTempFile(resizedImg);
      setState(() {
        _images.add(DraggableResizableItem(
          image: resizedImg,
          x: Platform.isAndroid ? 10 : MediaQuery.of(context).size.width * 0.1,
          y: Platform.isAndroid ? 10 : MediaQuery.of(context).size.width * 0.1,
          child: Image.file(
            File(tempImageFile.path),
            width: Platform.isAndroid
                ? MediaQuery.of(context).size.width * 0.2
                : 150,
            height: Platform.isAndroid
                ? MediaQuery.of(context).size.height * 0.2
                : 150,
            fit: BoxFit.contain,
          ),
        ));
      });
    }
  }

  void _handlePanUpdate(
      DragUpdateDetails details, DraggableResizableItem item, Size size) {
    setState(() {
      item.x += details.delta.dx / 2;
      //item.xG += size.width + details.delta.dx;
      item.xG += details.delta.dx;
      item.y += details.delta.dy / 2;
      item.yG += details.delta.dy;
      //item.yG += size.height + details.delta.dy;
    });
  }

  Future<File> _createTempFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}tempfile.jpg');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  /*void postFrameCallback(_) {
    RenderBox _cardBox =
        _textKey.currentContext!.findRenderObject() as RenderBox;
    textSize = _cardBox.size;
  }*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //SchedulerBinding.instance?.addPostFrameCallback(postFrameCallback);
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        centerTitle: true,
        title: Text(
          'Editor',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _controller.value.isInitialized || widget.isSavedVideo
                ? Expanded(
                    child: Stack(
                      //fit: StackFit.expand,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(key: _textKey, _controller),
                        ),
                        /*ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Positioned(
                            left: _images[0].x,
                            top: _images[0].y,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                _handlePanUpdate(details, _images[0], textSize);
                              },
                              child: _images[0].child,
                            ),
                          ),
                        ),*/
                        for (int i = 0; i < _images.length; i++) ...[
                          if (i == 0) ...[
                            Positioned(
                              left: Platform.isAndroid ? _images[i].xG : 0,
                              top: Platform.isAndroid ? _images[i].yG : 50,
                              child: _images[i].child,
                            ),
                          ] else ...[
                            Positioned(
                              left: _images[i].xG,
                              top: _images[i].yG,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  _handlePanUpdate(details, _images[i], size);
                                },
                                child: _images[i].child,
                              ),
                            ),
                          ]
                        ],
                        for (final text in _texts)
                          Positioned(
                            left: text.xG,
                            top: text.yG,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  text.x += details.delta.dx;
                                  text.y += details.delta.dy;
                                  text.xG += details.delta.dx;
                                  text.yG += details.delta.dy;
                                });
                              },
                              child: SizedBox(
                                child: Text(
                                  text.text,
                                  // style: TextStyle(fontSize: 40 * text.scale,color:text.color ),
                                  style: TextStyle(
                                      fontSize: text.size, color: text.color),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: isLoading
                      ? const Column(mainAxisSize: MainAxisSize.min, children: [
                          CircularProgressIndicator(
                            color: AppColors.appColor1,
                          ),
                          SizedBox(height: 10),
                          /*Platform.isAndroid
                              ? Text("$processPercentage%",
                                  style: const TextStyle(
                                      fontSize: 20, color: AppColors.appColor1))
                              : const SizedBox.shrink(),*/
                        ])
                      : SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child: const Text("Guardar"),
                                onPressed: !loadedImages
                                    ? null
                                    : () async {
                                        saveVideo(size, saveVideo: true);
                                      },
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                child: const Text("Compartir"),
                                onPressed: () async {
                                  saveVideo(size, saveVideo: false);
                                },
                              ),
                            ],
                          ),
                        )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    _showTextInputDialog(context);
                  },
                  child: const Icon(Icons.text_fields),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    setState(() {
                      if (!_controller.value.isPlaying &&
                          _controller.value.isInitialized &&
                          (_controller.value.duration ==
                              _controller.value.position)) {
                        _controller.initialize();
                        _controller.play();
                      } else {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      }
                    });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: _getImageFromGallery,
                  child: const Icon(Icons.image),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DraggableText {
  String text;
  double x;
  double xG;
  double y;
  double yG;
  double scale;
  Color color;
  double size;

  _DraggableText({
    required this.text,
    this.x = 0,
    this.xG = 0,
    this.y = 0,
    this.yG = 0,
    this.scale = 1.0,
    this.color = AppColors.white,
    required this.size,
  });
}

class DraggableResizableItem {
  final Widget child;
  double x; // se usa para guardarlo
  double xG; //se usa para mostrar en pantalla
  double y;
  double yG;
  double scale;
  Uint8List image;

  DraggableResizableItem({
    required this.child,
    this.x = 0,
    this.xG = 0,
    this.y = 0,
    this.yG = 0,
    this.scale = 1.0,
    required this.image,
  });
}

class DialogWidget extends StatefulWidget {
  final Function(Color color) onChange;

  const DialogWidget({super.key, required this.onChange});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  int color = 0;
  List<Color> colors = [Colors.black, Colors.white];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile(
            title: const Text(
              'Negro',
              style: TextStyle(color: AppColors.white),
            ),
            value: 0,
            groupValue: color,
            activeColor: AppColors.appColor1,
            onChanged: (value) {
              color = value ?? 0;
              widget.onChange(colors[value ?? 0]);
              setState(() {});
            }),
        RadioListTile(
            title: const Text(
              'Blanco',
              style: TextStyle(color: AppColors.white),
            ),
            value: 1,
            groupValue: color,
            activeColor: AppColors.appColor1,
            onChanged: (value) {
              color = value ?? 0;
              widget.onChange(colors[value ?? 0]);
              setState(() {});
            }),
      ],
    );
  }
}
