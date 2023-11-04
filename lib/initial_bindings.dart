import 'package:get/get.dart';
import 'package:video_editors/controllers/form_controller.dart';
import 'package:video_editors/controllers/select_item_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(() => SelectItemController());
    Get.put(() => FormController());
  }
}
