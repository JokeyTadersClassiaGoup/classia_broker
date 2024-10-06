import 'package:either_dart/src/either.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceInterface remoteDataSourceInterface;

  AuthRepositoryImpl({required this.remoteDataSourceInterface});
  @override
  Future<Either<Failures, bool>> signUpWithPhone({
    required SignUpParams params,
    required BuildContext context,
    required String type,
  }) async {
    try {
      final response = await remoteDataSourceInterface.signUpWithPhone(
        params: params,
        context: context,
        type: params.type,
      );

      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, bool>> verifyOtp({
    required String smsCode,
    UserModel? userModel,
    required BuildContext context,
    required String verificationId,
    required String type,
  }) async {
    try {
      final response = await remoteDataSourceInterface.verifyOtp(
        smsCode: smsCode,
        userModel: userModel,
        context: context,
        verificationId: verificationId,
        type: type,
      );

      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, UserModel>> getUser(String id) async {
    try {
      final response = await remoteDataSourceInterface.getUser(id);

      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, bool>> updateUser(UserModel userModel) async {
    try {
      final response = await remoteDataSourceInterface.editUser(userModel);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
