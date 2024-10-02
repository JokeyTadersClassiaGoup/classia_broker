import 'package:classia_broker/core/utils/show_warning_toast.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entity/ltp.dart';
import 'home_cubit_state.dart';

class HomePageCubit extends Cubit<HomeCubitState> {
  final HomeRepository homeRepository;

  HomePageCubit(this.homeRepository) : super(HomePageLoadingState());

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
    final response = homeRepository.getPortfolioInstruments;
    emit(HomePageLoadedState(instruments: response));
    return response;
  }

  void removeInstrument(String instrumentKey) {
    homeRepository.removePortfolioInstrument(instrumentKey);
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
}
