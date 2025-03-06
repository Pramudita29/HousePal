import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job_application/presentation/view/helper/job_details_view.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockJobApplicationBloc
    extends MockBloc<JobApplicationEvent, JobApplicationState>
    implements JobApplicationBloc {}

void main() {
  late MockJobApplicationBloc mockJobApplicationBloc;
  final tJob = JobPosting(
    jobId: '1',
    jobTitle: 'Test Job',
    jobDescription: '',
    datePosted: DateTime.now(),
    status: '',
    category: '',
    subCategory: '',
    location: '',
    salaryRange: '',
    contractType: '',
    applicationDeadline: DateTime.now(),
    contactInfo: '',
    posterFullName: '',
    posterEmail: '',
    posterImage: '',
  );

  setUp(() {
    mockJobApplicationBloc = MockJobApplicationBloc();
  });

  testWidgets('triggers apply event on button tap', (tester) async {
    when(() => mockJobApplicationBloc.state)
        .thenReturn(const JobApplicationState(
      isLoading: false,
      isSuccess: false,
      errorMessage: '',
    ));
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<JobApplicationBloc>.value(
        value: mockJobApplicationBloc,
        child: JobDetailsView(job: tJob),
      ),
    ));

    await tester.tap(find.text('Apply for this Job'));
    await tester.pump();

    verify(() => mockJobApplicationBloc.add(const ApplyForJobEvent('1')))
        .called(1);
  });
}
