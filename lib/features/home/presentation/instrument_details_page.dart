import 'dart:async';
import 'dart:convert';

import 'package:classia_broker/core/common/widgets/loader.dart';
import 'package:classia_broker/features/order/1_domian/entity/order_page_args.dart';
import 'package:classia_broker/features/order/2_presentation/order_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../core/common/entity/ltp.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/convert_symbol_tostring.dart';
import '../../../core/utils/show_warning_toast.dart';
import '../domain/entity/ohlc.dart';

class InstrumentDetailsPage extends StatefulWidget {
  static const routeName = '/instrument-detials-page';
  final Ltp instrument;
  final String accessToken;
  const InstrumentDetailsPage({
    super.key,
    required this.accessToken,
    required this.instrument,
  });

  @override
  State<InstrumentDetailsPage> createState() => _InstrumentDetailsPageState();
}

class _InstrumentDetailsPageState extends State<InstrumentDetailsPage> {
  Ohlc ohlc = Ohlc(open: 10.0, high: 10, low: 10, close: 10);
  var isLoading = false;
  late Timer timer;
  ValueNotifier<double> lastTradedPrice = ValueNotifier(0.0);

  Future<void> getInstrumentDetails() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.https(
      'api.upstox.com',
      'v2/market-quote/ohlc',
      {
        'instrument_key': widget.instrument.instrumentKey,
        'interval': '1d',
      },
    );
    try {
      Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Accept': 'application/json',
        },
      );

      var responseBody = jsonDecode(response.body);

      var symbol =
          '${widget.instrument.segment}:${convertString(widget.instrument.tradingSymbol)}';

      if (response.statusCode == 200) {
        ohlc = Ohlc.fromMap(responseBody['data'][symbol]['ohlc']);
        setState(() {
          isLoading = false;
        });
      } else {
        showWarningToast(msg: responseBody['errors'][0]['message']);
        setState(() {
          isLoading = false;
        });
        print('error body $responseBody');
      }
    } catch (e) {
      showWarningToast(msg: e.toString());
      setState(() {
        isLoading = false;
      });
      print('fetching err $e');
    }
  }

  Future<void> getLastTradePrice() async {
    try {
      final url = Uri.https('api.upstox.com', 'v2/market-quote/ltp', {
        'instrument_key': widget.instrument.instrumentKey,
      });

      Response response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Accept': 'application/json',
      });

      var responseBody = jsonDecode(response.body);

      var symbol =
          '${widget.instrument.segment}:${convertString(widget.instrument.tradingSymbol)}';
      if (response.statusCode == 200) {
        lastTradedPrice.value = responseBody['data'][symbol]['last_price'];
      } else {
        showWarningToast(msg: responseBody['errors'][0]['message']);

        print('error body $responseBody');
      }
    } catch (e) {
      showWarningToast(msg: e.toString());

      print('fetching err $e');
    }
  }

  var isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (isInit) {
      await getInstrumentDetails();
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (time) async {
          await getLastTradePrice();
        },
      );
    }
    isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.instrument.instrumentName),
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InstrumentDetailsItem(
                        title: 'Open',
                        value: ohlc.open,
                      ),
                      InstrumentDetailsItem(
                        title: 'High',
                        value: ohlc.high,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InstrumentDetailsItem(
                        title: 'Low',
                        value: ohlc.low,
                      ),
                      InstrumentDetailsItem(
                        title: 'Close',
                        value: ohlc.close,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  color: Colors.white,
                ),
                Container(
                  // height: 200,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 40.0),
                  padding: const EdgeInsets.all(12.0),
                  // width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: lastTradedPrice,
                    builder: (context, _, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Last price',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '₹ ${lastTradedPrice.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: lastTradedPrice,
          builder: (context, _, state) {
            return Container(
              color: AppColors.primaryColor,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final args = OrderPageArgs(
                          orderType: false,
                          lastTradedPrice: lastTradedPrice.value,
                          title: widget.instrument.instrumentName,
                          availableBalance: 10,
                          accessToken: widget.accessToken,
                          instrumentKey: widget.instrument.instrumentKey,
                        );
                        context.pushNamed(
                          OrderPageProvider.routeName,
                          extra: args,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 50),
                        shape: const StadiumBorder(
                            side: BorderSide(color: AppColors.goldColor)),
                        // backgroundColor: AppColors.goldColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontFamily: 'lato',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Sell'),
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final args = OrderPageArgs(
                          orderType: true,
                          lastTradedPrice: lastTradedPrice.value,
                          title: widget.instrument.instrumentName,
                          availableBalance: 10,
                          accessToken: widget.accessToken,
                          instrumentKey: widget.instrument.instrumentKey,
                        );
                        context.pushNamed(
                          OrderPageProvider.routeName,
                          extra: args,
                        );

                        // if (widget.availableBalance == 0) {
                        //   showWarningToast(msg: 'Insufficient balance');
                        // } else {
                        //   final order = await context.read<UsxCubit>().postOrder(
                        //         order: Order(
                        //           quantity: 1,
                        //           product: "D",
                        //           validity: "DAY",
                        //           price: 0,
                        //           tag: "string",
                        //           instrumentToken: "BSE_FO|845332",
                        //           orderType: "MARKET",
                        //           transactionType: "BUY",
                        //           disclosedQuantity: 0,
                        //           triggerPrice: 0,
                        //           isAmo: false,
                        //         ),
                        //         accessToken: widget.accessToken,
                        //       );
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(
                          fontFamily: 'lato',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Buy'),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class InstrumentDetailsItem extends StatelessWidget {
  final String title;
  final double value;

  const InstrumentDetailsItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$title :',
            style: const TextStyle(color: Colors.white),
          ),
          // Gap(5),
          Center(
            child: Text(
              '\u{20B9} $value',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
