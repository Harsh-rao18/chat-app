import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/notification/presenation/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(FetchNotificationsEvent(user.id));
    }
  }

  Future<void> _onRefresh() async {
    _fetchNotifications();
  }

  String formatDateFromNow(DateTime dateTime) {
    DateTime istDateTime = dateTime.add(const Duration(hours: 5, minutes: 30));
    return Jiffy.parseFromDateTime(istDateTime).fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              return state.notifications.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        final userMetadata = notification.user?.metadata;

                        /// Fix: Access fields directly instead of using `[]`
                        final String profileImage = userMetadata?.image ??
                            'https://via.placeholder.com/150';
                        final String userName = userMetadata?.name ?? "Unknown";

                        return ListTile(
                          leading: ImageCircle(radius: 20, url: profileImage),
                          title: Text(userName),
                          subtitle: Text(notification.notification),
                          trailing: Text(formatDateFromNow(notification.createdAt)),
                        );
                      },
                    )
                  : const Center(child: Text("No Notifications Yet"));
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
