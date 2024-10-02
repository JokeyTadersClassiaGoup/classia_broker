import 'package:flutter/material.dart';

class PrimaryLoadingButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String title;

  const PrimaryLoadingButton(
      {super.key, required this.onPressed, required this.title});

  @override
  _PrimaryLoadingButtonState createState() => _PrimaryLoadingButtonState();
}

class _PrimaryLoadingButtonState extends State<PrimaryLoadingButton> {
  bool _isLoading = false;

  void _handlePress() async {
    setState(() {
      _isLoading = true;
    });
    await widget.onPressed().then((val) {
      print('done');
      setState(() {
        _isLoading = false;
      });
    }).catchError((er) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlePress,
        child: _isLoading
            ? const CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white)
            : Text(widget.title),
      ),
    );
  }
}
