import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';

class EventDetailController extends BaseController {
  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
    return super.initialData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
