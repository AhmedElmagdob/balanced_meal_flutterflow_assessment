import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/screen_utils.dart';
import '../widgets/custom_button.dart';
import '../blocs/user_details_bloc.dart';
import '../screens/order_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return BlocProvider(
      create: (_) => UserDetailsBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Enter your details',
            style: GoogleFonts.poppins(
              fontSize: ScreenUtils.getProportionateScreenWidth(24),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: BlocListener<UserDetailsBloc, UserDetailsState>(
            listenWhen: (previous, current) => previous.userProfile != current.userProfile && current.userProfile != null,
            listener: (context, state) {
              if (state.userProfile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderScreen(userProfile: state.userProfile!),
                  ),
                );
              }
            },
            child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
              builder: (context, state) {
                final bloc = context.read<UserDetailsBloc>();
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: ScreenUtils.getProportionateScreenHeight(24)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getProportionateScreenWidth(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Gender
                              Text(
                                'Gender',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    value: state.gender,
                                    isExpanded: true,
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 12),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                      iconSize: 24,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                      ),
                                    ),
                                    hint: Text('Choose your gender', style: GoogleFonts.questrial(color: Colors.grey)),
                                    items: ['Male', 'Female'].map((gender) {
                                      final isSelected = state.gender == gender;
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected ? Color(0xFFFFF1E7) : Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  gender,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(Icons.check, color: Color(0xFFF25700), size: 20),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return ['Male', 'Female'].map((gender) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            gender,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) => bloc.add(GenderChanged(value!)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // Weight
                              Text(
                                'Weight',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter your weight',
                                  hintStyle: GoogleFonts.questrial(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(top:12),
                                    child: Text(
                                      "Kg",
                                      style: GoogleFonts.questrial(
                                        fontWeight: FontWeight.w600,
                                        fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                      ),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.orange, width: 1.5),
                                  ),
                                ),
                                onChanged: (value) => bloc.add(WeightChanged(value)),
                              ),
                              SizedBox(height: 20),
                              // Height
                              Text(
                                'Height',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter your height',
                                  hintStyle: GoogleFonts.questrial(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(top:12),
                                    child: Text(
                                      "Cm",
                                      style: GoogleFonts.questrial(
                                        fontWeight: FontWeight.w600,
                                        fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                      ),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.orange, width: 1.5),
                                  ),
                                ),
                                onChanged: (value) => bloc.add(HeightChanged(value)),
                              ),
                              SizedBox(height: 20),
                              // Age
                              Text(
                                'Age',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter your age in years',
                                  hintStyle: GoogleFonts.questrial(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtils.getProportionateScreenWidth(15),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.orange, width: 1.5),
                                  ),
                                ),
                                onChanged: (value) => bloc.add(AgeChanged(value)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        ScreenUtils.getProportionateScreenHeight(24),
                      ),
                      child: SizedBox(
                        width: ScreenUtils.getProportionateScreenWidth(327),
                        height: ScreenUtils.getProportionateScreenHeight(60),
                        child: CustomButton(
                          text: 'Next',
                          onPressed: state.isValid
                              ? () {
                                  context.read<UserDetailsBloc>().add(SubmitUserDetails());
                                }
                              : null,
                          borderRadius: 12,
                          backgroundColor: state.isValid ? const Color(0xFFF25700) : Colors.grey[300],
                          textColor: state.isValid ? Colors.white : Colors.black54,
                          padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 