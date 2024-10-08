import 'dart:async';

import 'package:classia_broker/features/home/domain/use_case/get_selected_instruments_ltp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/common/entity/ltp.dart';

class ContainerSlider extends StatefulWidget {
  final String accessToken;
  final int lotValue;
  final List<Ltp> lots;

  const ContainerSlider({
    super.key,
    required this.accessToken,
    required this.lotValue,
    required this.lots,
  });

  @override
  _ContainerSliderState createState() => _ContainerSliderState();
}

class _ContainerSliderState extends State<ContainerSlider> {
  late Timer timer;
  var isLoading = false;
  // late double _currentPrice;
  var low;
  var high;
  var inst = 'NSE_FO|35718';
  var statusColor = Colors.white;
  ValueNotifier<double> currentPrice = ValueNotifier<double>(0.0);
  double currentWidth = 0.0;

  double? performance;
  var liveValue = 0;

  Future<void> calculateWidth() async {
    var function =
        GetSelectedInstrumentsLtp(repository: RepositoryProvider.of(context));
    var response = await function.call(widget.accessToken);
    if (response.isRight) {
      liveValue = response.right;
    } else {
      liveValue = 0;
    }

    var subValue = liveValue - widget.lotValue;
    print('sub val $subValue');
    performance = subValue * 100 / widget.lotValue;
    print('pr $performance');

    double minWidth = 0;
    double maxWidth = context.mounted ? MediaQuery.of(context).size.width : 0.0;
    var highValue = widget.lotValue * 2;
    statusColor = performance! < 0 ? Colors.red : Colors.green;
    symbol = performance! < 0 ? '-' : '+';
    currentWidth =
        minWidth + (liveValue - 0) / (highValue - 0) * (maxWidth - minWidth);
    // print('cw $currentWidth');
    setState(() {});
  }

  // Future getLiveInstrumentsDataAndCalculateValue(
  //     dynamic lotValue, String accessToken, ReadPortfolio readPortfolio) async {
  //   try {
  //     print('lot size $lotValue');
  //     liveValue = await getHttpLiveData(readPortfolio);
  //     // print('current price ${currentPrice.value}');
  //     var subValue = liveValue - lotValue;
  //     performance = subValue * 100 / lotValue;
  //     double minWidth = 0;
  //     double maxWidth = MediaQuery.of(context).size.width;
  //     var highValue = lotValue * 10;
  //     statusColor = performance! < 0 ? Colors.red : Colors.green;
  //     print(
  //         'highvalue $highValue, livevalue $liveValue lot valu $lotValue subValue $subValue performance $performance');
  //     currentWidth =
  //         minWidth + (liveValue - 0) / (highValue - 0) * (maxWidth - minWidth);
  //     print('currentWidth $currentWidth');
  //     setState(() {});
  //   } catch (e) {
  //     return 0.0;
  //   }
  // }

  var isInit = true;
  var symbol = '-';
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit && context.mounted) {
      timer = Timer.periodic(const Duration(seconds: 4), (v) async {
        await calculateWidth();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    currentPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return performance == null
        ? const Column(
            children: [
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              Gap(5),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentWidth < 0
                  ? const Center(
                      child: Text(
                        'No growth to show',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(
                      width: currentWidth,
                      // margin: const EdgeInsets.all(12.0),
                      height: 30,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/horse.png',
                        width: 35,
                        height: 35,
                        // color: ,
                      ),
                      // child:
                    ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '0 %',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '$symbol ${performance!.toStringAsFixed(2)} %',
                      style: TextStyle(color: statusColor),
                    ),
                    const Text(
                      '100 %',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Current Price: \u{20B9} $liveValue',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
  }
}
