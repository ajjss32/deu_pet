// import 'package:flutter/material.dart';
// import 'package:deu_pet/pages/user_registration.dart';
// import 'package:deu_pet/pages/login_page.dart';

// class LoginRegisterPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             SizedBox(height: 90),
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/Background.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(40),
//               width: double.infinity,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Text(
//                     "Acesse sua conta ou cadastre-se",
//                     style: TextStyle(fontSize: 25),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage()),
//                           );
//                         },
//                         child: Text("Login"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 85, 16, 224),
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           textStyle: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => RegistrationPage()),
//                           );
//                         },
//                         child: Text("Cadastro"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 85, 16, 224),
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           textStyle: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 60),
//                 ],
//               ),
//             ),
//             Spacer(),
//             Padding(
//               padding: EdgeInsets.only(bottom: 20),
//               child: Image.asset(
//                 'assets/logo.png',
//                 width: 50,
//                 height: 50,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
