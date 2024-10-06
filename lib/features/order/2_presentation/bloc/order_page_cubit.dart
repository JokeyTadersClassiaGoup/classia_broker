import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/use_case/use_case.dart';
import '../../1_domian/entity/order.dart';
import '../../1_domian/use_cases/place_order.dart';

class OrderPageCubit extends Cubit<OrderPageCubitState> {
  final PlaceOrder placeOrder;
  OrderPageCubit({required this.placeOrder}) : super(OrderPageCubitState());

  Future<String> createOrder({
    required Order order,
    required String accessToken,
  }) async {
    try {
      final result = await placeOrder.call(
        PlaceOrderParams(
          accessToken: accessToken,
          order: order,
        ),
      );
      if (result.isRight) {
        return result.right;
      } else {
        return 'Something went wrong';
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

class OrderPageCubitState {
  
}
