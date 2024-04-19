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
  border: Border(
    top: BorderSide(
      color: Colors.lightBlueAccent,
      width: 2.0,
    ),
  ),
);

InputDecoration kTextFieldDecoration(
    {bool? isHidden, Function()? togglePasswordView}) {
  return InputDecoration(
    hintText: 'example@xyz.com',
    contentPadding: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
    suffix: isHidden == null
        ? null
        : InkWell(
            onTap: togglePasswordView,
            child: Icon(
              isHidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
  );
}

GestureDetector kTemplate(IconData icons, String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                icons,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
          const Expanded(
            child: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget kSuffix(bool isHidden, Function() togglePasswordView) {
  return InkWell(
    onTap: togglePasswordView,
    child: Icon(
      isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
    ),
  );
}

DefaultTextStyle kDefaultText(String text) {
  return DefaultTextStyle(
    style: const TextStyle(
      color: Colors.black,
      fontSize: 35,
      fontWeight: FontWeight.w900,
    ),
    child: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(text, textAlign: TextAlign.center),
      ],
    ),
  );
}

Hero klogo() {
  return Hero(
    tag: 'logo',
    child: SizedBox(
      height: 225.0,
      child: Image.asset('assets/icon/icon.png'),
    ),
  );
}

Hero kHero(String tag, String text) {
  return Hero(
    tag: tag,
    child: DefaultTextStyle(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 50.0,
        fontWeight: FontWeight.w900,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
} // default text style wrapped with

// feedback responses
SnackBar ksnackBar(String text) {
  return SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.white,
  );
}

TextField kTextField(
  InputDecoration decoration,
  bool hidden,
  void Function(String) onChanged, {
  TextInputAction textInputAction = TextInputAction.next,
  TextInputType keyboardType = TextInputType.visiblePassword,
  bool enableSuggestions = false,
}) {
  return TextField(
    autofocus: true,
    obscureText: hidden,
    autocorrect: false,
    enableSuggestions: enableSuggestions,
    textInputAction: textInputAction,
    textAlign: TextAlign.center,
    onChanged: onChanged,
    decoration: decoration,
    keyboardType: keyboardType,
  );
}

Widget kDeleteTextField(
  void Function(String) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: TextField(
      autofocus: true,
      cursorHeight: 20,
      cursorWidth: 1.5,
      obscureText: true,
      autocorrect: false,
      onChanged: onChanged,
      enableSuggestions: false,
      textAlign: TextAlign.center,
      cursorColor: Colors.blueGrey,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
        hintText: 'Confirm your password',
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(17),
          ),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    ),
  );
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

TextButton kNoButton(BuildContext ctx, bool? v) {
  return TextButton(
    onPressed: () => Navigator.of(ctx).pop(v),
    child: const Text(
      'No',
      style: TextStyle(
        fontSize: 20,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

TextButton kYesButton(
  BuildContext ctx,
  bool? v,
) {
  return TextButton(
    onPressed: () => Navigator.of(ctx).pop(v),
    child: const Text(
      'Yes',
      style: TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget kSpacer() {
  return SizedBox(
    height: 20.0,
    width: 2.0,
    child: Container(color: Colors.grey),
  );
}
