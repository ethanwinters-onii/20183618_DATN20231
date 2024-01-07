import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/event_model/event_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';

class EventController extends BaseController {
  final accountLocal = AccountLocalHelper.get();

  RxList<EventModel> eventWillParticipate = <EventModel>[].obs;
  RxList<EventModel> eventMayBe = <EventModel>[].obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    getEventWillParticipate();
    getEventMayBe();
    setStatus(Status.success);
    return super.initialData();
  }

  void getEventWillParticipate() async {
    final result =
        await FirebaseProvider.getEventParticipate(accountLocal.userId ?? "");
    if (result != null && result.isNotEmpty) {
      eventWillParticipate.addAll(result);
    }
  }

  void getEventMayBe() async {
    final result =
        await FirebaseProvider.getOtherEvents(accountLocal.userId ?? "");
    if (result != null && result.isNotEmpty) {
      eventMayBe.addAll(result);
    }
  }

  void handleParticipateEvent(EventModel event) async {
    await FirebaseProvider.updateInterestedEvent(
        event, accountLocal.userId ?? "");
    eventMayBe.remove(event);
    eventWillParticipate.add(event);
  }

  void handleDeclineEvent(EventModel event) async {
    await FirebaseProvider.updateInterestedEvent(
        event, accountLocal.userId ?? "");
    eventMayBe.add(event);
    eventWillParticipate.remove(event);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
