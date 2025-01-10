import 'package:flutter/material.dart';

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RadioMenuButton(
            value: false,
            groupValue: 1,
            onChanged: (value){},
            child: Text(
              'Male',
            )
        ),
        RadioMenuButton(
            value: false,
            groupValue: 1,
            onChanged: (value){},
            child: Text(
              'Female',
            )
        ),
      ],
    );
  }
}
