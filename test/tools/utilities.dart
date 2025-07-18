import 'exports.dart';

Future<void> setupUnitsTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
}

Future pumpWidget(
  Widget widget,
  final WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 100),
  EnginePhase phase = EnginePhase.sendSemanticsUpdate,
  Duration timeout = const Duration(minutes: 10),
}) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(duration, phase, timeout);
}

Future pumpAction(
  Function? action,
  final WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 100),
  EnginePhase phase = EnginePhase.sendSemanticsUpdate,
  Duration timeout = const Duration(minutes: 10),
}) async {
  if (action == null) return;
  await action();
  await tester.pumpAndSettle(duration, phase, timeout);
}

Future pumpTap(
  Finder finder,
  final WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 100),
  EnginePhase phase = EnginePhase.sendSemanticsUpdate,
  Duration timeout = const Duration(minutes: 10),
}) async {
  await tester.tap(finder);
  await tester.pumpAndSettle(duration, phase, timeout);
}

Widget getWidgetByType<T extends Widget>() {
  return find.byType(T).evaluate().first.widget;
}

T getWidgetByTypeAndKey<T extends Widget>({required final dynamic key}) {
  return find.byKey(Key(key)).evaluate().first.widget as T;
}
