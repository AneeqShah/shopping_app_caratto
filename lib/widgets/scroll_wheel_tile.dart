import 'package:flutter/material.dart';

class ScrollWheelTile extends StatelessWidget {
  final String? size;
  const ScrollWheelTile({
    @required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      child: Text(size!),
    );
  }
}
