import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../models/user_model.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, bool>> signUpWithPhone(
      {required SignUpParams params,
      required BuildContext context,
      required String type});

  Future<Either<Failures, bool>> verifyOtp({
    required String smsCode,
    // UserModel? userModel,
    required BuildContext context,
    required String verificationId,
    // required String type,
  });

  Future<Either<Failures, UserModel>> getUser(String id);

  Future<Either<Failures, bool>> updateUser(UserModel userModel);
}
