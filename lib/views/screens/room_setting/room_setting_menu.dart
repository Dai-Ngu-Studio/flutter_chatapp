import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';

class RoomSettingMenu extends StatelessWidget {
  const RoomSettingMenu({Key? key, required this.text, this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: kPadding,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.4),
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
