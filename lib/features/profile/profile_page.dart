import 'package:classia_broker/core/common/widgets/primary_text_field.dart';
import 'package:classia_broker/core/utils/show_warning_toast.dart';
import 'package:classia_broker/features/auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile-page';
  final String? accessToken;
  ProfilePage({super.key, this.accessToken});
  final TextEditingController controller = TextEditingController(text: 'Groww');
  final TextEditingController phoneNumberController =
      TextEditingController(text: '+91 7676633560');

  FocusNode focusNode = FocusNode();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     // await auth.signOut();
          //     // context.pushReplacementNamed(DecisionPage.routeName);
          //   },
          //   icon: const Icon(Icons.logout_rounded),
          // )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircleAvatar(
                  radius: 50,
                  foregroundImage: NetworkImage(
                      'https://cdn.freelogovectors.net/wp-content/uploads/2023/11/groww_logo-freelogovectors.net_.png'),
                )),
            const Gap(50),
            PrimaryTextField(
              controller: controller,
              labelText: 'First name',
              readOnly: true,
            ),
            const Gap(20),
            PrimaryTextField(
              controller: phoneNumberController,
              labelText: 'Phone Number',
              readOnly: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextButton(
                onPressed: () {
                  showWarningToast(
                      msg: 'Request for profile editing has been sent.');
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
                // icon: Icon(Icons.edit_outlined),
              ),
            ),
            // ListTile(
            //   // contentPadding: EdgeInsets.zero,
            //   leading: Icon(Icons.logout),
            //   title: Text('Logout'),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20.0)
            //   ),
            //   onTap: (){},
            // ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                  context.pushReplacementNamed(LoginPage.routeName);
                  // context.pushNamed(JTPageProvider.routeName);
                },
                child: const Text('Logout'),
              ),
            ),
            const Gap(10)
          ],
        ),
      ),
    );
  }
}
