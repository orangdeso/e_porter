import 'package:flutter/material.dart';
import 'dart:math';

class ProfileAvatar extends StatefulWidget {
  final String fullName;

  const ProfileAvatar({
    Key? key,
    required this.fullName,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late final Color _randomColor;

  @override
  void initState() {
    super.initState();
    final colorChoices = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    _randomColor = colorChoices[Random().nextInt(colorChoices.length)];
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(widget.fullName);
    return CircleAvatar(
      radius: 26,
      backgroundColor: _randomColor,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return parts[0].substring(0, 1).toUpperCase() +
          parts[1].substring(0, 1).toUpperCase();
    }
  }
}
