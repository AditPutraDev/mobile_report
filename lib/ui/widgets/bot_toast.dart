part of 'widgets.dart';

void showBotToastText(text) {
  BotToast.showText(
    text: '$text',
    textStyle: TextStyle(
        fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800),
    duration: Duration(seconds: 5),
    borderRadius: BorderRadius.all(Radius.circular(8)),
    clickClose: true,
    contentColor: Colors.black,
    contentPadding: EdgeInsets.fromLTRB(12, 12.5, 12, 12.5),
  );
}
