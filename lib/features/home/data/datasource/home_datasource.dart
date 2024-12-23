import 'dart:convert';

import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/core/utils/collection_name.dart';
import 'package:classia_broker/features/home/domain/model/activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../../core/common/entity/ltp.dart';
import '../../../../core/utils/convert_symbol_tostring.dart';
import '../../../../core/utils/show_warning_toast.dart';

abstract class HomeRemoteDatasourceInterface {
  Future<Either<Failures, int>> getSelectedInstrumentsLtp(
      List<Ltp> instruments, String accessToken);
  Future<bool> activateBroker(ActivityModel activityModel);

  Future<bool> stopBroker(ActivityModel activityModel);

  Future<ActivityModel?> getBrokerById(String uid, String accessToken);

  // Future<bool> checkBrokerStatus(String uid);
}

class HomeDataSourceImpl extends HomeRemoteDatasourceInterface {
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
  Future<bool> activateBroker(ActivityModel activityModel) async {
    var response = await FirebaseFirestore.instance
        .collection(brokersCollectionName)
        .doc(activityModel.brokerUid)
        .get();

    var phoneNumber = response.data()!['phoneNumber'];

    if (await isUserBlocked(phoneNumber)) {
      showWarningToast(
          msg: 'You have been blocked, kindly request admin to unblock');
      return Future.error('Error');
    } else {
      try {
        await FirebaseFirestore.instance
            .collection(activeBrokerCollectionName)
            .doc(activityModel.brokerUid)
            .set(activityModel.toMap());

        return true;
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<bool> stopBroker(ActivityModel activityModel) async {
    try {
      print('stop pressed');
      var brokerUid = activityModel.brokerUid;
      var activityId = activityModel.activityId;
      var totalInvestment = 0.0;
      var totalWithdraw = 0.0;

      DocumentReference<Map<String, dynamic>> activeBrokerDocumentReference =
          FirebaseFirestore.instance
              .collection(activeBrokerCollectionName)
              .doc(brokerUid); //document reference

      DocumentReference<Map<String, dynamic>>
          activityHistoryCollectionReference = FirebaseFirestore.instance
              .collection(brokersCollectionName)
              .doc(brokerUid)
              .collection(activityHistoryCollectionName)
              .doc(activityId);

      var activeBroker = await activeBrokerDocumentReference.get(); //docs data

      final liveTransactionCollection = activeBrokerDocumentReference
          .collection(liveTransactionCollectionName);

      // QuerySnapshot<Map<String, dynamic>> withdrawCollection =
      //     await activeBrokerDocumentReference
      //         .collection(withdrawCollectionName)
      //         .get();

      //for now displaying only total numbers of invest and withdraw
      //later on need to make it specific which user has invested with trans details

      // QuerySnapshot<Map<String, dynamic>> transactions =
      //     await activeBrokerDocumentReference
      //         .collection(transactionsCollectionName)
      //         .get();

      // WriteBatch batch = FirebaseFirestore.instance.batch();
      // totalInvestment = liveTransactionCollection.docs.fold(0,
      //     (previousValue, element) => previousValue + element.data()['amount']);
      // totalWithdraw = liveTransactionCollection.docs.fold(0,
      //     (previousValue, element) => previousValue + element.data()['amount']);

      if (activeBroker.exists) {
        print('brokers exists ${activeBroker.exists}');
        print('total investment $totalInvestment');
        print('withdraw $totalWithdraw');

        // for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        //     in transactions.docs) {
        //   Map<String, dynamic> data = doc.data();
        //   TradeTransModel tradeTransModel = TradeTransModel.fromMap(doc.data());
        //   if (tradeTransModel.transType == 'invest') {
        //     totalInvestment += tradeTransModel.amount;
        //   } else {
        //     totalWithdraw += tradeTransModel.amount;
        //   }

        //   batch.set(activityHistoryCollectionReference, data);
        // }

        // try {
        //   await batch.commit();
        // } catch (e) {
        //   print('eee ${e.toString()}');
        // }
        ActivityModel updatedModel = activityModel.copyWith(
            totalInvest: totalInvestment, totalWithdraw: totalWithdraw);
        print('updating model ${updatedModel.toMap()}');
        await activityHistoryCollectionReference.set(activityModel.toMap());

        await fetchDataAndStoreInHistory(
          liveTransactionCollection,
          activityHistoryCollectionReference
              .collection(liveTransactionCollectionName),
        );
      }

      await activeBrokerDocumentReference.delete();

      return true;
    } catch (e) {
      print('stop err ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ActivityModel?> getBrokerById(String uid, String accessToken) async {
    final user = FirebaseAuth.instance.currentUser;
    ActivityModel? broker;
    if (user == null) {
      throw ('Broker not found');
    }
    final userId = user.uid;
    print('user id = $userId');
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(activeBrokerCollectionName)
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        print('data $data');
        broker = ActivityModel.fromMap(data);
        // selectedInstru = jokey!.lots;
        FirebaseFirestore.instance
            .collection(activeBrokerCollectionName)
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

//  @override
  Future<bool> isUserBlocked(String phoneNumber) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(blockedUsersCollectionName)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> fetchDataAndStoreInHistory(CollectionReference collectionRef,
      CollectionReference historyCollection) async {
    // Reference to the active collection
    // final liveTransactionCollection =
    //     FirebaseFirestore.instance.collection(liveTransactionCollectionName);

    // Fetch all documents in the active collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get the list of documents from the querySnapshot
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    // Call the function to store data into the history collection
    await storeDataInHistory(docs, historyCollection);
  }

  Future<void> storeDataInHistory(List<QueryDocumentSnapshot> docs,
      CollectionReference historyCollection) async {
    // final historyCollection =
    //     FirebaseFirestore.instance.collection('history-collection');

    // Loop through each document and add it to the history collection
    for (var doc in docs) {
      await historyCollection.add({...doc.data() as Map<String, dynamic>});
    }
  }
}
