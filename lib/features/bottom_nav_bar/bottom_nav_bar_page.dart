import 'package:classia_broker/features/level/presentation/level_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class BottomNavBarPage extends StatefulWidget {
  static const routeName = '/bottom-navbar-page';
  final StatefulNavigationShell navigationShell;

  const BottomNavBarPage({
    super.key,
    required this.navigationShell,
  });

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      // HomePageProvider(accessToken: widget.accessToken),
      LevelPage(),

      // const BrokerHomePage(),
      // const BrokerHistoryPageProvider(),
      // BrokerProfilePage(),
    ];
    return Scaffold(
      body: widget.navigationShell,
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
          height: 70,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(index,
                initialLocation: index == widget.navigationShell.currentIndex);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.swap_horiz_outlined),
              selectedIcon: Icon(Icons.swap_horiz_rounded),
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
