import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/use_case/use_case.dart';
import '../../../domain/usecases/sign_up.dart';
import 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final SignUp signUp;
  AuthCubit({
    required this.signUp,
  }) : super(AuthSignUpLoadingState());

  Future signUpUser(SignUpParams params) async {
    final response = await signUp.call(params);

    response.fold(
        (l) => AuthSignUpErrorState(l.message), (r) => AuthSignUpLoadedState());
  }
}
