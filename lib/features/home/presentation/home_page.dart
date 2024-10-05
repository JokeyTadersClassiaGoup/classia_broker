import 'package:classia_broker/core/common/widgets/common_text.dart';
import 'package:classia_broker/core/common/widgets/loader.dart';
import 'package:classia_broker/features/home/domain/model/broker_model.dart';
import 'package:classia_broker/features/home/domain/use_case/activate_broker.dart';
import 'package:classia_broker/features/home/domain/use_case/get_broker_by_id.dart';
import 'package:classia_broker/features/home/domain/use_case/stop_broker.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit_state.dart';
import 'package:classia_broker/features/home/widgets/bottom_widget.dart';
import 'package:classia_broker/features/home/widgets/company_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'instrument_details_page.dart';

class HomePageProvider extends StatelessWidget {
  static const routeName = '/home-page-provider';
  final String? accessToken;

  const HomePageProvider({super.key, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(
        homeRepository: RepositoryProvider.of(context),
        activateBroker: ActivateBroker(
          homeRepository: RepositoryProvider.of(context),
        ),
        stopBroker: StopBroker(
          homeRepository: RepositoryProvider.of(context),
        ),
        getBrokerById: GetBrokerById(
          homeRepository: RepositoryProvider.of(context),
        ),
      )..getInst(),
      child: HomePage(
        accessToken: accessToken!,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String accessToken;
  const HomePage({super.key, required this.accessToken});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> isActivate = ValueNotifier(false);
  ValueNotifier<int> totalValue = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  var isInit = true;
  BrokerModel? brokerModel;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (isInit == true && brokerModel == null) {
      print(brokerModel);
      // context.read<HomePageCubit>().getInst();
      print('ok');
      brokerModel =
          await context.read<HomePageCubit>().getBroker(widget.accessToken);

      if (brokerModel != null) {
        totalValue.value = brokerModel!.lotValue;
        isActivate.value = true;
      }
    }
    isInit = false;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   isActivate.dispose();
  //   totalValue.dispose();
  //   isLoading.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomeCubitState>(
      builder: (_, state) {
        final cubit = context.read<HomePageCubit>();
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
          body: Column(
            children: [
              if (state is HomePageLoadingState) const Loader(),
              if (state is HomePageLoadedState)
                state.instruments.isEmpty
                    ? Expanded(child: commonText('No Instruments selected'))
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
                                          backgroundColor:
                                              AppColors.primaryColor,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                // context.pop();
                                                cubit.removeInstrument(
                                                    instrument.instrumentKey);
                                                totalValue.value = await cubit
                                                    .getSelectedInstrumentLtp(
                                                        widget.accessToken);
                                                context.pop();
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        // color: Colors.amber,
                                      ),
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: const Icon(
                                          Icons.delete_outline_rounded),
                                    ),
                                    child: ListTile(
                                      tileColor: Colors.white12,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                      minTileHeight: 40,
                                      minVerticalPadding: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      onTap: () {
                                        context.pushNamed(
                                          InstrumentDetailsPage.routeName,
                                          extra: {
                                            'accessToken': widget.accessToken,
                                            'instrument': instrument,
                                          },
                                        );
                                      },
                                      title: Text(
                                        instrument.instrumentName,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white70,
                                          )),
                                    ),
                                  );
                                }),
                          );
                        },
                      )
            ],
          ),
          bottomSheet: state is HomePageLoadedState
              ? ValueListenableBuilder(
                  valueListenable: totalValue,
                  builder: (context, _, child) {
                    return ValueListenableBuilder(
                      valueListenable: isActivate,
                      builder: (context, val, chi) {
                        print('ac ${isActivate.value}');
                        return BottomWidget(
                          totalValue: totalValue,
                          isActivate: isActivate.value,
                          cubit: state,
                          accessToken: widget.accessToken,
                          instruments: state.instruments,
                          activate: (val) {
                            isActivate.value = val;
                          },
                        );
                      },
                    );
                  },
                )
              : SizedBox(),
        );
      },
    );
  }
}
