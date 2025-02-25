part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class FetchNotificationsEvent extends NotificationEvent {
  final String userId;

  const FetchNotificationsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
