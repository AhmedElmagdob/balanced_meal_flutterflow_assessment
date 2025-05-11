import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/screen_utils.dart';
import '../widgets/custom_button.dart';
import 'user_details_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome_secreen.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getProportionateScreenWidth(24),
                vertical: ScreenUtils.getProportionateScreenHeight(32),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ScreenUtils.getProportionateScreenHeight(24)),
                  Text(
                    'Balanced Meal',
                    style: GoogleFonts.abhayaLibre(
                      fontSize: ScreenUtils.getProportionateScreenWidth(36),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Text(
                    'Craft your ideal meal effortlessly with our app. Select nutritious ingredients tailored to your taste and well-being.',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: ScreenUtils.getProportionateScreenWidth(18),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ScreenUtils.getProportionateScreenHeight(32)),
                  CustomButton(
                    text: 'Order Food',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserDetailsScreen()),
                      );
                    },
                    width: double.infinity,
                    borderRadius: 12,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.getProportionateScreenHeight(16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 