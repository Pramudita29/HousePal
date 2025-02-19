import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUserUseCase;

  RegisterBloc({
    required RegisterUseCase registerUserUseCase,
  })  : _registerUserUseCase = registerUserUseCase,
        super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterEvent);
  }

  // Handle user registration
  void _onRegisterEvent(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true));

    final authEntity = AuthEntity(
      fullName: event.fullName,
      email: event.email,
      contactNo: event.contactNo,
      password: event.password,
      confirmPassword: event.confirmPassword,
      role: event.role,
      skills: event.skills,
      image: event.image,
      experience: event.experience,
    );

    final result = await _registerUserUseCase(authEntity);

    result.fold(
      (failure) {
        emit(state.copyWith(
            isLoading: false, isSuccess: false, errorMessage: failure.message));
      },
      (user) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }
}
