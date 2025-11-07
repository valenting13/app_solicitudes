import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
const PrimaryButton({super.key, required this.onPressed, required this.label});
final VoidCallback? onPressed;
final String label;


@override
Widget build(BuildContext context) {
return SizedBox(
height: 48,
child: ElevatedButton(
onPressed: onPressed,
style: ElevatedButton.styleFrom(
backgroundColor: kPrimaryColor,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
elevation: 0,
),
child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700,
color: kScaffoldLight)),
),
);
}
}