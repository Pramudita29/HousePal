import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/presentation/view/seeker/seeker_job_details_view.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockJobPostingBloc extends MockBloc<JobPostingEvent, JobPostingState>
    implements JobPostingBloc {}

void main() {
  late MockJobPostingBloc mockJobPostingBloc;
  final tJob = JobPosting(
    jobId: '1',
    jobTitle: 'Test Job',
    jobDescription: '',
    datePosted: DateTime.now(),
    status: 'Open',
    category: 'Cleaning',
    subCategory: '',
    location: '',
    salaryRange: '',
    contractType: '',
    applicationDeadline: DateTime.now(),
    contactInfo: '',
    posterFullName: '',
    posterEmail: 'test@example.com',
    posterImage: '',
  );

  setUp(() {
    mockJobPostingBloc = MockJobPostingBloc();
  });

  testWidgets('shows delete confirmation dialog on delete button tap',
      (tester) async {
    when(() => mockJobPostingBloc.state).thenReturn(const JobPostingState());
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<JobPostingBloc>.value(
        value: mockJobPostingBloc,
        child: SeekerJobDetailsView(job: tJob),
      ),
    ));

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm Deletion'), findsOneWidget);
  });
}
