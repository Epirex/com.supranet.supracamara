import 'package:flutter/material.dart';
import 'package:video_editors/controllers/select_item_controller.dart';
import 'package:get/get.dart';
import 'package:video_editors/screens/select_item_screen.dart';

class DownloadedVideoScreen extends StatefulWidget {
  DownloadedVideoScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<DownloadedVideoScreen> createState() => _DownloadedVideoScreenState();
}

class _DownloadedVideoScreenState extends State<DownloadedVideoScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Center(
              child: Text(
                "¡Buenísimo!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Text("El video se ha descargado\ncorrectamente",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 80,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectItemScreen(
                                data: widget.data,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: const Text('Comenzar nuevo proyecto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
