import 'package:flutter/material.dart';
import 'package:proyecto_solicitudes/core/theme/app_colors.dart';


class LoginHeader extends StatelessWidget {
const LoginHeader({super.key, 
this.title = 'Bienvenido de nuevo', 
this.subtitle = 'Ingresa tus credenciales para continuar'});
final String title;
final String subtitle;


@override
Widget build(BuildContext context) {
return Column(
children: [
Container(
height: 60,
width: 120,
decoration: BoxDecoration(
color: kPrimaryColor,
borderRadius: BorderRadius.circular(12),
),
child: Padding(
  padding: const EdgeInsets.all(10),
  child: Image(image: AssetImage("images/Logo_Grow_Up_Data_Analytics.png")),
)
),
const SizedBox(height: 12),
const Text(
'Bienvenido de nuevo',
textAlign: TextAlign.center,
style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kTextPrimary),
),
const SizedBox(height: 6),
const Text(
'Ingresa tus credenciales para continuar',
textAlign: TextAlign.center,
style: TextStyle(color: kHintColor),
),
],
);
}
}