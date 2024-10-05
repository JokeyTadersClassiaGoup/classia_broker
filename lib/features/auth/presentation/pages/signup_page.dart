import 'package:equal_space/equal_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/company_logo.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/common/widgets/primary_text_field.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../../core/utils/invest_amount.dart';
import '../../../../core/utils/show_warning_toast.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecases/sign_up.dart';
import 'bloc/auth_cubit.dart';
import 'bloc/auth_cubit_state.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = 'signup-page';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FocusNode fullNameNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    isOtpLoading.dispose();
    fullNameNode.dispose();
    // passwordNode.dispose();
    phoneNumberNode.dispose();
    emailFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AuthCubit(
        signUp: SignUp(
            authRepository: RepositoryProvider.of<AuthRepository>(context)),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: BlocBuilder<AuthCubit, AuthCubitState>(builder: (ct, state) {
              return SpacedColumn(
                space: 3.h,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Gap(50),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CompanyImage(),
                  ),
                  const Text(
                    "SignUp",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xffE0FFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: heightScreen * 0.01),
                    child: const Text(
                      "Welcome to Classia Traders",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ),
                  PrimaryTextField(
                    controller: fullNameController,
                    labelText: 'Full name',
                    focusNode: fullNameNode,
                    nextFocusNode: emailFocusNode,
                    obscureText: false,
                  ),
                  PrimaryTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    labelText: 'Email',
                    focusNode: emailFocusNode,
                    nextFocusNode: passwordNode,
                    obscureText: false,
                  ),
                  TextField(
                    focusNode: phoneNumberNode,
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    maxLength: 10,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Phone number',
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.9)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  ValueListenableBuilder(
                      valueListenable: isOtpLoading,
                      builder: (_, val, ch) {
                        return isOtpLoading.value
                            ? const Loader()
                            : PrimaryLoadingButton(
                                onPressed: () async {
                                  if (fullNameController.text.isEmpty ||
                                      emailController.text.isEmpty ||
                                      phoneNumberController.text.isEmpty) {
                                    isOtpLoading.value = false;
                                    showWarningToast(
                                        msg: 'Please fill all the details');
                                  } else {
                                    await ct.read<AuthCubit>().signUpUser(
                                          SignUpParams(
                                            phoneNumber: phoneNumberController
                                                .text
                                                .trim(),
                                            context: context,
                                            fullName:
                                                fullNameController.text.trim(),
                                            email: emailController.text.trim(),
                                            type: 'signin',
                                          ),
                                        );
                                  }
                                },
                                title: 'Create account',
                              );
                      }),
                  Gap(
                    heightScreen * 0.020,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already had an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 7)),
                        onPressed: () => context.pop(),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color(0xffFFDAB9),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
