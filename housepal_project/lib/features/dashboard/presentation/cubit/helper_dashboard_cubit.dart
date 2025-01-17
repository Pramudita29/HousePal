import 'package:bloc/bloc.dart';

class HelperDashboardCubit extends Cubit<int> {
  HelperDashboardCubit() : super(0);

  void selectTab(int index) {
    emit(index);
  }
}
