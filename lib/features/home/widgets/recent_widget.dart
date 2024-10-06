import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecentWidget extends StatelessWidget {
  const RecentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
          // color: Colors.white12,
          // borderRadius: BorderRadius.circular(20.0),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  // height: 30,
                  // margin: EdgeInsets.fromLTRB(10, 10.0, 5.0, 10.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Invest',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '0.0',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Container(
                  // height: 30,
                  // margin: EdgeInsets.fromLTRB(5, 10.0, 10.0, 10.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Withdraw',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '0.0',
                        style: TextStyle(color: Colors.white60),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
