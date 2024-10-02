import 'package:either_dart/either.dart';

import '../../../../core/common/entity/ltp.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  void addPortfolioInstrument(Ltp instrument);

  List<Ltp> get getPortfolioInstruments;

  void removePortfolioInstrument(String instrumentKey);

  Future<Either<Failures, int>> getSelectedInstrumentLtp(String accessToken);
}
