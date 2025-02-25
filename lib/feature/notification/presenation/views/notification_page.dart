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
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(FetchNotificationsEvent(user.id));
    }
  }

  String formatDateFromNow(DateTime dateTime) {
    // Convert UTC to IST (UTC+5:30 for Indian Standard Time)
    DateTime istDateTime = dateTime.add(const Duration(hours: 5, minutes: 30));

    // Format the DateTime using Jiffy
    return Jiffy.parseFromDateTime(istDateTime).fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
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

                      return ListTile(
                        leading: ImageCircle(
                          radius: 20,
                          url: userMetadata?.image ??
                              'https://via.placeholder.com/150', // Fallback image
                        ),
                        title: Text(userMetadata?.name ?? "Unknown"),
                        subtitle: Text(notification.notification),
                        trailing: Text(formatDateFromNow(notification.createdAt)), // Fix here
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
    );
  }
}
