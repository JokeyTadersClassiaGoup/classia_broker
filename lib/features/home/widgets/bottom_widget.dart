import 'package:classia_broker/core/common/entity/ltp.dart';
import 'package:classia_broker/core/common/entity/unique_id.dart';
import 'package:classia_broker/features/home/domain/model/activity_model.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jumping_dot/jumping_dot.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/show_warning_toast.dart';
import 'container_slider.dart';

class BottomWidget extends StatefulWidget {
  BottomWidget({
    super.key,
    required this.totalValue,
    required this.isActivate,
    required this.cubit,
    required this.accessToken,
    required this.instruments,
    required this.activate,
    this.activityModel,
  });

  final ValueNotifier<int> totalValue;
  bool isActivate;
  final HomeCubitState cubit;
  final String accessToken;
  final List<Ltp> instruments;
  final Function(bool) activate;
  final ActivityModel? activityModel;

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpside = ValueNotifier(false);

  final auth = FirebaseAuth.instance;

  var statusColor = AppColors.goldColor;

  ActivityModel? updatedStopModel() {
    if (widget.activityModel != null) {
      var endValue = 10; // live value
      var stopTime = Timestamp.now();
      var initialValue = widget.activityModel!.lotValue;
      var profit = initialValue - endValue;
      var closingBalance = widget.activityModel!.openingBalance +
          10; //fetch wallet to get current balance -- current balance = closing balance whatever the value

      return widget.activityModel!.copyWith(
        profit: double.parse(profit.toString()),
        closeTime: stopTime,
        closingBalance: closingBalance,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const radius = 30.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.isActivate
            ? ValueListenableBuilder(
                valueListenable: isUpside,
                builder: (_, val, child) {
                  return ExpansionTile(
                    onExpansionChanged: (direction) {
                      isUpside.value = direction;
                    },
                    trailing: Icon(
                      isUpside.value
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 35,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius),
                      ),
                    ),
                    collapsedBackgroundColor: AppColors.primaryColor,
                    backgroundColor: AppColors.primaryColor,
                    collapsedIconColor: Colors.white,
                    // trailing: Icon(Icons.keyboard_double_arrow_up_rounded, color: Colors.white,),
                    title: const Text(
                      'My status',
                      style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    children: [
                      // const RecentWidget(),
                      const Gap(5),
                      ContainerSlider(
                        accessToken: widget.accessToken,
                        lotValue: widget.totalValue.value.floor(),
                        lots: widget.instruments,
                      )
                    ],
                  );
                },
              )
            : const SizedBox(),
        Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Lot value : \u{20B9} ${widget.totalValue.value.floor()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, val, _) {
                    return isLoading.value
                        ? Center(
                            child: JumpingDots(
                              color: Colors.white,
                              radius: 5,
                              numberOfDots: 3,
                            ),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: statusColor,
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async {
                              if (widget.totalValue.value != 0) {
                                try {
                                  isLoading.value = true;
                                  !widget.isActivate
                                      ? await context
                                          .read<HomePageCubit>()
                                          .activate(
                                            ActivityModel(
                                              brokerUid: auth.currentUser!.uid,
                                              brokerName: 'User-1',
                                              lotValue: widget.totalValue.value
                                                  .floor(),
                                              lots: widget.instruments,
                                              dateTime: Timestamp.now(),
                                              // growth: 0.0,
                                              at: widget.accessToken,
                                              activityId: ActivityId().value,
                                              profit: 0,
                                              totalInvest: 0,
                                              totalWithdraw: 0,
                                              activeTime: Timestamp.now(),
                                              closeTime: Timestamp.now(),
                                              openingBalance: 1000.0,
                                              closingBalance: 1050.0,
                                              activityStatus: 'All Good',
                                            ),
                                          )
                                      : await context
                                          .read<HomePageCubit>()
                                          .stop(updatedStopModel()!);
                                  // setState(() {});

                                  isLoading.value = false;
                                } catch (e) {
                                  isLoading.value = false;
                                }
                                widget.isActivate = !widget.isActivate;
                                widget.activate(widget.isActivate);
                                setState(() {});
                              } else {
                                showWarningToast(
                                    msg: 'Select at least 1 instrument');
                              }
                            },
                            child: widget.isActivate
                                ? const Text('Stop')
                                : const Text('Activate'));
                  }),
            ],
          ),
        )
      ],
    );
  }
}
