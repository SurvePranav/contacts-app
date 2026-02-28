import 'package:contacts_app/app/core/common/widgets/loader.dart';
import 'package:contacts_app/app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String childText;
  final VoidCallback onPressed;
  final bool isLoading;
  const AuthButton({
    super.key,
    required this.childText,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPallete.gradient1, AppPallete.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.transparentColor,
          elevation: 0,
          padding: const EdgeInsets.all(20),
        ),
        child: Center(
          child: SizedBox(
            height: 30,

            child: isLoading
                ? SizedBox(height: 30, width: 30, child: Loader())
                : Text(
                    childText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
