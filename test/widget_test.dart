// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ai_therapy/Controllers/auth_controller.dart';
import 'package:ai_therapy/Services/auth_local_store.dart';
import 'package:ai_therapy/Services/auth_service.dart';
import 'package:ai_therapy/screens/auth/signin/signin_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUpAll(() async {
    Get.testMode = true;
    final store = InMemoryAuthLocalStore();
    final authService = AuthService(store: store);
    Get.put(AuthController(authService: authService, store: store), permanent: true);
  });

  tearDownAll(() {
    Get.reset();
  });

  testWidgets('Sign in screen renders key fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: SignInScreen(),
      ),
    );

    expect(find.text('Sign In To freud.ai'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
