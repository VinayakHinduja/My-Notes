import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(top: BorderSide(color: Colors.lightBlueAccent, width: 2.0)),
);

const kTextFieldDecoration = InputDecoration(
    hintText: 'example@xyz.com',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(17.0))));

GestureDetector kTemplate(IconData icons, String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(icons, size: 40, color: Colors.black))),
        const SizedBox(width: 10),
        Expanded(
            flex: 3,
            child: Text(text,
                style: const TextStyle(fontSize: 22, color: Colors.black))),
        const Expanded(
          child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.black),
        )
      ]),
    ),
  );
}

Widget kSuffix(bool isHidden, Function() togglePasswordView) => InkWell(
      onTap: togglePasswordView,
      child: Icon(
          isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
    );

DefaultTextStyle kDefaultText(String text) => DefaultTextStyle(
      style: const TextStyle(
          color: Colors.black, fontSize: 50.0, fontWeight: FontWeight.w900),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(text, textAlign: TextAlign.center),
        ],
      ),
    );

Hero klogo() => Hero(
    tag: 'logo',
    child: SizedBox(height: 250.0, child: Image.asset('assets/icon/icon.png')));

Hero kHero(String tag, String text) => Hero(
      tag: tag,
      child: DefaultTextStyle(
        style: const TextStyle(
            color: Colors.black, fontSize: 50.0, fontWeight: FontWeight.w900),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    ); // default text style wrapped with

// feedback responses
SnackBar ksnackBar(String text) {
  return SnackBar(
      content:
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 15)),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.white);
}

Future<void> kFlutterToast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    timeInSecForIosWeb: 1,
  );
}

Future<void> kShowDeleteDialog(context, Function() onTap) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Center(child: Text('Delete', textAlign: TextAlign.center)),
          titleTextStyle: const TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          content: const Text('Are you sure you want to delete this task',
              textAlign: TextAlign.center),
          contentTextStyle: const TextStyle(fontSize: 20.0, color: Colors.grey),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
              SizedBox(
                  height: 25.0,
                  width: 2.0,
                  child: Container(color: Colors.grey)),
              TextButton(
                  onPressed: onTap,
                  child: const Text('Yes',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)))
            ]),
          ],
        );
      });
}
