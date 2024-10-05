import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/core/use_case/use_case.dart';
import 'package:classia_broker/features/order/1_domian/repository/order_repository.dart';
import 'package:either_dart/src/either.dart';

class PlaceOrder extends UseCase<String, PlaceOrderParams> {
  final OrderRepository orderRepository;

  PlaceOrder({required this.orderRepository});
  @override
  Future<Either<Failures, String>> call(PlaceOrderParams params) async {
    return await orderRepository.placeOrder(
      order: params.order,
      accessToken: params.accessToken,
    );
  }
}
