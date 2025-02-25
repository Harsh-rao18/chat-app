import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/notification/domain/entities/notification.dart';
import 'package:application_one/feature/notification/domain/usecase/notification_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationUsecase _notificationUsecase;
  NotificationBloc({
    required NotificationUsecase notificationUsecase,
  })  : _notificationUsecase = notificationUsecase,
        super(NotificationInitial()) {
    on<FetchNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());

      final Either<Failure, List<Notification>> result =
          await _notificationUsecase(NotificationParams(userId: event.userId));

      result.fold(
        (failure) => emit(const NotificationError('Failed to load notifications')),
        (notifications) => emit(NotificationLoaded(notifications)),
      );
    });
  }
}
