import 'package:get/get.dart';

class SelectItemController extends GetxController {

  var isHorizontal = false.obs;
  var category = "".obs;

  final List<String> carImages = [
    'assets/placeholder_auto_horizontal.png',
    'assets/placeholder_auto.png',
  ];

  final List<String> realStateImages = [
    'assets/placeholder_casa_horizontal.png',
    'assets/placeholder_casa.png',
  ];

  final listSelected = <String>[].obs;

  void setList(String r) {
    if (r == 'automoviles') {
      listSelected.value = List.of(carImages);
    } else {
      listSelected.value = List.of(realStateImages);
    }
    setImage(listSelected[1]);
  }

  var imageSelected = ''.obs;

  void setImage(String i) {
    imageSelected.value = i;
  }

  void setMode(bool b) {
    isHorizontal.value = b;
    if (isHorizontal.value) {
      setImage(listSelected[0]);
    } else {
      setImage(listSelected[1]);
    }
  }
}
