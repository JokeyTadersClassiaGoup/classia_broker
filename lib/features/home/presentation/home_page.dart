import 'package:classia_broker/core/common/widgets/common_text.dart';
import 'package:classia_broker/core/common/widgets/loader.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit_state.dart';
import 'package:classia_broker/features/home/widgets/company_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class HomePageProvider extends StatelessWidget {
  const HomePageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomePageCubit(RepositoryProvider.of(context))..getInst(),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> isActivate = ValueNotifier(false);
  ValueNotifier<int> totalValue = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    isActivate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            title: CompanySearchBar(
              cubitContext: context,
              totalValFun: (val) {
                totalValue.value = val;
              },
            ),
          ),
        ),
        body: BlocBuilder<HomePageCubit, HomeCubitState>(builder: (_, state) {
          if (state is HomePageLoadingState) {
            return const Loader();
          } else if (state is HomePageLoadedState) {
            return state.instruments.isEmpty
                ? commonText('No Instruments selected')
                : ListView.builder(
                    itemCount: state.instruments.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final instrument = state.instruments[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          10,
                          10,
                          10,
                          0.0,
                        ),
                        child: ValueListenableBuilder(
                            valueListenable: isActivate,
                            builder: (context, val, chi) {
                              return Dismissible(
                                key: UniqueKey(),
                                confirmDismiss: (direction) {
                                  return showDialog(
                                    context: context,
                                    builder: (contxt) => AlertDialog(
                                      backgroundColor: AppColors.primaryColor,
                                      title: const Text(
                                        'Do you want to remove this instrument key?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70),
                                      ),
                                      content: Text(
                                        instrument.instrumentName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => context.pop(),
                                          child: const Text(
                                            'No',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            context.pop();
                                            // cubit.removePortfolioInstruments(
                                            //   instrument.instrumentKey,
                                            // );
                                            // totalValue.value = await context
                                            //     .read<TradePageCubit>()
                                            //     .readPortolioValue(
                                            //         widget.accessToken);
                                            // setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize:
                                                const Size.fromHeight(40),
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          child: const Text('Yes'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                direction: isActivate.value
                                    ? DismissDirection.none
                                    : DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // color: Colors.amber,
                                  ),
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child:
                                      const Icon(Icons.delete_outline_rounded),
                                ),
                                child: ListTile(
                                  tileColor: Colors.white10,
                                  contentPadding: const EdgeInsets.all(12.0),
                                  minTileHeight: 40,
                                  minVerticalPadding: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  onTap: () {
                                    //   context.pushNamed(
                                    //   InstrumentDetailsPage.routeName,
                                    //   extra: {
                                    //     'accessToken': widget.accessToken,
                                    //     'instrument': instrument,
                                    //     'availableBalance': availableBalance,
                                    //   },
                                    // );
                                  },
                                  title: Text(
                                    instrument.instrumentName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                  );
          } else {
            return commonText('Something went wrong try again later');
          }
        }),
        bottomSheet: ValueListenableBuilder(
          valueListenable: totalValue,
          builder: (context, _, child) {
            return ValueListenableBuilder(
              valueListenable: isActivate,
              builder: (context, val, chi) {
                return EndValue(totalValue: totalValue);
              },
            );
          },
        ));
  }
}

class EndValue extends StatelessWidget {
  const EndValue({
    super.key,
    required this.totalValue,
  });

  final ValueNotifier<int> totalValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // isActivate.value
        // ? ExpansionTile(
        //     collapsedBackgroundColor: AppColors.primaryColor,
        //     backgroundColor: AppColors.primaryColor,
        //     collapsedIconColor: Colors.white,
        //     // trailing: Icon(Icons.keyboard_double_arrow_up_rounded, color: Colors.white,),
        //     title: const Text(
        //       'My status',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     iconColor: Colors.white,
        //     children: [
        //       const RecentWidget(),
        //       const Gap(5),
        //       if (state is TradePageCubitLoadedState)
        //         ContainerSlider(
        //           accessToken: widget.accessToken,
        //           lotValue: totalValue.value.floor(),
        //           lots: selectedInstru.isEmpty
        //               ? state.portfolioInstruments
        //               : selectedInstru,
        //         )
        //     ],
        //   )
        // : const SizedBox(),
    
        Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Lot value : \u{20B9} ${totalValue.value.floor()}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 20),
              ),
              // ValueListenableBuilder(
              //     valueListenable: isLoading,
              //     builder: (context, val, _) {
              //       return isLoading.value
              //           ? Center(
              //               child: JumpingDots(
              //                 color: Colors.white,
              //                 radius: 5,
              //                 numberOfDots: 3,
              //               ),
              //             )
              //           : TextButton(
              //               style: TextButton.styleFrom(
              //                 foregroundColor:
              //                     AppColors.goldColor,
              //                 textStyle: GoogleFonts.poppins(
              //                   fontSize: 15,
              //                 ),
              //               ),
              //               onPressed: () async {
              //                 if (state
              //                         is TradePageCubitLoadedState &&
              //                     totalValue.value != 0) {
              //                   try {
              //                     isLoading.value = true;
              //                     !isActivate.value
              //                         ? await cubit.activate(
              //                             Jokey(
              //                               jockeyUid: auth
              //                                   .currentUser!
              //                                   .uid,
              //                               jockeyName:
              //                                   'User-1',
              //                               lotValue: totalValue
              //                                   .value
              //                                   .floor(),
              //                               lots: selectedInstru
              //                                       .isEmpty
              //                                   ? await cubit
              //                                       .getInstrumentList()
              //                                   : selectedInstru,
              //                               dateTime:
              //                                   DateTime.now(),
              //                               // growth: 0.0,
              //                               at: widget
              //                                   .accessToken,
              //                               // predictionValue: double.parse(predictionTextController.text),
              //                               // successRation: 0.0,
              //                             ),
              //                           )
              //                         : await cubit.stopRace(
              //                             auth.currentUser!
              //                                 .uid);
    
              //                     isLoading.value = false;
              //                   } catch (e) {
              //                     isLoading.value = false;
              //                   }
              //                   isActivate.value =
              //                       !isActivate.value;
              //                 } else {
              //                   showWarningToast(
              //                       msg:
              //                           'Select atlest 1 instrument');
              //                 }
              //               },
              //               child: isActivate.value
              //                   ? const Text('Stop')
              //                   : const Text('Activate'));
              //     }),
            ],
          ),
        )
      ],
    );
  }
}
