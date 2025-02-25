import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/notification/domain/entities/notification.dart';
import 'package:application_one/feature/notification/domain/repository/notification_repository.dart';
import 'package:fpdart/fpdart.dart';

class NotificationUsecase
    implements UseCase<List<Notification>, NotificationParams> {
  final NotificationRepository repository;
  NotificationUsecase(this.repository);
  @override
  Future<Either<Failure, List<Notification>>> call(
      NotificationParams params) async {
    return await repository.fetchNotification(params.userId);
  }
}

class NotificationParams {
  final String userId;

  NotificationParams({required this.userId});
}
