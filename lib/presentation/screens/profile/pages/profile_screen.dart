import 'package:flutter/material.dart';

import '../../../../_core/constants/colors.dart';
import '../../../../_core/constants/typography.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      body: Center(
        child: TypographyStyles.h4('Profile'),
      ),
    );
  }
}
