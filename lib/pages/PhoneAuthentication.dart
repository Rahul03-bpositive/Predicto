// ignore: file_names
// import 'package:app/pages/profilesetuppage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneAuthentication extends StatefulWidget {
//   final String phoneNumber;
//   const PhoneAuthentication({super.key, required this.phoneNumber});

//   @override
//   State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
// }

// class _PhoneAuthenticationState extends State<PhoneAuthentication> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController otpController = TextEditingController();

//   String verificationId = '';
//   bool otpSent = false;

//   Future<void> verifyPhoneNumber() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: widget.phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         navigateToProfileSetup();
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
//       },
//       codeSent: (String id, int? resendToken) {
//         setState(() {
//           verificationId = id;
//           otpSent = true;
//         });
//       },
//       codeAutoRetrievalTimeout: (String id) {
//         verificationId = id;
//       },
//     );
//   }

//   Future<void> verifyOTP() async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: otpController.text.trim(),
//       );
//       await _auth.signInWithCredential(credential);
//       navigateToProfileSetup();
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
//     }
//   }

//   void navigateToProfileSetup() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => ProfileSetup()),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     verifyPhoneNumber(); // Start OTP process automatically
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Phone Authentication')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child:
//             otpSent
//                 ? Column(
//                   children: [
//                     TextField(
//                       controller: otpController,
//                       decoration: const InputDecoration(labelText: 'Enter OTP'),
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: verifyOTP,
//                       child: const Text('Verify'),
//                     ),
//                   ],
//                 )
//                 : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }

import 'dart:async' as async;
import 'package:app/pages/profilesetuppage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneAuthentication extends StatefulWidget {
  final String phoneNumber;
  const PhoneAuthentication({super.key, required this.phoneNumber});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController otpController = TextEditingController();

  String verificationId = '';
  bool otpSent = false;
  int resendTime = 30;
  bool showTimer = true;
  async.Timer? _timer;

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();

    // Delay disposing the controller to avoid async access crash
    Future.delayed(Duration.zero, () {
      if (mounted) otpController.dispose();
    });

    super.dispose();
  }

  void _startTimer() {
    setState(() {
      resendTime = 30;
      showTimer = true;
    });
    _timer?.cancel();
    _timer = async.Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // ✅ Prevent updates after dispose
      if (resendTime > 0) {
        setState(() => resendTime--);
      } else {
        setState(() => showTimer = false);
        timer.cancel();
      }
    });
  }

  Future<void> verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (!mounted) return; // ✅ Stop if widget is gone
        await _auth.signInWithCredential(credential);
        navigateToProfileSetup();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      },
      codeSent: (String id, int? resendToken) {
        if (!mounted) return;
        setState(() {
          verificationId = id;
          otpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String id) {
        if (mounted) verificationId = id;
      },
    );
  }

  Future<void> verifyOTP() async {
    try {
      final code = otpController.text.trim();
      if (code.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please enter OTP')));
        return;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _auth.signInWithCredential(credential);
      if (mounted) navigateToProfileSetup();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
    }
  }

  void navigateToProfileSetup() {
    if (!mounted) return; // ✅ Check before navigating
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSetup()),
    );
  }

  void _onResendPressed() {
    verifyPhoneNumber();
    _startTimer();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP Resent')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f3f3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child:
            otpSent
                ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          "Verify phone",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "OTP has been sent to ${widget.phoneNumber}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OTP field
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child:
                              mounted
                                  ? PinCodeTextField(
                                    appContext: context,
                                    length: 6,
                                    controller: otpController,
                                    cursorColor: Colors.black,
                                    cursorHeight: 20,
                                    animationDuration: Duration.zero,
                                    enableActiveFill: true,
                                    keyboardType: TextInputType.number,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      borderWidth: 0,
                                      fieldHeight: 50,
                                      fieldWidth: 42,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedFillColor: Colors.white,
                                      activeColor: Colors.grey.shade400,
                                      inactiveColor: Colors.grey.shade400,
                                      selectedColor: Colors.grey.shade500,
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 2),
                        Row(
                          children: [
                            InkWell(
                              onTap: showTimer ? null : _onResendPressed,
                              child: const Text(
                                "Resend OTP",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (showTimer)
                              Text(
                                "$resendTime sec",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 56, 96, 254),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 380),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "This game may be habit-forming or financially risky. Play responsibly. ",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()..onTap = () {},
                                ),
                                const TextSpan(
                                  text:
                                      " apply, for 18+ only. Participation as per state laws.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: verifyOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Verify",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
