import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class BrokerBottomNavBar extends StatefulWidget {
  final String accessToken;

  const BrokerBottomNavBar({
    super.key,
    required this.accessToken,
  });

  @override
  State<BrokerBottomNavBar> createState() => _BrokerBottomNavBarState();
}

class _BrokerBottomNavBarState extends State<BrokerBottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      // TradeOverviewPage(accessToken: widget.accessToken),
      // const BrokerHomePage(),
      // const BrokerHistoryPageProvider(),
      // BrokerProfilePage(),
    ];
    return Scaffold(
      body: screens.elementAt(currentIndex),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white12,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? const TextStyle(
                    color: AppColors.goldColor,
                  )
                : const TextStyle(
                    color: AppColors.lightBlue,
                  ),
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? const IconThemeData(
                    color: AppColors.goldColor,
                  )
                : const IconThemeData(
                    color: AppColors.lightBlue,
                  ),
          ),
          backgroundColor: AppColors.primaryColor,
          // indicatorColor: Colors.amber,
          //  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.upload),
              selectedIcon: Icon(Icons.upload_rounded),
              label: 'Trade',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.trending_up_rounded),
              icon: Icon(Icons.trending_up_rounded),
              label: 'Level',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person_crop_circle),
              selectedIcon: Icon(CupertinoIcons.person_crop_circle_fill),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
