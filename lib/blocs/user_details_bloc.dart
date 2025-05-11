import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_profile.dart';

// Events
abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();
  @override
  List<Object?> get props => [];
}

class GenderChanged extends UserDetailsEvent {
  final String gender;
  const GenderChanged(this.gender);
  @override
  List<Object?> get props => [gender];
}

class WeightChanged extends UserDetailsEvent {
  final String weight;
  const WeightChanged(this.weight);
  @override
  List<Object?> get props => [weight];
}

class HeightChanged extends UserDetailsEvent {
  final String height;
  const HeightChanged(this.height);
  @override
  List<Object?> get props => [height];
}

class AgeChanged extends UserDetailsEvent {
  final String age;
  const AgeChanged(this.age);
  @override
  List<Object?> get props => [age];
}

class SubmitUserDetails extends UserDetailsEvent {}

// State
class UserDetailsState extends Equatable {
  final String? gender;
  final String weight;
  final String height;
  final String age;
  final bool isValid;
  final UserProfile? userProfile;

  const UserDetailsState({
    this.gender,
    this.weight = '',
    this.height = '',
    this.age = '',
    this.isValid = false,
    this.userProfile,
  });

  UserDetailsState copyWith({
    String? gender,
    String? weight,
    String? height,
    String? age,
    bool? isValid,
    UserProfile? userProfile,
  }) {
    return UserDetailsState(
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      isValid: isValid ?? this.isValid,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object?> get props => [gender, weight, height, age, isValid, userProfile];
}

// Bloc
class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc() : super(const UserDetailsState()) {
    on<GenderChanged>((event, emit) {
      final newState = state.copyWith(gender: event.gender);
      emit(_validate(newState));
    });
    on<WeightChanged>((event, emit) {
      final newState = state.copyWith(weight: event.weight);
      emit(_validate(newState));
    });
    on<HeightChanged>((event, emit) {
      final newState = state.copyWith(height: event.height);
      emit(_validate(newState));
    });
    on<AgeChanged>((event, emit) {
      final newState = state.copyWith(age: event.age);
      emit(_validate(newState));
    });
    on<SubmitUserDetails>((event, emit) {
      if (state.isValid) {
        final profile = UserProfile(
          gender: state.gender!,
          weight: int.parse(state.weight),
          height: int.parse(state.height),
          age: int.parse(state.age),
        );
        emit(state.copyWith(userProfile: profile));
      }
    });
  }

  UserDetailsState _validate(UserDetailsState s) {
    final valid =
      (s.gender != null &&
      s.weight.isNotEmpty &&
      s.height.isNotEmpty &&
      s.age.isNotEmpty);
    return s.copyWith(isValid: valid);
  }
} 