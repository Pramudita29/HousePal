import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/usecases/create_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/delete_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/filter_jobs_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/get_all_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/update_job_usecase.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:housepal_project/features/job_application/domain/usecases/apply_for_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/get_appication_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/update_application_usecase.dart';
import 'package:housepal_project/features/job_application/presentation/view/seeker/job_application_item.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';
import 'package:housepal_project/features/review/domain/usecases/get_helper_review_usecase.dart';
import 'package:housepal_project/features/review/domain/usecases/sumbit_review_usecase.dart';
import 'package:housepal_project/features/review/presentation/view_model/review_bloc.dart';
import 'package:housepal_project/features/task/domain/usecases/get_helper_task_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/get_seeker_bookings_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/update_task_status.dart';
import 'package:housepal_project/features/task/presentation/view_model/task_bloc.dart';
import 'package:http/http.dart' as http;

class SeekerJobApplicationsView extends StatefulWidget {
  const SeekerJobApplicationsView({super.key});

  @override
  State<SeekerJobApplicationsView> createState() =>
      _SeekerJobApplicationsViewState();
}

class _SeekerJobApplicationsViewState extends State<SeekerJobApplicationsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasFetchedApplications = false;
  late final JobApplicationBloc _jobApplicationBloc;
  final Set<String> _paidTasks = {};
  final Set<String> _ratedTasks = {};
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _jobApplicationBloc = JobApplicationBloc(
      applyForJobUseCase: getIt<ApplyForJobUseCase>(),
      getApplicationsForJobUseCase: getIt<GetApplicationsForJobUseCase>(),
      updateApplicationStatusUseCase: getIt<UpdateApplicationStatusUseCase>(),
      authRepo: getIt<AuthRemoteRepository>(),
    );
    _fetchUserData();
  }

  void _fetchUserData() {
    print('Fetching user data...');
    context.read<UserBloc>().add(const FetchUserEvent(''));
    context.read<UserBloc>().stream.listen((state) {
      if (state.user != null && !_isUserDataLoaded) {
        print('User data loaded: ${state.user!.email}');
        setState(() => _isUserDataLoaded = true);
      }
    });
  }

  void _fetchApplicationsForSeekerJobs(BuildContext context) {
    final jobState = context.read<JobPostingBloc>().state;
    final jobIds = jobState.jobPostings?.map((job) => job.jobId).toList() ?? [];
    print('Job IDs from JobPostingBloc: $jobIds');
    if (jobIds.isNotEmpty && !_hasFetchedApplications) {
      for (var jobId in jobIds) {
        print('Dispatching GetApplicationsForJobEvent for jobId: $jobId');
        _jobApplicationBloc.add(GetApplicationsForJobEvent(jobId));
      }
      _hasFetchedApplications = true;
    } else if (!_hasFetchedApplications) {
      print('No jobs found, using fallback jobId: 67c015a03f8627b3d9abd068');
      _jobApplicationBloc
          .add(const GetApplicationsForJobEvent('67c015a03f8627b3d9abd068'));
      _hasFetchedApplications = true;
    }
  }

  Future<void> _handlePayment(String taskId, String helperEmail, String jobId,
      String helperName) async {
    try {
      final jobState = context.read<JobPostingBloc>().state;
      int amount;
      String jobTitle = 'Unknown Job';
      String currency = 'NPR';

      if (jobState.jobPostings == null || jobState.jobPostings!.isEmpty) {
        amount = 2000 * 100; // 2000 NPR in paisa
      } else {
        final job = jobState.jobPostings!.firstWhere(
          (j) => j.jobId == jobId,
          orElse: () => JobPosting(
            jobId: jobId,
            jobTitle: jobTitle,
            jobDescription: '',
            datePosted: DateTime.now(),
            status: '',
            category: '',
            subCategory: '',
            location: '',
            salaryRange: '2000',
            contractType: '',
            applicationDeadline: DateTime.now(),
            contactInfo: '',
            posterFullName: '',
            posterEmail: '',
            posterImage: '',
          ),
        );
        jobTitle = job.jobTitle;
        amount = _parseSalary(job.salaryRange);
        currency = 'USD';
      }

      final amountDisplay = (amount / 100).toStringAsFixed(2);

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Payment Successful',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'You have paid $currency $amountDisplay to $helperName for "$jobTitle".'),
              const SizedBox(height: 16),
              const Text('Payment Details:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Amount: $currency $amountDisplay'),
              Text('Method: Credit Card (Visa ending in 1234)'),
              Text('Date: ${DateTime.now().toString().split('.')[0]}'),
              Text(
                  'Transaction ID: TXN${taskId.substring(0, 8).toUpperCase()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _paidTasks.add(taskId);
                });
                showMySnackBar(
                  context: context,
                  message:
                      'Payment of $currency $amountDisplay to $helperName completed!',
                  color: Colors.green,
                );
              },
              child: const Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );
    } catch (e) {
      showMySnackBar(
        context: context,
        message: 'Payment failed: $e',
        color: Colors.red,
      );
    }
  }

  int _parseSalary(String salaryRange) {
    final parts = salaryRange.split('-');
    final amountStr = parts.isNotEmpty ? parts[0].trim() : salaryRange;
    final amount =
        double.tryParse(amountStr.replaceAll(RegExp(r'[^\d.]'), '')) ?? 2000.0;
    return (amount * 100).toInt();
  }

  Future<String> _createPaymentIntent(int amount) async {
    final url =
        Uri.parse('http://192.168.1.68:3000/api/create-checkout-session');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'currency': 'usd',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['clientSecret'];
    } else {
      throw Exception('Failed to create payment intent: ${response.body}');
    }
  }

  void _submitReview(
    BuildContext context,
    String helperEmail,
    int rating,
    String? comment,
    String taskId,
    String seekerEmail,
    String seekerFullName,
    String? seekerImage,
  ) {
    final fullSeekerImage = seekerImage != null && seekerImage.isNotEmpty
        ? (seekerImage.startsWith('http')
            ? seekerImage
            : ApiEndpoints.imageUrl(seekerImage))
        : null;

    final reviewBloc = context.read<ReviewBloc>();
    reviewBloc.add(SubmitReviewEvent(
      helperEmail: helperEmail,
      seekerEmail: seekerEmail,
      seekerFullName: seekerFullName,
      seekerImage: fullSeekerImage,
      rating: rating,
      comment: comment,
      taskId: taskId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<JobPostingBloc>(
          create: (context) => JobPostingBloc(
            createJobPostingUseCase: getIt<CreateJobPostingUseCase>(),
            filterJobsUseCase: getIt<FilterJobsUseCase>(),
            getAllJobUseCase: getIt<GetAllJobUseCase>(),
            updateJobUseCase: getIt<UpdateJobUseCase>(),
            deleteJobUseCase: getIt<DeleteJobUseCase>(),
          ),
        ),
        BlocProvider<JobApplicationBloc>.value(value: _jobApplicationBloc),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            getHelperTasksUseCase: getIt<GetHelperTasksUseCase>(),
            getSeekerBookingsUseCase: getIt<GetSeekerBookingsUseCase>(),
            updateTaskStatusUseCase: getIt<UpdateTaskStatusUseCase>(),
          ),
        ),
        BlocProvider<ReviewBloc>(
          create: (context) => ReviewBloc(
            submitReviewUseCase: getIt<SubmitReviewUseCase>(),
            getHelperReviewsUseCase: getIt<GetHelperReviewsUseCase>(),
          ),
        ),
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>(),
        ),
      ],
      child: Builder(
        builder: (providerContext) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('Initial fetch triggered');
            providerContext.read<JobPostingBloc>().add(const GetAllJobsEvent());
            providerContext.read<TaskBloc>().add(FetchSeekerBookingsEvent());
            _fetchApplicationsForSeekerJobs(providerContext); // Direct fetch
          });

          return Scaffold(
            appBar: AppBar(
              title: const Text('Applications & Bookings'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    print('Refresh clicked');
                    _hasFetchedApplications = false;
                    providerContext
                        .read<JobPostingBloc>()
                        .add(const GetAllJobsEvent());
                    providerContext
                        .read<TaskBloc>()
                        .add(FetchSeekerBookingsEvent());
                    _fetchApplicationsForSeekerJobs(providerContext);
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Applications'),
                    Tab(text: 'Bookings'),
                  ],
                ),
                Expanded(
                  child: BlocListener<JobApplicationBloc, JobApplicationState>(
                    listener: (context, appState) {
                      print(
                          'JobApplicationState: isLoading=${appState.isLoading}, '
                          'errorMessage=${appState.errorMessage}, '
                          'jobApplications=${appState.jobApplications?.length ?? 0}');
                      if (appState.errorMessage.isNotEmpty) {
                        showMySnackBar(
                            context: context,
                            message: appState.errorMessage,
                            color: Colors.red);
                      }
                      if (appState.isSuccess && appState.appliedJobId != null) {
                        showMySnackBar(
                            context: context,
                            message:
                                'A Helper has applied for one of your jobs!',
                            color: Colors.green);
                      }
                      if (appState.isSuccess &&
                          appState.jobApplications
                                  ?.any((app) => app.status == 'accepted') ==
                              true) {
                        context
                            .read<TaskBloc>()
                            .add(FetchSeekerBookingsEvent());
                      }
                    },
                    child: BlocListener<TaskBloc, TaskState>(
                      listener: (context, taskState) {
                        if (taskState.errorMessage != null) {
                          showMySnackBar(
                              context: context,
                              message: taskState.errorMessage!,
                              color: Colors.red);
                        }
                      },
                      child: BlocListener<ReviewBloc, ReviewState>(
                        listener: (context, reviewState) {
                          if (reviewState.errorMessage != null) {
                            showMySnackBar(
                                context: context,
                                message: reviewState.errorMessage!,
                                color: Colors.red);
                          } else if (reviewState.isSuccess) {
                            showMySnackBar(
                                context: context,
                                message: 'Review submitted successfully',
                                color: Colors.green);
                            context
                                .read<TaskBloc>()
                                .add(FetchSeekerBookingsEvent());
                          }
                        },
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            BlocBuilder<JobPostingBloc, JobPostingState>(
                              builder: (context, jobState) {
                                print(
                                    'JobPostingState: isLoading=${jobState.isLoading}, '
                                    'jobPostings=${jobState.jobPostings?.length ?? 0}, '
                                    'errorMessage=${jobState.errorMessage}');
                                if (jobState.isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (jobState.errorMessage.isNotEmpty) {
                                  return Center(
                                      child: Text(
                                          'Job Error: ${jobState.errorMessage}'));
                                }
                                return BlocBuilder<JobApplicationBloc,
                                    JobApplicationState>(
                                  builder: (context, appState) {
                                    if (appState.isLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (appState.errorMessage.isNotEmpty) {
                                      return Center(
                                          child: Text(appState.errorMessage));
                                    }
                                    if (appState.jobApplications == null ||
                                        appState.jobApplications!.isEmpty) {
                                      return const Center(
                                          child: Text(
                                              'No applications received for your jobs yet.'));
                                    }
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(16.0),
                                      itemCount:
                                          appState.jobApplications!.length,
                                      itemBuilder: (context, index) {
                                        final jobApplication =
                                            appState.jobApplications![index];
                                        String jobTitle =
                                            jobApplication.jobTitle ??
                                                'Unknown Job';
                                        if (jobTitle == 'Unknown Job' &&
                                            jobState.jobPostings != null) {
                                          final job =
                                              jobState.jobPostings!.firstWhere(
                                            (job) =>
                                                job.jobId ==
                                                jobApplication.jobId,
                                            orElse: () => JobPosting(
                                              jobId: jobApplication.jobId,
                                              jobTitle: jobTitle,
                                              jobDescription: '',
                                              datePosted: DateTime.now(),
                                              status: '',
                                              category: '',
                                              subCategory: '',
                                              location: '',
                                              salaryRange: '',
                                              contractType: '',
                                              applicationDeadline:
                                                  DateTime.now(),
                                              contactInfo: '',
                                              posterFullName: '',
                                              posterEmail: '',
                                              posterImage: '',
                                            ),
                                          );
                                          jobTitle = job.jobTitle;
                                        }
                                        return JobApplicationItem(
                                          jobApplication: jobApplication,
                                          jobTitle: jobTitle,
                                          onStatusUpdated: () {
                                            context.read<TaskBloc>().add(
                                                FetchSeekerBookingsEvent());
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            BlocBuilder<TaskBloc, TaskState>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (state.errorMessage != null) {
                                  return Center(
                                      child: Text(state.errorMessage!,
                                          style: const TextStyle(
                                              color: Colors.red)));
                                }
                                if (state.tasks == null ||
                                    state.tasks!.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'No tasks booked yet. Tap refresh to load.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey)));
                                }

                                final pendingTasks = state.tasks!
                                    .where((task) => task.status == 'pending')
                                    .toList();
                                final ongoingTasks = state.tasks!
                                    .where((task) => task.status == 'ongoing')
                                    .toList();
                                final completedTasks = state.tasks!
                                    .where((task) => task.status == 'completed')
                                    .toList();

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildKanbanColumn(
                                          providerContext,
                                          'Pending',
                                          pendingTasks,
                                          const Color(0xFFBBDEFB)),
                                      _buildKanbanColumn(
                                          providerContext,
                                          'Ongoing',
                                          ongoingTasks,
                                          const Color(0xFFFFCCBC)),
                                      _buildKanbanColumn(
                                          providerContext,
                                          'Completed',
                                          completedTasks,
                                          const Color(0xFFC8E6C9)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKanbanColumn(BuildContext providerContext, String title,
      List<dynamic> tasks, Color color) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: color.withOpacity(0.7),
            child: Center(
              child: Text(
                '$title (${tasks.length})',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text('No $title tasks',
                        style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final helperFullName =
                          task.helperFullName ?? 'Unknown Helper';
                      final helperEmail = task.helperEmail ?? 'No Email';
                      final jobId = task.jobId;
                      return material.Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        color: color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.jobTitle,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Text('Helper: $helperFullName',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text('Email: $helperEmail',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text(
                                'Scheduled: ${task.scheduledTime.toLocal().toString().split('.')[0]}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              if (task.status == 'completed') ...[
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed:
                                            !_paidTasks.contains(task.taskId)
                                                ? () => _handlePayment(
                                                    task.taskId,
                                                    helperEmail,
                                                    jobId,
                                                    helperFullName)
                                                : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: const Text('Pay'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed:
                                            !_ratedTasks.contains(task.taskId)
                                                ? () => _showReviewDialog(
                                                    providerContext,
                                                    helperEmail,
                                                    task.taskId)
                                                : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: const Text('Rate'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(
      BuildContext providerContext, String helperEmail, String taskId) {
    int rating = 0;
    String? comment;

    showDialog(
      context: providerContext,
      builder: (dialogContext) => BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          final seekerEmail = userState.user?.email ?? 'unknown@example.com';
          final seekerFullName = userState.user?.fullName ?? 'Unknown';
          final seekerImage = userState.user?.image ?? '';

          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setDialogState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rate Your Helper',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () =>
                              setDialogState(() => rating = index + 1),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Comment (optional)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      maxLines: 3,
                      onChanged: (value) =>
                          comment = value.isEmpty ? null : value,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: (rating == 0 || userState.user == null)
                              ? null
                              : () {
                                  _submitReview(
                                    providerContext,
                                    helperEmail,
                                    rating,
                                    comment,
                                    taskId,
                                    seekerEmail,
                                    seekerFullName,
                                    seekerImage,
                                  );
                                  Navigator.pop(dialogContext);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: userState.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Submit'),
                        ),
                      ],
                    ),
                    if (userState.user == null && !userState.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'User data not loaded. Please try again.',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).then((_) {
      final reviewBloc = providerContext.read<ReviewBloc>();
      if (reviewBloc.state.isSuccess) {
        setState(() => _ratedTasks.add(taskId));
      }
    });
  }
}
