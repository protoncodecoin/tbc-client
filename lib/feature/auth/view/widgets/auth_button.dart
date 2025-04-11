import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTab;
  const AuthButton({super.key, required this.buttonText, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: ElevatedButton(
        onPressed: onTab,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          buttonText,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
