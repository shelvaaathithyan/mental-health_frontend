import 'package:get/get.dart';

class AssessmentController extends GetxController {
  final Rx<String?> goalId = Rx<String?>(null);
  final Rx<String?> genderId = Rx<String?>(null);
  final RxBool genderSkipped = false.obs;
  final RxInt age = 18.obs;

  void selectGoal(String id) {
    goalId.value = id;
  }

  void selectGender(String? id) {
    genderId.value = id;
    genderSkipped.value = false;
  }

  void skipGender() {
    genderId.value = null;
    genderSkipped.value = true;
  }

  void updateAge(int value) {
    age.value = value;
  }

  bool get hasGoal => goalId.value != null;
  bool get hasGenderSelection => genderId.value != null;
  bool get hasGender => genderId.value != null || genderSkipped.value;
  bool get hasAge => age.value > 0;
}
