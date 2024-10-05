import 'dart:convert';

import 'package:classia_broker/core/theme/app_colors.dart';
import 'package:classia_broker/features/home/presentation/bloc/home_cubit.dart';
import 'package:classia_broker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/common/entity/ltp.dart';

class CompanySearchBar extends StatefulWidget {
  final BuildContext cubitContext;
  final Function(int totalValue) totalValFun;
  const CompanySearchBar(
      {super.key, required this.cubitContext, required this.totalValFun});

  @override
  State<CompanySearchBar> createState() => _CompanySearchBarState();
}

class _CompanySearchBarState extends State<CompanySearchBar> {
  TextEditingController searchController = TextEditingController();

  final jsonData = '''
  [
    {"segment":"BSE_EQ","name":"NILKAMAL LTD.","exchange":"BSE","isin":"INE310A01015","instrument_type":"B","instrument_key":"BSE_EQ|INE310A01015","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"523385","tick_size":5.0,"trading_symbol":"NILKAMAL","short_name":"NILKAMAL"},
    {"segment":"BSE_EQ","name":"HINDUSTAN ZINC LTD.","exchange":"BSE","isin":"INE267A01025","instrument_type":"A","instrument_key":"BSE_EQ|INE267A01025","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"500188","tick_size":5.0,"trading_symbol":"HINDZINC","short_name":"HINDUSTAN ZINC"},
    {"segment":"BSE_EQ","name":"TATA STEEL LTD.","exchange":"BSE","isin":"INE081A01020","instrument_type":"A","instrument_key":"BSE_EQ|INE081A01020","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"500470","tick_size":5.0,"trading_symbol":"TATASTEEL","short_name":"TATA STEEL"},    
    {"segment":"BSE_EQ","name":"Indian Railway Finance Corpora","exchange":"BSE","isin":"INE053F01010","instrument_type":"A","instrument_key":"BSE_EQ|INE053F01010","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"543257","tick_size":5.0,"trading_symbol":"IRFC","short_name":"INDIAN RAILWAY FINANCIAL CORPORATION"},
    {"segment":"BSE_EQ","name":"Zomato Limited","exchange":"BSE","isin":"INE758T01015","instrument_type":"A","instrument_key":"BSE_EQ|INE758T01015","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"543320","tick_size":5.0,"trading_symbol":"ZOMATO","short_name":"Zomato"},
    {"segment":"NSE_EQ","name":"JSW STEEL LIMITED","exchange":"NSE","isin":"INE019A01038","instrument_type":"EQ","instrument_key":"NSE_EQ|INE019A01038","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"11723","tick_size":5.0,"trading_symbol":"JSWSTEEL","short_name":"JSW Steel","security_type":"NORMAL"},
    {"segment":"BSE_EQ","name":"POWER FINANCE CORPORATION LTD.","exchange":"BSE","isin":"INE134E01011","instrument_type":"A","instrument_key":"BSE_EQ|INE134E01011","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"532810","tick_size":5.0,"trading_symbol":"PFC","short_name":"POWER FINANCE CORP"},
    {"segment":"BSE_EQ","name":"KAVVERI TELECOM PRODUCTS LTD.","exchange":"BSE","isin":"INE641C01019","instrument_type":"T","instrument_key":"BSE_EQ|INE641C01019","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"590041","tick_size":1.0,"trading_symbol":"KAVVERITEL"},
    {"segment":"BSE_EQ","name":"ITC LTD.","exchange":"BSE","isin":"INE154A01025","instrument_type":"A","instrument_key":"BSE_EQ|INE154A01025","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"500875","tick_size":5.0,"trading_symbol":"ITC","short_name":"ITC"},
    {"segment":"BSE_EQ","name":"RELIANCE POWER LTD.","exchange":"BSE","isin":"INE614G01033","instrument_type":"A","instrument_key":"BSE_EQ|INE614G01033","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"532939","tick_size":1.0,"trading_symbol":"RPOWER","short_name":"RELIANCE POWER"},
    {"segment":"BSE_EQ","name":"Adani Wilmar Limited","exchange":"BSE","isin":"INE699H01024","instrument_type":"A","instrument_key":"BSE_EQ|INE699H01024","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"543458","tick_size":5.0,"trading_symbol":"AWL"},
    {"segment":"BSE_EQ","name":"Ola Electric Mobility Limited","exchange":"BSE","isin":"INE0LXG01040","instrument_type":"B","instrument_key":"BSE_EQ|INE0LXG01040","lot_size":1,"freeze_quantity":100000.0,"exchange_token":"544225","tick_size":5.0,"trading_symbol":"OLAELEC"}
  ]
  ''';

  List<Ltp> instruments = [];

  @override
  void initState() {
    super.initState();
    instruments = (json.decode(jsonData) as List).map((data) {
      return Ltp(
        instrumentKey: data['instrument_key'],
        lastPrice: 0,
        instrumentName: data['name'],
        segment: data['segment'],
        tradingSymbol: data['trading_symbol'],
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = widget.cubitContext.read<HomePageCubit>();
    return Container(
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: TypeAheadField(
          suggestionsCallback: (instrument) {
            print('call');
            return instruments
                .where(
                  (item) => item.instrumentName.toLowerCase().contains(
                        instrument.toLowerCase(),
                      ),
                )
                .toList();
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search company...',
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            );
          },
          itemBuilder: (context, instrument) {
            return ListTile(
              tileColor: AppColors.primaryColor,
              title: Text(
                instrument.instrumentName,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: IconButton(
                color: Colors.white,
                style: IconButton.styleFrom(backgroundColor: Colors.white10),
                onPressed: () async {
                  cubit.addInstrument(instrument);
                  final val =
                      await cubit.getSelectedInstrumentLtp(accesssToken);
                  widget.totalValFun(val);
                },
                icon: const Icon(Icons.add),
                focusColor: Colors.white,
              ),
            );
          },
          onSelected: (city) {},
          itemSeparatorBuilder: (context, index) => const Divider(
            color: Colors.white24,
            thickness: 0.5,
            height: 0.6,
          ),
        )

        //  TypeAheadField<Ltp>(
        //   textFieldConfiguration: TextFieldConfiguration(
        //     controller: searchController,
        //     style: const TextStyle(
        //       color: Colors.white,
        //       fontSize: 16,
        //     ),
        //     keyboardType: TextInputType.name,
        //     textCapitalization: TextCapitalization.characters,
        //     decoration: InputDecoration(
        //       hintText: 'Search company...',
        //       suffixIcon: const Icon(
        //         Icons.search,
        //         color: Colors.grey,
        //       ),
        //       hintStyle: const TextStyle(color: Colors.grey),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(30.0),
        //       ),
        //     ),
        //   ),
        //   // controller: searchController,
        //   // builder: (context, searchController, node) {
        //   //   return TextField(

        //   // },
        //   // decorationBuilder: (context, child) => Material(
        //   //   type: MaterialType.card,
        //   //   elevation: 4,
        //   //   // borderRadius: borderRadius,
        //   //   child: child,
        //   // ),

        //   suggestionsBoxDecoration: SuggestionsBoxDecoration(
        //     color: AppColors.primaryColor,
        //     borderRadius: BorderRadius.circular(10.0),
        //   ),

        //   hideOnEmpty: true,
        //   // noItemsFoundBuilder: (context) => const ListTile(
        //   //   title: Text('No Instrument found'),
        //   // ),
        //   itemBuilder: (_, instrument) {
        //     print('sel');
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //       child: ListTile(
        //         tileColor: Colors.white10,
        //         title: Text(
        //           instrument.instrumentName,
        //           style: const TextStyle(color: Colors.white, fontSize: 14),
        //         ),
        //         trailing: IconButton(
        //           color: Colors.white,
        //           style: IconButton.styleFrom(backgroundColor: Colors.white10),
        //           onPressed: () async {
        //             cubit.addInstrument(instrument);
        //             final val = await cubit.getSelectedInstrumentLtp(
        //                 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI4NEFHOU4iLCJqdGkiOiI2NmZhMjIxMDQ1OTZmMzI5ZTAwZmZjZjciLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzI3NjY4NzUyLCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3Mjc3MzM2MDB9.uEmMRCSl_0zFiajk1OUZmA1X4jM3bYlxikLEvP73NIo');
        //             widget.totalValFun(val);
        //           },
        //           icon: const Icon(Icons.add),
        //           focusColor: Colors.white,
        //         ),
        //         // onTap: () => selectedInstruments.add(instrument),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(
        //             20.0,
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        //   suggestionsCallback: (instrument) {
        //     print('call');
        //     return instruments
        //         .where(
        //           (item) => item.instrumentName.toLowerCase().contains(
        //                 instrument.toLowerCase(),
        //               ),
        //         )
        //         .toList();
        //   },
        //   onSuggestionSelected: (Ltp suggestion) {},
        //   itemSeparatorBuilder: (context, index) => const Divider(
        //     color: Colors.black12,
        //   ),
        // ),

        );
  }
}
