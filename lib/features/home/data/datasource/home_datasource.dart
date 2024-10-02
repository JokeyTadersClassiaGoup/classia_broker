import 'dart:convert';

import 'package:classia_broker/core/error/failures.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../../core/common/entity/ltp.dart';
import '../../../../core/utils/convert_symbol_tostring.dart';
import '../../../../core/utils/show_warning_toast.dart';

abstract class HomeRemoteDatasourceInterface {
  Future<Either<Failures, int>> getSelectedInstrumentLtp(
      List<Ltp> instruments, String accessToken);
}

class HomeDatasourceImpl extends HomeRemoteDatasourceInterface {

  @override
  Future<Either<Failures, int>> getSelectedInstrumentLtp(
      List<Ltp> instruments, String accessToken) async {
    var totalValue = 0.0;

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

      print('params ${newUrl.queryParameters}');

      var response = await http.get(newUrl, headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      });

      final responsebody = jsonDecode(response.body);
      print('res $responsebody');
      // data: {NSE_EQ:NHPC: {last_price: 105.04, instrument_token: NSE_EQ|INE848E01016}, NSE_FO:IDFCFIRSTB24AUG69PE: {last_price: 0.45, instrument_token: NSE_FO|125547}}
      if (response.statusCode == 200) {
        for (var instrument in instruments) {
          var symbol = '';
          symbol =
              '${instrument.segment}:${convertString(instrument.tradingSymbol)}';
          print('sy $symbol');
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
  }
}
