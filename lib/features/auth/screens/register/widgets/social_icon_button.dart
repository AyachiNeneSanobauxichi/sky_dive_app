import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;
  double get size => HappySpacing.lg * 1.5;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(size),
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: HappySpacing.lg),
    ),
  );
}
