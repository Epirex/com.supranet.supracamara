import 'package:flutter/material.dart';
import 'package:video_editors/controllers/select_item_controller.dart';
import 'package:video_editors/screens/form_screen.dart';
import 'package:get/get.dart';
import 'package:video_editors/screens/login_screen.dart';
import '../themes/colors.dart';

class SelectItemScreen extends StatefulWidget {
  const SelectItemScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<SelectItemScreen> createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  String? category; //no radio button will be selected

  late final SelectItemController _selectItemController;

  bool showButtonCloseSesion = false ;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              setState(() {
                showButtonCloseSesion = !showButtonCloseSesion;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          showButtonCloseSesion ?
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10, right: 20.0, left: 20.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.black)
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                      (_) => false,);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ) : const SizedBox.shrink(),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "¡Comencemos un nuevo projecto!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child:
                      Text("Escoge una opción: ", style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        _selectItemController.setList("inmobiliarias");
                        _selectItemController.category("inmobiliarias");
                        setState(() {
                          category = "inmobiliarias";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FormScreen(
                                      data:
                                          widget.data,
                                    )));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.house, size: 100),
                          Text("Inmobiliarias",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        _selectItemController.setList("automoviles");
                        _selectItemController.category("automoviles");
                        setState(() {
                          category = "automoviles";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FormScreen(
                                      data:
                                          widget.data,
                                    )));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.directions_car_filled, size: 100),
                          Text("Venta de autos",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
