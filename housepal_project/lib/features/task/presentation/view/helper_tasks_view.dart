import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/task/domain/usecases/get_helper_task_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/get_seeker_bookings_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/update_task_status.dart';
import 'package:housepal_project/features/task/presentation/view_model/task_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HelperTasksView extends StatefulWidget {
  const HelperTasksView({super.key});

  @override
  State<HelperTasksView> createState() => _HelperTasksViewState();
}

class _HelperTasksViewState extends State<HelperTasksView> {
  final authRepo = getIt<AuthRemoteRepository>();
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _lastX = 0.0, _lastY = 0.0, _lastZ = 0.0;
  static const double _shakeThreshold = 20.0;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();
    _setupAccelerometerDetection();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _setupAccelerometerDetection() {
    try {
      _accelerometerSubscription = accelerometerEvents.listen(
        (AccelerometerEvent event) {
          if (!mounted) return;
          final double x = event.x;
          final double y = event.y;
          final double z = event.z;

          final double deltaX = (x - _lastX).abs();
          final double deltaY = (y - _lastY).abs();
          final double deltaZ = (z - _lastZ).abs();

          _lastX = x;
          _lastY = y;
          _lastZ = z;

          if (deltaX + deltaY + deltaZ > _shakeThreshold) {
            if (!_isShaking) {
              _isShaking = true;
              _handleShake(context);
              Future.delayed(const Duration(seconds: 1), () {
                _isShaking = false;
              });
            }
          }
        },
        onError: (error) {
          debugPrint('Accelerometer sensor error: $error');
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize accelerometer sensor: $e');
    }
  }

  void _handleShake(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    final currentState = taskBloc.state;

    if (currentState.tasks == null || currentState.isLoading) return;

    for (final task in currentState.tasks!) {
      String? newStatus;
      if (task.status == 'pending') {
        newStatus = 'ongoing';
      } else if (task.status == 'ongoing') {
        newStatus = 'completed';
      } else if (task.status == 'completed') {
        continue; // Do not move back from completed
      }

      if (newStatus != null) {
        taskBloc.add(UpdateTaskStatusEvent(
          task.taskId,
          newStatus,
          helperEmail: task.helperEmail ?? '',
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: authRepo
          .getCurrentUser()
          .then((result) => result.fold((_) => null, (user) => user.email)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final helperEmail = snapshot.data ?? '';

        return BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            getHelperTasksUseCase: getIt<GetHelperTasksUseCase>(),
            getSeekerBookingsUseCase: getIt<GetSeekerBookingsUseCase>(),
            updateTaskStatusUseCase: getIt<UpdateTaskStatusUseCase>(),
          )..add(FetchHelperTasksEvent(helperEmail)),
          child: Scaffold(
            body: BlocListener<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage!)),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "My Tasks",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state.errorMessage != null) {
                          return Center(child: Text(state.errorMessage!));
                        }
                        if (state.tasks == null || state.tasks!.isEmpty) {
                          return const Center(
                              child: Text('No tasks assigned yet.'));
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildKanbanColumn(
                                  context,
                                  'Pending',
                                  pendingTasks,
                                  const Color(0xFFBBDEFB),
                                  helperEmail),
                              _buildKanbanColumn(
                                  context,
                                  'Ongoing',
                                  ongoingTasks,
                                  const Color(0xFFFFCCBC),
                                  helperEmail),
                              _buildKanbanColumn(
                                  context,
                                  'Completed',
                                  completedTasks,
                                  const Color(0xFFC8E6C9),
                                  helperEmail),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKanbanColumn(BuildContext context, String title,
      List<dynamic> tasks, Color color, String helperEmail) {
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
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 500,
            child: tasks.isEmpty
                ? Center(
                    child: Text('No $title tasks',
                        style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
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
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Seeker: ${task.seekerEmail}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text(
                                'Scheduled: ${task.scheduledTime.toLocal().toString().split('.')[0]}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              const SizedBox(height: 12),
                              DropdownButton<String>(
                                value: task.status,
                                items: const [
                                  DropdownMenuItem(
                                      value: 'pending', child: Text('Pending')),
                                  DropdownMenuItem(
                                      value: 'ongoing', child: Text('Ongoing')),
                                  DropdownMenuItem(
                                      value: 'completed',
                                      child: Text('Completed')),
                                ],
                                onChanged: (newStatus) {
                                  if (newStatus != null &&
                                      newStatus != task.status) {
                                    context.read<TaskBloc>().add(
                                          UpdateTaskStatusEvent(
                                            task.taskId,
                                            newStatus,
                                            helperEmail: helperEmail,
                                          ),
                                        );
                                  }
                                },
                              ),
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
}
