import 'package:bloc/bloc.dart';

class SeekerDashboardCubit extends Cubit<int> {
  SeekerDashboardCubit() : super(0);

  void selectTab(int index) {
    emit(index);
  }
}
