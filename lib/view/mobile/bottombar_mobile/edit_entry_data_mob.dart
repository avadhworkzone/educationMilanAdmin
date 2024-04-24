import 'package:flutter/material.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';

class EditEntryDataMob extends StatefulWidget {
  final int? editEntryDataMobIndex;
  const EditEntryDataMob({Key? key, this.editEntryDataMobIndex}) : super(key: key);

  @override
  State<EditEntryDataMob> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EditEntryDataMob> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText("Student lisEdit Entry Data"),
    );
  }
}
