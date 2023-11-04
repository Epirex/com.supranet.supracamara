import 'package:get/get.dart';

class FormController extends GetxController {
  RxString title = "".obs;
  RxString subtitle = "".obs;
  RxString address = "".obs;
  RxString price = "".obs;
  RxString amountRooms = "".obs;
  RxString amountBathRooms = "".obs;
  RxString amountGarages = "".obs;
  RxString metersBuilt = "".obs;
  RxString totalMeters = "".obs;
  RxString refNumber = "".obs;
  RxString kilometers = "".obs;
  RxString fuel = "".obs;
  RxString gearbox = "".obs;
  RxString year = "".obs;
  RxString enginePower = "".obs;

  RxBool showLogo = true.obs;
  RxBool showFotoPersonal = true.obs;
  RxBool showTelefono = true.obs;
  RxBool showLinkWeb = true.obs;
  RxBool showNombreEmpresa = true.obs;
  RxBool showNombreAsesor = true.obs;
}