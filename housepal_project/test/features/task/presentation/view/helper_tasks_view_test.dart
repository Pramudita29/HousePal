import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/task/presentation/view/helper_tasks_view.dart';
import 'package:housepal_project/features/task/presentation/view_model/task_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockAuthRemoteRepository extends Mock implements AuthRemoteRepository {}

void main() {
  late MockTaskBloc mockTaskBloc;
  late MockAuthRemoteRepository mockAuthRemoteRepository;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
    mockAuthRemoteRepository = MockAuthRemoteRepository();
    when(() => mockAuthRemoteRepository.getCurrentUser()).thenAnswer(
      (_) async => Right(AuthEntity(
        fullName: 'Test',
        email: 'test@example.com',
        contactNo: '',
        password: '',
        confirmPassword: '',
        role: '',
      )),
    );
  });

  testWidgets('shows tasks when loaded', (tester) async {
    when(() => mockTaskBloc.state).thenReturn(const TaskState(tasks: []));
    await tester.pumpWidget(MaterialApp(
      home: RepositoryProvider<AuthRemoteRepository>.value(
        value: mockAuthRemoteRepository,
        child: BlocProvider<TaskBloc>.value(
          value: mockTaskBloc,
          child: const HelperTasksView(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('No tasks assigned yet.'), findsOneWidget);
  });
}
