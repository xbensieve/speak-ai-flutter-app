import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
