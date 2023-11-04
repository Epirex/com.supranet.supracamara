import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editors/controllers/form_controller.dart';
import 'package:video_editors/controllers/select_item_controller.dart';
import 'package:video_editors/screens/select_additional_info_screen.dart';
import 'package:video_editors/utils/route.dart';
import '../themes/colors.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountRoomsController = TextEditingController();
  TextEditingController amountBathRoomsController = TextEditingController();
  TextEditingController amountGaragesController = TextEditingController();
  TextEditingController metersBuiltController = TextEditingController();
  TextEditingController totalMetersController = TextEditingController();
  TextEditingController refNumberController = TextEditingController();
  TextEditingController kilometersController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController gearboxController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController enginePowerController = TextEditingController();

  late final FormController _formController;
  late final SelectItemController _selectItemController;
  late bool isInmobiliaria;

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectItemController = Get.find<SelectItemController>();
    isInmobiliaria = _selectItemController.category.value == 'inmobiliarias';
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Theme(
                    data: ThemeData(
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
                      type: stepperType,
                      physics: const ScrollPhysics(),
                      currentStep: _currentStep,
                      onStepTapped: (step) => tapped(step),
                      steps: <Step>[
                        Step(
                          title: const Text(''),
                          content: const SizedBox(),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 0
                              ? StepState.indexed
                              : StepState.disabled,
                          label: const Text('Crear zócalo',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Step(
                          title: new Text(''),
                          content: SizedBox(),
                          isActive: false,
                          state: StepState.disabled,
                          label: const Text('Datos adicionales',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Step(
                          title: new Text(''),
                          content: SizedBox(),
                          isActive: false,
                          state: StepState.disabled,
                          label: const Text('Subir video',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                      "Completa los siguientes datos de tu anuncio. Si no los completas, no aparecerán en el video: ",
                      style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isInmobiliaria) ...[
                        inputWidget(titleController, 'Título',
                            "Escribe el título", false),
                        inputWidget(subtitleController, 'Subtítulo',
                            "Escribe el subtítulo", false),
                        inputWidget(addressController, 'Dirección',
                            "Escribe la dirección", false),
                        inputWidget(priceController, 'Precio',
                            "Escribe el precio", true),
                        inputWidget(
                            amountRoomsController,
                            'Número de habitaciones',
                            "Escribe el número",
                            true),
                        inputWidget(amountBathRoomsController,
                            'Número de baños', "Escribe el número", true),
                        inputWidget(amountGaragesController,
                            'Número de cocheras', "Escribe el número", true),
                        inputWidget(metersBuiltController, 'Metros construidos',
                            "Escribe el número", true),
                        inputWidget(totalMetersController, 'Metros totales',
                            "Escribe el número", true),
                        inputWidget(refNumberController, 'Número de referencia',
                            "Escribe el número", true)
                      ] else ...[
                        inputWidget(titleController, 'Titulo',
                            "Escribe el titulo", false),
                        inputWidget(subtitleController, 'Subtitulo',
                            "Escribe el subtitulo", false),
                        inputWidget(priceController, 'Precio',
                            "Escribe el precio", true),
                        inputWidget(kilometersController, 'Kilometraje',
                            "Escribe el número", true),
                        inputWidget(fuelController, 'Combustible',
                            "Escribe el combustible que consume", true),
                        inputWidget(gearboxController, 'Caja de cambios',
                            "Escribe el tipo de caja de cambio", false),
                        inputWidget(
                            yearController, 'Año', "Escribe el número", true),
                        inputWidget(enginePowerController, 'Potencia del motor',
                            "Escribe el número", true),
                        inputWidget(addressController, 'Ubicación',
                            "Escribe la ubicación", false),
                        inputWidget(refNumberController, 'Número de referencia',
                            "Escribe el número", true),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20.0),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                          onPressed: () async {
                            if (isInmobiliaria) {
                              _formController.title.value =
                                  titleController.text;
                              _formController.subtitle.value =
                                  subtitleController.text;
                              _formController.address.value =
                                  addressController.text;
                              _formController.price.value =
                                  "\$ ${priceController.text}";
                              _formController.amountRooms.value =
                                  amountRoomsController.text;
                              _formController.amountBathRooms.value =
                                  amountBathRoomsController.text;
                              _formController.amountGarages.value =
                                  amountGaragesController.text;
                              _formController.metersBuilt.value =
                                  metersBuiltController.text;
                              _formController.totalMeters.value =
                                  totalMetersController.text;
                              _formController.refNumber.value =
                                  refNumberController.text;
                            } else {
                              _formController.title.value =
                                  titleController.text;
                              _formController.subtitle.value =
                                  subtitleController.text;
                              _formController.address.value =
                                  addressController.text;
                              _formController.price.value =
                                  "\$ ${priceController.text}";
                              _formController.kilometers.value =
                                  kilometersController.text;
                              _formController.fuel.value = fuelController.text;
                              _formController.gearbox.value =
                                  gearboxController.text;
                              _formController.year.value = yearController.text;
                              _formController.enginePower.value =
                                  enginePowerController.text;
                              _formController.refNumber.value =
                                  refNumberController.text;
                            }
                            await Navigator.push(
                                context,
                                ruta(
                                    SelectAdditionalInfoScreen(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget inputWidget(TextEditingController controller, String label,
      String hintText, bool isNumeric) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
          keyboardType: isNumeric
              ? const TextInputType.numberWithOptions(
                  signed: true, decimal: true)
              : TextInputType.text,
        ),
      ],
    );
  }
}
