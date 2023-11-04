import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_editors/controllers/select_item_controller.dart';
import 'package:video_editors/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../themes/colors.dart';
import '../utils/route.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';


class SelectActionScreen extends StatefulWidget {
  SelectActionScreen(
      {super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<SelectActionScreen> createState() => _SelectActionScreenState();
}

class _SelectActionScreenState extends State<SelectActionScreen> {
  String? gender; //no radio button will be selected

  late final SelectItemController _selectItemController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectItemController =
        Get.put<SelectItemController>(SelectItemController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: AppColors.appColor1,
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Theme(
                data: ThemeData(
                  //canvasColor: Colors.yellow,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColors.appColor1,
                    background: AppColors.appColor1,
                    secondary: AppColors.appColor1,
                  ),
                ),
                child: Stepper(
                  controlsBuilder: (context, controller) {
                    return const SizedBox.shrink();
                  },
                  elevation: 0,
                  type: StepperType.horizontal,
                  physics: const ScrollPhysics(),
                  currentStep: 0,
                  steps: const <Step>[
                    Step(
                      title: Text(''),
                      content: SizedBox(),
                      isActive: false,
                      state: StepState.complete ,
                      label: Text('Crear zócalo',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,)),
                    ),
                    Step(
                      title: Text(''),
                      content: SizedBox(),
                      isActive: false,
                      state: StepState.complete,
                      label: Text('Datos adicionales',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,)),
                    ),
                    Step(
                      title: Text(''),
                      content: SizedBox(),
                      isActive: true,
                      state: StepState.indexed,
                      label: Text('Subir video',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,)),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text (
                  "Selecciona una opción: ",
                  style: TextStyle(fontSize: 15)
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    setState(() {
                      gender = "subir";
                    });
                    _getVideoFromGallery();
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.upload_file, size: 100),
                      Text (
                          "Subir video",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      gender = "grabar";
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              data: widget
                                  .data,
                            )));
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.video_call, size: 100),
                      Text (
                          "Grabar video",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getVideoFromGallery() async {
    final videoFile =
    await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      final imageBytes = await videoFile.readAsBytes();
      final tempImageFile = await _createTempFile(imageBytes);
      Navigator.push(
          context,
          ruta(
              EditorScreenTest(
                path: tempImageFile.path,
                video: videoFile,
                pathImage: _selectItemController.imageSelected.value,
                data: widget.data,
                isSavedVideo: true,
              ),
              const Offset(0, 2)));
    }
  }

  Future<File> _createTempFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}tempfile.jpg');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }
}