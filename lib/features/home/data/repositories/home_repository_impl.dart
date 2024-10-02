import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/features/home/data/datasource/home_datasource.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/entity/ltp.dart';
import '../../../../core/utils/show_warning_toast.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDatasourceInterface remoteDatasourceInterface;
  List<Ltp> portfolioInstruments = [];

  HomeRepositoryImpl({required this.remoteDatasourceInterface});

  @override
  void addPortfolioInstrument(Ltp instrument) {
    if (portfolioInstruments.contains(instrument)) {
      showWarningToast(msg: 'Instrument already exists');
    } else {
      portfolioInstruments.add(instrument);
      print('len ${portfolioInstruments.length}');
      showWarningToast(msg: 'Instrument added', color: Colors.green);
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
    showWarningToast(
        msg: 'Instrument removed successfully', color: Colors.green);
  }

  @override
  Future<Either<Failures, int>> getSelectedInstrumentLtp(
      String accessToken) async {
        print('sending list $portfolioInstruments');
    final response = await remoteDatasourceInterface.getSelectedInstrumentLtp(
      portfolioInstruments,
      accessToken,
    );
    if (response.isRight) {
      return Right(response.right);
    } else {
      return Left(response.left);
    }
  }
}

