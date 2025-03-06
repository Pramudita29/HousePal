import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/notification/presentation/view/notification_view.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationBloc
    extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

void main() {
  late MockNotificationBloc mockNotificationBloc;

  setUp(() {
    mockNotificationBloc = MockNotificationBloc();
  });

  testWidgets('shows notifications when loaded', (tester) async {
    when(() => mockNotificationBloc.state).thenReturn(const NotificationState(
      isLoading: false,
      notifications: [],
    ));
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<NotificationBloc>.value(
        value: mockNotificationBloc,
        child: const NotificationView(),
      ),
    ));

    expect(find.text('No notifications available'), findsOneWidget);
  });
}
