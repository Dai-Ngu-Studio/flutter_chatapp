import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/views/screens/home/components/room_box.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                chatappColor.shade50.withOpacity(0.6),
                chatappColor.shade50,
                chatappColor.shade100
              ],
              stops: const [0, 0.4, 0.9, 1],
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 56),
            child: Column(
              children: [
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
                RoomBox(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
