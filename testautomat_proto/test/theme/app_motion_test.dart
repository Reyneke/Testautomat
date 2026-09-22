// Bewegung: "Bewegung reduzieren" wird respektiert (E-24, U-71).

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/theme/app_motion.dart';

void main() {
  // Die Plattform-Merkmale kommen aus der Test-Bindung.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ohne reduzierte Bewegung sind Animationen erlaubt', () {
    expect(AppMotion.erlaubt(reduziert: false), isTrue);
  });

  test('mit reduzierter Bewegung sind Animationen gesperrt', () {
    expect(AppMotion.erlaubt(reduziert: true), isFalse);
  });

  test('der Testlauf meldet keine reduzierten Merkmale', () {
    // FakeAccessibilityFeatures ist standardmaessig aus.
    expect(
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .reduceMotion,
      isFalse,
    );
    expect(AppMotion.erlaubt(), isTrue);
  });
}
