import 'package:classia_broker/core/use_case/use_case.dart';
import 'package:classia_broker/core/utils/show_warning_toast.dart';
import 'package:classia_broker/features/home/domain/model/broker_model.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entity/ltp.dart';
import '../../domain/use_case/activate_broker.dart';
import '../../domain/use_case/get_broker_by_id.dart';
import '../../domain/use_case/stop_broker.dart';
import 'home_cubit_state.dart';

class HomePageCubit extends Cubit<HomeCubitState> {
  final HomeRepository homeRepository;
  final ActivateBroker activateBroker;
  final StopBroker stopBroker;
  final GetBrokerById getBrokerById;

  HomePageCubit({
    required this.homeRepository,
    required this.activateBroker,
    required this.stopBroker,
    required this.getBrokerById,
  }) : super(HomePageLoadingState());

  void addInstrument(Ltp instrument) {
    if (state is HomePageLoadedState) {
      final currentState = state as HomePageLoadedState;
      homeRepository.addPortfolioInstrument(instrument);

      // Create a new list from the existing instruments and add the new one
      final updatedInstruments = getInst();

      // Emit a new state with the updated list
      emit(HomePageLoadedState(instruments: updatedInstruments));
    }
  }

  List<Ltp> getInst() {
    emit(HomePageLoadingState());
    List<Ltp> response;

    // if (accessToken != null) {
    //   final bros = await getBroker(accessToken);
    //   if (bros.lots.isNotEmpty) {
    //     response = bros.lots;
    //   }
    // }

    response = homeRepository.getPortfolioInstruments;
    emit(HomePageLoadedState(instruments: response));

    return response;
  }

  void removeInstrument(String instrumentKey) async {
    homeRepository.removePortfolioInstrument(instrumentKey);
    final updatedInstruments = getInst();

    emit(HomePageLoadedState(instruments: updatedInstruments));
  }

  Future<int> getSelectedInstrumentLtp(String accessToken) async {
    final response = await homeRepository.getSelectedInstrumentLtp(accessToken);

    if (response.isRight) {
      return response.right;
    } else {
      showWarningToast(msg: response.left.message);
      return 0;
    }
  }

  Future<void> activate(BrokerModel brokerModel) async {
    final response = await activateBroker
        .call(ActivateBrokerParams(brokerModel: brokerModel));

    if (response.isLeft) {
      showWarningToast(msg: response.left.message);
    }
  }

  Future<void> stop(String brokerUid) async {
    final response = await stopBroker.call(brokerUid);

    if (response.isLeft) {
      showWarningToast(msg: response.left.message);
    }
  }

  Future<BrokerModel?> getBroker(String accessToken) async {
    final uId = FirebaseAuth.instance.currentUser!.uid;

    final response = await getBrokerById
        .call(GetBrokerIdParams(accessToken: accessToken, uId: uId));

    if (response.isRight) {
      return response.right;
    } else {
      print('mesg33 ${response.left.message}');
      showWarningToast(msg: response.left.message);
    }
    return null;
  }
}
