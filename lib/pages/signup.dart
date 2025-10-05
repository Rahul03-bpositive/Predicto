import 'package:app/pages/verification.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset("assets/images/images.jpg", fit: BoxFit.cover),

          // White Container at Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Login or Signup", style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "Enter Phone Number",
                      labelStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0xffb0b0b0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Verification(),
                        ),
                      );
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xfff5f5f5),
                    child: Text(
                      "By continuing, you accept that you are above 18 years of age, consent to receiving WhatsApp messages & agree to our Terms and Conditions",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 10), // extra bottom spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:app/pages/verification.dart';
// import 'package:flutter/material.dart';

// class SignUp extends StatelessWidget {
//   const SignUp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background Image
//           SizedBox(
//             height: 700,
//             width: 420,
//             child: Image.asset("assets/images/images.jpg", fit: BoxFit.cover),
//           ),

//           // White Container at Bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0, // Ensures full width
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 color: Colors.white,
//               ),
//               height: 240,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 17),
//                   const Text("Login or Signup", style: TextStyle(fontSize: 15)),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(20.0, 15, 20, 15),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(
//                             10.0,
//                           ), // Adjust the radius as needed
//                         ),
//                         labelText: "Enter Phone Number",
//                         labelStyle: TextStyle(fontSize: 15),
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     style: ButtonStyle(
//                       minimumSize: WidgetStateProperty.all(
//                         Size(MediaQuery.of(context).size.width * 0.9, 50),
//                       ), // Width: 200, Height: 50
//                       shape: WidgetStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                             20,
//                           ), // Reduce border radius
//                         ),
//                       ),
//                       backgroundColor: WidgetStateProperty.all(
//                         Color(0xffb0b0b0),
//                       ), // Use WidgetStateProperty instead
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Verification()),
//                       );
//                     },
//                     child: Text(
//                       "Continue",
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 15.5, 0, 0),
//                     child: Container(
//                       decoration: BoxDecoration(color: Color(0xfff5f5f5)),
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
//                         child: Text(
//                           "By continuing, you accept that you are above 18 years of age, consent to receiving WhatsApp messages & agree to our Terms and Conditions",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
