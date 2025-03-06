import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';
import 'package:housepal_project/features/notification/domain/usecases/get_notification_usecases.dart';
import 'package:housepal_project/features/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building NotificationView...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () {
              print('Mark all as read pressed.');
              context
                  .read<NotificationBloc>()
                  .add(const MarkAllNotificationsAsReadEvent());
            },
            tooltip: 'Mark All as Read',
          ),
        ],
      ),
      body: BlocProvider<NotificationBloc>(
        create: (context) {
          print('Creating NotificationBloc...');
          final bloc = NotificationBloc(
            getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
            markAllNotificationsAsReadUseCase:
                getIt<MarkAllNotificationsAsReadUseCase>(),
            notificationRepository: getIt<INotificationRepository>(),
          );
          print('NotificationBloc created: $bloc');
          bloc.add(const FetchNotificationsEvent());
          return bloc;
        },
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            print(
                'NotificationState: isLoading=${state.isLoading}, notifications=${state.notifications?.length ?? 0}, error=${state.errorMessage}');
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.notifications != null &&
                state.notifications!.isNotEmpty) {
              return ListView.builder(
                key: ValueKey(state
                    .notifications.hashCode), // Ensure rebuild on list change
                padding: const EdgeInsets.all(16.0),
                itemCount: state.notifications!.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications![index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(notification.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(notification.message),
                      trailing: notification.isRead
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.circle, color: Colors.red),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No notifications available'));
            }
          },
        ),
      ),
    );
  }
}
