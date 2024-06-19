import 'package:intl/intl.dart';

import '../model/usermodel.dart';
import '../model/messagw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);
  final Messages message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final user = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return user.toString() == widget.message.from
        ? _blueMessage()
        : _redMessage();
  }

  Widget _blueMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      getFormattedTime(
                            widget.message.sent),
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _redMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 1,
          ),
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: Row(
                      children: [
                        Text(
                            getFormattedTime(
                                widget.message.sent),
                            style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
                        Spacer(),
                        widget.message.read.isNotEmpty?
                          Icon(
                            Icons.done_all,
                            color: Colors.grey,
                            size: 18,
                          ) : Icon(
                            Icons.done_all,
                            color: Colors.blue,
                            size: 18,
                          ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFormattedTime( String time ) {
    // Convert the string to an integer
    int millisecondsSinceEpoch = int.parse(time);

    // Create a DateTime object from the millisecondsSinceEpoch
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    // Get the current date
    DateTime now = DateTime.now();

    // Check if the dateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    // Define date formats
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yy');

    // Return the formatted date
    return isToday ? timeFormat.format(dateTime) : dateFormat.format(dateTime);
  }
}
