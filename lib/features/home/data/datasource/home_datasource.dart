import 'dart:convert';

import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/features/home/domain/model/broker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../../core/common/entity/ltp.dart';
import '../../../../core/utils/convert_symbol_tostring.dart';
import '../../../../core/utils/show_warning_toast.dart';

abstract class HomeRemoteDatasourceInterface {
  Future<Either<Failures, int>> getSelectedInstrumentsLtp(
    List<Ltp> instruments,
    String accessToken,
  );
  Future<bool> activateBroker({required BrokerModel brokerModel});

  Future<bool> stopBroker({required String brokerUid});

  Future<BrokerModel?> getBrokerById(String uid, String accessToken);

  // Future<bool> checkBrokerStatus(String uid);
}

class HomeDatasourceImpl extends HomeRemoteDatasourceInterface {
  @override
  Future<Either<Failures, int>> getSelectedInstrumentsLtp(
      List<Ltp> instruments, String accessToken) async {
    var totalValue = 0.0;
    if (instruments.isNotEmpty) {
      try {
        var keys =
            instruments.map((instrument) => instrument.instrumentKey).toList();
        Uri newUrl = Uri.https(
          'api.upstox.com',
          'v2/market-quote/ltp',
          {
            'instrument_key': keys.join(','),
          },
        );

        // print('params ${newUrl.queryParameters}');

        var response = await http.get(newUrl, headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        });

        final responsebody = jsonDecode(response.body);
        // print('res $responsebody');
        // data: {NSE_EQ:NHPC: {last_price: 105.04, instrument_token: NSE_EQ|INE848E01016}, NSE_FO:IDFCFIRSTB24AUG69PE: {last_price: 0.45, instrument_token: NSE_FO|125547}}
        if (response.statusCode == 200) {
          for (var instrument in instruments) {
            var symbol = '';
            symbol =
                '${instrument.segment}:${convertString(instrument.tradingSymbol)}';
            // print('sy $symbol');
            totalValue += responsebody['data'][symbol]['last_price'];
            Ltp ltps = Ltp(
              instrumentKey: responsebody['data'][symbol]['instrument_token'],
              lastPrice: responsebody['data'][symbol]['last_price'],
              instrumentName: instrument.instrumentName,
              segment: instrument.segment,
              tradingSymbol: instrument.tradingSymbol,
            );
          }
          return Right(totalValue.floor());
        } else {
          print('responsebody $responsebody');
          showWarningToast(msg: responsebody['errors'][0]['message']);
          return Future.error(responsebody['errors'][0]['message']);
        }
      } catch (e) {
        print('err ${e.toString()}');
        return Left(
          ServerFailure(
            e.toString(),
          ),
        );
      }
    } else {
      return const Right(0);
    }
  }

  @override
  Future<bool> activateBroker({required BrokerModel brokerModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Active-Jokies')
          .doc(brokerModel.jockeyUid)
          .set(brokerModel.toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> stopBroker({required String brokerUid}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Active-Jokies')
          .doc(brokerUid)
          .delete();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BrokerModel?> getBrokerById(String uid, String accessToken) async {
    final user = FirebaseAuth.instance.currentUser;
    BrokerModel? broker;
    if (user == null) {
      throw ('Broker not found');
    }
    final userId = user.uid;
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Active-Jokies')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        broker = BrokerModel.fromMap(data);
        // selectedInstru = jokey!.lots;
        FirebaseFirestore.instance
            .collection('Active-Jokies')
            .doc(user.uid)
            .update({
          'at': accessToken,
        });
      }
      return broker;
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<bool> checkBrokerStatus(String uid) async {
  //   try {
  //     final docSnapshot = await FirebaseFirestore.instance
  //         .collection('Active-Jokies')
  //         .doc(uid)
  //         .get();
  //     return docSnapshot.exists;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
