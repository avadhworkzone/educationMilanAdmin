import 'package:flutter/material.dart';
import 'package:responsivedashboard/common_widget/custom_text.dart';

class EditEntryData extends StatefulWidget {
  const EditEntryData({Key? key}) : super(key: key);

  @override
  State<EditEntryData> createState() => _EditEntryDataState();
}

class _EditEntryDataState extends State<EditEntryData> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: CustomText("Edit Entry Data"));
  }
}
