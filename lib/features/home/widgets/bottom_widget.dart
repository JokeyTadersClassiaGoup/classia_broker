import 'package:classia_broker/core/common/entity/ltp.dart';
import 'package:classia_broker/features/home/domain/model/broker_model.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit_state.dart';
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
  });

  final ValueNotifier<int> totalValue;
  bool isActivate;
  final HomeCubitState cubit;
  final String accessToken;
  final List<Ltp> instruments;
  final Function(bool) activate;

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    const radius = 30.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.isActivate
            ? ExpansionTile(
                trailing: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 35,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius))),
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
              )
            : const SizedBox(),
        Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
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
                              foregroundColor: AppColors.goldColor,
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
                                            BrokerModel(
                                              jockeyUid: auth.currentUser!.uid,
                                              jockeyName: 'User-1',
                                              lotValue: widget.totalValue.value
                                                  .floor(),
                                              lots: widget.instruments,
                                              dateTime: DateTime.now(),
                                              // growth: 0.0,
                                              at: widget.accessToken,
                                              // predictionValue: double.parse(predictionTextController.text),
                                              // successRation: 0.0,
                                            ),
                                          )
                                      : await context
                                          .read<HomePageCubit>()
                                          .stop(auth.currentUser!.uid);

                                  isLoading.value = false;
                                } catch (e) {
                                  isLoading.value = false;
                                }
                                widget.isActivate = !widget.isActivate;
                                widget.activate(widget.isActivate);
                                setState(() {});
                              } else {
                                showWarningToast(
                                    msg: 'Select atlest 1 instrument');
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
