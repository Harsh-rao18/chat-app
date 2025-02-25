import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/notification/domain/entities/notification.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<Notification>>> fetchNotification(String userId);
}
