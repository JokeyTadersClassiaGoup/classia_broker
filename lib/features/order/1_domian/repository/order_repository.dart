import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../entity/order.dart';

abstract class OrderRepository {
  Future<Either<Failures, String>> placeOrder({
    required Order order,
    required String accessToken,
  });
}
