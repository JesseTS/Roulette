import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputDialog extends StatefulWidget {
  const InputDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InputDialogState();

  Future show(context) {
    return showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}

class InputDialogState extends State<InputDialog> {
  var textEditingController1 = TextEditingController();
  var textEditingController2 = TextEditingController();
  var textEditingController3 = TextEditingController();
  var textEditingController4 = TextEditingController();
  var textEditingController5 = TextEditingController();
  var textEditingController6 = TextEditingController();

  @override
  void initState() {
    super.initState();

    for (var element in [
      textEditingController1,
      textEditingController2,
      textEditingController3,
      textEditingController4,
      textEditingController5,
      textEditingController6
    ]) {
      element.addListener(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('輸入獎項數量'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('大獎: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: textEditingController1,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text('二獎: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: textEditingController2,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text('三獎: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: textEditingController3,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('四獎: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: textEditingController4,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text('五獎: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: textEditingController5,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Text('六獎: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: textEditingController6,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: _validate() ? 1 : .5,
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  elevation: MaterialStateProperty.all(2),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                onPressed: _validate() ? _confirm : null,
                child: const Text(
                  '確認',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validate() {
    return textEditingController1.text.isNotEmpty &&
        textEditingController2.text.isNotEmpty &&
        textEditingController3.text.isNotEmpty &&
        textEditingController4.text.isNotEmpty &&
        textEditingController5.text.isNotEmpty &&
        textEditingController6.text.isNotEmpty;
  }

  _confirm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("reward1", int.parse(textEditingController1.text));
    prefs.setInt("reward2", int.parse(textEditingController2.text));
    prefs.setInt("reward3", int.parse(textEditingController3.text));
    prefs.setInt("reward4", int.parse(textEditingController4.text));
    prefs.setInt("reward5", int.parse(textEditingController5.text));
    prefs.setInt("reward6", int.parse(textEditingController6.text));

    Navigator.of(context).pop();
  }
}
