import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  void setProfile({String? email, String? name}) {
    emit(ProfileLoaded(email: email, name: name));
  }

  void clear() => emit(const ProfileInitial());
}
