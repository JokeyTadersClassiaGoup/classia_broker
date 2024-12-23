import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/features/home/data/datasource/home_datasource.dart';
import 'package:classia_broker/features/home/domain/model/activity_model.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../../../core/common/entity/ltp.dart';
import '../../../../core/utils/show_warning_toast.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDatasourceInterface remoteDataSourceInterface;
  List<Ltp> portfolioInstruments = [];

  HomeRepositoryImpl({required this.remoteDataSourceInterface});

  @override
  void addPortfolioInstrument(Ltp instrument) {
    if (portfolioInstruments.contains(instrument)) {
      showWarningToast(msg: 'Instrument already exists');
    } else {
      portfolioInstruments.add(instrument);
      showWarningToast(msg: 'Instrument added');
    }
  }

  @override
  List<Ltp> get getPortfolioInstruments => portfolioInstruments;

  @override
  void removePortfolioInstrument(String instrumentKey) {
    final existingInstrumentIndex = portfolioInstruments
        .indexWhere((instrument) => instrument.instrumentKey == instrumentKey);

    Ltp? existingInstrument = portfolioInstruments[existingInstrumentIndex];
    portfolioInstruments.removeAt(existingInstrumentIndex);
  }

  @override
  Future<Either<Failures, int>> getSelectedInstrumentLtp(
      String accessToken) async {
    print('sending list $portfolioInstruments');
    final response = await remoteDataSourceInterface.getSelectedInstrumentsLtp(
      portfolioInstruments,
      accessToken,
    );
    if (response.isRight) {
      return Right(response.right);
    } else {
      return Left(response.left);
    }
  }

  @override
  Future<Either<Failures, bool>> activateBroker(
      ActivityModel activityModel) async {
    try {
      final response =
          await remoteDataSourceInterface.activateBroker(activityModel);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, bool>> stopBroker(ActivityModel activityModel) async {
    try {
      final response =
          await remoteDataSourceInterface.stopBroker(activityModel);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, ActivityModel?>> getBrokerById(
      String uid, String accessToken) async {
    try {
      final response =
          await remoteDataSourceInterface.getBrokerById(uid, accessToken);
      if (response != null && response.lots.isNotEmpty) {
        print('items found ${response.lots.map((inst) => inst.toMap())}');
        portfolioInstruments = response.lots;
      }
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
