import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/food_item.dart';
import '../repositories/food_repository.dart';
import 'package:dio/dio.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrderData extends OrderEvent {}
class AddItem extends OrderEvent {
  final String category;
  final int index;
  const AddItem(this.category, this.index);
  @override
  List<Object?> get props => [category, index];
}
class RemoveItem extends OrderEvent {
  final String category;
  final int index;
  const RemoveItem(this.category, this.index);
  @override
  List<Object?> get props => [category, index];
}
class PlaceOrder extends OrderEvent {}

// State
class OrderState extends Equatable {
  final List<FoodItem> vegetables;
  final List<FoodItem> meats;
  final List<FoodItem> carbs;
  final int totalCalories;
  final int totalItems;
  final int totalPrice;
  final bool loading;
  final int maxCalories;
  final String? warning;

  const OrderState({
    this.vegetables = const [],
    this.meats = const [],
    this.carbs = const [],
    this.totalCalories = 0,
    this.totalItems = 0,
    this.totalPrice = 0,
    this.loading = false,
    this.maxCalories = 0,
    this.warning,
  });

  OrderState copyWith({
    List<FoodItem>? vegetables,
    List<FoodItem>? meats,
    List<FoodItem>? carbs,
    int? totalCalories,
    int? totalItems,
    int? totalPrice,
    bool? loading,
    int? maxCalories,
    String? warning,
  }) {
    return OrderState(
      vegetables: vegetables ?? this.vegetables,
      meats: meats ?? this.meats,
      carbs: carbs ?? this.carbs,
      totalCalories: totalCalories ?? this.totalCalories,
      totalItems: totalItems ?? this.totalItems,
      totalPrice: totalPrice ?? this.totalPrice,
      loading: loading ?? this.loading,
      maxCalories: maxCalories ?? this.maxCalories,
      warning: warning,
    );
  }

  @override
  List<Object?> get props => [vegetables, meats, carbs, totalCalories, totalItems, totalPrice, loading, maxCalories, warning];
}

class PlaceOrderState extends OrderState {
  final bool isPlacing;
  final bool isSuccess;
  final String? error;
  PlaceOrderState({
    required OrderState base,
    this.isPlacing = false,
    this.isSuccess = false,
    this.error,
  }) : super(
    vegetables: base.vegetables,
    meats: base.meats,
    carbs: base.carbs,
    totalCalories: base.totalCalories,
    totalItems: base.totalItems,
    totalPrice: base.totalPrice,
    loading: base.loading,
    maxCalories: base.maxCalories,
    warning: base.warning,
  );

  @override
  List<Object?> get props => super.props + [isPlacing, isSuccess, error];
}

// Bloc
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FoodRepository repository;
  OrderBloc(this.repository) : super(const OrderState(loading: true)) {
    on<LoadOrderData>(_onLoadOrderData);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onLoadOrderData(LoadOrderData event, Emitter<OrderState> emit) async {
    emit(state.copyWith(loading: true));
    final vegetables = await repository.loadVegetables();
    final meats = await repository.loadMeats();
    final carbs = await repository.loadCarbs();
    emit(state.copyWith(
      vegetables: vegetables,
      meats: meats,
      carbs: carbs,
      totalCalories: 0,
      totalItems: 0,
      totalPrice: 0,
      loading: false,
    ));
  }

  void _onAddItem(AddItem event, Emitter<OrderState> emit) {
    List<FoodItem> updatedList;
    int itemCalories = 0;
    if (event.category == 'vegetables') {
      updatedList = List.from(state.vegetables);
      itemCalories = updatedList[event.index].calories;
    } else if (event.category == 'meats') {
      updatedList = List.from(state.meats);
      itemCalories = updatedList[event.index].calories;
    } else {
      updatedList = List.from(state.carbs);
      itemCalories = updatedList[event.index].calories;
    }
    final newTotalCalories = state.totalCalories + itemCalories;
    if (state.maxCalories > 0 && newTotalCalories > state.maxCalories) {
      emit(state.copyWith(warning: 'You cannot exceed your daily calorie limit.'));
      return;
    }
    if (event.category == 'vegetables') {
      updatedList[event.index] = updatedList[event.index].copyWith(quantity: updatedList[event.index].quantity + 1);
      emit(_recalculate(state.copyWith(vegetables: updatedList, warning: null)));
    } else if (event.category == 'meats') {
      updatedList[event.index] = updatedList[event.index].copyWith(quantity: updatedList[event.index].quantity + 1);
      emit(_recalculate(state.copyWith(meats: updatedList, warning: null)));
    } else if (event.category == 'carbs') {
      updatedList[event.index] = updatedList[event.index].copyWith(quantity: updatedList[event.index].quantity + 1);
      emit(_recalculate(state.copyWith(carbs: updatedList, warning: null)));
    }
  }

  void _onRemoveItem(RemoveItem event, Emitter<OrderState> emit) {
    List<FoodItem> updatedList;
    if (event.category == 'vegetables') {
      updatedList = List.from(state.vegetables);
      final current = updatedList[event.index].quantity;
      if (current > 0) {
        updatedList[event.index] = updatedList[event.index].copyWith(quantity: current - 1);
        emit(_recalculate(state.copyWith(vegetables: updatedList)));
      }
    } else if (event.category == 'meats') {
      updatedList = List.from(state.meats);
      final current = updatedList[event.index].quantity;
      if (current > 0) {
        updatedList[event.index] = updatedList[event.index].copyWith(quantity: current - 1);
        emit(_recalculate(state.copyWith(meats: updatedList)));
      }
    } else if (event.category == 'carbs') {
      updatedList = List.from(state.carbs);
      final current = updatedList[event.index].quantity;
      if (current > 0) {
        updatedList[event.index] = updatedList[event.index].copyWith(quantity: current - 1);
        emit(_recalculate(state.copyWith(carbs: updatedList)));
      }
    }
  }

  OrderState _recalculate(OrderState s) {
    final all = [...s.vegetables, ...s.meats, ...s.carbs];
    final totalCalories = all.fold(0, (sum, item) => sum + (item.calories * item.quantity));
    final totalItems = all.fold(0, (sum, item) => sum + item.quantity);
    final totalPrice = all.fold(0, (sum, item) => sum + (item.price * item.quantity));
    return s.copyWith(totalCalories: totalCalories, totalItems: totalItems, totalPrice: totalPrice);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(PlaceOrderState(base: state, isPlacing: true));
    final all = [...state.vegetables, ...state.meats, ...state.carbs];
    final items = all
        .where((item) => item.quantity > 0)
        .map((item) => {
              'name': item.foodName,
              'total_price': item.price * item.quantity,
              'quantity': item.quantity,
            })
        .toList();
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://uz8if7.buildship.run/placeOrder',
        data: {'items': items},
      );
      if (response.statusCode == 200) {
        emit(PlaceOrderState(base: state, isPlacing: false, isSuccess: true));
        print("send done gl " + response.data.toString());
      } else {
        emit(PlaceOrderState(base: state, isPlacing: false, error: 'Failed to place order'));
      }
    } catch (e) {
      emit(PlaceOrderState(base: state, isPlacing: false, error: e.toString()));
    }
  }
} 