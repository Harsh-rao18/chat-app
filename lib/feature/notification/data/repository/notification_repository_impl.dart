import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/notification/data/datasource/notification_remote_data_source.dart';
import 'package:application_one/feature/notification/domain/entities/notification.dart';
import 'package:application_one/feature/notification/domain/repository/notification_repository.dart';
import 'package:fpdart/fpdart.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<Notification>>> fetchNotification(
      String userId) async {
    try {
      final notification = await remoteDataSource.fetchNotication(userId);
      return right(notification);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
