import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class CreateFolderDialog extends StatefulWidget {
  final FolderStore store;

  const CreateFolderDialog({Key key, this.store}) : super(key: key);
  @override
  _CreateFolderDialogState createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool _loading = false;
  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  _submit() async {
    _focusNode.unfocus();
    final _name = _controller.text ?? '';
    if (_name.isEmpty) return;
    _setLoading(true);
    final _result = await widget.store.createFolder(_name);
    if (_result) Navigator.of(context).pop();
    _setLoading(false);
  }

  _setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: kBgLightColor,
      titleTextStyle: TextStyle(fontSize: 16),
      title: const Text('Create Folder'),
      contentPadding: EdgeInsets.all(kDefaultPadding),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding * .5)),
      children: [
        _InputField(
          controller: _controller,
          focusNode: _focusNode,
          onSubmit: _submit,
        ),
        SizedBox(height: kDefaultPadding * .8),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 60.0,
            height: 28.0,
            child: _loading
                ? const _LoadingWidget()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                    onPressed: () => _submit(),
                    child: const Text('ok'),
                  ),
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    Key key,
    @required TextEditingController controller,
    @required FocusNode focusNode,
    this.onSubmit,
  })  : _controller = controller,
        _focusNode = focusNode,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: kBgDarkColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14.0),
          enableSuggestions: false,
          autofocus: true,
          cursorColor: kPrimaryColor,
          scrollPadding: EdgeInsets.zero,
          decoration: InputDecoration(
            hintText: 'new folder',
            hintStyle: TextStyle(color: kGrayColor, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
          ),
          onSubmitted: (s) => onSubmit(),
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Center(
        child: SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              valueColor: AlwaysStoppedAnimation(kPrimaryColor),
            )),
      ),
    );
  }
}
