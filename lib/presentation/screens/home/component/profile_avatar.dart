import 'package:e_porter/_core/constants/typography.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ProfileAvatar extends StatefulWidget {
  final String fullName;
  final double? radius;

  const ProfileAvatar({
    Key? key,
    required this.fullName,
    this.radius,
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
      radius: widget.radius ?? 24,
      backgroundColor: _randomColor,
      child: TypographyStyles.body(
        initials,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return parts[0].substring(0, 1).toUpperCase() + parts[1].substring(0, 1).toUpperCase();
    }
  }
}
