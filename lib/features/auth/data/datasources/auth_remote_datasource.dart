import 'package:classia_broker/features/auth/presentation/pages/upstox_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../../core/utils/invest_amount.dart';
import '../../../../core/utils/show_warning_toast.dart';
import '../../../otp/presentation/bloc/otp_verification_page.dart';
import '../../domain/models/user_model.dart';

abstract class AuthRemoteDataSourceInterface {
  Future<bool> signUpWithPhone({
    required SignUpParams params,
    required BuildContext context,
    required String type,
  });

  Future<bool> verifyOtp({
    required String smsCode,
    // UserModel? userModel,
    required BuildContext context,
    required String verificationId,
    // required String type,
  });

  Future<UserModel> getUser(String id);

  Future<bool> editUser(UserModel userModel);
}

var collectionName = 'brokers';

class AuthRemoteDatasource implements AuthRemoteDataSourceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<bool> signUpWithPhone({
    required SignUpParams params,
    required BuildContext context,
    required String type,
  }) async {
    try {
      isOtpLoading.value = true;
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${params.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          try {
            await _auth.signInWithCredential(phoneAuthCredential);
          } catch (e) {
            print('auth error ${e.toString()}');
          }
        },
        verificationFailed: (e) {
          isOtpLoading.value = false;
          print('verification error: ${e.code} - ${e.message}');
          showWarningToast(msg: e.message!);
        },
        codeSent: (((verificationId, forceResendingToken) async {
          // UserModel userModel = UserModel(
          //   uId: '',
          //   fullName: params.fullName ?? '',
          //   email: params.email ?? '',
          //   phoneNumber: params.phoneNumber,
          // );
          isOtpLoading.value = false;

          context.pushNamed(
            OtpVerificationPage.routeName,
            extra: {
              'verificationId': verificationId,
              'type': type,
            },
          );
        })),
        codeAutoRetrievalTimeout: ((verificationId) {}),
      );
      return true;
    } catch (e) {
      isOtpLoading.value = false;

      print('execption ${e.toString()}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> verifyOtp({
    required String smsCode,
    // UserModel? userModel,
    required BuildContext context,
    required String verificationId,
    // required String type,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userResult = await _auth.signInWithCredential(credential);
      // if (userModel != null && userResult.additionalUserInfo!.isNewUser) {
      //   await FirebaseFirestore.instance
      //       .collection(collectionName)
      //       .doc(_auth.currentUser!.uid)
      //       .set(userModel.toMap(_auth.currentUser!.uid));
      // } else if (!userResult.additionalUserInfo!.isNewUser &&
      //     type == 'signin') {
      //   print('type $type');
      //   showWarningToast(msg: 'Account already exists.');
      // }
      if (context.mounted) {
        context.pushReplacementNamed(UpstoxLogin.routeName);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print('verify otp error ${e.message}');
      // showWarningToast(msg: e.message!);
      throw e.message!;
    }
  }

  @override
  Future<UserModel> getUser(String id) async {
    try {
      print('getting user $id');
      final docSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .get();
      if (!docSnapshot.exists) {
        return Future.error('User not available');
      } else {
        UserModel user = UserModel.fromMap(docSnapshot.data()!);
        return user;
      }
    } on FirebaseException catch (e) {
      print('get ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> editUser(UserModel userModel) async {
    print('values to update ${userModel.toMap(userModel.uId)}');
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userModel.uId)
          .get();

      if (!docSnapshot.exists) {
        return Future.error('User not available');
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userModel.uId)
            .update(userModel.toMap(_auth.currentUser!.uid));
        return true;
      }
    } on FirebaseException {
      rethrow;
    }
  }
}
