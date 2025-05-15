// import 'package:stock_market_app/core/routes/page_route_names.dart';
// import 'package:stock_market_app/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
//
// class OtpScreen extends StatelessWidget {
//   const OtpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
//         title: Text(
//           "OTP",
//           style: TextStyle(
//             fontSize: 33
//           )
//         )
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "Enter the 6 digits sent to you",
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500
//                 ),
//               ),
//               SizedBox(height: 10),
//               OtpTextField(
//                 numberOfFields: 6,
//                 borderColor: Color(0xFF512DA8),
//                 showFieldAsBox: true,
//                 autoFocus: true,
//                 filled: true,
//                 fillColor: AppColors.grey,
//                 fieldWidth: size.width * 0.13,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 textStyle: TextStyle(
//                   fontSize: 23
//                 ),
//                 onCodeChanged: (String code) {
//
//                 },
//                 onSubmit: (String verificationCode){
//                   Navigator.pushNamed(context, PageRouteNames.newPassword);
//                 }, // end onSubmit
//               ),
//               SizedBox(height: 10),
//               Text.rich(
//                 textAlign: TextAlign.start,
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "Didn't receive your code yet? ",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.darkGrey
//                       )
//                     ),
//                     WidgetSpan(
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Text(
//                           "Resend OTP",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: const Color.fromRGBO(51, 51, 51, 0.6),
//                             fontWeight: FontWeight.w500
//                           ),
//                         ),
//                       )
//                     )
//                   ]
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
