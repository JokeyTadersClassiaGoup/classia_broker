import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/features/order/0_data/datasource/order_datasource.dart';
import 'package:classia_broker/features/order/1_domian/entity/order.dart';
import 'package:classia_broker/features/order/1_domian/repository/order_repository.dart';
import 'package:either_dart/src/either.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSourceInterface remoteDataSourceInterface;

  OrderRepositoryImpl({required this.remoteDataSourceInterface});
  @override
  Future<Either<Failures, String>> placeOrder(
      {required Order order, required String accessToken}) {
    return remoteDataSourceInterface.placeOrder(
      order: order,
      accessToken: accessToken,
    );
  }
}
