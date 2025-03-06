import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/job/presentation/view/seeker/add_task_view.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockJobPostingBloc extends MockBloc<JobPostingEvent, JobPostingState>
    implements JobPostingBloc {}

void main() {
  late MockJobPostingBloc mockJobPostingBloc;

  setUp(() async {
    mockJobPostingBloc = MockJobPostingBloc();
    SharedPreferences.setMockInitialValues(
        {'fullName': 'John Doe', 'email': 'test@example.com'});
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<JobPostingBloc>.value(
        value: mockJobPostingBloc,
        child: const AddTaskView(),
      ),
    );
  }

  testWidgets('submits job posting with valid input', (tester) async {
    when(() => mockJobPostingBloc.state).thenReturn(const JobPostingState());
    await tester.pumpWidget(buildTestWidget());

    await tester.enterText(find.byType(TextFormField).at(0), 'Test Job');
    await tester.enterText(find.byType(TextFormField).at(1), 'Details');
    await tester.enterText(find.byType(TextFormField).at(2), 'Location');
    await tester.enterText(find.byType(TextFormField).at(3), '1000-2000');
    await tester.enterText(find.byType(TextFormField).at(4), 'Contact');
    await tester.tap(find.text('Post Job'));
    await tester.pump();

    verify(() =>
            mockJobPostingBloc.add(any(that: isA<CreateJobPostingEvent>())))
        .called(1);
  });
}
