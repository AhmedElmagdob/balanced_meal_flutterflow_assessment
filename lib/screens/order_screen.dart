import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_bloc.dart';
import '../repositories/food_repository.dart';
import '../models/food_item.dart';
import '../widgets/custom_button.dart';
import '../utils/screen_utils.dart';
import '../models/user_profile.dart';
import '../widgets/food_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_summary_screen.dart';

class OrderScreen extends StatelessWidget {
  final UserProfile userProfile;
  const OrderScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return BlocProvider(
      create: (_) => OrderBloc(FoodRepository())
        ..add(LoadOrderData())
        ..emit(OrderState(maxCalories: userProfile.dailyCalories.toInt())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create your order',
            style: GoogleFonts.poppins(
              fontSize: ScreenUtils.getProportionateScreenWidth(24),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state.warning != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.warning!)),
                  );
                  context.read<OrderBloc>().emit(state.copyWith(warning: null));
                });
              }
              if (state.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FoodGroupSection(
                            title: 'Vegetables',
                            items: state.vegetables,
                            category: 'vegetables',
                          ),
                          _FoodGroupSection(
                            title: 'Meat',
                            items: state.meats,
                            category: 'meats',
                          ),
                          _FoodGroupSection(
                            title: 'Carbs',
                            items: state.carbs,
                            category: 'carbs',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          '${state.totalCalories} out of ${userProfile.dailyCalories.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 22 / 14,
                            letterSpacing: 0,
                            color: const Color(0xFF959595),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          '\$ ${state.totalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 22 / 16,
                            letterSpacing: 0,
                            color: const Color(0xFFF25700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: CustomButton(
                      text: 'Place order',
                      onPressed: state.totalItems > 0
                          ? () {
                              // Gather selected items with category and index
                              final selectedItems = <Map<String, dynamic>>[];
                              for (var i = 0; i < state.vegetables.length; i++) {
                                final item = state.vegetables[i];
                                if (item.quantity > 0) {
                                  selectedItems.add({
                                    'imageUrl': item.imageUrl,
                                    'name': item.foodName,
                                    'calories': '${item.calories} Cal',
                                    'price': '\$ ${item.price.toStringAsFixed(2)}',
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
                                    'price': '\$ ${item.price.toStringAsFixed(2)}',
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
                                    'price': '\$ ${item.price.toStringAsFixed(2)}',
                                    'quantity': item.quantity,
                                    'category': 'carbs',
                                    'index': i,
                                    'onAdd': () => context.read<OrderBloc>().add(AddItem('carbs', i)),
                                    'onRemove': () => context.read<OrderBloc>().add(RemoveItem('carbs', i)),
                                  });
                                }
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<OrderBloc>(context),
                                    child: OrderSummaryScreen(
                                      userProfile: userProfile,
                                      onConfirm: () {
                                        // TODO: Handle order confirmation
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                          : null,
                      width: double.infinity,
                      borderRadius: 12,
                      backgroundColor: state.totalItems > 0 ? const Color(0xFFF25700) : Colors.grey[300],
                      textColor: state.totalItems > 0 ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FoodGroupSection extends StatelessWidget {
  final String title;
  final List<FoodItem> items;
  final String category;
  const _FoodGroupSection({required this.title, required this.items, required this.category});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          SizedBox(
            height: ScreenUtils.getProportionateScreenHeight(220),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width:10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: FoodCard(
                    imageUrl: item.imageUrl,
                    name: item.foodName,
                    calories: '${item.calories} Cal',
                    price: '${item.price}',
                    quantity: item.quantity,
                    onAdd: () => context.read<OrderBloc>().add(AddItem(category, index)),
                    onRemove: item.quantity > 0 ? () => context.read<OrderBloc>().add(RemoveItem(category, index)) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
