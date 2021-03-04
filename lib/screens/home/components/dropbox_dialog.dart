import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class DropboxDialog extends StatefulWidget {
  final Function(String) onSubmit;
  const DropboxDialog({this.onSubmit});
  @override
  _DropboxDialogState createState() => _DropboxDialogState();
}

class _DropboxDialogState extends State<DropboxDialog> {
  TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      width: 300,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter your Dropbox access code',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: kDefaultPadding),
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: kBgDarkColor, borderRadius: BorderRadius.circular(4)),
            child: Center(
              child: TextField(
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                ),
                enableSuggestions: false,
                scrollPadding: EdgeInsets.zero,
                controller: _textEditingController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  border: InputBorder.none,
                ),
                onSubmitted: (s) => widget.onSubmit(s),
              ),
            ),
          ),
          SizedBox(height: kDefaultPadding),
          ElevatedButton(
              onPressed: () => widget.onSubmit(_textEditingController.text),
              child: Text('Submit'))
        ],
      ),
    );
  }
}
