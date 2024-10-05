import 'package:classia_broker/features/home/domain/model/broker_model.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../features/auth/domain/models/user_model.dart';
import '../../features/order/1_domian/entity/order.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failures, Type>> call(Params params);
}

abstract class Params extends Equatable {}

class NoParams extends Params {
  @override
  List<Object?> get props => [];
}

class LoginParams extends Params {
  final String phoneNumber;
  final BuildContext context;

  LoginParams({required this.phoneNumber, required this.context});
  @override
  List<Object?> get props => [phoneNumber, context];
}

class SignUpParams extends Params {
  final String? fullName;
  final String phoneNumber;
  final String? email;
  final BuildContext context;
  final String type;

  SignUpParams({
    required this.phoneNumber,
    required this.context,
    this.fullName,
    this.email,
    required this.type,
  });
  @override
  List<Object?> get props => [phoneNumber, context, fullName, email];
}

class VerifyOtpParams extends Params {
  final String smsCode;
  final UserModel? userModel;
  final BuildContext context;
  final String verificationId;
  final String type;

  VerifyOtpParams({
    required this.smsCode,
    this.userModel,
    required this.context,
    required this.verificationId,
    required this.type,
  });

  @override
  List<Object?> get props => [smsCode, userModel, context, verificationId];
}

class PlaceOrderParams extends Params {
  final Order order;
  final String accessToken;

  PlaceOrderParams({required this.order, required this.accessToken});
  @override
  List<Object?> get props => [order, accessToken];
}

class ActivateBrokerParams extends Params {
  final BrokerModel brokerModel;

  ActivateBrokerParams({required this.brokerModel});

  @override
  List<Object?> get props => [brokerModel];
}

class GetBrokerIdParams extends Params {
  final String accessToken;
  final String uId;

  GetBrokerIdParams({required this.accessToken, required this.uId});

  @override
  List<Object?> get props => [accessToken, uId];
}
// class WriteTradeHistoryParams extends Params {
//   final TradeTransModel tradeTransModel;

//   WriteTradeHistoryParams({required this.tradeTransModel});
//   @override
//   // TODO: implement props
//   List<Object?> get props => [tradeTransModel];
// }

// class LiveDataParams extends Params {
//   final String accessToken;
//   final List<Ltp> lots;
//   final int lotValue;
//   final int liveValue;

//   LiveDataParams({
//     required this.accessToken,
//     required this.lots,
//     required this.lotValue,
//     required this.liveValue,
//   });

//   @override
//   List<Object?> get props => [accessToken, lots, lotValue, liveValue];
// }

// class MoneyTransactionParams extends Params {
//   final MoneyTransactionModel moneyTransactionModel;

//   MoneyTransactionParams({required this.moneyTransactionModel});

//   @override
//   List<Object?> get props => [moneyTransactionModel];
// }
