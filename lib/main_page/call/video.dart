// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrinomy/global/notification.dart';
import 'package:matrinomy/model/usermodel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Package imports:


/// Please follow the link below to see more details:
/// https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_call_example_flutter

/// this is a normal call demo.
/// about call invitation or offline call, please see in github demo
/// st
///
class Zegoc extends StatefulWidget {
  UserModel my,them;bool video;
 Zegoc({super.key,required this.my,required this.them,required this.video});

  @override
  State<Zegoc> createState() => _ZegocState();
}

class _ZegocState extends State<Zegoc> {
  String getConversationId() =>
      widget.them.uid.hashCode <= widget.my.uid.hashCode ? '${widget.my.uid}_${widget.them.uid}' : '${widget.them.uid}_${widget.my.uid}';

  Timer? _timer;

  int _remainingSeconds = 10 * 60;
 // 10 minutes in seconds
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          print(getConversationId());
        } else {
          timer.cancel();
          Navigator.pop(context);
          Send.message(context, "10 Min Maximum Received", false);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_sharp)),
        automaticallyImplyLeading: true,
        title: Text("Video Call"),
      ),
      body: normalCallPage(getConversationId(), widget.my.uid, widget.them.uid),
    );
  }

  Widget normalCallPage(String callid,String myid,String userid) {
    return ZegoUIKitPrebuiltCall(
      appID: 26815675, // your AppID,
      appSign: "5cf4955a37190eb9686d5a6917227326febadad14d3d3b564535249ae67cf399",
      userID: myid,
      userName: userid,
      callID: callid,
      config: widget.video? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall():ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}



