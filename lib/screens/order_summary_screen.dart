import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/screen_utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/horizontal_food_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_bloc.dart';
import '../models/user_profile.dart';

class OrderSummaryScreen extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback onConfirm;

  const OrderSummaryScreen({
    Key? key,
    required this.userProfile,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order summary',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is PlaceOrderState && state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order placed successfully!')),
            );
            Navigator.pop(context);
          } else if (state is PlaceOrderState && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: \\${state.error}')),
            );
          }
        },
        builder: (context, state) {
          final isPlacing = state is PlaceOrderState && state.isPlacing;
          // Gather selected items with category and index
          final selectedItems = <Map<String, dynamic>>[];
          for (var i = 0; i < state.vegetables.length; i++) {
            final item = state.vegetables[i];
            if (item.quantity > 0) {
              selectedItems.add({
                'imageUrl': item.imageUrl,
                'name': item.foodName,
                'calories': '${item.calories} Cal',
                'price': '\$ ${item.price}',
                'quantity': item.quantity,
                'category': 'vegetables',
                'index': i,
                'onAdd': () => context.read<OrderBloc>().add(AddItem('vegetables', i)),
                'onRemove': () => context.read<OrderBloc>().add(RemoveItem('vegetables', i)),
              });
            }
          }
          for (var i = 0; i < state.meats.length; i++) {
            final item = state.meats[i];
            if (item.quantity > 0) {
              selectedItems.add({
                'imageUrl': item.imageUrl,
                'name': item.foodName,
                'calories': '${item.calories} Cal',
                'price': '\$ ${item.price}',
                'quantity': item.quantity,
                'category': 'meats',
                'index': i,
                'onAdd': () => context.read<OrderBloc>().add(AddItem('meats', i)),
                'onRemove': () => context.read<OrderBloc>().add(RemoveItem('meats', i)),
              });
            }
          }
          for (var i = 0; i < state.carbs.length; i++) {
            final item = state.carbs[i];
            if (item.quantity > 0) {
              selectedItems.add({
                'imageUrl': item.imageUrl,
                'name': item.foodName,
                'calories': '${item.calories} Cal',
                'price': '\$ ${item.price}',
                'quantity': item.quantity,
                'category': 'carbs',
                'index': i,
                'onAdd': () => context.read<OrderBloc>().add(AddItem('carbs', i)),
                'onRemove': () => context.read<OrderBloc>().add(RemoveItem('carbs', i)),
              });
            }
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.getProportionateScreenWidth(16),
                    vertical: ScreenUtils.getProportionateScreenHeight(12),
                  ),
                  itemCount: selectedItems.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = selectedItems[index];
                    return HorizontalFoodCard(
                      imageUrl: item['imageUrl'],
                      name: item['name'],
                      calories: item['calories'],
                      price: item['price'],
                      quantity: item['quantity'],
                      onAdd: item['onAdd'],
                      onRemove: item['onRemove'],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getProportionateScreenWidth(24),
                  vertical: ScreenUtils.getProportionateScreenHeight(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cals', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          '${state.totalCalories} Cal out of ${userProfile.dailyCalories.toInt()} Cal',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 22 / 14,
                            color: const Color(0xFF959595),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          '\$ ${state.totalPrice.toDouble()}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 22 / 16,
                            color: const Color(0xFFF25700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      text: isPlacing ? 'Placing...' : 'Confirm',
                      onPressed: isPlacing ? null : () {
                        context.read<OrderBloc>().add(PlaceOrder());
                      },
                      width: double.infinity,
                      borderRadius: 12,
                      backgroundColor: isPlacing ? Colors.grey[300] : const Color(0xFFF25700),
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtils.getProportionateScreenHeight(16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 