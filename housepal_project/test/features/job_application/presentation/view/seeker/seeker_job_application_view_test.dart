import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:housepal_project/features/job_application/presentation/view/seeker/seeker_job_application_view.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockJobPostingBloc extends MockBloc<JobPostingEvent, JobPostingState>
    implements JobPostingBloc {}

class MockJobApplicationBloc
    extends MockBloc<JobApplicationEvent, JobApplicationState>
    implements JobApplicationBloc {}

void main() {
  late MockJobPostingBloc mockJobPostingBloc;
  late MockJobApplicationBloc mockJobApplicationBloc;

  setUp(() {
    mockJobPostingBloc = MockJobPostingBloc();
    mockJobApplicationBloc = MockJobApplicationBloc();
  });

  testWidgets('shows loading indicator when applications are loading',
      (tester) async {
    when(() => mockJobPostingBloc.state).thenReturn(const JobPostingState());
    when(() => mockJobApplicationBloc.state)
        .thenReturn(const JobApplicationState(
      isLoading: true,
      isSuccess: false,
      errorMessage: '',
    ));
    await tester.pumpWidget(MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<JobPostingBloc>.value(value: mockJobPostingBloc),
          BlocProvider<JobApplicationBloc>.value(value: mockJobApplicationBloc),
        ],
        child: const SeekerJobApplicationsView(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
