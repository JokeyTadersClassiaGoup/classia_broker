import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/show_warning_toast.dart';
import '../../1_domian/entity/order.dart';

abstract class OrderRemoteDataSourceInterface {
  Future<Either<Failures, String>> placeOrder({
    required Order order,
    required String accessToken,
  });
}

class OrderDataSource extends OrderRemoteDataSourceInterface {
  @override
  Future<Either<Failures, String>> placeOrder(
      {required Order order, required String accessToken}) async {
    const url = 'https://api-hft.upstox.com/v2/order/place';
    Dio dio = Dio();
    Map<String, dynamic> data = {
      "quantity": order.quantity,
      "product": order.product,
      "validity": order.validity,
      "price": 0,
      "tag": "string",
      "instrument_token": order.instrumentToken,
      "order_type": order.orderType,
      "transaction_type": order.transactionType,
      "disclosed_quantity": order.quantity,
      "trigger_price": order.quantity,
      "is_amo": order.isAmo
    };

    try {
      var response = await dio.post(url,
          data: jsonEncode(data),
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Accept': 'application/json'
            },
            validateStatus: (status) {
              return true;
            },
          ));

      final responseBody = response.data;
      print('got body $responseBody');

      if (response.statusCode == 200) {
        showWarningToast(msg: 'Order placed');
        return Right(responseBody['data']['order_id']);
      } else {
        showWarningToast(msg: '${responseBody['errors'][0]['message']}');
        return Left(ServerFailure(responseBody['status']));
      }
    } catch (e) {
      print('err sr ${e.toString()}');
      showWarningToast(msg: e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }
}
