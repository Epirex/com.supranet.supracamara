import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editors/controllers/form_controller.dart';
import 'package:video_editors/screens/select_action.dart';
import 'package:video_editors/utils/route.dart';
import '../themes/colors.dart';

class SelectAdditionalInfoScreen extends StatefulWidget {
  const SelectAdditionalInfoScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<SelectAdditionalInfoScreen> createState() => _SelectAdditionalInfoScreenState();
}

class _SelectAdditionalInfoScreenState extends State<SelectAdditionalInfoScreen> {

  late final FormController _formController;
  late bool isInmobiliaria;
  bool showLogo = true;
  bool showFotoPersonal = true;
  bool showTelefono = true;
  bool showLinkWeb = true;
  bool showNombreEmpresa = true;
  bool showNombreAsesor = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formController = Get.put<FormController>(FormController());
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
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
                          state: StepState.complete,
                          label: Text('Crear zócalo',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,)),
                        ),
                        Step(
                          title: Text(''),
                          content: SizedBox(),
                          isActive: true,
                          state: StepState.indexed,
                          label: Text('Datos adicionales',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,)),
                        ),
                        Step(
                          title: Text(''),
                          content: SizedBox(),
                          isActive:false,
                          state: StepState.disabled,
                          label: Text('Subir video',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,)),
                        ),
                      ],
                    ),
                  ),
                ),
                const Center(
                  child: Text (
                      "Elije si quieres ver en tu video lo siguiente: ",
                      style: TextStyle(fontSize: 15)
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Logo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switchLogoWidget(),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Foto personal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switchFotoPersonalWidget(),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Teléfono',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switchTelefonoWidget(),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Link web',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switchLinkWebWidget(),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nombre de la empresa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switchNombreEmpresaWidget(),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nombre de asesor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            //style: Theme.of(context).textTheme.titleLarge,
                          ),
                          switchNombreAsesorWidget(),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 20.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () async  {
                      _formController.showLogo.value = showLogo;
                      _formController.showFotoPersonal.value = showFotoPersonal;
                      _formController.showTelefono.value = showTelefono;
                      _formController.showLinkWeb.value = showLinkWeb;
                      _formController.showNombreEmpresa.value = showNombreEmpresa;
                      _formController.showNombreAsesor.value = showNombreAsesor;

                      await Navigator.push(
                          context,
                          ruta(
                              SelectActionScreen(
                                data: widget.data,
                              ),
                              const Offset(0, 2)));
                    },
                    child: const Text('Siguiente'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget switchLogoWidget() {
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: showLogo,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.appColor1,
        onChanged: (value) {
          print(value);
          setState(() {
            showLogo = value;
          });
        },
      ),
    );
  }

  Widget switchFotoPersonalWidget() {
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: showFotoPersonal,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.appColor1,
        onChanged: (value) {
          print(value);
          setState(() {
            showFotoPersonal = value;
          });
        },
      ),
    );
  }

  Widget switchTelefonoWidget() {
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: showTelefono,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.appColor1,
        onChanged: (value) {
          print(value);
          setState(() {
            showTelefono = value;
          });
        },
      ),
    );
  }

  Widget switchLinkWebWidget() {
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: showLinkWeb,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.appColor1,
        onChanged: (value) {
          print(value);
          setState(() {
            showLinkWeb = value;
          });
        },
      ),
    );
  }

  Widget switchNombreEmpresaWidget() {
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: showNombreEmpresa,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.appColor1,
        onChanged: (value) {
          print(value);
          setState(() {
            showNombreEmpresa = value;
          });
        },
      ),
    );
  }

  Widget switchNombreAsesorWidget() {
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: showNombreAsesor,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.appColor1,
        onChanged: (value) {
          print(value);
          setState(() {
            showNombreAsesor = value;
          });
        },
      ),
    );
  }

}